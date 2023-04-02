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

  static void idle(Type name) {
    log(
      "${_white}${DateTime.now().toIso8601String()} ${_magenta}Idle${_resetColor}",
      name: name.toString(),
      time: DateTime.now(),
    );
  }

  static void busy(Type name) {
    log(
      "${_white}${DateTime.now().toIso8601String()} ${_blue}Busy${_resetColor}",
      name: name.toString(),
      time: DateTime.now(),
    );
  }

  static void error(Type name, Object exception, [StackTrace? stackTrace]) {
    log(
      "${_white}${DateTime.now().toIso8601String()} ${_red}Error${_resetColor}",
      name: name.toString(),
      time: DateTime.now(),
    );

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

  static void success(Type name, dynamic data, [bool? isPreviousData]) {
    log(
      "${_white}${DateTime.now().toIso8601String()} ${_green}Success${_resetColor}",
      name: name.toString(),
      time: DateTime.now(),
    );

    if (kDebugMode) {
      log(
        "${_cyan}${data}${isPreviousData == true ? "\nisPreviousData: ${isPreviousData}" : ""}${_resetColor}",
        name: name.toString(),
        time: DateTime.now(),
      );
    }
  }
}
