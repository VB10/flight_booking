import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../bin/server.dart';

const _body = {
  'cartItems': [
    {'id': 1, 'price': 650},
    {'id': 2, 'price': 499},
  ],
  'userEmail': 'user@test.com',
};

void main() {
  late Handler handler;

  setUp(() {
    orders.clear();
    handler = FlightServer(checkoutDelay: Duration.zero).handler;
  });

  Future<Response> checkout({String? key, bool drop = false}) async {
    return handler(
      Request(
        'POST',
        Uri.parse('http://localhost/checkout'),
        body: jsonEncode(_body),
        headers: {
          'Content-Type': 'application/json',
          if (key != null) 'Idempotency-Key': key,
          if (drop) 'X-Simulate-Drop': 'after-commit',
        },
      ),
    );
  }

  Future<Map<String, dynamic>> json(Response r) async =>
      jsonDecode(await r.readAsString()) as Map<String, dynamic>;

  group('the bug (no key): connection drops after the server committed', () {
    test('a retry creates a SECOND order', () async {
      final dropped = await checkout(drop: true);
      expect(dropped.statusCode, 503);
      expect(orders, hasLength(1)); // committed although the client saw an error

      await checkout(); // user taps retry
      expect(orders, hasLength(2)); // double booking
    });
  });

  group('with Idempotency-Key', () {
    test('retry after a drop replays the first order', () async {
      final dropped = await checkout(key: 'k1', drop: true);
      expect(dropped.statusCode, 503);

      final retry = await checkout(key: 'k1');
      expect(retry.statusCode, 200);
      expect(retry.headers['Idempotent-Replayed'], 'true');
      expect(orders, hasLength(1));
      expect((await json(retry))['bookingReference'],
          orders.single['bookingReference']);
    });

    test('same key twice: one order, same reference', () async {
      final first = await checkout(key: 'k2');
      final second = await checkout(key: 'k2');
      expect(first.headers['Idempotent-Replayed'], isNull);
      expect(second.headers['Idempotent-Replayed'], 'true');
      expect(orders, hasLength(1));
      expect((await json(second))['bookingReference'],
          (await json(first))['bookingReference']);
    });

    test('different keys are different payments', () async {
      await checkout(key: 'a');
      await checkout(key: 'b');
      expect(orders, hasLength(2));
    });
  });

  group('debug panel', () {
    Future<Response> post(String path, [Map<String, dynamic>? body]) async {
      return handler(
        Request(
          'POST',
          Uri.parse('http://localhost$path'),
          body: body == null ? '' : jsonEncode(body),
          headers: {'Content-Type': 'application/json'},
        ),
      );
    }

    Future<Map<String, dynamic>> state() async => json(
      await handler(Request('GET', Uri.parse('http://localhost/debug/state'))),
    );

    test('idempotency OFF: the same key creates two orders', () async {
      await post('/debug/idempotency', {'enabled': false});
      await checkout(key: 'same');
      await checkout(key: 'same');
      expect(orders, hasLength(2));

      final s = await state();
      expect(s['idempotencyEnabled'], false);
      final list = (s['orders'] as List).cast<Map<String, dynamic>>();
      expect(list.map((o) => o['duplicate']), [false, true]);
    });

    test('idempotency ON (default): the same key creates one order', () async {
      await checkout(key: 'same');
      await checkout(key: 'same');
      expect(orders, hasLength(1));
      expect((await state())['idempotencyEnabled'], true);
    });

    test('drop-next arms ONE dropped checkout and shows in state', () async {
      await post('/debug/drop-next');
      expect((await state())['dropArmed'], true);
      expect((await checkout(key: 'x')).statusCode, 503);
      expect((await state())['dropArmed'], false);
      expect((await checkout(key: 'y')).statusCode, 200);
    });

    test('state lists recent requests, newest first', () async {
      await checkout(key: 'k');
      await checkout(key: 'k');
      final events =
          ((await state())['events'] as List).cast<Map<String, dynamic>>();
      expect(events.first['status'], 200);
      expect(events.first['replayed'], true);
      expect(events.last['replayed'], false);
    });

    test('reset clears orders, keys and events but keeps the switch', () async {
      await post('/debug/idempotency', {'enabled': false});
      await checkout(key: 'k');
      await post('/debug/reset');
      final s = await state();
      expect(s['orders'], isEmpty);
      expect(s['events'], isEmpty);
      expect(s['idempotencyEnabled'], false);
      await post('/debug/idempotency', {'enabled': true});
      await checkout(key: 'k'); // key was forgotten by reset: a fresh order
      expect(orders, hasLength(1));
    });

    test('GET /debug serves the panel page', () async {
      final r = await handler(
        Request('GET', Uri.parse('http://localhost/debug')),
      );
      expect(r.statusCode, 200);
      expect(r.headers['content-type'], contains('text/html'));
      expect(await r.readAsString(), contains('/debug/state'));
    });
  });
}
