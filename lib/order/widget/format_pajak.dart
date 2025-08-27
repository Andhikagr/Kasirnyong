//format pajak
String formatPajak(double pajak) {
  if (pajak % 1 == 0) {
    return pajak.toInt().toString();
  } else {
    return pajak.toStringAsFixed(2);
  }
}
