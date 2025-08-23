import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_app/controller/kategori_control.dart';
import 'package:food_app/controller/produk_control.dart';
import 'package:food_app/menu/produk/widget/format_rupiah.dart';
import 'package:food_app/order.dart';
import 'package:food_app/widget/drawer_list.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //menentukan posisi awal index
  int selectedIndex = 0;
  final kategoriAdd = Get.find<KategoriControl>();
  final produkLoad = Get.find<ProdukControl>();

  //semua nama kategori
  List<String> get menu =>
      kategoriAdd.kategoriList.map((e) => e["nama"] as String).toList();
  //semua produk
  List<Map<String, dynamic>> get produkList => produkLoad.produkList;

  //produk filter
  List<Map<String, dynamic>> get filteredMenu {
    if (produkList.isEmpty) return [];
    final selectedCategory = menu[selectedIndex];
    return produkList
        .where((item) => item["kategori_nama"] == selectedCategory)
        .toList();
  }

  RxInt totalItem = 0.obs;
  RxDouble totalBayar = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kasirnyong",
          style: GoogleFonts.lobster(
            fontSize: 20,
            color: Colors.grey.shade900,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Row(
              children: [
                Text(
                  "Transaksi Hari Ini :",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Text("20 item", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      drawer: MenuDrawer(),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                child: Obx(
                  () => Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepPurple,
                      border: Border.all(color: Colors.deepPurple),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Bayar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              totalBayar.value.toRupiah(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "(${totalItem.value} Item)",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              totalBayar.value = 0.0;
                              totalItem.value = 0;
                            },
                            child: Ink(
                              height: 40,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  "Reset",
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
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
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: menu.length,
                  itemBuilder: (context, index) {
                    final menuItem = menu[index];
                    final bool isSelected = selectedIndex == index;
                    return Row(
                      children: [
                        if (index == 0) SizedBox(width: 10),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: 60,
                              width: 120,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.deepPurple
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                                color: isSelected
                                    ? Colors.deepPurple
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  menuItem,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Obx(() {
                    final items = filteredMenu;
                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          "Produk masih kosong",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: EdgeInsets.only(bottom: 15),
                      itemCount: items.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 30,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.95,
                      ),
                      itemBuilder: (context, index) {
                        final produkView = items[index];
                        return GestureDetector(
                          onTap: () {
                            final harga = (produkView["harga_jual"] as num)
                                .toDouble();
                            totalBayar.value += harga;
                            totalItem.value += 1;
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade500,
                                  blurRadius: 1,
                                  offset: Offset(1, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 130,
                                    width: 150,
                                    child: produkView["gambar"] != null
                                        ? Image.file(
                                            File(produkView["gambar"]),
                                            fit: BoxFit.contain,
                                          )
                                        : Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                          ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      produkView["nama"] ?? "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      (produkView["harga_jual"] as num)
                                          .toRupiah(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => Get.to(
          () => Order(),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 300),
        ),
        child: Icon(Icons.point_of_sale, color: Colors.white),
      ),
    );
  }
}
