import 'package:flutter/material.dart';
import 'package:food_app/menu/produk/widget/textform_produk.dart';
import 'package:food_app/order/widget/box_order.dart';

class Nama extends StatefulWidget {
  const Nama({super.key});

  @override
  State<Nama> createState() => _NamaState();
}

class _NamaState extends State<Nama> {
  final TextEditingController _namaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          title: Text("Identitas"),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 30),
              TextformProduk(
                label: "Nama Toko / Usaha",
                controller: _namaController,
                readOnly: false,
              ),
              SizedBox(height: 20),
              TextformProduk(
                label: "Alamat",
                controller: _namaController,
                readOnly: false,
              ),
              SizedBox(height: 20),
              TextformProduk(
                label: "Nomor Telp.",
                controller: _namaController,
                readOnly: false,
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: BoxOrder(
                  height: 50,
                  width: 150,
                  bgColors: Colors.deepPurple,
                  textColors: Colors.white,
                  label: "Simpan",
                ),
              ),

              SizedBox(height: 20),
              Container(
                height: 200,
                width: double.infinity,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
