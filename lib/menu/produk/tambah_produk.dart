import 'package:flutter/material.dart';
import 'package:food_app/menu/produk/widget/button_produk.dart';
import 'package:food_app/menu/produk/widget/textform_produk.dart';

class EditProduk extends StatefulWidget {
  const EditProduk({super.key});

  @override
  State<EditProduk> createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          title: Text("Tambah Produk"),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                TextformProduk(label: "Nama Produk"),
                SizedBox(height: 15),
                Text(
                  "Kategori",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  hint: const Text("Pilih Kategori"),
                  items: ["Makanan", "Minuman", "Snack"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {},
                ),
                SizedBox(height: 20),
                TextformProduk(label: "Harga Dasar"),
                SizedBox(height: 20),
                TextformProduk(label: "Harga Jual"),
                SizedBox(height: 20),
                TextformProduk(label: "Stok (opsional)"),
                SizedBox(height: 15),
                Text(
                  "Gambar Produk",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          ButtonProduk(
                            label: "Pilih Gambar",
                            icons: Icons.photo,
                          ),
                          SizedBox(height: 20),
                          ButtonProduk(
                            label: "Ambil Foto",
                            icons: Icons.camera_alt,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsetsGeometry.all(15),
          child: Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "Simpan",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
