import 'package:flutter/material.dart';
import 'package:food_app/database/database.dart';
import 'package:food_app/homepage/widget/update_transaksi.dart';
import 'package:food_app/manaj_produk/produk/widget/format_rupiah.dart';
import 'package:food_app/manaj_produk/produk/widget/textform_produk.dart';
import 'package:food_app/order/sukses_bayar.dart';
import 'package:food_app/order/widget/box_order.dart';
import 'package:get/get.dart';

class Bayar extends StatefulWidget {
  final RxString totalBayar;
  final RxList<Map<String, dynamic>> pesananList;

  const Bayar({super.key, required this.totalBayar, required this.pesananList});

  @override
  State<Bayar> createState() => _BayarState();
}

class _BayarState extends State<Bayar> {
  final TextEditingController _tunaiController = TextEditingController();
  final TextEditingController _kembalianController = TextEditingController();
  final List<String> metodeBayar = ["Tunai", "QRIS", "Transfer"];
  String? pilihKategori;

  RxString kembalian = "Rp. 0".obs;

  @override
  void initState() {
    super.initState();

    _tunaiController.addListener(() {
      final tunai = _tunaiController.text.toDoubleClean();
      final total = widget.totalBayar.value.toDoubleClean();
      final kembaliHitung = tunai - total;

      kembalian.value = kembaliHitung > 0 ? kembaliHitung.toRupiah() : "Rp. 0";
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tunaiController.dispose();
    _kembalianController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back),
          ),
          title: Text("Pembayaran", style: TextStyle(fontSize: 18)),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(height: 20),
                Obx(
                  () => Container(
                    height: 120,
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepPurple,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.totalBayar.value,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Total Pembayaran",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextformProduk(
                  label: "Tunai",
                  controller: _tunaiController,
                  readOnly: false,
                  isCurrency: true,
                  textsize: 16,
                ),
                SizedBox(height: 30),
                Container(
                  height: 100,
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Kembali",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      Obx(
                        () => Text(
                          kembalian.value,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: BoxOrder(
                    width: 180,
                    height: 40,
                    label: "Metode Pembayaran",
                    bgColors: Colors.amberAccent,
                  ),
                ),
                SizedBox(height: 15),
                DropdownButtonFormField(
                  hint: const Text("Pilih"),
                  value: pilihKategori,
                  items: metodeBayar.map((e) {
                    return DropdownMenuItem<String>(
                      value: e,
                      child: Row(
                        children: [
                          Icon(
                            e == "Tunai"
                                ? Icons.attach_money
                                : e == "QRIS"
                                ? Icons.qr_code
                                : Icons.credit_card,
                            color: Colors.black,
                          ),
                          SizedBox(width: 10),
                          Text(e, style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      pilihKategori = value;
                    });
                  },
                ),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      _tunaiController.clear();
                      setState(() {
                        pilihKategori = null;
                      });
                    },
                    child: Ink(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.amberAccent,
                      ),
                      child: Center(
                        child: Text(
                          "Reset",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 90,
          padding: EdgeInsets.only(bottom: 25, top: 10),
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  if (widget.pesananList.isNotEmpty) {
                    final pajakPersen = await DatabaseKasir.getPajak();
                    if (pilihKategori == null) {
                      if (_tunaiController.text.isEmpty) {
                        Get.snackbar(
                          "Ups",
                          "Kolom tunai belum di isi",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.white,
                          colorText: Colors.black,
                          icon: Icon(Icons.warning, color: Colors.orange),
                        );
                        return;
                      }
                      Get.snackbar(
                        "Ups",
                        "Pilih metode pembayaran dulu",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.white,
                        colorText: Colors.black,
                        icon: Icon(Icons.warning, color: Colors.orange),
                      );
                      return;
                    }
                    await DatabaseKasir.simpanOrder(
                      widget.pesananList,
                      pajakPersen.toDouble(),
                      pilihKategori!,
                    );

                    _tunaiController.clear();

                    setState(() {
                      pilihKategori = null;
                    });
                    widget.pesananList.clear();
                    widget.totalBayar.value = "0";

                    //
                    updateTransaksi();
                    Get.to(
                      () => SuksesBayar(),
                      transition: Transition.native,
                      duration: Duration(milliseconds: 300),
                    );
                  } else {
                    Get.snackbar(
                      "Gagal",
                      "Tidak ada pesanan untuk disimpan",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.white,
                      colorText: Colors.black,
                      icon: Icon(Icons.dangerous, color: Colors.red),
                    );
                  }
                },
                child: Ink(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.deepPurple,
                  ),
                  child: Center(
                    child: Text(
                      "Selesai",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
