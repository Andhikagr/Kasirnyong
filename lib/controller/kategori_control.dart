import 'package:food_app/database/database.dart';
import 'package:get/get.dart';

class KategoriControl extends GetxController {
  //// Observable list untuk menyimpan data kategori
  var kategoriList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadKategori();
  }

  //load data
  void loadKategori() async {
    kategoriList.value = await DatabaseKasir.getKategori();
  }

  //post
  void tambahKategori(String nama) async {
    await DatabaseKasir.postKategori(nama);
    loadKategori();
  }

  //delete
  void hapusKategori(int id) async {
    await DatabaseKasir.deleteKategori(id);
    loadKategori();
  }
}
