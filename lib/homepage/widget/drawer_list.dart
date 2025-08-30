import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasirnyong/backup_data/backup_data.dart';
import 'package:kasirnyong/laporan.dart';
import 'package:kasirnyong/manaj_produk/manaj_produk.dart';
import 'package:kasirnyong/nama.dart';
import 'package:kasirnyong/print.dart';
import 'package:kasirnyong/transaksi/lapor_transaksi.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> drawerMenu = [
      {
        "label": "Nama Toko",
        "icon": Icons.storefront_sharp,
        "page": () => Nama(),
      },
      {
        "label": "Transaksi",
        "icon": Icons.receipt_long,
        "page": () => LaporTransaksi(),
      },
      {
        "label": "Manajemen Produk",
        "icon": CupertinoIcons.tray_2_fill,
        "page": () => ManajProduk(),
      },
      {
        "label": "Print",
        "icon": CupertinoIcons.printer_fill,
        "page": () => Print(),
      },
      {
        "label": "Laporan Penjualan",
        "icon": CupertinoIcons.doc_text_fill,
        "page": () => Laporan(),
      },
      {
        "label": "Database",
        "icon": CupertinoIcons.cloud_fog_fill,
        "page": () => BackupData(),
      },
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage('assets/brand.png'), context);
      precacheImage(AssetImage('assets/list.png'), context);
    });
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              "Kasirnyong",
              style: GoogleFonts.lobster(
                fontSize: 28,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(height: 10),
          SizedBox(height: 15),
          ...drawerMenu.map((dataDrawer) {
            return Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.deepPurple.shade200, blurRadius: 2),
                ],
              ),

              child: ListTile(
                leading: Icon(dataDrawer["icon"], color: Colors.grey.shade800),
                title: Text(
                  "${dataDrawer["label"]}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(
                    dataDrawer["page"],
                    transition: Transition.native,
                    duration: Duration(milliseconds: 800),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
