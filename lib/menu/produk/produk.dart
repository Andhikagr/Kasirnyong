import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:food_app/controller/produk_control.dart';
import 'package:food_app/menu/produk/tambah_produk.dart';
import 'package:food_app/menu/produk/widget/edit_produk.dart';
import 'package:food_app/menu/produk/widget/format_rupiah.dart';
import 'package:get/get.dart';

class Produk extends StatefulWidget {
  const Produk({super.key});

  @override
  State<Produk> createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  final produkLoad = Get.find<ProdukControl>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,

        title: Text("Produk"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Obx(() {
          final produkByKategori = groupBy(
            produkLoad.produkList,
            (p) => p["kategori_nama"],
          );
          return ListView(
            padding: EdgeInsets.all(15),
            children: produkByKategori.entries.map((entry) {
              final kategori = entry.key;
              final listProduk = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kategori,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  //produk
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listProduk.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 0.82,
                    ),
                    itemBuilder: (context, index) {
                      final produk = listProduk[index];
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 1,
                              offset: Offset(3, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              height: 80,
                              width: double.infinity,
                              child: produk["gambar"] != null
                                  ? Image.file(
                                      File(produk["gambar"]),
                                      fit: BoxFit.contain,
                                    )
                                  : Image.asset("assets/nophotos.png"),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5,
                              ),
                              height: 45,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  produk['nama'], //
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (produk["harga_jual"] as num).toRupiah(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Apakah kamu yakin?",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  produkLoad.hapusProduk(
                                                    produk["id"],
                                                  );
                                                  Get.back();
                                                },
                                                child: Text(
                                                  "Ya",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () => Get.back(),
                                                child: Text(
                                                  "Batal",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () => Get.to(
                                  () => EditProduk(
                                    produkId: produk["id"],
                                    nama: produk["nama"],
                                    kategoriNama: produk["kategori_nama"],
                                    hargaDasar: (produk["harga_dasar"] as num)
                                        .toDouble(),
                                    hargaJual: produk["harga_jual"],
                                    stok: produk["stok"],
                                    gambar: produk["gambar"],
                                  ),
                                ),
                                child: Ink(
                                  padding: EdgeInsets.all(3),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Edit produk",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
              );
            }).toList(),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          Get.to(
            () => TambahProduk(),
            transition: Transition.rightToLeft,
            duration: Duration(milliseconds: 300),
          );
          produkLoad.loadProduk();
        },
        child: Icon(Icons.add_box_rounded, color: Colors.white),
      ),
    );
  }
}
