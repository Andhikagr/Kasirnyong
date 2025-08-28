import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/manaj_produk/produk/widget/format_persen.dart';
import 'package:food_app/manaj_produk/produk/widget/format_rupiah.dart';

class TextformProduk extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isCurrency;
  final bool isDiskon;
  final bool readOnly;
  final String? suffixText;
  final double? textsize;

  const TextformProduk({
    super.key,
    required this.label,
    required this.controller,
    this.isCurrency = false,
    this.isDiskon = false,
    this.readOnly = true,
    this.suffixText,
    this.textsize,
  });

  @override
  Widget build(BuildContext contex) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        readOnly: readOnly,
        inputFormatters: [
          if (isCurrency) ...[
            FilteringTextInputFormatter.digitsOnly,
            FormatRupiah(),
          ],
          if (isDiskon) FormatPersen(),
        ],
        controller: controller,
        enableSuggestions: false,
        style: TextStyle(decoration: TextDecoration.none, fontSize: textsize),
        decoration: InputDecoration(
          suffixText: suffixText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: label,
          labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade500),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade800, width: 1.5),
          ),
        ),
      ),
    );
  }
}
