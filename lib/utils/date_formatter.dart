import 'package:intl/intl.dart';

class DateFormatter {
  final DateTime dateTime;

  DateFormatter(this.dateTime);

  // Format as 'yyyy-MM-dd'
  String toYearMonthDay() {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  // Format as 'dd-MM-yyyy'
  String toDayMonthYear() {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  // Format as 'MMMM dd, yyyy' (e.g., 'July 24, 2024')
  String toFullMonthDayYear() {
    return DateFormat('MMMM dd, yyyy').format(dateTime);
  }

  // Format as 'MM/dd/yyyy'
  String toMonthDayYear() {
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }

  // Format as 'yyyy/MM/dd HH:mm' (24-hour format)
  String toYearMonthDayHourMinute() {
    return DateFormat('yyyy/MM/dd HH:mm').format(dateTime);
  }

  // Format as 'MMM d, yyyy' (e.g., 'Jul 24, 2024')
  String toShortMonthDayYear() {
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  // Format as 'yyyy-MM-ddTHH:mm:ss' (ISO 8601)
  String toIso8601() {
    return DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);
  }

  // Format as 'EEEE, MMMM d, yyyy' (e.g., 'Wednesday, July 24, 2024')
  String toWeekdayMonthDayYear() {
    return DateFormat('EEEE, MMMM d, yyyy').format(dateTime);
  }

  // Format as 'HH:mm:ss' (24-hour format)
  String toTime24Hour() {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  // Format as 'hh:mm a' (12-hour format with AM/PM)
  String toTime12Hour() {
    return DateFormat('hh:mm a').format(dateTime);
  }

  // Custom format
  String toCustomFormat(String pattern) {
    return DateFormat(pattern).format(dateTime);
  }
}
