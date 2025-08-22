import 'package:flutter/material.dart';
import 'package:food_app/controller/kategori_control.dart';
import 'package:food_app/database/database.dart';
import 'package:food_app/menu/produk/widget/button_produk.dart';
import 'package:food_app/menu/produk/widget/textform_produk.dart';
import 'package:get/get.dart';

class EditProduk extends StatefulWidget {
  const EditProduk({super.key});

  @override
  State<EditProduk> createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final kategoriAdd = Get.find<KategoriControl>();
  int? pilihKategoriId;
  final TextEditingController simpanCOntroller = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaDasarController = TextEditingController();
  final TextEditingController hargaJualController = TextEditingController();
  final TextEditingController stokController = TextEditingController();

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
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                TextformProduk(
                  label: "Nama Produk",
                  controller: namaController,
                ),
                SizedBox(height: 10),
                Text(
                  "Kategori",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 10),
                Obx(
                  () => DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    hint: const Text("Pilih Kategori"),
                    items: kategoriAdd.kategoriList
                        .map(
                          (e) => DropdownMenuItem<int>(
                            value: e["id"],
                            child: Text(e["nama"]),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        pilihKategoriId = val;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                TextformProduk(
                  label: "Harga Dasar",
                  controller: hargaDasarController,
                ),
                SizedBox(height: 20),
                TextformProduk(
                  label: "Harga Jual",
                  controller: hargaJualController,
                ),
                SizedBox(height: 20),
                TextformProduk(
                  label: "Stok (opsional)",
                  controller: stokController,
                ),
                SizedBox(height: 10),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () {
                    namaController.clear();
                    hargaDasarController.clear();
                    hargaJualController.clear();
                    stokController.clear();
                    setState(() {
                      pilihKategoriId = null;
                    });
                  },
                  child: Text("Clear"),
                ),
                SizedBox(height: 10),
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
                    SizedBox(width: 25),
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

        bottomNavigationBar: pilihKategoriId != null
            ? Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 3,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),

                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Material(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        if (pilihKategoriId != null &&
                            namaController.text.isNotEmpty) {
                          await DatabaseKasir.postProduk(
                            nama: namaController.text,
                            kategoriId: pilihKategoriId!,
                            hargaDasar:
                                double.tryParse(hargaDasarController.text) ?? 0,
                            hargaJual:
                                double.tryParse(hargaJualController.text) ?? 0,
                            stok: int.tryParse(stokController.text) ?? 0,
                            gambar: null,
                          );
                          Get.back();
                        }
                      },
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
              )
            : null,
      ),
    );
  }
}
