import 'package:intl/intl.dart';

abstract class DateAndTime {
  static String dateWithSec() {

    DateTime date = DateTime.now();
    String now = DateFormat('yyyy/MM/dd HH:mm:ss').format(date);

    return now;
  }
}
