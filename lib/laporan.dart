import 'package:flutter/material.dart';

class Laporan extends StatefulWidget {
  const Laporan({super.key});

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  final TextEditingController _tanggalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text("Laporan Penjualan"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDatePicker(
                context: context,
                firstDate: DateTime(2025),
                lastDate: DateTime(2525),
              );
            },
            icon: Icon(Icons.calendar_month),
          ),
        ],
      ),
    );
  }
}
