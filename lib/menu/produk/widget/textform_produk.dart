import 'package:flutter/material.dart';

class TextformProduk extends StatelessWidget {
  final String label;

  const TextformProduk({super.key, required this.label});

  @override
  Widget build(BuildContext contex) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        enableSuggestions: false,
        style: TextStyle(decoration: TextDecoration.none),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: label,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          border: InputBorder.none,
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
