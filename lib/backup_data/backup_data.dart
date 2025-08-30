import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirnyong/backup_data/widget/backup_service.dart';
import 'package:kasirnyong/controller/kategori_control.dart';
import 'package:kasirnyong/controller/produk_control.dart';
import 'package:kasirnyong/homepage/homepage.dart';
import 'package:kasirnyong/homepage/widget/box_item.dart';
import 'package:kasirnyong/splash.dart';

class BackupData extends StatefulWidget {
  const BackupData({super.key});

  @override
  State<BackupData> createState() => _BackupState();
}

class _BackupState extends State<BackupData> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/backup.png'), context);
      precacheImage(const AssetImage('assets/restore.png'), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text("Database", style: TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Row(
          children: [
            Expanded(
              child: BoxItem(
                images: "assets/backup.png",
                label: "Backup Data",
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          "Backup Data To Google Drive",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              try {
                                await backupGdrive();
                                Get.back();
                                Get.snackbar(
                                  "Sukses",
                                  "Backup berhasil",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.white,
                                  icon: Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                  colorText: Colors.grey.shade800,
                                );
                              } catch (e) {
                                Get.back();
                                Get.snackbar(
                                  "Error",
                                  "Backup gagal: $e",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.white,
                                  icon: Icon(Icons.warning, color: Colors.red),
                                  colorText: Colors.grey.shade800,
                                );
                              }
                            },
                            child: Text(
                              "Backup",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              "Batal",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey.shade800,
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
            Expanded(
              child: BoxItem(
                images: "assets/restore.png",
                label: "Restore",
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          "Restore Data From Google Drive",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              try {
                                await restoreGdrive();
                                await Get.find<KategoriControl>()
                                    .loadKategori();
                                await Get.find<ProdukControl>().loadProduk();

                                Get.snackbar(
                                  "Sukses",
                                  "Restore berhasil, aplikasi akan dimulai ulang",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.white,
                                  icon: Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                  colorText: Colors.grey.shade800,
                                );
                                await Future.delayed(Duration(seconds: 5));
                                Get.offAll(() => Splash());
                              } catch (e) {
                                Get.back();
                                Get.snackbar(
                                  "Error",
                                  "Restore gagal: $e",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.white,
                                  icon: Icon(Icons.warning, color: Colors.red),
                                  colorText: Colors.grey.shade800,
                                );
                              }
                            },
                            child: Text(
                              "Restore",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              "Batal",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey.shade800,
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
          ],
        ),
      ),
    );
  }
}
