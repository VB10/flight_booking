import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';
  String userEmail = '';
  int userId = 0;
  String userToken = '';
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  // Kötü pratik: Cache logic burada tekrar yazılmış
  void loadUserProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Hard coded key'ler tekrar - kötü praktik
      String? name = prefs.getString('user_name');
      String? email = prefs.getString('user_email');
      int? id = prefs.getInt('user_id');
      String? token = prefs.getString('user_token');

      if (name != null && email != null && id != null && token != null) {
        setState(() {
          userName = name;
          userEmail = email;
          userId = id;
          userToken = token;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Kullanıcı bilgileri bulunamadı!';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Hata: $e';
      });
    }
  }

  // Kötü pratik: Logout logic yine burada tekrar yazılmış
  void logout() async {
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
                performLogout();
              },
            ),
          ],
        );
      },
    );
  }

  // Aynı kod tekrarı - kötü praktik
  void performLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Hard coded key'ler yine aynı
    await prefs.remove('user_token');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_id');
    await prefs.setBool('is_logged_in', false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  // Fake API call - gereksiz
  void refreshProfile() async {
    setState(() {
      isLoading = true;
    });

    // Kötü pratik: Fake API call
    Dio dio = Dio();
    String baseUrl = 'http://localhost:8080'; // Hard coded URL tekrarı

    try {
      // Fake profile endpoint çağrısı
      await Future.delayed(Duration(seconds: 1)); // Fake delay

      // Sadece cache'den tekrar yükle - anlamsız
      loadUserProfile();
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Profil yenilenemedi: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: refreshProfile),
          IconButton(icon: Icon(Icons.logout), onPressed: logout),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    errorMessage,
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: loadUserProfile,
                    child: Text('Tekrar Dene'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profil header
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blue,
                          child: Text(
                            userName.isNotEmpty
                                ? userName[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          userEmail,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Kullanıcı Bilgileri
                  Text(
                    'Kullanıcı Bilgileri',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 16),

                  buildInfoCard('Kullanıcı ID', userId.toString()),
                  buildInfoCard('İsim', userName),
                  buildInfoCard('Email', userEmail),
                  buildInfoCard(
                    'Token',
                    '${userToken.substring(0, 10)}...', // Güvenlik için kısalt
                  ),

                  SizedBox(height: 30),

                  // Hesap Ayarları
                  Text(
                    'Hesap Ayarları',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 16),

                  buildActionCard(
                    'Profili Yenile',
                    'Profil bilgilerini sunucudan yeniden yükle',
                    Icons.refresh,
                    Colors.blue,
                    refreshProfile,
                  ),

                  buildActionCard(
                    'Çıkış Yap',
                    'Hesaptan çıkış yap ve giriş ekranına dön',
                    Icons.logout,
                    Colors.red,
                    logout,
                  ),

                  SizedBox(height: 30),

                  // Debug bilgileri - production'da olmaması gereken
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Debug Bilgileri',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Token: $userToken',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildInfoCard(String title, String value) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: Icon(icon, color: color),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(subtitle),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }
}
