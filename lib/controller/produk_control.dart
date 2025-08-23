import 'package:food_app/database/database.dart';
import 'package:get/get.dart';

class ProdukControl extends GetxController {
  var produkList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProduk();
  }

  //load data
  void loadProduk() async {
    produkList.value = await DatabaseKasir.getProduk();
  }

  void hapusProduk(int id) async {
    await DatabaseKasir.deleteProduk(id);
    loadProduk();
  }
}
