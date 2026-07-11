import 'package:logger/logger.dart';

/// A utility class for standardized logging across the application.
/// 
/// This class wraps the `logger` package to provide a consistent interface
/// and configuration, ensuring that log messages are formatted correctly
/// and categorized by severity.
class AppLogger {
  // Private instance of the Logger
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: false, // Print an emoji for each log message
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // Should each log print contain a timestamp
    ),
  );

  /// Logs a message at the [Level.debug] level.
  /// 
  /// Use this for fine-grained informational events that are most useful
  /// to debug an application.
  static void debug(dynamic message) {
    _logger.d(message);
  }

  /// Logs a message at the [Level.info] level.
  /// 
  /// Use this for high-level events that track the application's flow
  /// (e.g., "User logged in", "API request started").
  static void info(dynamic message) {
    _logger.i(message);
  }

  /// Logs a message at the [Level.warning] level.
  /// 
  /// Use this for potentially harmful situations or unexpected behaviors
  /// that don't necessarily crash the app (e.g., "Retrying API call").
  static void warning(dynamic message) {
    _logger.w(message);
  }

  /// Logs a message at the [Level.error] level.
  /// 
  /// Use this for error events that might still allow the application to
  /// continue running, but indicate a failure in a specific operation.
  static void error(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a message at the [Level.fatal] level.
  /// 
  /// Use this for very severe error events that will presumably lead the
  /// application to abort or enter an unusable state.
  static void fatal(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
