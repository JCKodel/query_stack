import 'dart:io';

import '../environment.dart';

import 'current_platform.dart';

CurrentPlatform getCurrentPlatformInfo() {
  if (Platform.isAndroid) {
    return const CurrentPlatform(PlatformMedia.mobile, PlatformHost.android);
  }

  if (Platform.isIOS) {
    return const CurrentPlatform(PlatformMedia.mobile, PlatformHost.ios);
  }

  if (Platform.isWindows) {
    return const CurrentPlatform(PlatformMedia.desktop, PlatformHost.windows);
  }

  if (Platform.isMacOS) {
    return const CurrentPlatform(PlatformMedia.desktop, PlatformHost.macos);
  }

  if (Platform.isLinux) {
    return const CurrentPlatform(PlatformMedia.desktop, PlatformHost.linux);
  }

  return const CurrentPlatform(PlatformMedia.unknown, PlatformHost.unknown);
}
