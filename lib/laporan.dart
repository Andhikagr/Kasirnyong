import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasirnyong/database/database.dart';
import 'package:kasirnyong/manaj_produk/produk/widget/format_rupiah.dart';

class Laporan extends StatefulWidget {
  const Laporan({super.key});

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  DateTime? tanggalLaporan;
  num totalPenjualan = 0;
  Map<String, dynamic>? produkTerlaris;
  int totalTransaksi = 0;

  //load database
  Future<void> loadLaporan() async {
    final orderLaporan = await DatabaseKasir.getOrders();
    num total = 0;
    int transaksi = 0;
    Map<String, Map<String, dynamic>> hitungProduk = {};

    if (tanggalLaporan == null) {
      setState(() {
        totalPenjualan = 0;
        totalTransaksi = 0;
        produkTerlaris = null;
      });
      return;
    }

    final tanggalTerpilih = DateFormat("yyyy-MM-dd").format(tanggalLaporan!);
    for (var order in orderLaporan) {
      final rawTanggal = order["tanggal"] as String;

      final convertTanggal = DateTime.parse(rawTanggal);
      final orderTanggal = DateFormat("yyyy-MM-dd").format(convertTanggal);

      if (orderTanggal == tanggalTerpilih) {
        total += (order["total_order"] as num);
        transaksi++;

        final List details = order["details"] ?? [];
        for (var prod in details) {
          final namaProduk = prod["produk_nama"] as String;
          final jumlah = prod["jumlah"] as int;
          final gambar = prod["gambar"];

          if (!hitungProduk.containsKey(namaProduk)) {
            hitungProduk[namaProduk] = {
              "nama": namaProduk,
              "jumlah": jumlah,
              "gambar": gambar,
            };
          } else {
            hitungProduk[namaProduk]!["jumlah"] += jumlah;
          }
        }
      }
    }

    //produk terlaris
    Map<String, dynamic>? produkBest;
    if (hitungProduk.isNotEmpty) {
      final sorted = hitungProduk.values.toList()
        ..sort((a, b) => (b["jumlah"] as int).compareTo(a["jumlah"] as int));
      produkBest = sorted.first;
    }

    setState(() {
      totalPenjualan = total;
      totalTransaksi = transaksi;
      produkTerlaris = produkBest;
    });
  }

  //fungsi memilih tanggal
  Future<void> _pickTanggal() async {
    final pick = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2525),
    );

    if (pick != null) {
      setState(() {
        tanggalLaporan = pick;
      });
      await loadLaporan();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text("Laporan Penjualan", style: TextStyle(fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _pickTanggal, icon: Icon(Icons.calendar_month)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.shade200,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      totalPenjualan.toRupiah(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    Text(
                      tanggalLaporan != null
                          ? "Total Penjualan ${DateFormat("dd-MM-yyyy").format(tanggalLaporan!)}"
                          : "Silahkan pilih tanggal",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(7),
                        height: 35,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepPurple,
                        ),
                        child: Center(
                          child: Text(
                            "Jumlah Transaksi : $totalTransaksi",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(5),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.shade200,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Produk terlaris hari ini",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Divider(),
                    if (produkTerlaris != null) ...[
                      produkTerlaris!["gambar"] != null
                          ? Image.file(
                              File(produkTerlaris!["gambar"]),
                              width: 150,
                            )
                          : Icon(Icons.image_not_supported),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                produkTerlaris!["nama"],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "Terjual : ${produkTerlaris!["jumlah"]} item",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Image.asset("assets/best.png", width: 80),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
