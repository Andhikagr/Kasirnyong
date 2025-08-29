import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

//kirim file wa
Future<void> sendInvoiceWa(String phoneNumber, String pdfLink) async {
  final text = Uri.encodeComponent(
    "Silahkan download invoice anda di: $pdfLink",
  );
  final url = Uri.parse("https://wa.me/$phoneNumber?text=$text");

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw "Tidak bisa membuka WhatsApp";
  }
}

//google drive
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _inner = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }
}

//upload file
Future<String> uploadPdf(Uint8List pdfData, String fileName) async {
  //signin
  final googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveFileScope]);
  final account = await googleSignIn.signIn();
  if (account == null) throw Exception("Login Gagal");

  final authHeaders = await account.authHeaders;
  final client = GoogleAuthClient(authHeaders);
  final driveApi = drive.DriveApi(client);

  final driveFile = drive.File()..name = fileName;
  final response = await driveApi.files.create(
    driveFile,
    uploadMedia: drive.Media(Stream.fromIterable([pdfData]), pdfData.length),
  );

  //link publik
  await driveApi.permissions.create(
    drive.Permission()
      ..type = "anyone"
      ..role = "reader",
    response.id!,
  );
  return "https://drive.google.com/uc?id=$response&export=download";
}
