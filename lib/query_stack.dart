library query_stack;

import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:collection/collection.dart';
import 'package:rxdart/subjects.dart';

import 'src/platform_info.dart';
import 'src/web_current_platform_info.dart' if (dart.library.io) "src/io_get_current_platform_info.dart";

export 'src/platform_info.dart';

part "src/environment.dart";
part "src/environment_provider.dart";
part "src/environment_provider_route_observer.dart";
part "src/i_equatable.dart";
part "src/log.dart";
part "src/mutation_builder.dart";
part "src/query_builder.dart";
part "src/query_key.dart";
part "src/query_mutation.dart";
