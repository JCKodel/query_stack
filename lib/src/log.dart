part of query_stack;

abstract class Log {
  static const _resetColor = "\x1B[0m";
  static const _red = "\x1B[31m";
  static const _green = "\x1B[32m";
  static const _yellow = "\x1B[33m";
  static const _blue = "\x1B[34m";
  static const _magenta = "\x1B[35m";
  static const _cyan = "\x1B[36m";
  static const _white = "\x1B[37m";

  static String? _lastEntry;

  static bool _writeLog(Type name, QueryKey queryKey, String color, String message, [Object? data]) {
    message = "${_cyan}${queryKey} ${color}${message}";

    final key = "${message};${data}";

    if (key == _lastEntry) {
      return false;
    }

    _lastEntry = key;

    log(
      "${_white}${DateTime.now().toIso8601String()} ${message}${_resetColor}",
      name: name.toString(),
      time: DateTime.now(),
    );

    return true;
  }

  static void idle(Type name, QueryKey queryKey) {
    _writeLog(name, queryKey, _magenta, "Idle");
  }

  static void busy(Type name, QueryKey queryKey) {
    _writeLog(name, queryKey, _blue, "Busy");
  }

  static void error(Type name, QueryKey queryKey, Object exception, [StackTrace? stackTrace]) {
    if (_writeLog(name, queryKey, _red, "Error", exception) == false) {
      return;
    }

    if (kDebugMode) {
      log(
        "${_yellow}${exception}${_resetColor}",
        name: name.toString(),
        time: DateTime.now(),
      );

      if (stackTrace != null) {
        log(
          "${_yellow}${stackTrace}${_resetColor}",
          name: name.toString(),
          time: DateTime.now(),
        );
      }
    }
  }

  static void success(Type name, QueryKey queryKey, dynamic data, [bool? isPreviousData]) {
    if (_writeLog(name, queryKey, _green, "Success", data) == false) {
      return;
    }

    if (kDebugMode) {
      log(
        "${_cyan}${data}${isPreviousData == true ? "\nisPreviousData: ${isPreviousData}" : ""}${_resetColor}",
        name: name.toString(),
        time: DateTime.now(),
      );
    }
  }
}
