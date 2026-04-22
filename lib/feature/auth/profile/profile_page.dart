import 'package:flight_booking/core/theme/theme.dart';
import 'package:flight_booking/product/application/auth/auth_cubit.dart';
import 'package:flight_booking/product/service/impl/auth_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                performLogout();
              },
              child: ProductText.labelLarge(context, 'Çıkış Yap'),
            ),
          ],
        );
      },
    );
  }

  Future<void> performLogout() => context.read<AuthCubit>().logout();

  void refreshProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final authService = AuthServiceImpl();
    final result = await authService.getProfile();

    result.fold(
      onSuccess: (response) {
        if (response.success) {
          setState(() {
            userName = response.data.name;
            userEmail = response.data.email;
            userId = response.data.id;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = response.message;
          });
        }
      },
      onError: (error) {
        setState(() {
          isLoading = false;
          errorMessage = error.model?.message ?? 'Profil yenilenemedi';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ProductText.titleLarge(context, 'Profil'),
        backgroundColor: context.colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshProfile,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: context.colorScheme.error,
                  ),
                  const SizedBox(height: AppSizes.spacingM),
                  ProductText.bodyLarge(
                    context,
                    errorMessage,
                    style: context.appTextTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingL),
                  ElevatedButton(
                    onPressed: loadUserProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colorScheme.primary,
                      foregroundColor: context.colorScheme.onPrimary,
                    ),
                    child: ProductText.labelLarge(context, 'Tekrar Dene'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: AppPagePadding.all20(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: AppPagePadding.all20(),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      borderRadius: AppRadius.circular12,
                      border: Border.all(
                        color: context.colorScheme.primary.withOpacity(0.5),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: context.colorScheme.primary,
                          child: ProductText.h2(
                            context,
                            userName.isNotEmpty
                                ? userName[0].toUpperCase()
                                : 'U',
                            style: context.appTextTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacingM),
                        ProductText.h3(
                          context,
                          userName,
                          style: context.appTextTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacingXs),
                        ProductText.bodyLarge(
                          context,
                          userEmail,
                          style: context.appTextTheme.bodyLarge?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingXl),
                  ProductText.titleLarge(
                    context,
                    'Kullanıcı Bilgileri',
                    style: context.appTextTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingM),
                  buildInfoCard(context, 'Kullanıcı ID', userId.toString()),
                  buildInfoCard(context, 'İsim', userName),
                  buildInfoCard(context, 'Email', userEmail),
                  buildInfoCard(
                    context,
                    'Token',
                    '${userToken.substring(0, 10)}...',
                  ),
                  const SizedBox(height: AppSizes.spacingXl),
                  ProductText.titleLarge(
                    context,
                    'Hesap Ayarları',
                    style: context.appTextTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacingM),
                  buildActionCard(
                    context,
                    'Profili Yenile',
                    'Profil bilgilerini sunucudan yeniden yükle',
                    Icons.refresh,
                    context.colorScheme.primary,
                    refreshProfile,
                  ),
                  buildActionCard(
                    context,
                    'Çıkış Yap',
                    'Hesaptan çıkış yap ve giriş ekranına dön',
                    Icons.logout,
                    context.colorScheme.error,
                    logout,
                  ),
                  const SizedBox(height: AppSizes.spacingXl),
                  Container(
                    width: double.infinity,
                    padding: AppPagePadding.all16(),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerHighest,
                      borderRadius: AppRadius.circular8,
                      border: Border.all(color: context.appTheme.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductText.labelLarge(
                          context,
                          'Debug Bilgileri',
                          style: context.appTextTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacingXs),
                        ProductText.labelSmall(
                          context,
                          'Token: $userToken',
                          style: context.appTextTheme.labelSmall?.copyWith(
                            fontFamily: 'monospace',
                            color: context.colorScheme.onSurfaceVariant,
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

  Widget buildInfoCard(BuildContext context, String title, String value) {
    final scheme = context.colorScheme;
    return Container(
      width: double.infinity,
      margin: AppPagePadding.marginBottom12(),
      padding: AppPagePadding.all16(),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AppRadius.circular8,
        border: Border.all(color: context.appTheme.divider),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductText.labelLarge(
            context,
            title,
            style: context.appTextTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          ProductText.bodyLarge(context, value),
        ],
      ),
    );
  }

  Widget buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      width: double.infinity,
      margin: AppPagePadding.marginBottom12(),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: Icon(icon, color: color, size: AppSizes.iconMedium),
          title: ProductText.titleMedium(
            context,
            title,
            style: context.appTextTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: ProductText.bodySmall(context, subtitle),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: AppSizes.iconSmall,
            color: context.colorScheme.onSurfaceVariant,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
