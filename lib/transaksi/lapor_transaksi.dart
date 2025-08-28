import 'package:flutter/material.dart';
import 'package:food_app/database/database.dart';
import 'package:food_app/homepage/homepage.dart';
import 'package:food_app/transaksi/transaksi.dart';
import 'package:food_app/transaksi/widget/format_waktu.dart';
import 'package:get/get.dart';

class LaporTransaksi extends StatefulWidget {
  const LaporTransaksi({super.key});

  @override
  State<LaporTransaksi> createState() => _LaporTransaksiState();
}

class _LaporTransaksiState extends State<LaporTransaksi> {
  List<String> tanggal = [];
  bool isLoading = false;

  Future<void> loadTanggal() async {
    setState(() => isLoading = true);

    final orderTersimpan = await DatabaseKasir.getOrders();
    //ambil tanggal
    final tanggalSet = orderTersimpan.map((orderCek) {
      final listTanggal = DateTime.parse(orderCek["tanggal"]);
      return "${listTanggal.day}-${listTanggal.month}-${listTanggal.year}";
    }).toSet();

    setState(() {
      tanggal = tanggalSet.toList()..sort((a, b) => b.compareTo(a));
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTanggal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text("Transaksi"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.off(
            () => Homepage(),
            transition: Transition.native,
            duration: Duration(milliseconds: 500),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : tanggal.isEmpty
            ? Center(child: Text("Belum ada transaksi"))
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  crossAxisCount: 3,
                  childAspectRatio: 0.9,
                ),
                itemCount: tanggal.length,
                itemBuilder: (context, index) {
                  final showTanggal = tanggal[index];
                  return InkWell(
                    onTap: () async {
                      // ambil transaksi hanya untuk tanggal ini
                      final allOrders = await DatabaseKasir.getOrders();

                      final convert = showTanggal.split('-');
                      final selectedTanggal = DateTime(
                        int.parse(convert[2]),
                        int.parse(convert[1]),
                        int.parse(convert[0]),
                      );

                      final selectTanggal = allOrders.where((cek) {
                        final tanggalPilih = DateTime.parse(cek["tanggal"]);
                        return tanggalPilih.year == selectedTanggal.year &&
                            tanggalPilih.month == selectedTanggal.month &&
                            tanggalPilih.day == selectedTanggal.day;
                      }).toList();

                      Get.to(
                        () => Transaksi(listOrders: selectTanggal),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: 300),
                      );
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade600,
                          width: 2,
                        ),
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/calendar.png', width: 55),
                            SizedBox(height: 15),
                            Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  FormatWaktu.tanggal(showTanggal),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
