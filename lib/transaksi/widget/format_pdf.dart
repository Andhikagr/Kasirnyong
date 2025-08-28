import 'package:flutter/services.dart';
import 'package:food_app/database/database.dart';
import 'package:food_app/manaj_produk/produk/widget/format_rupiah.dart';
import 'package:food_app/order/widget/format_pajak.dart';
import 'package:food_app/transaksi/widget/format_waktu.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

//fungsi persen
String formatDiskon(num diskon) {
  if (diskon % 1 == 0) {
    return diskon.toInt().toString();
  } else {
    return diskon.toString();
  }
}

Future<Uint8List> formatPdf(Map<String, dynamic> orderInvoice) async {
  final pdf = pw.Document();
  final ttfRegular = pw.Font.ttf(
    await rootBundle.load('assets/Roboto-Regular.ttf'),
  );

  final items = orderInvoice["details"] as List<Map<String, dynamic>>;
  final subTotal = (orderInvoice["sub_total_order"] ?? 0) as num;
  final pajak = (orderInvoice["pajak_persen"] ?? 0) as num;
  final total = (orderInvoice["total_order"] ?? 0) as num;
  final metodeBayar = orderInvoice["metode_bayar"] ?? "-";

  final identitas = await DatabaseKasir.getIdentitas();
  final nama = identitas["nama"] ?? "";
  final alamat = identitas["alamat"] ?? "";
  final noTelp = identitas["no_telp"] ?? "";

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat(95 * PdfPageFormat.mm, double.infinity),
      build: (pw.Context context) {
        return pw.Padding(
          padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: pw.Column(
            children: [
              pw.Column(
                children: [
                  pw.Text(
                    nama,
                    style: pw.TextStyle(
                      font: ttfRegular,
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    "$alamat \nTelp: $noTelp",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: ttfRegular, fontSize: 10),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  "INVOICE",
                  style: pw.TextStyle(
                    font: ttfRegular,
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  "ID Transaksi: #${orderInvoice["id"]}",
                  style: pw.TextStyle(font: ttfRegular, fontSize: 9),
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  "Tanggal: ${FormatWaktu.tanggal(orderInvoice["tanggal"])}",
                  style: pw.TextStyle(font: ttfRegular, fontSize: 9),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Column(
                children: [
                  ...items.map(
                    (item) => pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            //bagian kiri
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  item["produk_nama"],
                                  style: pw.TextStyle(
                                    font: ttfRegular,
                                    fontSize: 11,
                                  ),
                                ),
                                pw.Row(
                                  children: [
                                    pw.Text(
                                      "${item["jumlah"].toString()}x",
                                      style: pw.TextStyle(
                                        font: ttfRegular,
                                        fontSize: 9,
                                      ),
                                    ),
                                    pw.SizedBox(width: 5),
                                    pw.Text(
                                      ((item["harga_jual"] ?? 0) as num)
                                          .toRupiah(),
                                      style: pw.TextStyle(
                                        font: ttfRegular,
                                        fontSize: 9,
                                      ),
                                    ),
                                    pw.SizedBox(width: 5),
                                    pw.Text(
                                      (item["diskon"] != null &&
                                              (item["diskon"] as num) > 0
                                          ? "-${(item["diskon"] as num).toInt()}%"
                                          : ""),
                                      style: pw.TextStyle(
                                        font: ttfRegular,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            //
                            pw.Text(
                              ((item["total"] ?? 0) as num).toRupiah(),
                              style: pw.TextStyle(
                                font: ttfRegular,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.Divider(),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      infoRow(
                        "Subtotal",
                        subTotal.toRupiah(),
                        fontSize: 10,
                        fontRegular: ttfRegular,
                      ),
                      infoRow(
                        "Pajak",
                        "${formatPajak(pajak.toDouble())}%",
                        fontSize: 10,
                        fontRegular: ttfRegular,
                      ),
                      infoRow(
                        "Total",
                        total.toRupiah(),
                        fontSize: 10,
                        bold: true,
                        fontRegular: ttfRegular,
                      ),

                      pw.Text(
                        "Metode Bayar : $metodeBayar",
                        style: pw.TextStyle(fontSize: 10, font: ttfRegular),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 15),
                  pw.Center(
                    child: pw.Text(
                      "Terima kasih sudah berbelanja",
                      style: pw.TextStyle(
                        font: ttfRegular,
                        fontSize: 10,
                        fontStyle: pw.FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
  return pdf.save();
}

pw.Widget infoRow(
  String label,
  String value, {
  double? fontSize,
  bool bold = false,
  required pw.Font fontRegular,
}) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(
        label,
        style: pw.TextStyle(
          font: fontRegular,
          fontSize: fontSize,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
      pw.Text(
        value,
        style: pw.TextStyle(
          font: fontRegular,
          fontSize: fontSize,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    ],
  );
}
