# Flutter Custom Theme Extension Implementation Prompt

## Görev
Flutter projesine Material 3 tabanlı custom theme extension sistemi kurmak. Bu sistem, Flutter'ın varsayılan theme yapısını genişleterek projeye özel renkler ve değerler eklemenizi sağlar.

## Gereksinimler

### 1. ThemeExtension Sınıfı Oluşturma
- `ThemeExtension<AppThemeExtension>` sınıfından türeyen bir extension sınıfı oluşturun
- Light ve dark theme için ayrı static instance'lar tanımlayın
- `copyWith()` ve `lerp()` metodlarını implement edin
- Aşağıdaki custom renkleri içermeli:
  - `brandPrimary`: Marka birincil rengi
  - `brandSecondary`: Marka ikincil rengi
  - `success`: Başarı durumu rengi
  - `warning`: Uyarı durumu rengi
  - `info`: Bilgi durumu rengi
  - `cardBackground`: Kart arka plan rengi
  - `divider`: Ayırıcı çizgi rengi
  - `shimmerBase`: Shimmer efekti için base rengi
  - `shimmerHighlight`: Shimmer efekti için highlight rengi

### 2. BuildContext Extension
- `BuildContext` için bir extension ekleyin
- `context.appTheme` ile kolay erişim sağlayın
- Null-safe olmalı (`!` operatörü kullanılabilir)

### 3. ThemeData Entegrasyonu
- `AppTheme.lightTheme` ve `AppTheme.darkTheme` içinde `extensions` parametresine extension'ı ekleyin
- Extension'ı `ThemeExtension<dynamic>` listesine ekleyin

### 4. Export
- Extension dosyasını barrel export dosyasına (`theme.dart`) ekleyin

## Dosya Yapısı

```
lib/core/theme/
├── app_theme_extension.dart  # Yeni oluşturulacak
├── app_theme.dart            # Güncellenecek
└── theme.dart                 # Güncellenecek
```

## Örnek Kullanım

```dart
// Extension ile erişim
context.appTheme.brandPrimary
context.appTheme.success
context.appTheme.cardBackground

// Shimmer efekti için
Shimmer.fromColors(
  baseColor: context.appTheme.shimmerBase,
  highlightColor: context.appTheme.shimmerHighlight,
  child: Widget(),
)

// Card widget için
Container(
  color: context.appTheme.cardBackground,
  child: Widget(),
)
```

## Teknik Detaylar

1. **ThemeExtension Interface**: Flutter'ın `ThemeExtension<T>` abstract sınıfını extend edin
2. **copyWith**: Yeni bir instance döndüren, değişen değerleri override eden metod
3. **lerp**: İki extension arasında animasyon için interpolasyon yapan metod
4. **Color.lerp**: Renkler arası geçiş için Flutter'ın built-in `Color.lerp` metodunu kullanın

## Kontrol Listesi

- [ ] `AppThemeExtension` sınıfı oluşturuldu
- [ ] `light` ve `dark` static instance'lar tanımlandı
- [ ] `copyWith()` metodu implement edildi
- [ ] `lerp()` metodu implement edildi
- [ ] `BuildContext` extension eklendi
- [ ] `AppTheme.lightTheme` ve `darkTheme` içine extension eklendi
- [ ] Barrel export dosyasına eklendi
- [ ] `flutter analyze` hatasız geçiyor
- [ ] Kullanım örnekleri test edildi

## Notlar

- Extension değerleri `AppColors` sınıfından referans alabilir
- Light ve dark theme için farklı renk değerleri kullanılmalı
- Tüm renkler `const Color` olarak tanımlanmalı
- Extension'lar null-safe olmalı (`!` operatörü kullanılabilir)

## Beklenen Çıktı

- `lib/core/theme/app_theme_extension.dart`: Custom theme extension sınıfı
- `lib/core/theme/app_theme.dart`: Extension'ın entegre edildiği güncellenmiş tema dosyası
- `lib/core/theme/theme.dart`: Extension'ın export edildiği barrel dosyası
- Tüm dosyalar linter kurallarına uygun ve hatasız
