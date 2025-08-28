import 'package:intl/intl.dart';

class FormatWaktu {
  static String tanggal(String dateTimeString) {
    try {
      if (dateTimeString.contains(".")) {
        final parts = dateTimeString.split(".");
        dateTimeString = parts[0];
      }

      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat("dd-MM-yyyy - HH:mm:ss").format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }
}
