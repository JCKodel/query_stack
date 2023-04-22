part of query_stack_environment;

/// The design system used by the platform host
enum PlatformDesignSystem {
  /// Android or Linux
  materialDesign,

  /// MacOS, iPhone or iPad
  appleHumanInterface,

  /// Windows machine
  fluentDesign,

  /// Unable to determine the host or design system
  unknown;

  T when<T>({
    T Function()? onMaterialDesign,
    T Function()? onAppleHumanInterface,
    T Function()? onFluentDesign,
    T Function()? orElse,
  }) {
    if (onMaterialDesign == null && onAppleHumanInterface == null && onFluentDesign == null) {
      throw UnsupportedError(
        "At least one PlatformDesignSystem should be provided",
      );
    }

    if (onMaterialDesign == null || onAppleHumanInterface == null || onFluentDesign == null) {
      if (orElse == null) {
        throw UnsupportedError(
          "If not all PlatformDesignSystems are provided, orElse should be provided",
        );
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
