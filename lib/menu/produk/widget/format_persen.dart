import 'package:flutter/services.dart';

class FormatPersen extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: "");
    }

    // Hapus simbol % dulu
    String value = newValue.text.replaceAll("%", "").trim();

    if (value.isEmpty) {
      return newValue.copyWith(text: "");
    }

    // Pastikan hanya angka
    final parsed = int.tryParse(value);
    if (parsed == null) return oldValue;

    // Tambahkan % di akhir
    final newText = "$parsed%";

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length - 1),
      // cursor sebelum spasi %, biar enak edit
    );
  }
}
