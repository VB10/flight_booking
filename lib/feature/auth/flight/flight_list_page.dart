import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/product/initialize/firebase/custom_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../unauth/login/login_page.dart';
import '../cart/cart_page.dart';
import '../flight_detail/flight_detail_page.dart';
import '../profile/profile_page.dart';
import 'flights_response_model.dart';

class FlightListPage extends StatefulWidget {
  @override
  _FlightListPageState createState() => _FlightListPageState();
}

class _FlightListPageState extends State<FlightListPage> {
  List<FlightModel> flights = [];
  List<Map<String, dynamic>> cart = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchFlights();
    // Kötü pratik: Version check'i sayfada yapmak
    _checkAppVersion();
    // Analytics - Sayfa görüntüleme
    _logScreenView();
  }

  // Kötü pratik: Screen tracking her sayfada tekrar
  Future<void> _logScreenView() async {
    try {
      await CustomRemoteConfig.instance.analytics.logScreenView(
        screenName: 'flight_list',
        screenClass: 'FlightListPage',
      );

      // Custom screen event
      await CustomRemoteConfig.instance.analytics.logEvent(
        name: 'screen_view_flight_list',
        parameters: {
          'screen_name': 'flight_list',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'previous_screen': 'login', // Kötü pratik: Hard coded
        },
      );

      debugPrint('Analytics: Flight list screen view logged');
    } catch (e) {
      debugPrint('Analytics screen view failed: $e');
    }
  }

  // Kötü pratik: Version kontrolü burada hardcoded
  Future<void> _checkAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // Remote config'den minimum version al
      String minimumVersion = CustomRemoteConfig.instance.remoteConfig
          .getString('minimum_app_version');
      bool forceUpdate = CustomRemoteConfig.instance.remoteConfig.getBool(
        'force_update_required',
      );
      String updateMessage = CustomRemoteConfig.instance.remoteConfig.getString(
        'update_message_tr',
      );

      // Kötü pratik: Basit string karşılaştırması
      if (_isVersionOlder(currentVersion, minimumVersion)) {
        _showUpdateDialog(forceUpdate, updateMessage);
      }
    } catch (e) {
      // Kötü pratik: Silent error
      debugPrint('Version check failed: $e');
    }
  }

  // Kötü pratik: Version karşılaştırması çok basit
  bool _isVersionOlder(String current, String minimum) {
    // Bu çok basit bir implementasyon - production'da semantic versioning kullanılmalı
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> minimumParts = minimum.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      if (currentParts[i] < minimumParts[i]) return true;
      if (currentParts[i] > minimumParts[i]) return false;
    }
    return false;
  }

  // Kötü pratik: Update dialog'u burada inline
  void _showUpdateDialog(bool forceUpdate, String message) {
    showDialog(
      context: context,
      barrierDismissible: !forceUpdate, // Force update varsa kapatılamaz
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.system_update, color: context.appTheme.warning),
              const SizedBox(width: AppSizes.spacingS),
              ProductText.titleLarge(context, 'Güncelleme Gerekli'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // SVG ikonu ekle - kötü pratik: Hard coded path
              SvgPicture.asset(
                'assets/undraw_connected-world_anke.svg',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: AppSizes.spacingL),
              ProductText.bodyLarge(
                context,
                message.isEmpty
                    ? 'Yeni versiyon mevcut! Lütfen uygulamayı güncelleyin.'
                    : message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            if (!forceUpdate)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: ProductText.bodyMedium(
                  context,
                  'Daha Sonra',
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.appTheme.warning,
                foregroundColor: context.colorScheme.onPrimary,
              ),
              onPressed: () {
                debugPrint(
                  'Store\'a yönlendir - URL: https://play.google.com/store/apps/details?id=com.example.flight_booking',
                );
                if (!forceUpdate) Navigator.of(context).pop();
              },
              child: ProductText.labelLarge(
                context,
                'Güncelle',
                style: context.appTextTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Kötü pratik: Aynı kod tekrarı
  void fetchFlights() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    Dio dio = Dio(); // Her seferinde yeni Dio instance
    String baseUrl = 'http://localhost:8080'; // Hard coded URL tekrarı

    try {
      Response response = await dio.get('$baseUrl/flights');

      // Status code kontrolü tekrarı
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.data);
        FlightsResponseModel flightsResponse = FlightsResponseModel.fromJson(
          jsonResponse,
        );

        if (flightsResponse.success) {
          setState(() {
            flights = flightsResponse.data;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = flightsResponse.message;
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Server hatası: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Bağlantı hatası: $e';
      });
    }
  }

  void addToCart(FlightModel flight) {
    // Kötü pratik: Haptic feedback burada doğrudan kullanılmış
    HapticFeedback.mediumImpact(); // Titreşim ekle

    // Analytics - Sepete ekleme event'i
    _logAddToCart(flight);

    // FlightModel'i Map'e çevir - kötü pratik
    Map<String, dynamic> flightMap = flight.toJson();
    setState(() {
      cart.add(flightMap);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ProductText.bodyMedium(context, 'Bilet sepete eklendi!'),
        backgroundColor: context.appTheme.success,
      ),
    );
  }

  // Kötü pratik: Analytics method'u burada gömülü
  Future<void> _logAddToCart(FlightModel flight) async {
    try {
      // Add to cart event - Firebase Analytics standard event
      await CustomRemoteConfig.instance.analytics.logAddToCart(
        currency: 'TRY',
        value: flight.price.toDouble(),
        parameters: {
          'item_id': flight.id.toString(),
          'item_name': flight.airline,
          'item_category': 'flight_ticket',
          'price': flight.price,
          'from': flight.from,
          'to': flight.to,
          'departure_time': flight.departureTime,
          'arrival_time': flight.arrivalTime,
          'flight_date': flight.date,
          'duration': flight.duration,
        },
      );

      // Custom event - sepete ekleme detayı
      await CustomRemoteConfig.instance.analytics.logEvent(
        name: 'flight_added_to_cart',
        parameters: {
          'flight_id': flight.id,
          'airline': flight.airline,
          'price': flight.price,
          'route': '${flight.from}-${flight.to}',
          'cart_size': cart.length + 1, // Yeni eklendikten sonraki boyut
          'add_timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      debugPrint('Analytics: Add to cart logged for ${flight.airline}');
    } catch (e) {
      debugPrint('Analytics add to cart failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ProductText.titleMedium(context, 'Uçak Biletleri'),
        backgroundColor: context.colorScheme.primary,
        actions: [
          // Profile butonu eklendi
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          // Kötü pratik: Logout burada basit yapılmış
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: ProductText.titleLarge(context, 'Çıkış Yap'),
                    content: ProductText.bodyMedium(
                      context,
                      'Çıkış yapmak istediğinizden emin misiniz?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: ProductText.labelLarge(context, 'İptal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          logout();
                        },
                        child: ProductText.labelLarge(context, 'Çıkış Yap'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(cartItems: cart),
                    ),
                  );
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: AppSizes.spacingXs,
                  top: AppSizes.spacingXs,
                  child: Container(
                    padding: AppPadding.p4,
                    decoration: BoxDecoration(
                      color: context.colorScheme.error,
                      borderRadius: AppRadius.circular8,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: AppSizes.iconSmall,
                      minHeight: AppSizes.iconSmall,
                    ),
                    child: ProductText.labelSmall(
                      context,
                      cart.length.toString(),
                      style: context.appTextTheme.labelSmall?.copyWith(
                        color: context.colorScheme.onError,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? buildShimmerLoading(context)
          : errorMessage.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/undraw_fast-loading_ae60.svg',
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: AppSizes.spacingXl),
                  ProductText.bodyLarge(
                    context,
                    'Hata: $errorMessage',
                    style: context.appTextTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingL),
                  ElevatedButton(
                    onPressed: fetchFlights,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colorScheme.primary,
                      foregroundColor: context.colorScheme.onPrimary,
                    ),
                    child: ProductText.labelLarge(context, 'Tekrar Dene'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: AppPagePadding.all10(),
              itemCount: flights.length,
              itemBuilder: (context, index) {
                final flight = flights[index];
                final scheme = context.colorScheme;
                final appTheme = context.appTheme;
                return Card(
                  margin: AppPagePadding.marginBottom15(),
                  elevation: 3,
                  child: Padding(
                    padding: AppPagePadding.all15(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProductText.titleMedium(
                              context,
                              flight.airline,
                              style: context.appTextTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: scheme.primary,
                              ),
                            ),
                            ProductText.titleLarge(
                              context,
                              '${flight.price} ₺',
                              style: context.appTextTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: appTheme.success,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.spacingS),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProductText.titleMedium(
                                    context,
                                    flight.from,
                                    style: context
                                        .appTextTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  ProductText.bodyMedium(
                                    context,
                                    flight.departureTime,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: scheme.onSurfaceVariant,
                              size: AppSizes.iconMedium,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ProductText.titleMedium(
                                    context,
                                    flight.to,
                                    style: context
                                        .appTextTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  ProductText.bodyMedium(
                                    context,
                                    flight.arrivalTime,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.spacingS),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProductText.labelSmall(
                              context,
                              'Süre: ${flight.duration}',
                              style: context.appTextTheme.labelSmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            ProductText.labelSmall(
                              context,
                              'Tarih: ${flight.date}',
                              style: context.appTextTheme.labelSmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.spacingM),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  final flightMap = flight.toJson();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<Widget>(
                                      builder: (context) =>
                                          FlightDetailPage(flight: flightMap),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: scheme.surfaceContainerHighest,
                                  foregroundColor: scheme.onSurface,
                                ),
                                child: ProductText.labelLarge(
                                  context,
                                  'Detaylar',
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSizes.spacingS),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => addToCart(flight),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: appTheme.brandPrimary,
                                  foregroundColor: scheme.onPrimary,
                                ),
                                child: ProductText.labelLarge(
                                  context,
                                  'Sepete Ekle',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Kötü pratik: Logout logic sayfaya gömülü
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Hard coded key'leri temizle - kötü praktik
    await prefs.remove('user_token');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_id');
    await prefs.setBool('is_logged_in', false);

    // Tüm cache'i temizle - agresif yaklaşım
    // await prefs.clear(); // Bu da kötü pratik

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  Widget buildShimmerLoading(BuildContext context) {
    final appTheme = context.appTheme;
    final surfaceColor = context.colorScheme.surface;
    return ListView.builder(
      padding: AppPagePadding.all10(),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: appTheme.shimmerBase,
          highlightColor: appTheme.shimmerHighlight,
          child: Card(
            margin: AppPagePadding.marginBottom15(),
            elevation: 3,
            child: Padding(
              padding: AppPagePadding.all15(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 120,
                        height: 16,
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: AppRadius.circular4,
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 18,
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: AppRadius.circular4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacingS),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,
                              height: 16,
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: AppRadius.circular4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 50,
                              height: 14,
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: AppRadius.circular4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: AppRadius.circular4,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 80,
                              height: 16,
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: AppRadius.circular4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 50,
                              height: 14,
                              decoration: BoxDecoration(
                                color: surfaceColor,
                                borderRadius: AppRadius.circular4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacingS),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 70,
                        height: 12,
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: AppRadius.circular4,
                        ),
                      ),
                      Container(
                        width: 90,
                        height: 12,
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: AppRadius.circular4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacingM),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: AppSizes.buttonHeightSmall,
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: AppRadius.circular4,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.spacingS),
                      Expanded(
                        child: Container(
                          height: AppSizes.buttonHeightSmall,
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: AppRadius.circular4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
