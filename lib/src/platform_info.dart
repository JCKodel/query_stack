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

  T when<T>({
    T Function()? onAndroid,
    T Function()? oniOS,
    T Function()? onWindows,
    T Function()? onMacOS,
    T Function()? onLinux,
    T Function()? onWeb,
    T Function()? orElse,
  }) {
    if (onAndroid == null && oniOS == null && onWindows == null && onMacOS == null && onLinux == null && onWeb == null) {
      throw UnsupportedError("At least one NativePlatform should be provided");
    }

    if (onAndroid == null || oniOS == null || onWindows == null || onMacOS == null || onLinux == null || onWeb == null) {
      if (orElse == null) {
        throw UnsupportedError("If not all NativePlatforms are provided, orElse should be provided");
      }
    }

    switch (this) {
      case NativePlatform.android:
        return (onAndroid ?? orElse)!();
      case NativePlatform.ios:
        return (oniOS ?? orElse)!();
      case NativePlatform.windows:
        return (onWindows ?? orElse)!();
      case NativePlatform.macos:
        return (onMacOS ?? orElse)!();
      case NativePlatform.linux:
        return (onLinux ?? orElse)!();
      case NativePlatform.web:
        return (onWeb ?? orElse)!();
      case NativePlatform.unknown:
        return orElse!();
    }
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

  T when<T>({
    T Function()? onMaterialDesign,
    T Function()? onAppleHumanInterface,
    T Function()? onFluentDesign,
    T Function()? orElse,
  }) {
    if (onMaterialDesign == null && onAppleHumanInterface == null && onFluentDesign == null) {
      throw UnsupportedError("At least one PlatformDesignSystem should be provided");
    }

    if (onMaterialDesign == null || onAppleHumanInterface == null || onFluentDesign == null) {
      if (orElse == null) {
        throw UnsupportedError("If not all PlatformDesignSystems are provided, orElse should be provided");
      }
    }

    switch (this) {
      case PlatformDesignSystem.materialDesign:
        return (onMaterialDesign ?? orElse)!();
      case PlatformDesignSystem.appleHumanInterface:
        return (onAppleHumanInterface ?? orElse)!();
      case PlatformDesignSystem.fluentDesign:
        return (onFluentDesign ?? orElse)!();
      case PlatformDesignSystem.unknown:
        return orElse!();
    }
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

  T when<T>({
    T Function()? onAndroid,
    T Function()? oniOS,
    T Function()? onWindows,
    T Function()? onMacOS,
    T Function()? onLinux,
    T Function()? orElse,
  }) {
    if (onAndroid == null && oniOS == null && onWindows == null && onMacOS == null && onLinux == null) {
      throw UnsupportedError("At least one PlatformHost should be provided");
    }

    if (onAndroid == null || oniOS == null || onWindows == null || onMacOS == null || onLinux == null) {
      if (orElse == null) {
        throw UnsupportedError("If not all PlatformHosts are provided, orElse should be provided");
      }
    }

    switch (this) {
      case PlatformHost.android:
        return (onAndroid ?? orElse)!();
      case PlatformHost.ios:
        return (oniOS ?? orElse)!();
      case PlatformHost.windows:
        return (onWindows ?? orElse)!();
      case PlatformHost.macos:
        return (onMacOS ?? orElse)!();
      case PlatformHost.linux:
        return (onLinux ?? orElse)!();
      case PlatformHost.unknown:
        return orElse!();
    }
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

  T when<T>({
    T Function()? onWeb,
    T Function()? onDesktop,
    T Function()? onMobile,
    T Function()? orElse,
  }) {
    if (onWeb == null && onDesktop == null && onMobile == null) {
      throw UnsupportedError("At least one PlatformMedia should be provided");
    }

    if (onWeb == null || onDesktop == null || onMobile == null) {
      if (orElse == null) {
        throw UnsupportedError("If not all PlatformMedias are provided, orElse should be provided");
      }
    }

    switch (this) {
      case PlatformMedia.web:
        return (onWeb ?? orElse)!();
      case PlatformMedia.desktop:
        return (onDesktop ?? orElse)!();
      case PlatformMedia.mobile:
        return (onMobile ?? orElse)!();
      case PlatformMedia.unknown:
        return orElse!();
    }
  }
}
