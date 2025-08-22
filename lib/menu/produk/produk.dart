import 'package:flutter/material.dart';
import 'package:food_app/menu/produk/tambah_produk.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class Produk extends StatelessWidget {
  const Produk({super.key});

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
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            return null;
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => Get.to(
          () => EditProduk(),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 300),
        ),
        child: Icon(Icons.add_box_rounded, color: Colors.white),
      ),
    );
  }
}
