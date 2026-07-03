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

## 📋 Planlanan Ana Feature'lar

### Cache Manager (v11)
- [x] Cache manager soyutlaması — `module/cache_manager` local package (ICacheManager + Strategy)
- [x] Hive primary + SharedPreferences fallback (kritik key'lerde dual-write)
- [x] AuthCubit + profile_page → ICacheManager refactor
- [x] Package testleri (strateji + fallback davranışı)
- [x] Skill'ler: `/cache-setup` + `/cache-add-model` (Hive model besleme)
- Issue: https://github.com/VB10/flight_booking/issues/14

### Code Generation & Assets (v12)
- [ ] Asset generation (flutter_gen)
- [ ] Localization (easy_localization / intl)
- [ ] Build runner script/otomasyon düzeni

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
**Son Güncelleme:** v10 yayınlandı (Navigation - go_router)
**Sıradaki Bölüm:** v11 - Cache Manager
