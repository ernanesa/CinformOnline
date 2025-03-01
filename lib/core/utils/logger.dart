import 'package:logging/logging.dart';

class AppLogger {
  static final _logger = Logger('MyApp');

  static void init() {
    Logger.root.level = Level.ALL; // Defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  static void log(String message, {Level level = Level.INFO}) {
    _logger.log(level, message);
  }

  static void info(String message) {
    _logger.info(message);
  }

  static void warning(String message) {
    _logger.warning(message);
  }

  static void severe(String message) {
    _logger.severe(message);
  }
} 