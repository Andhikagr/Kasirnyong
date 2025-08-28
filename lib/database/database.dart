import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseKasir {
  //database global
  static Database? _db;

  //inisialisasi database
  static Future<Database> _initDB() async {
    //ambil path default database device
    final path = await getDatabasesPath();

    //buat database
    return openDatabase(
      join(path, "app.db"),
      version: 1,
      //aktifkan foreign key
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
      // => lokasi database
      onCreate: (db, version) async {
        //tabel kategori
        await db.execute('''
        CREATE TABLE KATEGORI(
        nama TEXT PRIMARY KEY
        )
        ''');
        //tabel produk
        await db.execute('''
        CREATE TABLE PRODUK(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        kategori_nama TEXT NOT NULL,
        harga_dasar REAL NOT NULL,
        harga_jual REAL NOT NULL,
        diskon REAL,
        stok INTEGER DEFAULT 0,
        gambar TEXT,
        FOREIGN KEY (kategori_nama) REFERENCES KATEGORI(nama) ON DELETE CASCADE
        )
        ''');
        //tabel order
        await db.execute('''
        CREATE TABLE ORDER_HEADER(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tanggal TEXT NOT NULL,
        sub_total_order REAL NOT NULL,
        pajak_persen REAL,
        total_order REAL NOT NULL,
        metode_bayar TEXT NOT NULL
        )
        ''');
        //tabel order detail
        await db.execute('''
        CREATE TABLE ORDER_DETAIL(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        produk_id INTEGER NOT NULL,
        jumlah INTEGER NOT NULL,
        harga_jual REAL NOT NULL,
        diskon REAL,
        harga_akhir REAL NOT NULL,
        total REAL NOT NULL,
        FOREIGN KEY (order_id) REFERENCES ORDER_HEADER(id) ON DELETE CASCADE,
        FOREIGN KEY (produk_id) REFERENCES PRODUK(id) ON DELETE CASCADE
        )
        ''');
        //tabel pajak
        await db.execute('''
        CREATE TABLE PAJAK(
        persen REAL
        )
        ''');
        //identitas
        await db.execute('''
        CREATE TABLE IDENTITAS(
        nama TEXT NOT NULL,
        alamat TEXT NOT NULL,
        no_telp TEXT NOT NULL
        )
        ''');
      },
    );
  }

  //memastikan database sudah siap
  static Future<Database> getDB() async {
    _db ??= await _initDB();
    return _db!;
  }

  //IDENTITAS
  //set identitas
  static Future<void> setIdentitas(
    String nama,
    String alamat,
    String noTelp,
  ) async {
    final db = await getDB();
    await db.execute(
      "INSERT OR REPLACE INTO IDENTITAS(rowid, nama, alamat, no_telp) VALUES (1, ?, ?, ?)",
      [nama, alamat, noTelp],
    );
  }

  //get
  static Future<Map<String, dynamic>> getIdentitas() async {
    final db = await getDB();
    final result = await db.query("IDENTITAS", limit: 1);
    if (result.isNotEmpty) {
      return result.first;
    }

    return {"nama": "", "alamat": "", "no_telp": ""};
  }

  //CRUD KATEGORI
  //post
  static Future<int> postKategori(String nama) async {
    final db = await getDB();
    //masukkan data ke tabel kategori
    return await db.insert("KATEGORI", {"nama": nama});
  }

  //get
  static Future<List<Map<String, dynamic>>> getKategori() async {
    final db = await getDB();
    return await db.query("KATEGORI", orderBy: "nama ASC"); // => urutan
  }

  //delete
  static Future<int> deleteKategori(String nama) async {
    final db = await getDB();
    return await db.delete("KATEGORI", where: "nama = ?", whereArgs: [nama]);
  }

  //CRUD PAJAK
  //set
  static Future<void> setPajak(double persen) async {
    final db = await getDB();
    await db.execute(
      "INSERT OR REPLACE INTO PAJAK(rowid, persen) VALUES (1, ?)",
      [persen],
    );
  }

  //get
  static Future<num> getPajak() async {
    final db = await getDB();
    final result = await db.query("PAJAK", limit: 1);
    if (result.isNotEmpty) {
      return result.first["persen"] as num;
    }
    return 0; // => urutan
  }

  //CRUD PRODUK
  static Future<int> postProduk({
    required String nama,
    required String kategoriNama,
    required double hargaDasar,
    required double hargaJual,
    int? stok,
    double? diskon,
    String? gambar,
  }) async {
    final db = await getDB();
    return await db.insert("PRODUK", {
      "nama": nama,
      "kategori_nama": kategoriNama,
      "harga_dasar": hargaDasar,
      "harga_jual": hargaJual,
      "stok": stok,
      "diskon": diskon,
      "gambar": gambar,
    });
  }

  //get
  static Future<List<Map<String, dynamic>>> getProduk() async {
    final db = await getDB();
    return await db.query("PRODUK", orderBy: "id ASC"); // => urutan
  }

  //delete
  static Future<int> deleteProduk(int id) async {
    final db = await getDB();
    return await db.delete("PRODUK", where: "id = ?", whereArgs: [id]);
  }

  //Update Produk
  static Future<int> updateProduk({
    required int id,
    required String nama,
    required String kategoriNama,
    required double hargaDasar,
    required double hargaJual,
    int? stok,
    double? diskon,
    String? gambar,
  }) async {
    final db = await getDB();
    return await db.update(
      "PRODUK",
      {
        "nama": nama,
        "kategori_nama": kategoriNama,
        "harga_dasar": hargaDasar,
        "harga_jual": hargaJual,
        "stok": stok,
        "diskon": diskon,
        "gambar": gambar,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  //get produk dengan kategori
  static Future<List<Map<String, dynamic>>> getProdukKategori() async {
    final db = await getDB();
    return await db.rawQuery('''
    SELECT p.id, p.nama, p.harga_dasar, p.harga_jual, p.stok, p.diskon, p.gambar, k.nama as nama_kategori
    FROM PRODUK p
    JOIN KATEGORI k ON p.kategori_nama = k.nama
    ORDER BY p.id ASC
      ''');
  }

  //save order
  static Future<void> simpanOrder(
    RxList<Map<String, dynamic>> pesananList,
    double pajakPersen,
    String metodeBayar,
  ) async {
    final db = await getDB();
    await db.transaction((txn) async {
      double subTotalOrder = 0;

      //hitung total order
      for (var item in pesananList) {
        final jumlah = (item["jumlah"] as RxInt).value;
        final hargaAkhir = (item["harga_akhir"] as num).toDouble();
        subTotalOrder += (hargaAkhir * jumlah);
      }
      //
      final pajak = (subTotalOrder * pajakPersen) / 100;
      final totalOrder = subTotalOrder + pajak;

      //simpan ke header
      final orderId = await txn.insert("ORDER_HEADER", {
        "tanggal": DateTime.now().toIso8601String(),
        "sub_total_order": subTotalOrder,
        "total_order": totalOrder,
        "pajak_persen": pajakPersen,
        "metode_bayar": metodeBayar,
      });

      //simpan detail produk
      for (var item in pesananList) {
        final result = await txn.query(
          "PRODUK",
          columns: ["id"],
          where: "nama = ?",
          whereArgs: [item["nama"]],
          limit: 1,
        );
        if (result.isEmpty) continue;
        final produkId = result.first["id"] as int;
        final hargaJual = (item["harga_jual"] as num).toDouble();
        final diskon = (item["diskon"] as num?);
        final hargaAkhir = (item["harga_akhir"] as num).toDouble();
        final jumlah = (item["jumlah"] as RxInt).value;
        final total = (hargaAkhir * jumlah);

        //insert detail
        await txn.insert("ORDER_DETAIL", {
          "order_id": orderId,
          "produk_id": produkId,
          "jumlah": jumlah,
          "harga_jual": hargaJual,
          "diskon": diskon,
          "harga_akhir": hargaAkhir,
          "total": total,
        });
      }
    });
  }

  //get order
  static Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await getDB();

    //limit -> jumlah data ditampilkan per page
    final orders = await db.query("ORDER_HEADER", orderBy: "id DESC");
    List<Map<String, dynamic>> result = [];

    for (var order in orders) {
      final details = await db.rawQuery(
        '''
        SELECT d.jumlah, d.harga_jual, d.diskon, d.harga_akhir, d.total, p.nama as produk_nama FROM ORDER_DETAIL d JOIN PRODUK p ON d.produk_id = p.id
        WHERE d.order_id = ?
        ''',
        [order["id"]],
      );
      result.add({
        "id": order["id"],
        "tanggal": order["tanggal"],
        "sub_total_order": order["sub_total_order"],
        "total_order": order["total_order"],
        "pajak_persen": order["pajak_persen"],
        "metode_bayar": order["metode_bayar"],
        "details": details,
      });
    }
    return result;
  }
}
