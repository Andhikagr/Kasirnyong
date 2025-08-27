import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_app/controller/kategori_control.dart';
import 'package:food_app/controller/produk_control.dart';
import 'package:food_app/database/database.dart';
import 'package:food_app/menu/produk/widget/button_produk.dart';
import 'package:food_app/menu/produk/widget/format_rupiah.dart';
import 'package:food_app/menu/produk/widget/textform_produk.dart';
import 'package:get/get.dart';

class EditProduk extends StatefulWidget {
  final int? produkId;
  final String? nama;
  final String? kategoriNama;
  final double? hargaDasar;
  final double? hargaJual;
  final int? stok;
  final double? diskon;
  final String? gambar;

  const EditProduk({
    super.key,
    this.produkId,
    this.nama,
    this.kategoriNama,
    this.hargaDasar,
    this.hargaJual,
    this.stok,
    this.diskon,
    this.gambar,
  });

  @override
  State<EditProduk> createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
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
    // Prefill data jika ada
    namaController.text = widget.nama ?? "";
    hargaDasarController.text = widget.hargaDasar!.toRupiah();
    hargaJualController.text = widget.hargaJual!.toRupiah();
    stokController.text = widget.stok?.toString() ?? "";
    pilihKategoriNama = widget.kategoriNama;
    diskonController.text = (widget.diskon != null && widget.diskon! > 0)
        ? "${widget.diskon!.toInt()}%"
        : "";
    gambarPath = widget.gambar;
    hargaJualController.addListener(hargaDiskon);
    diskonController.addListener(hargaDiskon);
    hargaDiskon();
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
          title: Text("Edit Produk"),
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
                DropdownButtonFormField<String>(
                  value: pilihKategoriNama,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: pilihKategoriNama,
                      child: Text(pilihKategoriNama ?? "-"),
                    ),
                  ],
                  onChanged: null,
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
                        height: 150,
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
                        double? diskonValue;
                        final diskonPersen = diskonController.text
                            .replaceAll("%", "")
                            .trim();
                        if (diskonPersen.isNotEmpty) {
                          diskonValue = double.tryParse(diskonPersen);
                        } else {
                          diskonValue = null;
                        }
                        await DatabaseKasir.updateProduk(
                          id: widget.produkId!,
                          nama: namaController.text,
                          kategoriNama: pilihKategoriNama!,
                          hargaDasar: hargaDasarController.text.toDoubleClean(),
                          hargaJual: hargaJualController.text.toDoubleClean(),
                          diskon: diskonValue,
                          stok: int.tryParse(stokController.text) ?? 0,
                          gambar: gambarPath,
                        );
                        Get.snackbar(
                          "Sukses",
                          "produk berhasil diperbaharui",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.white,
                          colorText: Colors.black,
                          icon: Icon(Icons.check_circle, color: Colors.green),
                        );

                        final produkLoad = Get.find<ProdukControl>();
                        produkLoad.loadProduk();
                      },
                      child: Center(
                        child: Text(
                          "Update",
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
