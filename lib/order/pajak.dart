import 'package:flutter/material.dart';
import 'package:food_app/database/database.dart';
import 'package:food_app/menu/produk/widget/textform_produk.dart';
import 'package:get/get.dart';

class Pajak extends StatefulWidget {
  const Pajak({super.key});

  @override
  State<Pajak> createState() => _PajakState();
}

class _PajakState extends State<Pajak> {
  final TextEditingController _pajakController = TextEditingController();

  //format pajak
  String formatPajak(double pajak) {
    if (pajak % 1 == 0) {
      return pajak.toInt().toString();
    } else {
      return pajak.toString();
    }
  }

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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          title: Text("Pajak"),
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
                      final pajak = double.tryParse(_pajakController.text) ?? 0;

                      await DatabaseKasir.setPajak(pajak);
                      Get.snackbar(
                        "Sukses",
                        "pajak berhasil ditambahkan",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.white,
                        colorText: Colors.black,
                      );
                      _loadPajak();
                    },
                    child: Ink(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Simpan",
                          style: TextStyle(
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
