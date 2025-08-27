import 'package:flutter/material.dart';
import 'package:food_app/database/database.dart';
import 'package:food_app/menu/produk/widget/format_rupiah.dart';
import 'package:food_app/transaksi/detail_transaksi.dart';
import 'package:food_app/transaksi/widget/format_waktu.dart';
import 'package:get/get.dart';

class Transaksi extends StatelessWidget {
  const Transaksi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text("Riwayat Transaksi"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseKasir.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Belum ada transaksi"));
          }
          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  height: 80,
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

                  child: ListTile(
                    onTap: () => Get.to(
                      () => DetailTransaksi(order: order),
                      transition: Transition.rightToLeft,
                      duration: Duration(milliseconds: 300),
                    ),
                    leading: Image.asset("assets/inv.png", width: 40),
                    title: Text(
                      "Order #${order["id"]} - total: ${(order["total_order"] as num).toRupiah()}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      FormatWaktu.tanggal(order["tanggal"]),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
