import 'dart:developer' as developer;

/// 日志级别枚举
enum LogLevel { debug, info, warning, error }

/// 日志服务类
class LogService {
  /// 打印调试日志
  void debug(String message, [dynamic data]) {
    _log(LogLevel.debug, message, data);
  }

  /// 打印信息日志
  void info(String message, [dynamic data]) {
    _log(LogLevel.info, message, data);
  }

  /// 打印警告日志
  void warning(String message, [dynamic data]) {
    _log(LogLevel.warning, message, data);
  }

  /// 打印错误日志
  void error(String message, [dynamic data]) {
    _log(LogLevel.error, message, data);
  }

  /// 记录错误信息和堆栈跟踪
  void logError(dynamic error, [StackTrace? stackTrace]) {
    developer.log(
      '🔴 错误: $error',
      name: 'app',
      error: error,
      stackTrace: stackTrace,
    );

    // 这里可以添加错误上报到服务器的逻辑
  }

  /// 内部日志方法
  void _log(LogLevel level, String message, [dynamic data]) {
    String emoji;

    switch (level) {
      case LogLevel.debug:
        emoji = '🟣';
        break;
      case LogLevel.info:
        emoji = '🔵';
        break;
      case LogLevel.warning:
        emoji = '🟠';
        break;
      case LogLevel.error:
        emoji = '🔴';
        break;
    }

    if (data != null) {
      developer.log('$emoji $message', name: 'app', error: data);
    } else {
      developer.log('$emoji $message', name: 'app');
    }
  }
}
