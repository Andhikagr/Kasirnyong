import 'package:flutter/services.dart';
import 'package:kasirnyong/transaksi/widget/format_pdf.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareInvoice(Map<String, dynamic> orderInvoice) async {
  Uint8List pdfData = await formatPdf(orderInvoice);

  await SharePlus.instance.share(
    ShareParams(
      files: [
        XFile.fromData(
          pdfData,
          name: "invoice_${orderInvoice["id"]}.pdf",
          mimeType: "application/pdf",
        ),
      ],
      text: "Invoice Transaksi",
    ),
  );
}
