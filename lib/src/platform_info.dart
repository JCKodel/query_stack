class PlatformInfo {
  const PlatformInfo({required this.platformMedia, required this.platformHost});

  final PlatformMedia platformMedia;

  final PlatformHost platformHost;

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
        return PlatformDesignSystem.appleHumanIntercace;
      case PlatformHost.windows:
        return PlatformDesignSystem.fluentDesign;
      case PlatformHost.unknown:
        return PlatformDesignSystem.unknown;
    }
  }
}

/// The app is running as a native app in one of these OSes or is Flutter Web?
enum NativePlatform {
  /// Android phone or tablet
  android(singleLetterName: "A"),

  /// iPhone or iPad
  ios(singleLetterName: "I"),

  /// Windows machine
  windows(singleLetterName: "W"),

  /// MacOS machine
  macos(singleLetterName: "M"),

  /// Linux machine
  linux(singleLetterName: "L"),

  /// Flutter web
  web(singleLetterName: "B"),

  /// Unable to determine the native platform
  unknown(singleLetterName: "X");

  const NativePlatform({required this.singleLetterName});

  final String singleLetterName;
}

/// The design system used by the platform host
enum PlatformDesignSystem {
  /// Android or Linux
  materialDesign(singleLetterName: "M"),

  /// MacOS, iPhone or iPad
  appleHumanIntercace(singleLetterName: "A"),

  /// Windows machine
  fluentDesign(singleLetterName: "F"),

  /// Unable to determine the host or design system
  unknown(singleLetterName: "U");

  const PlatformDesignSystem({required this.singleLetterName});

  final String singleLetterName;
}

/// After considering `PlatformMedia`, which host is running the app?
enum PlatformHost {
  /// Android phone or tablet
  android(singleLetterName: "A"),

  /// iPhone or iPad
  ios(singleLetterName: "I"),

  /// Windows machine
  windows(singleLetterName: "W"),

  /// MacOS machine
  macos(singleLetterName: "M"),

  /// Linux machine
  linux(singleLetterName: "L"),

  /// Unable to determine the host
  unknown(singleLetterName: "U");

  const PlatformHost({required this.singleLetterName});

  final String singleLetterName;
}

/// What kind of platform the app is running?
enum PlatformMedia {
  /// App running on a web browser (Flutter Web)
  web(singleLetterName: "W"),

  /// App running on a native desktop enviroment (Windows, Linux or MacOS)
  desktop(singleLetterName: "D"),

  /// App running on a mobile device (Android or iOS)
  mobile(singleLetterName: "M"),

  /// Could not determine the media
  unknown(singleLetterName: "U");

  const PlatformMedia({required this.singleLetterName});

  final String singleLetterName;
}
