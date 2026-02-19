import 'package:flight_booking/core/theme/theme.dart';
import 'package:flutter/material.dart';

class FlightDetailPage extends StatefulWidget {
  final Map<String, dynamic> flight;
  
  FlightDetailPage({required this.flight});

  @override
  _FlightDetailPageState createState() => _FlightDetailPageState();
}

class _FlightDetailPageState extends State<FlightDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ProductText.titleLarge(context, 'Bilet Detayları'),
        backgroundColor: context.colorScheme.primary,
      ),
      body: Padding(
        padding: AppPagePadding.all20(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: AppPagePadding.all20(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ProductText.h3(
                        context,
                        widget.flight['airline'] as String,
                        style: context.appTextTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingL),
                    buildDetailRow(context, 'Kalkış Şehri:', widget.flight['from'] as String),
                    buildDetailRow(context, 'Varış Şehri:', widget.flight['to'] as String),
                    buildDetailRow(context, 'Kalkış Saati:', widget.flight['departureTime'] as String),
                    buildDetailRow(context, 'Varış Saati:', widget.flight['arrivalTime'] as String),
                    buildDetailRow(context, 'Uçuş Süresi:', widget.flight['duration'] as String),
                    buildDetailRow(context, 'Tarih:', widget.flight['date'] as String),
                    buildDetailRow(context, 'Fiyat:', '${widget.flight['price']} ₺'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spacingXl),
            Card(
              elevation: 3,
              child: Padding(
                padding: AppPagePadding.all15(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductText.titleMedium(
                      context,
                      'Bagaj Bilgileri',
                      style: context.appTextTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacingS),
                    ProductText.bodyMedium(context, '• El bagajı: 8 kg dahil'),
                    ProductText.bodyMedium(context, '• Bagaj: 20 kg dahil'),
                    ProductText.bodyMedium(context, '• Yemek servisi mevcut'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spacingXl),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: ProductText.bodyMedium(context, 'Bilet rezerve edildi!'),
                    backgroundColor: context.appTheme.success,
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.appTheme.success,
                foregroundColor: context.colorScheme.onPrimary,
                minimumSize: const Size(double.infinity, AppSizes.buttonHeightMedium),
              ),
              child: ProductText.labelLarge(context, 'Rezervasyon Yap'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(BuildContext context, String title, String value) {
    return Padding(
      padding: AppPagePadding.pageVertical8(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProductText.titleMedium(context, title),
          ProductText.bodyLarge(
            context,
            value,
            style: context.appTextTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}