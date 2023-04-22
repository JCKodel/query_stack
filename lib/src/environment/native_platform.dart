part of query_stack_environment;

/// The app is running as a native app in one of these OSes or is Flutter Web?
enum NativePlatform {
  /// Android phone or tablet
  android,

  /// iPhone or iPad
  ios,

  /// Windows machine
  windows,

  /// MacOS machine
  macos,

  /// Linux machine
  linux,

  /// Flutter web
  web,

  /// Unable to determine the native platform
  unknown;

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
