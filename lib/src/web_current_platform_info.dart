// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'platform_info.dart';

PlatformInfo getCurrentPlatformInfo() {
  final userAgent = html.window.navigator.userAgent;
  final platform = html.window.navigator.platform!.toLowerCase();

  if (["darwin", "macintosh", "macintel"].contains(platform)) {
    return const PlatformInfo(platformMedia: PlatformMedia.web, platformHost: PlatformHost.macos);
  }

  if (["iphone", "ipad", "ipod"].contains(platform)) {
    return const PlatformInfo(platformMedia: PlatformMedia.web, platformHost: PlatformHost.ios);
  }

  if (["win64", "win32", "windows"].contains(platform)) {
    return const PlatformInfo(platformMedia: PlatformMedia.web, platformHost: PlatformHost.windows);
  }

  if (userAgent.contains("Android")) {
    return const PlatformInfo(platformMedia: PlatformMedia.web, platformHost: PlatformHost.android);
  }

  if (platform.contains("linux")) {
    return const PlatformInfo(platformMedia: PlatformMedia.web, platformHost: PlatformHost.linux);
  }

  return const PlatformInfo(platformMedia: PlatformMedia.web, platformHost: PlatformHost.unknown);
}
