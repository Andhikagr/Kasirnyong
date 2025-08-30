import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirnyong/controller/produk_control.dart';
import 'package:kasirnyong/manaj_produk/produk/edit_produk.dart';
import 'package:kasirnyong/manaj_produk/produk/tambah_produk.dart';
import 'package:kasirnyong/manaj_produk/produk/widget/format_rupiah.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text("Produk", style: TextStyle(fontSize: 18)),
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
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  //produk
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listProduk.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio: 0.78,
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
                        margin: EdgeInsets.all(3),
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.shade200,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => Get.to(
                                    () => EditProduk(
                                      produkId: produk["id"],
                                      nama: produk["nama"],
                                      kategoriNama: produk["kategori_nama"],
                                      hargaDasar: (produk["harga_dasar"] as num)
                                          .toDouble(),
                                      hargaJual: produk["harga_jual"],
                                      stok: produk["stok"],
                                      diskon: produk["diskon"],
                                      gambar: produk["gambar"],
                                    ),
                                  ),
                                  child: Container(
                                    height: 25,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.deepPurple,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "edit",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Apakah kamu yakin?",
                                            style: TextStyle(
                                              fontSize: 14,
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
                                                  color: Colors.grey.shade800,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () => Get.back(),
                                              child: Text(
                                                "Batal",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade800,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    CupertinoIcons.trash_circle_fill,
                                    color: Colors.red,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 70,
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
                                  fontSize: 11,
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
                                    fontSize: 11,
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
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
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
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  (produk["harga_jual"] as num).toRupiah(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
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
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  produk["diskon"] != null
                                      ? "${produk["diskon"]!.toInt()}%"
                                      : "-",
                                  style: TextStyle(
                                    fontSize: 11,
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
                                        style: TextStyle(fontSize: 11),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          hargaDiskon != null
                                              ? hargaDiskon.toRupiah()
                                              : "-",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
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
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 8),
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
        child: Icon(
          CupertinoIcons.add_circled_solid,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
