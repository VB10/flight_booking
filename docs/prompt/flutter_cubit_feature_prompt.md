# Flutter Cubit + View + ValueListenable + State Prompt

Bu prompt, feature ekranlarında **flutter_bloc Cubit**, **Equatable state + copyWith**, **BlocSelector**, **View (StatefulWidget + mixin)** ve **ValueListenableBuilder** birlikte kullanımını standartlaştırır. Örnek referans: `lib/feature/unauth/login/`.

---

## PROMPT (kopyala-yapıştır)

```
Şu feature / sayfayı Cubit + mixin + ValueListenable desenine göre uygula veya refaktör et: {FEATURE_PATH}

Hedef yapı (feature kökü: lib/feature/{area}/{feature_name}/):
├── {feature_name}_page.dart          # StatefulWidget + part'lar + BlocProvider(create:) / BlocListener
├── cubit/
│   ├── {feature_name}_cubit.dart     # Cubit<State>, servisler constructor ile
│   └── {feature_name}_state.dart     # Equatable: tek state sınıfı + copyWith
├── view/
│   ├── {feature_name}_page_mixin.dart # part of — yaşam döngüsü, controller'lar, aksiyon metodları
│   └── widget/
│       └── {feature_name}_page_body.dart  # part of — BlocSelector, ValueListenableBuilder, alt widget'lar

Kurallar — Cubit & state:
- State sınıfı `Equatable` + `copyWith`; sealed class KULLANMA.
- State alanları: `isLoading`, `errorMessage`, `isSuccess` gibi düz alanlar; `props` doğru tanımlansın.
- İş akışı (API, cache, side-effect): Cubit içinde; UI sadece `emit` sonuçlarını dinler.
- State geçişlerinde `state.copyWith(...)` kullan; her emit'te sadece değişen alanları güncelle.
- Servis arayüzleri `ProductContainer.instance.get<I...>()` ile çözülür; gerekirse `lib/product/container/product_container.dart` içine kayıt ekle.
- Navigasyon / SnackBar gibi BuildContext gerektirenler: `BlocListener` ile, Cubit içinde `Navigator` kullanma.

Kurallar — BlocSelector:
- State'in tek bir alanını dinleyen widget'lar `BlocBuilder` yerine `BlocSelector` kullansın — gereksiz rebuild önlenir.
- Örnek: `BlocSelector<LoginCubit, LoginState, bool>(selector: (s) => s.isLoading, builder: ...)`.
- Birden fazla alan gerekiyorsa `BlocBuilder` veya `buildWhen` tercih et.

Kurallar — View & mixin:
- `final class {Feature}Page extends StatefulWidget`; `State` + `{Feature}PageMixin on State<{Feature}Page>`.
- Mixin: sadece **birden fazla widget tarafından paylaşılan** controller / notifier'lar burada olsun. Tek bir widget'a ait notifier'ı o widget'ın kendi State'inde tanımla.
- Mixin'de `initState` ve `dispose` ile controller lifecycle yönetimi.
- Ana sayfa `build`: `BlocProvider(create: (_) => Cubit(...))` + `BlocListener` + `Scaffold` + body.

Kurallar — ValueNotifier & isimlendirme:
- ValueNotifier değişkenleri `Notifier` suffix'i ile bitsin: `obscureNotifier`, `expandedNotifier`, `selectedTabNotifier`.
- Notifier sadece tek bir widget'ta kullanılıyorsa → o widget `StatefulWidget` olsun, kendi `State`'inde oluştursun/dispose etsin. Mixin'den geçirme.
- Notifier birden fazla widget'tan erişiliyorsa → mixin'de tanımla, body'ye geçir.
- setState kullanma: sunucu/ekran durumu Cubit'te; küçük yerel UI (şifre göster/gizle, panel aç/kapa, chip) `ValueNotifier` + `ValueListenableBuilder`.
- Her notifier için `dispose` unutulmasın.
- `dart:async` `unawaited` ile fire-and-forget Future'lar lint uyarılarını giderir.

Bağımlılıklar:
- flutter_bloc, equatable, get_it (ProductContainer)

Adımlar:
1. Cubit + state dosyalarını cubit/ altında oluştur veya güncelle.
2. product_container'a gerekli I* servis kayıtlarını ekle.
3. view/*_page_mixin.dart ile paylaşılan controller'ları mixin'e taşı.
4. Body'de BlocSelector (tek alan) veya BlocBuilder (çoklu alan) ve ValueListenableBuilder (yerel UI).
5. dart analyze lib/feature/{area}/{feature_name} çalıştır.
```

---

## Katman sorumlulukları

| Katman | Sorumluluk |
|--------|------------|
| **{Feature}State** | Equatable + copyWith; `isLoading`, `errorMessage`, `isSuccess` vb. düz alanlarla tüm durumları tek sınıfta tutar. |
| **{Feature}Cubit** | `emit(state.copyWith(...))`, async işler, `IAuthService` / `IFlightService` vb.; token/cache/analytics burada. |
| **{Feature}PageMixin** | Sadece paylaşılan controller'lar ve aksiyon metodları. Tek widget'a ait notifier burada olmaz. |
| **Body widget'ları** | `BlocSelector` tek alan için; `BlocBuilder` / `BlocListener` çoklu alan için; `ValueListenableBuilder` yerel UI state için. Widget'a özel notifier kendi `State`'inde. |

---

## State şablonu (copyWith)

### Form / aksiyon state (login örneği)

```dart
import 'package:equatable/equatable.dart';

@immutable
final class LoginState extends Equatable {
  const LoginState({
    this.isLoading = false,
    this.errorMessage = '',
    this.isSuccess = false,
  });

  final bool isLoading;
  final String errorMessage;
  final bool isSuccess;

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, isSuccess];
}
```

### Liste state (flight örneği)

```dart
final class FlightListState extends Equatable {
  const FlightListState({
    this.isLoading = false,
    this.errorMessage = '',
    this.flights = const [],
  });

  final bool isLoading;
  final String errorMessage;
  final List<FlightModel> flights;

  FlightListState copyWith({ ... }) { ... }

  @override
  List<Object?> get props => [isLoading, errorMessage, flights];
}
```

---

## Cubit şablonu (özet)

```dart
final class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authService, this._networkManager)
      : super(const LoginState());

  final IAuthService _authService;
  final IProductNetworkManager _networkManager;

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(isLoading: true, errorMessage: '', isSuccess: false));
    // ... fold / emit state.copyWith(isLoading: false, isSuccess: true)
    //         veya state.copyWith(isLoading: false, errorMessage: '...')
  }
}
```

---

## Sayfa + mixin şablonu (özet)

```dart
// {feature}_page.dart
part 'view/{feature}_page_mixin.dart';
part 'view/widget/{feature}_page_body.dart';

final class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

final class _LoginPageState extends State<LoginPage> with LoginPageMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => loginCubit,
      child: BlocListener<LoginCubit, LoginState>(
        listenWhen: (p, c) => c.isSuccess && !p.isSuccess,
        listener: (context, state) { /* Navigator */ },
        child: Scaffold(
          body: _LoginPageBody(
            emailController: emailController,
            passwordController: passwordController,
            onLogin: () => onLoginPressed(context),
          ),
        ),
      ),
    );
  }
}
```

```dart
// view/login_page_mixin.dart — sadece paylaşılan controller ve aksiyonlar
part of '../login_page.dart';

mixin LoginPageMixin on State<LoginPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  late final LoginCubit loginCubit = LoginCubit(
    ProductContainer.instance.get<IAuthService>(),
    ProductContainer.instance.get<IProductNetworkManager>(),
  );

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onLoginPressed(BuildContext context) {
    unawaited(loginCubit.login(
      email: emailController.text,
      password: passwordController.text,
    ));
  }
}
```

---

## BlocSelector — tek alan dinleme (gereksiz rebuild önleme)

```dart
// Sadece isLoading değişince rebuild — errorMessage veya isSuccess değişince rebuild OLMAZ
BlocSelector<LoginCubit, LoginState, bool>(
  selector: (state) => state.isLoading,
  builder: (context, isLoading) {
    if (isLoading) return const CircularProgressIndicator();
    return ElevatedButton(onPressed: onLogin, child: Text('Login'));
  },
)

// Sadece errorMessage değişince rebuild
BlocSelector<LoginCubit, LoginState, String>(
  selector: (state) => state.errorMessage,
  builder: (context, errorMessage) {
    if (errorMessage.isEmpty) return const SizedBox.shrink();
    return Text(errorMessage, style: TextStyle(color: Colors.red));
  },
)
```

**Ne zaman BlocSelector, ne zaman BlocBuilder?**
- Widget state'in **tek bir alanını** dinliyorsa → `BlocSelector`
- Widget state'in **birden fazla alanını** dinliyorsa → `BlocBuilder` (opsiyonel `buildWhen`)

---

## ValueListenableBuilder — widget'a özel notifier

```dart
// Şifre göster/gizle — _LoginPasswordField kendi notifier'ını yönetir
final class _LoginPasswordField extends StatefulWidget {
  const _LoginPasswordField({required this.controller});
  final TextEditingController controller;

  @override
  State<_LoginPasswordField> createState() => _LoginPasswordFieldState();
}

class _LoginPasswordFieldState extends State<_LoginPasswordField> {
  late final ValueNotifier<bool> obscureNotifier;

  @override
  void initState() {
    super.initState();
    obscureNotifier = ValueNotifier(true);
  }

  @override
  void dispose() {
    obscureNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscureNotifier,
      builder: (context, obscure, _) {
        return TextField(
          controller: widget.controller,
          obscureText: obscure,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () => obscureNotifier.value = !obscureNotifier.value,
              icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
            ),
          ),
        );
      },
    );
  }
}
```

---

## ProductContainer

- `ProductContainer.instance.setup()` uygulama başında bir kez (`main.dart`).
- Yeni servis: `registerLazySingleton<IAuthService>(() => AuthServiceImpl(_getIt()))` vb.
- Cubit genelde **sayfa başına bir örnek**; mixin'de `late final` ile oluşturulur, `BlocProvider(create: (_) => cubit)` ile sağlanır.

---

## İlgili dosyalar (bu repo)

- Login: `lib/feature/unauth/login/login_page.dart`, `view/login_page_mixin.dart`, `cubit/login_cubit.dart`, `cubit/login_state.dart`
- Flight list: `lib/feature/auth/flight/` — `FlightListCubit`, `BlocProvider` sayfa içinde
- DI: `lib/product/container/product_container.dart`

---

## Diğer prompt'larla ilişki

- **View + ValueNotifier + ViewModel** (eski): `docs/prompt/view_refactor_prompt.md`
- **Cubit + mixin + ValueListenable** (bu dosya): sunucu durumu Cubit'te; yerel UI notifier'da; mixin sadece paylaşılan controller'lar için.
