import 'package:flutter/foundation.dart';

import '../environment.dart';

@immutable
class CurrentPlatform {
  const CurrentPlatform(this.platformMedia, this.platformHost);

  final PlatformMedia platformMedia;
  final PlatformHost platformHost;
}
