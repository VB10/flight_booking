import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'flight_detail_page.dart';
import 'cart_page.dart';
import 'flights_response_model.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'main.dart'; // Global firebase services için

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
      await analytics.logScreenView(
        screenName: 'flight_list',
        screenClass: 'FlightListPage',
      );

      // Custom screen event
      await analytics.logEvent(
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
      String minimumVersion = remoteConfig.getString('minimum_app_version');
      bool forceUpdate = remoteConfig.getBool('force_update_required');
      String updateMessage = remoteConfig.getString('update_message_tr');

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
              Icon(Icons.system_update, color: Colors.orange),
              SizedBox(width: 10),
              Text(
                'Güncelleme Gerekli',
                style: TextStyle(
                  fontFamily: 'Roboto', // Kötü pratik: Hard coded font
                  fontWeight: FontWeight.bold,
                ),
              ),
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
              SizedBox(height: 20),
              Text(
                message.isEmpty
                    ? 'Yeni versiyon mevcut! Lütfen uygulamayı güncelleyin.'
                    : message,
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            if (!forceUpdate)
              TextButton(
                child: Text(
                  'Daha Sonra',
                  style: TextStyle(fontFamily: 'Roboto', color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Güncelle',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                // Kötü pratik: URL hard coded ve platform check yok
                // Production'da store URL'leri farklı olmalı
                debugPrint(
                  'Store\'a yönlendir - URL: https://play.google.com/store/apps/details?id=com.example.flight_booking',
                );
                if (!forceUpdate) {
                  Navigator.of(context).pop();
                }
              },
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
        content: Text('Bilet sepete eklendi!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Kötü pratik: Analytics method'u burada gömülü
  Future<void> _logAddToCart(FlightModel flight) async {
    try {
      // Add to cart event - Firebase Analytics standard event
      await analytics.logAddToCart(
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
      await analytics.logEvent(
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
        title: Text(
          'Uçak Biletleri',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.blue,
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
                    title: Text('Çıkış Yap'),
                    content: Text('Çıkış yapmak istediğinizden emin misiniz?'),
                    actions: [
                      TextButton(
                        child: Text('İptal'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Çıkış Yap'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          logout();
                        },
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
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      cart.length.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? buildShimmerLoading()
          : errorMessage.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SVG ikonu - kötü pratik: Hard coded path
                  SvgPicture.asset(
                    'assets/undraw_fast-loading_ae60.svg',
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Hata: $errorMessage',
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Roboto', // Kötü pratik: Hard coded font
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: fetchFlights,
                    child: Text(
                      'Tekrar Dene',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: flights.length,
              itemBuilder: (context, index) {
                final flight = flights[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 15),
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              flight.airline,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontFamily:
                                    'Roboto', // Kötü pratik: Her yerde tekrar
                              ),
                            ),
                            Text(
                              '${flight.price} ₺',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    flight.from,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    flight.departureTime,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward, color: Colors.grey),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    flight.to,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    flight.arrivalTime,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Süre: ${flight.duration}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'Tarih: ${flight.date}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // FlightModel'i Map'e çevir - kötü pratik
                                  Map<String, dynamic> flightMap = flight
                                      .toJson();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FlightDetailPage(flight: flightMap),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text('Detaylar'),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => addToCart(flight),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text('Sepete Ekle'),
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

  // Kötü pratik: Shimmer widget burada sayfaya gömülü
  Widget buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: 6, // Fake 6 item göster
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: EdgeInsets.only(bottom: 15),
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Havayolu ve fiyat placeholder
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 120,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Şehir bilgileri placeholder
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              width: 50,
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              width: 50,
                              height: 14,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // Süre ve tarih placeholder
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 70,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 90,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  // Buton placeholders
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
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
