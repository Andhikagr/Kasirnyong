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
        total REAL NOT NULL
        )
        ''');
        //tabel order detail
        await db.execute('''
        CREATE TABLE ORDER_DETAIL(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        produk_id INTEGER NOT NULL,
        jumlah INTEGER NOT NULL,
        harga_pcs REAL NOT NULL,
        diskon REAL,
        sub_total REAL NOT NULL,
        FOREIGN KEY (order_id) REFERENCES ORDER_HEADER(id) ON DELETE CASCADE,
        FOREIGN KEY (produk_id) REFERENCES PRODUK(id) ON DELETE CASCADE
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
}
