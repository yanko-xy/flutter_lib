import 'package:logger/logger.dart';

class XYLogger {
  static Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  static dev(dynamic message, {String title = "dev"}) {
    logger.d("$title: ${message.toString()}");
  }
}