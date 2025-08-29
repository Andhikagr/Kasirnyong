import 'package:flutter/material.dart';
import 'package:food_app/manaj_produk/kategori/kategori.dart';
import 'package:food_app/manaj_produk/produk/produk.dart';
import 'package:food_app/homepage/widget/box_item.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class Item extends StatelessWidget {
  const Item({super.key});

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
