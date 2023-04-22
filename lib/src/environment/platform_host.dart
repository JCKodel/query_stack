part of query_stack_environment;

/// After considering `PlatformMedia`, which host is running the app?
enum PlatformHost {
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

  /// Unable to determine the host
  unknown;

  T when<T>({
    T Function()? onAndroid,
    T Function()? oniOS,
    T Function()? onWindows,
    T Function()? onMacOS,
    T Function()? onLinux,
    T Function()? orElse,
  }) {
    if (onAndroid == null && oniOS == null && onWindows == null && onMacOS == null && onLinux == null) {
      throw UnsupportedError(
        "At least one PlatformHost should be provided",
      );
    }

    if (onAndroid == null || oniOS == null || onWindows == null || onMacOS == null || onLinux == null) {
      if (orElse == null) {
        throw UnsupportedError(
          "If not all PlatformHosts are provided, orElse should be provided",
        );
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
