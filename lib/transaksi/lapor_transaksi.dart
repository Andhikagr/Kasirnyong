import 'package:flutter/material.dart';
import 'package:food_app/database/database.dart';
import 'package:food_app/homepage/homepage.dart';
import 'package:food_app/manaj_produk/produk/widget/textform_produk.dart';
import 'package:food_app/transaksi/riwayat_transaksi.dart';
import 'package:food_app/transaksi/widget/format_csv.dart';
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
  DateTime? _tanggalAwal;
  DateTime? _tanggalAkhir;

  final TextEditingController _tanggalAwalController = TextEditingController();
  final TextEditingController _tanggalAkhirController = TextEditingController();

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

  //pilih tanggal
  Future<void> _pickTanggalAwal() async {
    final pickAwal = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2525),
    );

    if (pickAwal != null) {
      setState(() {
        _tanggalAwal = pickAwal;
        _tanggalAwalController.text =
            "${pickAwal.day}-${pickAwal.month}-${pickAwal.year}";
      });
    }
  }

  Future<void> _pickTanggalAkhir() async {
    final pickAkhir = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2525),
    );

    if (pickAkhir != null) {
      setState(() {
        _tanggalAkhir = pickAkhir;
        _tanggalAkhirController.text =
            "${pickAkhir.day}-${pickAkhir.month}-${pickAkhir.year}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadTanggal();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/calender.png'), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text("Transaksi", style: TextStyle(fontSize: 18)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.off(
            () => Homepage(),
            transition: Transition.native,
            duration: Duration(milliseconds: 500),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      "Pilih tanggal",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: SizedBox(
                      height: 220,
                      child: Column(
                        children: [
                          TextformProduk(
                            label: "Tanggal Awal",
                            controller: _tanggalAwalController,
                            onTap: () => _pickTanggalAwal(),
                          ),
                          SizedBox(height: 15),
                          TextformProduk(
                            label: "Tanggal Akhir",
                            controller: _tanggalAkhirController,
                            onTap: () => _pickTanggalAkhir(),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "PERINGATAN* Menghapus riwayat transaksi akan menghilangkan semua data secara permanen. Pastikan data sudah dibackup atau di eksport ke dalam file CSV.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          "Batal",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await DatabaseKasir.deleteOrderHistory(
                            _tanggalAwal!,
                            _tanggalAkhir!,
                          );
                          loadTanggal();
                          Get.back();
                        },
                        child: Text(
                          "Hapus",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.manage_history_sharp),
            tooltip: "Hapus transaksi",
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : tanggal.isEmpty
            ? Center(child: Text("Belum ada transaksi"))
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 5,
                  crossAxisCount: 3,
                  childAspectRatio: 0.9,
                ),
                itemCount: tanggal.length,
                itemBuilder: (context, index) {
                  final showTanggal = tanggal[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
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
                        () => RiwayatTransaksi(listOrders: selectTanggal),
                        transition: Transition.rightToLeft,
                        duration: Duration(milliseconds: 300),
                      );
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.shade200,
                            blurRadius: 2,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/calender.png', width: 55),
                            SizedBox(height: 15),
                            Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  FormatWaktu.tanggal(showTanggal),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.white,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: exportCSV,
        child: Image.asset("assets/csve.png", width: 35),
      ),
    );
  }
}
