part of query_stack_environment;

@immutable
class PlatformInfo {
  const PlatformInfo._({required this.platformMedia, required this.platformHost});

  final PlatformMedia platformMedia;
  final PlatformHost platformHost;

  static PlatformInfo? _current;

  static PlatformInfo get current {
    if (_current != null) {
      return _current!;
    }

    final currentPlatform = getCurrentPlatformInfo();

    return _current = PlatformInfo._(
      platformMedia: currentPlatform.platformMedia,
      platformHost: currentPlatform.platformHost,
    );
  }

  NativePlatform get nativePlatform {
    switch (platformMedia) {
      case PlatformMedia.web:
        return NativePlatform.web;
      case PlatformMedia.desktop:
        switch (platformHost) {
          case PlatformHost.windows:
            return NativePlatform.windows;
          case PlatformHost.macos:
            return NativePlatform.macos;
          case PlatformHost.linux:
            return NativePlatform.linux;
          default:
            return NativePlatform.unknown;
        }
      case PlatformMedia.mobile:
        switch (platformHost) {
          case PlatformHost.android:
            return NativePlatform.android;
          case PlatformHost.ios:
            return NativePlatform.ios;
          default:
            return NativePlatform.unknown;
        }
      case PlatformMedia.unknown:
        return NativePlatform.unknown;
    }
  }

  PlatformDesignSystem get platformDesignSystem {
    switch (platformHost) {
      case PlatformHost.android:
      case PlatformHost.linux:
        return PlatformDesignSystem.materialDesign;
      case PlatformHost.ios:
      case PlatformHost.macos:
        return PlatformDesignSystem.appleHumanInterface;
      case PlatformHost.windows:
        return PlatformDesignSystem.fluentDesign;
      case PlatformHost.unknown:
        return PlatformDesignSystem.unknown;
    }
  }
}
