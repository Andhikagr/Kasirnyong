import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:food_app/controller/produk_control.dart';
import 'package:food_app/menu/produk/tambah_produk.dart';
import 'package:food_app/menu/produk/edit_produk.dart';
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
      resizeToAvoidBottomInset: false,
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
          //urut kategori
          final sorted = produkByKategori.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key));
          return ListView(
            children: sorted.map((entry) {
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
                      childAspectRatio: 0.68,
                    ),
                    itemBuilder: (context, index) {
                      final produk = listProduk[index];
                      //hitung harga diskon
                      final hargaJual = (produk["harga_jual"] as num)
                          .toDouble();
                      final diskon = (produk["diskon"] ?? 0.toDouble());
                      final hargaDiskon = diskon > 0
                          ? (hargaJual - (hargaJual * diskon / 100))
                          : null;
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.shade200,
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              height: 90,
                              width: double.infinity,
                              child: produk["gambar"] != null
                                  ? Image.file(
                                      File(produk["gambar"]),
                                      fit: BoxFit.contain,
                                    )
                                  : Image.asset("assets/nophotos.png"),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                produk['nama'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Harga Pokok",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Visibility(
                                    child: Text(
                                      (produk['harga_dasar'] as num).toRupiah(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Harga Jual",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  (produk["harga_jual"] as num).toRupiah(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Diskon",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  produk["diskon"] != null
                                      ? "${produk["diskon"]!.toInt()}%"
                                      : "-",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            diskon != 0
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Harga Diskon",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          hargaDiskon != null
                                              ? hargaDiskon.toRupiah()
                                              : "-",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Belum ada diskon",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 8),
                            Column(
                              children: [
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
                                        hargaDasar:
                                            (produk["harga_dasar"] as num)
                                                .toDouble(),
                                        hargaJual: produk["harga_jual"],
                                        stok: produk["stok"],
                                        diskon: produk["diskon"],
                                        gambar: produk["gambar"],
                                      ),
                                    ),
                                    child: Ink(
                                      padding: EdgeInsets.all(6),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Edit produk",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                GestureDetector(
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
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD00E00),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Hapus",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
