part of query_stack_environment;

/// What kind of platform the app is running?
enum PlatformMedia {
  /// App running on a web browser (Flutter Web)
  web,

  /// App running on a native desktop enviroment (Windows, Linux or MacOS)
  desktop,

  /// App running on a mobile device (Android or iOS)
  mobile,

  /// Could not determine the media
  unknown;

  T when<T>({
    T Function()? onWeb,
    T Function()? onDesktop,
    T Function()? onMobile,
    T Function()? orElse,
  }) {
    if (onWeb == null && onDesktop == null && onMobile == null) {
      throw UnsupportedError(
        "At least one PlatformMedia should be provided",
      );
    }

    if (onWeb == null || onDesktop == null || onMobile == null) {
      if (orElse == null) {
        throw UnsupportedError(
          "If not all PlatformMedias are provided, orElse should be provided",
        );
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
