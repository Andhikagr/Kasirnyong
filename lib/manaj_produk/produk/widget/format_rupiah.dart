import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class FormatRupiah extends TextInputFormatter {
  final NumberFormat _formater = NumberFormat.currency(
    locale: "id",
    symbol: "Rp. ",
    decimalDigits: 0,
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: "");
    }
    //hapus karakter nin digit
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), "");

    //convert ke number
    int number = int.parse(digits);

    //format jadi
    String newText = _formater.format(number);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

//string to doble
extension StringNumber on String {
  double toDoubleClean() {
    String digits = replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(digits) ?? 0.0;
  }
}

//double/int to rupiah
extension DoubleRupiah on num {
  String toRupiah() {
    final formatter = NumberFormat.currency(
      locale: "id",
      symbol: "Rp. ",
      decimalDigits: 0,
    );
    return formatter.format(this);
  }
}
