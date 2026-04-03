# Flutter Cubit + View + ValueListenable + State Prompt

Bu prompt, feature ekranlarında **flutter_bloc Cubit**, **Equatable state + copyWith**, **View (StatefulWidget + mixin)** ve **ValueListenableBuilder** birlikte kullanımını standartlaştırır. Örnek referans: `lib/feature/unauth/login/` (LoginCubit, LoginPageMixin, şifre görünürlüğü ve test bilgisi alanları).

---

## PROMPT (kopyala-yapıştır)

```
Şu feature / sayfayı Cubit + mixin + ValueListenable desenine göre uygula veya refaktör et: {FEATURE_PATH}

Hedef yapı (feature kökü: lib/feature/{area}/{feature_name}/):
├── {feature_name}_page.dart          # StatefulWidget + part'lar + BlocProvider.value / BlocListener
├── cubit/
│   ├── {feature_name}_cubit.dart     # Cubit<State>, servisler constructor ile
│   └── {feature_name}_state.dart     # Equatable: tek state sınıfı + copyWith
├── view/
│   ├── {feature_name}_page_mixin.dart # part of — yaşam döngüsü, notifier'lar, Cubit oluşturma, aksiyon metodları
│   └── widget/
│       └── {feature_name}_page_body.dart  # part of — BlocBuilder, ValueListenableBuilder, alt widget'lar

Kurallar — Cubit & state:
- State sınıfı `Equatable` + `copyWith`; sealed class KULLANMA.
- State alanları: `isLoading`, `errorMessage`, `isSuccess` gibi düz alanlar; `props` doğru tanımlansın.
- İş akışı (API, cache, side-effect): Cubit içinde; UI sadece `emit` sonuçlarını dinler.
- State geçişlerinde `state.copyWith(...)` kullan; her emit'te sadece değişen alanları güncelle.
- Servis arayüzleri `ProductContainer.instance.get<I...>()` ile çözülür; gerekirse `lib/product/container/product_container.dart` içine kayıt ekle.
- Navigasyon / SnackBar gibi BuildContext gerektirenler: `BlocListener` veya `listener` ile, Cubit içinde `Navigator` kullanma.

Kurallar — View & mixin:
- `final class {Feature}Page extends StatefulWidget`; `State` + `{Feature}PageMixin on State<{Feature}Page>`.
- Mixin: `late final` TextEditingController / `ValueNotifier`; `initState` ve `dispose` burada. Cubit'e `context.read<Cubit>()` ile erişilir (lifecycle'ı `BlocProvider` yönetir).
- Ana sayfa `build`: `BlocProvider(create: (_) => Cubit(...))` + `BlocListener` + `Scaffold` + body widget'a mixin alanlarını ve callback'leri geçir. `BlocProvider.value` sadece dışarıdan gelen cubit için kullanılır.
- setState kullanma: sunucu/ekran durumu Cubit'te; küçük yerel UI (şifre göster/gizle, panel aç/kapa, chip) `ValueNotifier` + `ValueListenableBuilder`.

Kurallar — ValueListenableBuilder:
- Her notifier için `dispose` unutulmasın.
- Buton / ikon metni dinamikse tek `ValueListenableBuilder` içinde Column ile buton + koşullu alt içerik verilebilir.
- `dart:async` `unawaited` ile fire-and-forget Future'lar (login, navigate) lint uyarılarını giderir.

Bağımlılıklar:
- flutter_bloc, equatable, get_it (ProductContainer)

Adımlar:
1. Cubit + state dosyalarını cubit/ altında oluştur veya güncelle.
2. product_container'a gerekli I* servis kayıtlarını ekle.
3. view/*_page_mixin.dart ile mantığı mixin'e taşı.
4. Body'de BlocBuilder (yükleniyor/hata/içerik) ve ValueListenableBuilder (yerel UI).
5. dart analyze lib/feature/{area}/{feature_name} çalıştır.
```

---

## Katman sorumlulukları

| Katman | Sorumluluk |
|--------|------------|
| **{Feature}State** | Equatable + copyWith; `isLoading`, `errorMessage`, `isSuccess` vb. düz alanlarla tüm durumları tek sınıfta tutar. |
| **{Feature}Cubit** | `emit(state.copyWith(...))`, async işler, `IAuthService` / `IFlightService` vb.; token/cache/analytics burada veya use-case'e delege. |
| **{Feature}PageMixin** | Controller ve `ValueNotifier`'lar, `onSubmit` gibi ince metodlar → `context.read<Cubit>()` ile Cubit çağrısı. |
| **Body widget'ları** | `BlocBuilder` / `BlocListener`; `ValueListenableBuilder` sadece yerel UI state için. |

---

## State şablonu (copyWith)

### Form / aksiyon state (login örneği)

```dart
import 'package:equatable/equatable.dart';

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
      create: (_) => LoginCubit(
        ProductContainer.instance.get<IAuthService>(),
        ProductContainer.instance.get<IProductNetworkManager>(),
      ),
      child: BlocListener<LoginCubit, LoginState>(
        listenWhen: (p, c) => c.isSuccess && !p.isSuccess,
        listener: (context, state) { /* Navigator */ },
        child: Scaffold(
          body: _LoginPageBody(
            emailController: emailController,
            obscurePassword: obscurePassword,
            testAccountExpanded: testAccountExpanded,
            onLogin: onLoginPressed,
            onToggleTestAccount: toggleTestAccountSection,
          ),
        ),
      ),
    );
  }
}
```

```dart
// view/login_page_mixin.dart
part of '../login_page.dart';

mixin LoginPageMixin on State<LoginPage> {
  late final TextEditingController emailController;
  late final ValueNotifier<bool> obscurePassword;
  late final ValueNotifier<bool> testAccountExpanded;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    obscurePassword = ValueNotifier(true);
    testAccountExpanded = ValueNotifier(false);
  }

  @override
  void dispose() {
    emailController.dispose();
    obscurePassword.dispose();
    testAccountExpanded.dispose();
    super.dispose();
  }

  void onLoginPressed() {
    unawaited(context.read<LoginCubit>().login(
      email: emailController.text,
      password: passwordController.text,
    ));
  }

  void toggleTestAccountSection() {
    testAccountExpanded.value = !testAccountExpanded.value;
  }
}
```

---

## BlocBuilder ve ValueListenableBuilder

```dart
// Sunucu / form sonucu — state alanları doğrudan erişilir
BlocBuilder<LoginCubit, LoginState>(
  builder: (context, state) {
    return Column(
      children: [
        if (state.errorMessage.isNotEmpty) _LoginErrorText(message: state.errorMessage),
        _LoginButton(isLoading: state.isLoading, onPressed: onLogin),
      ],
    );
  },
)

// Yerel UI (setState yok)
ValueListenableBuilder<bool>(
  valueListenable: obscurePassword,
  builder: (context, obscure, _) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () => obscurePassword.value = !obscurePassword.value,
          icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
        ),
      ),
    );
  },
)
```

---

## ProductContainer

- `ProductContainer.instance.setup()` uygulama başında bir kez (`main.dart`).
- Yeni servis: `registerLazySingleton<IAuthService>(() => AuthServiceImpl(_getIt()))` vb.
- Cubit genelde **sayfa başına bir örnek**; `registerFactory` ile GetIt'e koymak şart değil — mixin `initState`'te `LoginCubit(...)` yeterli; `BlocProvider.value` ile verilir.

---

## İlgili dosyalar (bu repo)

- Login: `lib/feature/unauth/login/login_page.dart`, `view/login_page_mixin.dart`, `cubit/login_cubit.dart`, `cubit/login_state.dart`
- Flight list: `lib/feature/auth/flight/` — `FlightListCubit`, `BlocProvider` sayfa içinde
- DI: `lib/product/container/product_container.dart`

---

## Diğer prompt'larla ilişki

- **View + ValueNotifier + ViewModel** (eski): `docs/prompt/view_refactor_prompt.md`
- **Cubit + mixin + ValueListenable** (bu dosya): sunucu durumu Cubit'te; yerel UI notifier'da; mixin yaşam döngüsü ve aksiyonları toplar.
