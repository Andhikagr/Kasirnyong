import 'package:flutter/material.dart';
import 'package:food_app/database/database.dart';
import 'package:food_app/manaj_produk/produk/widget/textform_produk.dart';
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
          title: Text("Identitas", style: TextStyle(fontSize: 18)),
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
                textsize: 12,
              ),
              SizedBox(height: 20),
              TextformProduk(
                label: "Nomor Telp.",
                controller: _noTelpController,
                readOnly: false,
                textsize: 12,
              ),
              SizedBox(height: 20),
              TextformProduk(
                label: "Alamat",
                controller: _alamatController,
                readOnly: false,
                textsize: 12,
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
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.deepPurple,
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

              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.shade200,
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: Obx(
                      () => Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          identitas["nama"] ?? "",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.shade200,
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: Obx(
                      () => Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          identitas["no_telp"] ?? "",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 75,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.shade200,
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: Obx(
                      () => Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          identitas["alamat"] ?? "",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
