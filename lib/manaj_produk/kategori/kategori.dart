import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirnyong/controller/kategori_control.dart';

class Kategori extends StatefulWidget {
  const Kategori({super.key});

  @override
  State<Kategori> createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  final kategoriLoad = Get.find<KategoriControl>();
  TextEditingController tambahKat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text("Kategori", style: TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Obx(
          () => ListView.separated(
            itemCount: kategoriLoad.kategoriList.length,
            separatorBuilder: (context, index) => SizedBox(height: 15),
            itemBuilder: (context, index) {
              final kategori = kategoriLoad.kategoriList[index];
              return Container(
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
                child: ListTile(
                  leading: Icon(Icons.storefront_sharp),
                  title: Text(
                    kategori['nama'],
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            icon: Icon(Icons.warning, color: Colors.red),
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
                                  kategoriLoad.hapusKategori(kategori["nama"]);
                                  Get.back();
                                },
                                child: Text(
                                  "Ya",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
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
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Tambah Kategori",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                content: TextFormField(
                  enableSuggestions: false,
                  controller: tambahKat,
                  decoration: InputDecoration(
                    hintText: "tambah",
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (tambahKat.text.isNotEmpty) {
                        kategoriLoad.tambahKategori(tambahKat.text);
                        tambahKat.clear();
                        Get.back();
                      }
                    },
                    child: Text(
                      "Simpan",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      tambahKat.clear();
                      Get.back();
                    },
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
          ),
        },

        child: Icon(Icons.add_box_rounded, color: Colors.white),
      ),
    );
  }
}
