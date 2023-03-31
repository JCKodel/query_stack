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
        return PlatformDesignSystem.appleHumanInterface;
      case PlatformHost.windows:
        return PlatformDesignSystem.fluentDesign;
      case PlatformHost.unknown:
        return PlatformDesignSystem.unknown;
    }
  }
}

const _kAndroidNativePlatform = "A";
const _kiOSNativePlatform = "I";
const _kWindowsNativePlatform = "W";
const _kMacOSNativePlatform = "M";
const _kLinuxNativePlatform = "L";
const _kWebNativePlatform = "B";
const _kUnknownNativePlatform = "U";

/// The app is running as a native app in one of these OSes or is Flutter Web?
enum NativePlatform {
  /// Android phone or tablet
  android(singleLetterName: _kAndroidNativePlatform),

  /// iPhone or iPad
  ios(singleLetterName: _kiOSNativePlatform),

  /// Windows machine
  windows(singleLetterName: _kWindowsNativePlatform),

  /// MacOS machine
  macos(singleLetterName: _kMacOSNativePlatform),

  /// Linux machine
  linux(singleLetterName: _kLinuxNativePlatform),

  /// Flutter web
  web(singleLetterName: _kWebNativePlatform),

  /// Unable to determine the native platform
  unknown(singleLetterName: _kUnknownNativePlatform);

  const NativePlatform({required this.singleLetterName});

  final String singleLetterName;

  static NativePlatform fromSingleLetterName(String singleLetterName) {
    return {
      _kAndroidNativePlatform: NativePlatform.android,
      _kiOSNativePlatform: NativePlatform.ios,
      _kWindowsNativePlatform: NativePlatform.windows,
      _kMacOSNativePlatform: NativePlatform.macos,
      _kLinuxNativePlatform: NativePlatform.linux,
      _kWebNativePlatform: NativePlatform.web,
      _kUnknownNativePlatform: NativePlatform.unknown,
    }[singleLetterName]!;
  }
}

const _kMaterialDesignPlatformDesignSystem = "M";
const _kAppleHumanInterfacePlatformDesignSystem = "A";
const _kFluentDesignPlatformDesignSystem = "F";
const _kUnknownPlatformDesignSystem = "U";

/// The design system used by the platform host
enum PlatformDesignSystem {
  /// Android or Linux
  materialDesign(singleLetterName: "M"),

  /// MacOS, iPhone or iPad
  appleHumanInterface(singleLetterName: "A"),

  /// Windows machine
  fluentDesign(singleLetterName: "F"),

  /// Unable to determine the host or design system
  unknown(singleLetterName: "U");

  const PlatformDesignSystem({required this.singleLetterName});

  final String singleLetterName;

  static PlatformDesignSystem fromSingleLetterName(String singleLetterName) {
    return {
      _kMaterialDesignPlatformDesignSystem: PlatformDesignSystem.materialDesign,
      _kAppleHumanInterfacePlatformDesignSystem: PlatformDesignSystem.appleHumanInterface,
      _kFluentDesignPlatformDesignSystem: PlatformDesignSystem.fluentDesign,
      _kUnknownPlatformDesignSystem: PlatformDesignSystem.unknown,
    }[singleLetterName]!;
  }
}

const _kAndroidPlatformHost = "A";
const _kiOSPlatformHost = "I";
const _kWindowsPlatformHost = "W";
const _kMacOSPlatformHost = "M";
const _kLinuxPlatformHost = "L";
const _kUnknownPlatformHost = "U";

/// After considering `PlatformMedia`, which host is running the app?
enum PlatformHost {
  /// Android phone or tablet
  android(singleLetterName: _kAndroidPlatformHost),

  /// iPhone or iPad
  ios(singleLetterName: _kiOSPlatformHost),

  /// Windows machine
  windows(singleLetterName: _kWindowsPlatformHost),

  /// MacOS machine
  macos(singleLetterName: _kMacOSPlatformHost),

  /// Linux machine
  linux(singleLetterName: _kLinuxPlatformHost),

  /// Unable to determine the host
  unknown(singleLetterName: _kUnknownPlatformHost);

  const PlatformHost({required this.singleLetterName});

  final String singleLetterName;

  static PlatformHost fromSingleLetterName(String singleLetterName) {
    return {
      _kAndroidPlatformHost: PlatformHost.android,
      _kiOSPlatformHost: PlatformHost.ios,
      _kWindowsPlatformHost: PlatformHost.windows,
      _kMacOSPlatformHost: PlatformHost.macos,
      _kLinuxPlatformHost: PlatformHost.linux,
      _kUnknownPlatformHost: PlatformHost.unknown,
    }[singleLetterName]!;
  }
}

const _kWebPlatformMedia = "W";
const _kDesktopPlatformMedia = "D";
const _kMobilePlatformMedia = "M";
const _kUnknownPlatformMedia = "U";

/// What kind of platform the app is running?
enum PlatformMedia {
  /// App running on a web browser (Flutter Web)
  web(singleLetterName: _kWebPlatformMedia),

  /// App running on a native desktop enviroment (Windows, Linux or MacOS)
  desktop(singleLetterName: _kDesktopPlatformMedia),

  /// App running on a mobile device (Android or iOS)
  mobile(singleLetterName: _kMobilePlatformMedia),

  /// Could not determine the media
  unknown(singleLetterName: _kUnknownPlatformMedia);

  const PlatformMedia({required this.singleLetterName});

  final String singleLetterName;

  static PlatformMedia fromSingleLetterName(String singleLetterName) {
    return {
      _kWebPlatformMedia: PlatformMedia.web,
      _kDesktopPlatformMedia: PlatformMedia.desktop,
      _kMobilePlatformMedia: PlatformMedia.mobile,
      _kUnknownPlatformMedia: PlatformMedia.unknown,
    }[singleLetterName]!;
  }
}
