import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/bigtableadmin/v2.dart';
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
        "page": () => ManajProduk(),
      },
      {"label": "Print", "icon": Icons.print, "page": () => Print()},
      {
        "label": "Laporan Penjualan",
        "icon": Icons.bar_chart,
        "page": () => Laporan(),
      },
      {"label": "Backup Data", "icon": Icons.backup, "page": () => Backup()},
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
