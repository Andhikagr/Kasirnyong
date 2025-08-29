//export to csv
import 'dart:io';

import 'package:kasirnyong/database/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> exportCSV() async {
  //ambil semua order
  final ordersAll = await DatabaseKasir.getOrders();

  //header
  List<List<String>> csvData = [
    [
      "ID Transaksi",
      "Tanggal",
      "Metode Bayar",
      "Produk",
      "Kategori",
      "Jumlah",
      "Harga Jual",
      "Diskon",
      "Total Produk",
    ],
  ];

  for (var orderHis in ordersAll) {
    final details = orderHis["details"] as List<dynamic>;
    for (var item in details) {
      csvData.add([
        orderHis['id'].toString(),
        orderHis['tanggal'],
        orderHis['metode_bayar'],
        item['produk_nama'],
        item["kategori"].toString(),
        item['jumlah'].toString(),
        item['harga_jual'].toString(),
        (item['diskon'] ?? 0).toString(),
        item['total'].toString(),
      ]);
    }
  }
  //convert String CSV
  String csv = csvData.map((e) => e.join(",")).join("\n");

  //simpan file sementara
  final directory = await getTemporaryDirectory();
  final path = "${directory.path}/orders.temp.csv";
  final file = File(path);
  await file.writeAsString(csv);

  //share
  await SharePlus.instance.share(ShareParams(files: [XFile(path)]));
}
