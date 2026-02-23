import 'package:dio/dio.dart';
import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/product/initialize/firebase/custom_remote_config.dart';
import 'package:flutter/material.dart';

import 'package:flight_booking/feature/auth/cart/checkout_response_model.dart';

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
      await CustomRemoteConfig.instance.analytics.logScreenView(
        screenName: 'cart',
        screenClass: 'CartPage',
      );

      // Cart view event with item count
      await CustomRemoteConfig.instance.analytics.logEvent(
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
        content: ProductText.bodyMedium(context, 'Bilet sepetten çıkarıldı!'),
        backgroundColor: context.appTheme.warning,
      ),
    );
  }

  void checkout() {
    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ProductText.bodyMedium(context, 'Sepetiniz boş!'),
          backgroundColor: context.colorScheme.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: ProductText.titleLarge(context, 'Ödeme Onayı'),
          content: ProductText.bodyMedium(
            context,
            'Toplam ${getTotalPrice()} ₺ ödeme yapmak istediğinizden emin misiniz?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: ProductText.labelLarge(context, 'İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processCheckout();
              },
              child: ProductText.labelLarge(context, 'Onayla'),
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
              const CircularProgressIndicator(),
              const SizedBox(width: AppSizes.spacingL),
              ProductText.bodyMedium(context, 'Ödeme işlemi yapılıyor...'),
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
      final responseData = response.data as Map<String, dynamic>?;
      // Status code kontrolü yine aynı
      if (response.statusCode == 200 && responseData != null) {
        CheckoutResponseModel checkoutResponse = CheckoutResponseModel.fromJson(
          responseData,
        );

        if (checkoutResponse.success) {
          // Analytics - Checkout başarılı
          await _logSuccessfulCheckout(
            requestBody['cartItems'] as List<dynamic>,
          );

          setState(() {
            widget.cartItems.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: ProductText.bodyMedium(context, checkoutResponse.message),
              backgroundColor: context.appTheme.success,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: ProductText.bodyMedium(context, checkoutResponse.message),
              backgroundColor: context.colorScheme.error,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: ProductText.bodyMedium(
              context,
              'Server hatası: ${response.statusCode}',
            ),
            backgroundColor: context.colorScheme.error,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: ProductText.bodyMedium(context, 'Bağlantı hatası: $e'),
            backgroundColor: context.colorScheme.error,
          ),
        );
      }
    }
  }

  // Kötü pratik: Analytics method'ları da buraya gömülü
  Future<void> _logRemoveFromCart(Map<String, dynamic> item) async {
    try {
      await CustomRemoteConfig.instance.analytics.logEvent(
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
      await CustomRemoteConfig.instance.analytics.logPurchase(
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
        await CustomRemoteConfig.instance.analytics.logEvent(
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
      await CustomRemoteConfig.instance.analytics.logEvent(
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
      appBar: AppBar(
        title: ProductText.titleLarge(context, 'Sepetim'),
        backgroundColor: context.colorScheme.primary,
      ),
      body: widget.cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSizes.spacingL),
                  ProductText.titleMedium(
                    context,
                    'Sepetiniz boş',
                    style: context.appTextTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: AppPagePadding.all10(),
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final flight = widget.cartItems[index];
                      final scheme = context.colorScheme;
                      final appTheme = context.appTheme;
                      return Card(
                        margin: AppPagePadding.marginBottom10(),
                        child: ListTile(
                          leading: Icon(
                            Icons.flight_takeoff,
                            color: scheme.primary,
                            size: AppSizes.iconMedium,
                          ),
                          title: ProductText.titleMedium(
                            context,
                            '${flight['from']} - ${flight['to']}',
                            style: context.appTextTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProductText.bodySmall(
                                context,
                                flight['airline'] as String? ?? '',
                              ),
                              ProductText.bodySmall(
                                context,
                                '${flight['departureTime']} - ${flight['arrivalTime']}',
                              ),
                              ProductText.labelSmall(
                                context,
                                'Tarih: ${flight['date']}',
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ProductText.titleMedium(
                                context,
                                '${flight['price']} ₺',
                                style: context.appTextTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: appTheme.success,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: scheme.error,
                                  size: AppSizes.iconMedium,
                                ),
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
                  padding: AppPagePadding.all20(),
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainerHighest,
                    border: Border(
                      top: BorderSide(color: context.appTheme.divider),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProductText.titleLarge(
                            context,
                            'Toplam:',
                            style: context.appTextTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ProductText.titleLarge(
                            context,
                            '${getTotalPrice()} ₺',
                            style: context.appTextTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.appTheme.success,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spacingM),
                      ElevatedButton(
                        onPressed: checkout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.appTheme.success,
                          foregroundColor: context.colorScheme.onPrimary,
                          minimumSize: const Size(
                            double.infinity,
                            AppSizes.buttonHeightMedium,
                          ),
                        ),
                        child: ProductText.labelLarge(context, 'Ödeme Yap'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
