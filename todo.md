# Flutter Refactoring Masterclass - Todo List

## ✅ Yayınlanan Bölümler
- ✅ v1: Proje inceleme, analiz ve yapılacaklar
- ✅ v2: Pubspec.yaml kontrolü ve düzenlemesi
- ✅ v3: Kod standartları, Linter, Editor ayarları
- ✅ v4: Paket mimarisi ve klasör yapısı
- ✅ v5: Proje başlangıç noktası ve Environment yönetimi
- ✅ v6: Theme & Design System (light/dark)
- ✅ v7: View - ViewModel - Mixin mimarisi
- ✅ v8: Network & Service Layer mimarisi (+ get_it DI, model/JSON serialization)
- ✅ v9: State Management - ValueNotifier + Cubit pattern
- ✅ v10: Navigation - go_router + AuthCubit (Typed Routes)
- ✅ v11: Cache Manager - Hive + Strategy Pattern + Fallback store — https://youtu.be/V8fA71Q-CRE

## 📋 Planlanan Ana Feature'lar

### Code Generation & Assets (v12)
**Asset generation (flutter_gen)**
- [x] `flutter_gen_runner` + pubspec `flutter_gen:` konfigürasyonu
- [x] Asset klasör düzeni normalize (`icon/svg`, `animation/lottie`, `image/png`)
- [x] Eksik Roboto font varyantlarını pubspec'e tanımla → `FontFamily.roboto`
- [x] Kırık 3 SVG path'ini generated `Assets` referanslarıyla değiştir

**Localization (easy_localization)**
- [x] `ProductLocalization` wrapper — paketi sayfalardan gizle (v11 felsefesi)
- [x] `assets/translations/{en,tr}.json` + `LocaleKeys` codegen
- [x] `MainApp` + `main.dart` bootstrap entegrasyonu
- [x] Locale tercihi `ICacheManager` ile kalıcı (ApplicationCubit)
- [x] Pilot migrasyon: login + flight_list (kalanı `/masterflutter-localization-add-key` ile)

**Build runner script/otomasyon düzeni**
- [x] `build.yaml`: flutter_gen + easy_localization builder'ları
- [x] `build_runner.sh` + `generate_models.sh` → tek `scripts/generate.sh`
- [x] `.vscode/tasks.json` + README "Code Generation" bölümü

**Skill & Command**
- [x] Tüm skill/command'lara `masterflutter-` prefix'i
- [x] Yeni skill'ler: `/masterflutter-codegen-setup`, `/masterflutter-asset-add`, `/masterflutter-localization-add-key`
- Issue: https://github.com/VB10/flight_booking/issues/17

### Custom Package & Widget Library (v13)
- [ ] Custom widget library
- [ ] Custom package management

### Testing (v14)
- [ ] Unit test yapısı ve coverage
- [ ] Widget test setup
- [ ] Integration test
- [ ] Mock ve test utilities
- [ ] Test automation

### Logging & Monitoring (v15)
- [ ] Logging yapısı (Talker / Logger)
- [ ] Error tracking
- [ ] Analytics integration
- [ ] Performance monitoring

### Security (v16)
- [ ] API key management
- [ ] Secure storage implementation
- [ ] Certificate pinning
- [ ] Obfuscation settings
- [ ] Sensitive data handling

### Multi-Flavor Setup (v17)
- [ ] Development, staging, production flavors
- [ ] Flavor-specific configuration
- [ ] Build variants
- [ ] Environment-based service endpoints

### Scripts & Automation (v18)
- [ ] Build scripts
- [ ] Code generation scripts
- [ ] Test automation scripts
- [ ] Deployment automation

### Deployment & Publishing (v19)
- [ ] iOS build ve publish süreci
- [ ] Android build ve publish süreci
- [ ] CI/CD pipeline setup
- [ ] Version management
- [ ] Store listing optimizasyonu

### Best Practices & Clean Code (v20)
- [ ] Code review ve refactoring
- [ ] Performance optimization
- [ ] Memory leak kontrolü
- [ ] Accessibility features
- [ ] Documentation

## 🔧 Refactoring (Ana feature'lar bittikten sonra)
> Login zaten cubit/view/mixin ile refactor edildi. Kalanlar eski tek-dosya halinde.
- [ ] Splash Page
- [ ] Flight List Page
- [ ] Flight Detail Page
- [ ] Cart Page
- [ ] Profile Page

---
**Son Güncelleme:** v11 yayınlandı (Cache Manager) · v12 kodu hazır, kayıt bekliyor
**Sıradaki Bölüm:** v12 - Code Generation & Assets (flutter_gen + easy_localization)
