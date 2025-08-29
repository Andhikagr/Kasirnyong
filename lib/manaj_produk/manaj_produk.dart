import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:kasirnyong/homepage/widget/box_item.dart';
import 'package:kasirnyong/manaj_produk/kategori/kategori.dart';
import 'package:kasirnyong/manaj_produk/produk/produk.dart';

class ManajProduk extends StatefulWidget {
  const ManajProduk({super.key});

  @override
  State<ManajProduk> createState() => _ItemState();
}

class _ItemState extends State<ManajProduk> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/brand.png'), context);
      precacheImage(const AssetImage('assets/list.png'), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text("Manajemen Produk", style: TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Row(
          children: [
            Expanded(
              child: BoxItem(
                images: "assets/brand.png",
                label: "Produk",
                onTap: () => Get.to(
                  () => Produk(),
                  transition: Transition.native,
                  duration: Duration(milliseconds: 600),
                ),
              ),
            ),
            Expanded(
              child: BoxItem(
                images: "assets/list.png",
                label: "Kategori",
                onTap: () => Get.to(
                  () => Kategori(),
                  transition: Transition.native,
                  duration: Duration(milliseconds: 600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
