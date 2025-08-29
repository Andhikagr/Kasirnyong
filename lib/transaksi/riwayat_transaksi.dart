import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirnyong/manaj_produk/produk/widget/format_rupiah.dart';
import 'package:kasirnyong/transaksi/detail_transaksi.dart';
import 'package:kasirnyong/transaksi/widget/format_waktu.dart';

class RiwayatTransaksi extends StatefulWidget {
  final List<Map<String, dynamic>> listOrders;
  const RiwayatTransaksi({super.key, required this.listOrders});

  @override
  State<RiwayatTransaksi> createState() => _RiwayatTransaksiState();
}

class _RiwayatTransaksiState extends State<RiwayatTransaksi> {
  late List<Map<String, dynamic>> allOrders;
  late List<Map<String, dynamic>> listOrders;
  int page = 0;
  final int limit = 7;

  @override
  void initState() {
    super.initState();
    allOrders = widget.listOrders;
    _loadPage();
  }

  void _loadPage() {
    final start = page * limit;
    final end = start + limit;
    setState(() {
      listOrders = allOrders.sublist(
        start,
        end > allOrders.length ? allOrders.length : end,
      );
    });
  }

  void previousPage() {
    if (page > 0) {
      page--;
      _loadPage();
    }
  }

  void nextPage() {
    if ((page + 1) * limit < allOrders.length) {
      page++;
      _loadPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text("Riwayat Transaksi", style: TextStyle(fontSize: 18)),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Expanded(
            child: listOrders.isEmpty
                ? Center(child: Text("Belum ada transaksi"))
                : ListView.builder(
                    itemCount: listOrders.length,
                    itemBuilder: (context, index) {
                      final order = listOrders[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        child: Container(
                          height: 70,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.shade200,
                                blurRadius: 2,
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
                            leading: Image.asset("assets/inv.png", width: 30),
                            title: Text(
                              "Order #${order["id"]} - total: ${(order["total_order"] as num).toRupiah()}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              FormatWaktu.tanggal(order["tanggal"]),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 20, top: 5),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 1,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: page > 0 ? previousPage : null,
              child: Text(
                "<",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            SizedBox(width: 30),
            Text("${page + 1}", style: TextStyle(fontSize: 18)),
            SizedBox(width: 30),
            ElevatedButton(
              onPressed: (page + 1) * limit < allOrders.length
                  ? nextPage
                  : null,
              child: Text(
                ">",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
