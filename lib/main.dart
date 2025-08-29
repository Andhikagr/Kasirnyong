import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasirnyong/controller/kategori_control.dart';
import 'package:kasirnyong/controller/produk_control.dart';
import 'package:kasirnyong/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(KategoriControl(), permanent: true);
  Get.put(ProdukControl(), permanent: true);
  //hanya potrait saja
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
