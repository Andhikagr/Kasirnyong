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
      join(path, "app.db"), // => lokasi database
      onCreate: (db, version) async {
        //buat tabel kategori
        await db.execute('''
CREATE TABLE KATEGORI(
id INTEGER  PRIMARY KEY AUTOINCREMENT, 
nama TEXT NOT NULL
)
''');
      },
      version: 1,
    );
  }

  //memastikan database sudah siap
  static Future<Database> getDB() async {
    _db ??= await _initDB();
    return _db!;
  }

  //post
  static Future<int> postKategori(String nama) async {
    final db = await getDB();
    //masukkan data ke tabel kategori
    return await db.insert("Kategori", {"Nama": nama});
  }

  //get
  static Future<List<Map<String, dynamic>>> getKategori() async {
    final db = await getDB();
    return await db.query("Kategori", orderBy: "id ASC"); // => urutan
  }

  static Future<int> deleteKategori(int id) async {
    final db = await getDB();
    return await db.delete("Kategori", where: "id = ?", whereArgs: [id]);
  }
}
