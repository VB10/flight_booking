abstract class PlatformInitializer {
  Future<void> prepare();
}

/// condintal important
final class WebPlatformInitializer implements PlatformInitializer {
  @override
  Future<void> prepare() async {
    // TODO: Implement web platform initialization
  }
}

final class MobilePlatformInitializer implements PlatformInitializer {
  @override
  Future<void> prepare() async {
    // TODO: Implement mobile platform initialization
  }
}
