import 'package:get/get.dart';
import 'package:kasirnyong/controller/produk_control.dart';
import 'package:kasirnyong/database/database.dart';

class KategoriControl extends GetxController {
  //// Observable list untuk menyimpan data kategori
  var kategoriList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadKategori();
  }

  //load data
  Future<void> loadKategori() async {
    kategoriList.value = await DatabaseKasir.getKategori();
  }

  //post
  void tambahKategori(String nama) async {
    await DatabaseKasir.postKategori(nama);
    loadKategori();
  }

  //delete
  void hapusKategori(String nama) async {
    await DatabaseKasir.deleteKategori(nama);
    loadKategori();

    final produkLoad = Get.find<ProdukControl>();
    produkLoad.loadProduk();
  }
}
