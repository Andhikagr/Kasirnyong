import 'package:flutter/material.dart';

import 'package:food_app/menu/backup.dart';
import 'package:food_app/menu/laporan.dart';
import 'package:food_app/menu/print.dart';
import 'package:food_app/menu/item.dart';
import 'package:food_app/menu/transaksi.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

final List<Map<String, dynamic>> drawerMenu = [
  {"label": "Transaksi", "icon": Icons.swap_horiz, "page": () => Transaksi()},
  {"label": "Produk", "icon": Icons.inventory, "page": () => Item()},
  {"label": "Print", "icon": Icons.print, "page": () => Print()},
  {"label": "Laporan", "icon": Icons.bar_chart, "page": () => Laporan()},
  {"label": "Backup Database", "icon": Icons.backup, "page": () => Backup()},
];

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(AssetImage('assets/brand.png'), context);
      precacheImage(AssetImage('assets/list.png'), context);
    });
    return Drawer(
      backgroundColor: Colors.deepPurple,
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              "Kasirnyong",
              style: GoogleFonts.lobster(
                fontSize: 28,
                color: Colors.white,
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
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ],
              ),

              child: ListTile(
                leading: Icon(dataDrawer["icon"]),
                title: Text("${dataDrawer["label"]}"),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(
                    dataDrawer["page"](),
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
