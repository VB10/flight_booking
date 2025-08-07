import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'checkout_response_model.dart';
import 'main.dart'; // Global analytics için

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  CartPage({required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    // Analytics - Cart sayfası görüntüleme
    _logCartScreenView();
  }

  // Kötü pratik: Screen tracking method'u buraya gömülü
  Future<void> _logCartScreenView() async {
    try {
      await analytics.logScreenView(
        screenName: 'cart',
        screenClass: 'CartPage',
      );

      // Cart view event with item count
      await analytics.logEvent(
        name: 'cart_view',
        parameters: {
          'cart_item_count': widget.cartItems.length,
          'cart_total_value': getTotalPrice().toDouble(),
          'currency': 'TRY',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      debugPrint('Analytics: Cart screen view logged');
    } catch (e) {
      debugPrint('Analytics cart screen view failed: $e');
    }
  }

  int getTotalPrice() {
    int total = 0;
    for (var item in widget.cartItems) {
      total += item['price'] as int;
    }
    return total;
  }

  void removeFromCart(int index) {
    // Analytics - Sepetten çıkarma event'i
    _logRemoveFromCart(widget.cartItems[index]);

    setState(() {
      widget.cartItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bilet sepetten çıkarıldı!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void checkout() {
    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sepetiniz boş!'), backgroundColor: Colors.red),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ödeme Onayı'),
          content: Text(
            'Toplam ${getTotalPrice()} ₺ ödeme yapmak istediğinizden emin misiniz?',
          ),
          actions: [
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Onayla'),
              onPressed: () {
                Navigator.of(context).pop();
                _processCheckout();
              },
            ),
          ],
        );
      },
    );
  }

  // Kötü pratik: Aynı kodun tekrarı burada da
  void _processCheckout() async {
    // Loading göster
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Ödeme işlemi yapılıyor...'),
            ],
          ),
        );
      },
    );

    Dio dio = Dio(); // Tekrar aynı kod
    String baseUrl = 'http://localhost:8080'; // Hard coded URL tekrarı

    try {
      // Request body doğrudan yazıldı
      Map<String, dynamic> requestBody = {
        'cartItems': widget.cartItems,
        'userEmail': 'user@test.com', // Hard coded email
      };

      Response response = await dio.post(
        '$baseUrl/checkout',
        data: requestBody,
      );

      Navigator.pop(context); // Loading dialog'u kapat

      // Status code kontrolü yine aynı
      if (response.statusCode == 200) {
        CheckoutResponseModel checkoutResponse = CheckoutResponseModel.fromJson(
          response.data,
        );

        if (checkoutResponse.success) {
          // Analytics - Checkout başarılı
          await _logSuccessfulCheckout(requestBody['cartItems']);

          setState(() {
            widget.cartItems.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(checkoutResponse.message),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(checkoutResponse.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server hatası: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Loading dialog'u kapat
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bağlantı hatası: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Kötü pratik: Analytics method'ları da buraya gömülü
  Future<void> _logRemoveFromCart(Map<String, dynamic> item) async {
    try {
      await analytics.logEvent(
        name: 'remove_from_cart',
        parameters: {
          'item_id': item['id']?.toString() ?? 'unknown',
          'item_name': item['airline'] ?? 'unknown',
          'item_category': 'flight_ticket',
          'price': item['price'] ?? 0,
          'currency': 'TRY',
          'from': item['from'] ?? 'unknown',
          'to': item['to'] ?? 'unknown',
        },
      );
      debugPrint('Analytics: Remove from cart logged');
    } catch (e) {
      debugPrint('Analytics remove from cart failed: $e');
    }
  }

  Future<void> _logSuccessfulCheckout(List<dynamic> cartItems) async {
    try {
      double totalValue = 0;
      int itemCount = cartItems.length;

      // Toplam değer hesapla
      for (var item in cartItems) {
        totalValue += (item['price'] ?? 0).toDouble();
      }

      // Purchase event - Firebase Analytics standard event
      await analytics.logPurchase(
        currency: 'TRY',
        value: totalValue,
        parameters: {
          'transaction_id': DateTime.now().millisecondsSinceEpoch.toString(),
          'item_count': itemCount,
          'payment_method': 'credit_card', // Kötü pratik: Hard coded
        },
      );

      // Her bir item için purchase detail
      for (int i = 0; i < cartItems.length; i++) {
        var item = cartItems[i];
        await analytics.logEvent(
          name: 'purchase_item_detail',
          parameters: {
            'item_id': item['id']?.toString() ?? 'unknown',
            'item_name': item['airline'] ?? 'unknown',
            'item_category': 'flight_ticket',
            'price': item['price'] ?? 0,
            'currency': 'TRY',
            'from': item['from'] ?? 'unknown',
            'to': item['to'] ?? 'unknown',
            'departure_time': item['departureTime'] ?? 'unknown',
            'item_position': i + 1,
          },
        );
      }

      // Custom checkout completion event
      await analytics.logEvent(
        name: 'checkout_completed',
        parameters: {
          'total_amount': totalValue,
          'item_count': itemCount,
          'checkout_timestamp': DateTime.now().millisecondsSinceEpoch,
          'platform': 'mobile',
        },
      );

      debugPrint('Analytics: Checkout events logged');
    } catch (e) {
      debugPrint('Analytics checkout logging failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sepetim'), backgroundColor: Colors.blue),
      body: widget.cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Sepetiniz boş',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final flight = widget.cartItems[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: Icon(
                            Icons.flight_takeoff,
                            color: Colors.blue,
                          ),
                          title: Text(
                            '${flight['from']} - ${flight['to']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(flight['airline']),
                              Text(
                                '${flight['departureTime']} - ${flight['arrivalTime']}',
                              ),
                              Text('Tarih: ${flight['date']}'),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${flight['price']} ₺',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => removeFromCart(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border(top: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Toplam:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${getTotalPrice()} ₺',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: checkout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text('Ödeme Yap'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
