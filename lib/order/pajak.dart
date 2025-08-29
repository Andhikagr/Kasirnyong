import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirnyong/database/database.dart';
import 'package:kasirnyong/manaj_produk/produk/widget/textform_produk.dart';
import 'package:kasirnyong/order/widget/format_pajak.dart';

class Pajak extends StatefulWidget {
  const Pajak({super.key});

  @override
  State<Pajak> createState() => _PajakState();
}

class _PajakState extends State<Pajak> {
  final TextEditingController _pajakController = TextEditingController();

  Future<void> _loadPajak() async {
    final pajak = await DatabaseKasir.getPajak();
    setState(() {
      _pajakController.text = formatPajak(pajak.toDouble());
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPajak();
  }

  @override
  void dispose() {
    _pajakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          title: Text("Pajak", style: TextStyle(fontSize: 18)),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              TextformProduk(
                label: "Pajak",
                controller: _pajakController,
                readOnly: false,
                suffixText: "%",
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Material(
                  child: InkWell(
                    onTap: () async {
                      final pajakText = _pajakController.text.trim();

                      final pajak = double.tryParse(pajakText) ?? 0;

                      await DatabaseKasir.setPajak(pajak);
                      Get.snackbar(
                        "Sukses",
                        "pajak berhasil ditambahkan",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.white,
                        colorText: Colors.black,
                        icon: Icon(Icons.check_circle, color: Colors.green),
                      );
                      _loadPajak();
                    },
                    child: Ink(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          "Simpan",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}
