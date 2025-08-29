import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

// kirim file wa
import 'package:url_launcher/url_launcher_string.dart';

Future<void> sendInvoiceWa(String phoneNumber, String pdfLink) async {
  final text = Uri.encodeComponent(
    "Silahkan download invoice anda di: $pdfLink",
  );

  // URL WhatsApp (app atau web)
  final whatsappUrl = "https://wa.me/$phoneNumber?text=$text";

  try {
    await launchUrlString(whatsappUrl, mode: LaunchMode.externalApplication);
    print("DEBUG: WhatsApp link berhasil dibuka");
  } catch (e) {
    print("DEBUG: Gagal membuka WhatsApp link -> $e");
  }
}

// google drive
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _inner = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    print("DEBUG: Mengirim request ke ${request.url}");
    request.headers.addAll(_headers);
    return _inner.send(request);
  }
}

// upload file
Future<String> uploadPdf(Uint8List pdfData, String fileName) async {
  try {
    print("DEBUG: Memulai Google Sign-In");
    final googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveFileScope]);
    final account = await googleSignIn.signIn();
    if (account == null) throw Exception("Login Gagal");
    print("DEBUG: Login berhasil, account = ${account.email}");

    final authHeaders = await account.authHeaders;
    final client = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(client);

    final driveFile = drive.File()..name = fileName;
    print("DEBUG: Mengupload file $fileName ke Google Drive");
    final response = await driveApi.files.create(
      driveFile,
      uploadMedia: drive.Media(Stream.fromIterable([pdfData]), pdfData.length),
    );
    print("DEBUG: Upload selesai, file id = ${response.id}");

    // set permission publik
    await driveApi.permissions.create(
      drive.Permission()
        ..type = "anyone"
        ..role = "reader",
      response.id!,
    );
    print("DEBUG: Permission publik sudah dibuat");

    final downloadLink =
        "https://drive.google.com/uc?id=${response.id}&export=download";
    print("DEBUG: Link download = $downloadLink");
    return downloadLink;
  } catch (e) {
    print("DEBUG: Error uploadPdf -> $e");
    rethrow;
  }
}
