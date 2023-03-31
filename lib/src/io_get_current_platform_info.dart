import 'dart:io';

import 'platform_info.dart';

PlatformInfo getCurrentPlatformInfo() {
  if (Platform.isAndroid) {
    return const PlatformInfo(platformMedia: PlatformMedia.mobile, platformHost: PlatformHost.android);
  }

  if (Platform.isIOS) {
    return const PlatformInfo(platformMedia: PlatformMedia.mobile, platformHost: PlatformHost.ios);
  }

  if (Platform.isWindows) {
    return const PlatformInfo(platformMedia: PlatformMedia.desktop, platformHost: PlatformHost.windows);
  }

  if (Platform.isMacOS) {
    return const PlatformInfo(platformMedia: PlatformMedia.desktop, platformHost: PlatformHost.macos);
  }

  if (Platform.isLinux) {
    return const PlatformInfo(platformMedia: PlatformMedia.desktop, platformHost: PlatformHost.linux);
  }

  return const PlatformInfo(platformMedia: PlatformMedia.unknown, platformHost: PlatformHost.unknown);
}
