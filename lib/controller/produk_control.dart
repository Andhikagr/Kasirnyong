import 'package:get/get.dart';
import 'package:kasirnyong/database/database.dart';

class ProdukControl extends GetxController {
  var produkList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProduk();
  }

  //load data
  Future<void> loadProduk() async {
    produkList.value = await DatabaseKasir.getProduk();
  }

  void hapusProduk(int id) async {
    await DatabaseKasir.deleteProduk(id);
    loadProduk();
  }
}
