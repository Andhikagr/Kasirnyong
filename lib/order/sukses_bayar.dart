import 'package:flutter/material.dart';
import 'package:food_app/homepage/homepage.dart';
import 'package:food_app/transaksi/transaksi.dart';
import 'package:get/get.dart';

class SuksesBayar extends StatelessWidget {
  const SuksesBayar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/sukses.png", fit: BoxFit.contain, width: 150),
              Text(
                "Pembayaran Berhasil",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Row(
          children: [
            Expanded(
              child: BoxSukses(
                bgColors: Colors.deepPurple,
                label: "Kirim Nota",
                onTap: () => Get.offAll(
                  () => Transaksi(),
                  transition: Transition.native,
                  duration: Duration(milliseconds: 500),
                ),
                textColors: Colors.white,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: BoxSukses(
                bgColors: Colors.white,
                label: "Selesai",
                onTap: () => Get.offAll(
                  () => Homepage(),
                  transition: Transition.native,
                  duration: Duration(milliseconds: 500),
                ),
                textColors: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoxSukses extends StatelessWidget {
  final Color? bgColors;
  final String label;
  final Color? textColors;
  final VoidCallback onTap;

  const BoxSukses({
    super.key,
    this.bgColors,
    required this.label,
    required this.textColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(10),
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: bgColors,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.shade200,
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                color: textColors,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
