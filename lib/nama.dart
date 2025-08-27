import 'package:flutter/material.dart';
import 'package:food_app/database/database.dart';
import 'package:food_app/menu/produk/widget/textform_produk.dart';
import 'package:get/get.dart';

class Nama extends StatefulWidget {
  const Nama({super.key});

  @override
  State<Nama> createState() => _NamaState();
}

class _NamaState extends State<Nama> {
  var identitas = <String, dynamic>{}.obs;

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();

  //load nama
  void loadIdentitas() async {
    identitas.value = await DatabaseKasir.getIdentitas();
  }

  @override
  void initState() {
    super.initState();
    loadIdentitas();
  }

  @override
  void dispose() {
    super.dispose();
    _alamatController.dispose();
    _noTelpController.dispose();
    _namaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          title: Text("Identitas"),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 30),
              TextformProduk(
                label: "Nama Toko / Usaha",
                controller: _namaController,
                readOnly: false,
              ),
              SizedBox(height: 20),
              TextformProduk(
                label: "Nomor Telp.",
                controller: _noTelpController,
                readOnly: false,
              ),
              SizedBox(height: 20),
              TextformProduk(
                label: "Alamat",
                controller: _alamatController,
                readOnly: false,
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () async {
                    if (_namaController.text.isEmpty ||
                        _alamatController.text.isEmpty ||
                        _noTelpController.text.isEmpty) {
                      Get.snackbar(
                        "Ups",
                        "Semua kolom harus diisi",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.white,
                        colorText: Colors.black,
                        icon: Icon(Icons.warning, color: Colors.orange),
                      );
                      return;
                    } else {
                      await DatabaseKasir.setIdentitas(
                        _namaController.text,
                        _alamatController.text,
                        _noTelpController.text,
                      );
                      Get.snackbar(
                        "Sukses",
                        "Identitas berhasil dibuat",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.white,
                        colorText: Colors.black,
                        icon: Icon(Icons.check_circle, color: Colors.green),
                      );
                      _namaController.clear();
                      _alamatController.clear();
                      _noTelpController.clear();
                      identitas.assignAll(await DatabaseKasir.getIdentitas());
                    }
                  },
                  child: Ink(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepPurple,
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

              SizedBox(height: 20),
              Container(
                height: 130,
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.deepPurple,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.shade200,
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => Text(
                          identitas["nama"] ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Obx(
                        () => Text(
                          identitas["no_telp"] ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Obx(
                        () => Text(
                          identitas["alamat"] ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
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
