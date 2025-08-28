import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_app/controller/kategori_control.dart';
import 'package:food_app/controller/produk_control.dart';
import 'package:food_app/database/database.dart';
import 'package:food_app/manaj_produk/produk/widget/button_produk.dart';
import 'package:food_app/manaj_produk/produk/widget/copy_gambar.dart';
import 'package:food_app/manaj_produk/produk/widget/format_rupiah.dart';
import 'package:food_app/manaj_produk/produk/widget/textform_produk.dart';
import 'package:get/get.dart';

class TambahProduk extends StatefulWidget {
  const TambahProduk({super.key});

  @override
  State<TambahProduk> createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  final kategoriAdd = Get.find<KategoriControl>();
  String? pilihKategoriNama;
  final TextEditingController simpanCOntroller = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaDasarController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController diskonController = TextEditingController();
  final TextEditingController hargaDiskonController = TextEditingController();

  //simpan gambar
  String? gambarPath;

  //fungsi harga diskon
  void hargaDiskon() {
    final hargaJual = hargaJualController.text.toDoubleClean();
    final diskonConvert = diskonController.text.replaceAll("%", "").trim();
    final diskon = diskonConvert.isEmpty
        ? 0
        : double.tryParse(diskonConvert) ?? 0;

    if (diskon > 0) {
      final hargaAkhir = hargaJual - (hargaJual * (diskon / 100));
      hargaDiskonController.text = hargaAkhir.toRupiah();
    } else {
      hargaDiskonController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    hargaJualController.addListener(hargaDiskon);
    diskonController.addListener(hargaDiskon);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          title: Text("Tambah Produk", style: TextStyle(fontSize: 18)),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                TextformProduk(
                  label: "Nama Produk",
                  controller: namaController,
                  readOnly: false,
                ),
                SizedBox(height: 10),
                Text(
                  "Kategori",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 7),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: pilihKategoriNama,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    hint: const Text(
                      "Pilih Kategori",
                      style: TextStyle(fontSize: 14),
                    ),
                    items: kategoriAdd.kategoriList
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e["nama"],
                            child: Text(
                              e["nama"],
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        pilihKategoriNama = val;
                      });
                    },
                  ),
                ),
                SizedBox(height: 15),
                TextformProduk(
                  label: "Harga Dasar",
                  controller: hargaDasarController,
                  isCurrency: true,
                  readOnly: false,
                ),
                SizedBox(height: 20),
                TextformProduk(
                  label: "Harga Jual",
                  controller: hargaJualController,
                  isCurrency: true,
                  readOnly: false,
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: TextformProduk(
                        label: "Stok (opsional)",
                        controller: stokController,
                        readOnly: false,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextformProduk(
                        label: "Diskon (opsional)",
                        controller: diskonController,
                        isDiskon: true,
                        readOnly: false,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                TextformProduk(
                  label: "Harga Diskon",
                  controller: hargaDiskonController,
                  isCurrency: true,
                  readOnly: true,
                ),

                SizedBox(height: 10),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () {
                    namaController.clear();
                    hargaDasarController.clear();
                    hargaJualController.clear();
                    stokController.clear();
                    diskonController.clear();
                    gambarPath = null;
                    setState(() {
                      pilihKategoriNama = null;
                    });
                  },
                  child: Text("Clear"),
                ),
                SizedBox(height: 5),
                Text(
                  "Gambar Produk",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 125,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: gambarPath != null
                            ? Image.file(File(gambarPath!), fit: BoxFit.contain)
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/nophotos.png",
                                    fit: BoxFit.cover,
                                    width: 100,
                                  ),
                                  Text(
                                    "Tidak ada gambar terpilih",
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: Column(
                        children: [
                          ButtonProduk(
                            label: "Pilih Gambar",
                            icons: Icons.photo,
                            onImage: (path) {
                              setState(() {
                                gambarPath = path;
                              });
                            },
                          ),

                          SizedBox(height: 20),
                          ButtonProduk(
                            label: "Ambil Foto",
                            icons: Icons.camera_alt,
                            onImage: (path) {
                              setState(() {
                                gambarPath = path;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: pilihKategoriNama != null
            ? Container(
                padding: EdgeInsets.only(bottom: 10),
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 3,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Material(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        if (namaController.text.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Nama produk harus diisi",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.white,
                            icon: Icon(Icons.warning, color: Colors.amber),
                            colorText: Colors.grey.shade800,
                          );
                          return;
                        }

                        if (hargaDasarController.text.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Harga dasar harus diisi",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.white,
                            icon: Icon(Icons.warning, color: Colors.amber),
                            colorText: Colors.grey.shade800,
                          );
                          return;
                        }

                        if (hargaJualController.text.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Harga jual harus diisi",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.white,
                            icon: Icon(Icons.warning, color: Colors.amber),
                            colorText: Colors.grey.shade800,
                          );
                          return;
                        }

                        double? diskonValue;
                        final diskonPersen = diskonController.text
                            .replaceAll("%", "")
                            .trim();
                        if (diskonPersen.isNotEmpty) {
                          diskonValue = double.tryParse(diskonPersen);
                        } else {
                          diskonValue = null;
                        }

                        if (gambarPath != null) {
                          gambarPath = await simpanGambar(gambarPath!);
                        }

                        await DatabaseKasir.postProduk(
                          nama: namaController.text,
                          kategoriNama: pilihKategoriNama!,
                          hargaDasar: hargaDasarController.text.toDoubleClean(),
                          hargaJual: hargaJualController.text.toDoubleClean(),
                          stok: int.tryParse(stokController.text) ?? 0,
                          diskon: diskonValue,
                          gambar: gambarPath,
                        );
                        namaController.clear();
                        hargaDasarController.clear();
                        hargaJualController.clear();
                        stokController.clear();
                        diskonController.clear();
                        gambarPath = null;
                        setState(() {
                          pilihKategoriNama = null;
                        });
                        Get.snackbar(
                          "Sukses",
                          "produk berhasil ditambahkan",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.white,
                          colorText: Colors.grey.shade800,
                          icon: Icon(Icons.check_circle, color: Colors.green),
                        );
                        final produkLoad = Get.find<ProdukControl>();
                        produkLoad.loadProduk();
                      },

                      child: Center(
                        child: Text(
                          "Simpan",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
