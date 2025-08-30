import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:kasirnyong/database/database.dart';
import 'package:kasirnyong/transaksi/widget/send_link.dart';

Future<String> backupData() async {
  final db = await DatabaseKasir.getDB();

  //ambil data
  final kategori = await db.query("KATEGORI");
  final orderHeader = await db.query("ORDER_HEADER");
  final orderDetail = await db.query("ORDER_DETAIL");
  final pajak = await db.query("PAJAK");
  final produk = await db.query("PRODUK");
  final identitas = await db.query("IDENTITAS");

  //map json
  final Map<String, dynamic> backupData = {
    "KATEGORI": kategori,
    "PRODUK": produk,
    "ORDER_HEADER": orderHeader,
    "ORDER_DETAIL": orderDetail,
    "PAJAK": pajak,
    "IDENTITAS": identitas,
  };
  return jsonEncode(backupData);
}

//upload google drive
Future<String> backupGdrive() async {
  final jsonString = await backupData();
  final fileName = "backup_kasirnyong.json";

  //google sign-in
  final googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveFileScope]);
  final account = await googleSignIn.signIn();
  if (account == null) throw Exception("Login Gagal");

  final authHeaders = await account.authHeaders;
  final client = GoogleAuthClient(authHeaders);
  final driveApi = drive.DriveApi(client);

  //hapus file lama
  final exixtingFile = await driveApi.files.list(
    q: "name='$fileName' and trashed=false",
  );
  if (exixtingFile.files!.isNotEmpty) {
    for (var timpa in exixtingFile.files!) {
      await driveApi.files.delete(timpa.id!);
    }
  }

  //upload
  final driveFile = drive.File()..name = fileName;
  final response = await driveApi.files.create(
    driveFile,
    uploadMedia: drive.Media(
      Stream.fromIterable([utf8.encode(jsonString)]),
      utf8.encode(jsonString).length,
    ),
  );

  //set permission
  await driveApi.permissions.create(
    drive.Permission()
      ..type = "anyone"
      ..role = "reader",
    response.id!,
  );
  return "https://drive.google.com/uc?id=${response.id}&export=download";
}

//restore google drive
Future<void> restoreGdrive() async {
  const fileName = "backup_kasirnyong.json";

  //google sign-in
  final googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveFileScope]);
  final account = await googleSignIn.signIn();
  if (account == null) throw Exception("Login Gagal");

  final authHeaders = await account.authHeaders;
  final client = GoogleAuthClient(authHeaders);
  final driveApi = drive.DriveApi(client);

  //cari file
  final fileList = await driveApi.files.list(
    q: "name='$fileName' and trashed=false",
  );

  if (fileList.files == null || fileList.files!.isEmpty) {
    throw Exception("File backup tidak ditemukan");
  }

  final fileId = fileList.files!.first.id!;
  // print("=== [RESTORE] File ID: $fileId ===");

  final media =
      await driveApi.files.get(
            fileId,
            downloadOptions: drive.DownloadOptions.fullMedia,
          )
          as drive.Media;
  // print("=== [RESTORE] Mulai download file... ===");

  final dataToko = <int>[];
  await for (final dataFile in media.stream) {
    dataToko.addAll(dataFile);
  }
  // print(
  //   "=== [RESTORE] File berhasil diunduh, size: ${dataToko.length} bytes ===",
  // );

  final jsonString = utf8.decode(dataToko);
  // print(
  //   "=== [RESTORE] JSON decode sukses, panjang string: ${jsonString.length} ===",
  // );

  final Map<String, dynamic> data = jsonDecode(jsonString);
  // print(
  //   "=== [RESTORE] JSON parsing selesai. Key yang ada: ${data.keys.toList()} ===",
  // );

  //simpan ke database lokal
  final db = await DatabaseKasir.getDB();
  // print("=== [RESTORE] Koneksi DB berhasil ===");

  await db.transaction((txn) async {
    // print("=== [RESTORE] Mulai hapus data lama ===");
    await txn.delete("KATEGORI");
    await txn.delete("PRODUK");
    await txn.delete("ORDER_HEADER");
    await txn.delete("ORDER_DETAIL");
    await txn.delete("PAJAK");
    await txn.delete("IDENTITAS");

    for (var row in data["KATEGORI"]) {
      await txn.insert("KATEGORI", Map<String, dynamic>.from(row));
    }
    for (var row in data["PRODUK"]) {
      await txn.insert("PRODUK", Map<String, dynamic>.from(row));
    }
    for (var row in data["ORDER_HEADER"]) {
      await txn.insert("ORDER_HEADER", Map<String, dynamic>.from(row));
    }
    for (var row in data["ORDER_DETAIL"]) {
      await txn.insert("ORDER_DETAIL", Map<String, dynamic>.from(row));
    }
    for (var row in data["PAJAK"]) {
      await txn.insert("PAJAK", Map<String, dynamic>.from(row));
    }
    for (var row in data["IDENTITAS"]) {
      await txn.insert("IDENTITAS", Map<String, dynamic>.from(row));
    }
  });
}
