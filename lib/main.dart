import 'package:flutter/material.dart';
import 'package:food_app/controller/kategori_control.dart';
import 'package:food_app/controller/produk_control.dart';
import 'package:food_app/splash.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  Get.put(KategoriControl());
  Get.put(ProdukControl());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: Splash(),
    );
  }
}
