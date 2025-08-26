import 'package:flutter/material.dart';
import 'package:food_app/menu/produk/widget/format_rupiah.dart';
import 'package:food_app/menu/produk/widget/textform_produk.dart';
import 'package:food_app/order/widget/box_order.dart';
import 'package:get/get.dart';

class Bayar extends StatefulWidget {
  final RxString totalBayar;

  const Bayar({super.key, required this.totalBayar});

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
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text("Pembayaran"),
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
                    height: 150,
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
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Total Pembayaran",
                          style: TextStyle(
                            fontSize: 18,
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
                        blurRadius: 5,
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
                            fontSize: 35,
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
                    bgColors: Colors.amber,
                    textColors: Colors.black,
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
                          Text(e),
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
                SizedBox(height: 20),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    _tunaiController.clear();
                    setState(() {
                      pilihKategori = null;
                    });
                  },
                  child: Ink(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepPurple,
                    ),
                    child: Center(
                      child: Text(
                        "reset",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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
          height: 100,
          padding: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: BoxOrder(
                    height: 60,
                    bgColors: Colors.amber,
                    label: "Selesai & Kirim Nota",
                    textColors: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: BoxOrder(
                    height: 60,
                    bgColors: Colors.deepPurple,
                    label: "Selesai",
                    textColors: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
