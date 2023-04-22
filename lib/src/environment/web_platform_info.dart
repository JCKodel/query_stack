// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import '../../query_stack.dart';

import 'current_platform.dart';

CurrentPlatform getCurrentPlatformInfo() {
  final userAgent = html.window.navigator.userAgent;
  final platform = html.window.navigator.platform!.toLowerCase();

  if (["darwin", "macintosh", "macintel"].contains(platform)) {
    return const CurrentPlatform(PlatformMedia.web, PlatformHost.macos);
  }

  if (["iphone", "ipad", "ipod"].contains(platform)) {
    return const CurrentPlatform(PlatformMedia.web, PlatformHost.ios);
  }

  if (["win64", "win32", "windows"].contains(platform)) {
    return const CurrentPlatform(PlatformMedia.web, PlatformHost.windows);
  }

  if (userAgent.contains("Android")) {
    return const CurrentPlatform(PlatformMedia.web, PlatformHost.android);
  }

  if (platform.contains("linux")) {
    return const CurrentPlatform(PlatformMedia.web, PlatformHost.linux);
  }

  return const CurrentPlatform(PlatformMedia.web, PlatformHost.unknown);
}
