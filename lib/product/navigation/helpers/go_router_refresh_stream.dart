import 'dart:async';

import 'package:flutter/foundation.dart';

/// GoRouter'ın `refreshListenable` parametresi [Listenable] bekler.
/// Bu adapter, bir [Stream] event'inde `notifyListeners` çağırarak
/// Bloc/Cubit stream'lerinin router'ı yeniden değerlendirmesini sağlar.
final class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (_) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
