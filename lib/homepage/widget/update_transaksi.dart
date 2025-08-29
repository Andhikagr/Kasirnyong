import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:kasirnyong/database/database.dart';

Rx totalOrderHari = 0.obs;

Future<void> updateTransaksi() async {
  final orders = await DatabaseKasir.getOrders();
  final today = DateTime.now();

  int totalOrder = 0;

  for (var order in orders) {
    final waktuOrder = DateTime.parse(order["tanggal"]);
    if (waktuOrder.year == today.year &&
        waktuOrder.month == today.month &&
        waktuOrder.day == today.day) {
      //jumlah order
      totalOrder += 1;
    }
  }

  totalOrderHari.value = totalOrder;
}
