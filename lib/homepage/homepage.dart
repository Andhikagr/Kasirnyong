import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_app/controller/kategori_control.dart';
import 'package:food_app/controller/produk_control.dart';
import 'package:food_app/homepage/widget/update_transaksi.dart';
import 'package:food_app/menu/produk/widget/format_rupiah.dart';
import 'package:food_app/order/order.dart';
import 'package:food_app/homepage/widget/animation_addchart.dart';
import 'package:food_app/homepage/widget/drawer_list.dart';

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
  //untuk mndapatkan posisi dan ukuran widget
  GlobalKey bayarKey = GlobalKey();

  //animasi
  void flyAnimation(Offset startPos, Offset endPos, Widget flyWidget) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) {
        return AnimatedFlyWidget(
          start: startPos,
          end: endPos,
          child: flyWidget,
          onComplete: () => entry.remove(),
        );
      },
    );
    overlay.insert(entry);
  }

  //simpan pesanan
  RxList<Map<String, dynamic>> pesananList = <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    super.initState();
    updateTransaksi();
  }

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
            padding: EdgeInsets.only(right: 20),
            child: Obx(
              () => Text(
                "Transaksi hari ini : ${totalOrderHari.value}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
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
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Obx(
                  () => Container(
                    key: bayarKey,
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    height: 110,
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
                            SizedBox(width: 10),
                            Badge(
                              label: Text("${totalItem.value}"),
                              child: Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 60,
                child: Obx(
                  () => ListView.builder(
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
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        final produkView = items[index];
                        final productKey = GlobalKey();
                        //hitung harga diskon
                        final hargaJual = (produkView["harga_jual"] as num)
                            .toDouble();
                        final diskon = (produkView["diskon"] ?? 0).toDouble();
                        final hargaAkhir = diskon > 0
                            ? (hargaJual - (hargaJual * diskon / 100))
                            : hargaJual;
                        return GestureDetector(
                          onTap: () {
                            totalBayar.value += hargaAkhir;
                            totalItem.value += 1;

                            // Tambahkan produk ke list pesanan
                            final index = pesananList.indexWhere(
                              (item) => item["nama"] == produkView["nama"],
                            );
                            if (index != -1) {
                              (pesananList[index]["jumlah"] as RxInt).value++;
                            } else {
                              pesananList.add({
                                "nama": produkView["nama"],
                                "harga_jual": produkView["harga_jual"],
                                "diskon": produkView["diskon"],
                                "harga_akhir": hargaAkhir,
                                "jumlah": 1.obs,
                              });
                            }

                            //posisi target
                            final renderBoxTarget =
                                bayarKey.currentContext?.findRenderObject()
                                    as RenderBox?;
                            final targetPos =
                                renderBoxTarget!.localToGlobal(Offset.zero) +
                                Offset(
                                  renderBoxTarget.size.width / 3,
                                  renderBoxTarget.size.height / 3,
                                );

                            //posisi awal
                            final renderBoxStart =
                                productKey.currentContext?.findRenderObject()
                                    as RenderBox?;
                            if (renderBoxStart == null) return;
                            final startPos =
                                renderBoxStart.localToGlobal(Offset.zero) +
                                Offset(
                                  renderBoxStart.size.width / 3,
                                  renderBoxStart.size.height / 3,
                                );

                            flyAnimation(
                              startPos,
                              targetPos,
                              Image.file(
                                File(produkView["gambar"]),
                                width: 100,
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
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
                                SizedBox(
                                  width: 150,
                                  height: 120,
                                  key: productKey,
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
                                SizedBox(height: 5),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      produkView["nama"] ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    if (diskon > 0)
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          hargaJual.toRupiah(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          hargaAkhir.toRupiah(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: diskon > 0
                                                ? Colors.red
                                                : Colors.black87,
                                          ),
                                        ),
                                        diskon != 0
                                            ? Text(
                                                "${produkView["diskon"]!.toInt()}% Off",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
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
        onPressed: () {
          totalBayar.value = 0.0;
          totalItem.value = 0;
          Get.to(
            () => Order(pesananList: pesananList),
            transition: Transition.rightToLeft,
            duration: Duration(milliseconds: 300),
          );
        },
        child: Icon(Icons.point_of_sale, color: Colors.white),
      ),
    );
  }
}
