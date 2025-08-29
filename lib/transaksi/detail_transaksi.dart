import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:kasirnyong/manaj_produk/produk/widget/format_rupiah.dart';
import 'package:kasirnyong/manaj_produk/produk/widget/textform_produk.dart';
import 'package:kasirnyong/order/widget/format_pajak.dart';
import 'package:kasirnyong/transaksi/widget/format_kirim.dart';
import 'package:kasirnyong/transaksi/widget/format_pdf.dart';
import 'package:kasirnyong/transaksi/widget/format_waktu.dart';
import 'package:kasirnyong/transaksi/widget/info.dart';

class DetailTransaksi extends StatelessWidget {
  final Map<String, dynamic> order;

  const DetailTransaksi({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final details = order["details"] as List<Map<String, dynamic>>;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text("Detail Transaksi", style: TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.shade200,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Info(
                    value: FormatWaktu.tanggal(order["tanggal"]),
                    label: "Tanggal",
                  ),
                  Info(value: "Order #${order["id"]}", label: "ID transaksi"),
                  Info(
                    value: (order["sub_total_order"] as num).toRupiah(),
                    label: "Sub Total",
                  ),
                  Info(
                    value:
                        "${formatPajak((order["pajak_persen"] ?? 0).toDouble())}%",
                    label: "Pajak",
                  ),
                  Divider(),
                  Info(
                    value: (order["total_order"] as num).toRupiah(),
                    label: "Total",
                  ),
                  Info(
                    value: order["metode_bayar"],
                    label: "Metode Pembayaran",
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.shade200,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Detail Pesanan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ...details.map(
                    (item) => ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text(
                        item["produk_nama"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      subtitle: Text(
                        "${(item["jumlah"] ?? 0).toString()} item x ${(item["harga_jual"] as num).toRupiah()}"
                        "${(item["diskon"] != null && (item["diskon"] as num) > 0 ? " (-${(item["diskon"] as num).toInt()}%)" : "")}",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      trailing: Text(
                        (item["total"] as num).toRupiah(),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        padding: EdgeInsets.only(bottom: 25, left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),

            // onTap: () async {
            //   await shareInvoice(order);
            // },
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  final phoneController = TextEditingController();
                  return AlertDialog(
                    title: Text(
                      "Input Nomor telepon",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    content: TextformProduk(
                      label: "Nomor WA",
                      controller: phoneController,
                      readOnly: false,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          Uint8List pdfData = await formatPdf(order);
                          String fileName = "invoice_${order["id"]}.pdf";

                          final phoneNumber = phoneController.text.trim();
                          if (phoneNumber.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "Nomor WA tidak boleh kosong",
                            );
                            return;
                          }
                          try {
                            String pdfLink = await uploadPdf(pdfData, fileName);

                            await sendInvoiceWa(phoneNumber, pdfLink);

                            Get.snackbar(
                              "Sukses",
                              "Invoice berhasil dikirim ke $phoneNumber",
                            );
                            Get.back();
                          } catch (e) {
                            Get.snackbar("Error", e.toString());
                          }
                        },
                        child: Text(
                          "Kirim",
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          "Batal",
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Kirim Invoice",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
