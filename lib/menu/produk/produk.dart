import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_app/controller/produk_control.dart';
import 'package:food_app/menu/produk/tambah_produk.dart';
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
        padding: EdgeInsets.all(15),
        child: Obx(
          () => GridView.builder(
            itemCount: produkLoad.produkList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 30,
              crossAxisSpacing: 30,
            ),
            itemBuilder: (context, index) {
              final produk = produkLoad.produkList[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
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
                    produk["gambar"] != null
                        ? Image.file(
                            File(produk["gambar"]),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                        : Image.asset("assets/nophotos.png"),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        produk['nama'], //
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (produk["harga_jual"] as num).toRupiah(),
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                                        produkLoad.hapusProduk(produk["id"]);
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
                          child: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          Get.to(
            () => EditProduk(),
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
