import 'package:flutter/material.dart';

import 'package:food_app/manaj_produk/backup.dart';
import 'package:food_app/manaj_produk/produk/manaj_produk.dart';
import 'package:food_app/laporan.dart';
import 'package:food_app/manaj_produk/print.dart';
import 'package:food_app/nama.dart';
import 'package:food_app/transaksi/lapor_transaksi.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> drawerMenu = [
      {
        "label": "Nama Toko",
        "icon": Icons.storefront_outlined,
        "page": () => Nama(),
      },
      {
        "label": "Transaksi",
        "icon": Icons.swap_horiz,
        "page": () => LaporTransaksi(),
      },
      {
        "label": "Manajemen Produk",
        "icon": Icons.inventory,
        "page": () => Item(),
      },
      {"label": "Print", "icon": Icons.print, "page": () => Print()},
      {
        "label": "Laporan Penjualan",
        "icon": Icons.bar_chart,
        "page": () => Laporan(),
      },
      {
        "label": "Backup Database",
        "icon": Icons.backup,
        "page": () => Backup(),
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
