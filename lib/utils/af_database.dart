import 'dart:convert';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/utils/hasil.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

enum MethodeRequest {
  get,
  post,
  put,
  delete,
  multipartRequest,
}

abstract class AFdatabase {

  static final AuthControl _authControl = Get.find();
  static const String _api = "http://localhost/apifjghrd/public/";

  static Future<Hasil> send({
    required String url,
    MethodeRequest methodeRequest = MethodeRequest.get,
    Map<String, dynamic>? body,
    Map<String, String>? filePaths,
    Map<String, List<int>>? fileBytes,
    bool defaultAPI = true,
    bool contentIsJson = false,
  }) async {
    String rute = defaultAPI ? "$_api$url" : url;
    Uri uriRute = Uri.parse(rute);
    Map<String, String> headers = {
      "Authorization" : "Bearer ${_authControl.user.tokenJWT}",
    };
    if(contentIsJson) {
      headers['Content-Type'] = 'application/json';
    }
    http.Response resp;
    var hasil = Hasil();
    try {
      switch(methodeRequest) {
        case MethodeRequest.post:
          if(contentIsJson) {
            resp = await http.post(uriRute, headers: headers, body: jsonEncode(body));
          } else {
            resp = await http.post(uriRute, headers: headers, body: body);
          }
          break;
        case MethodeRequest.put:
          if(contentIsJson) {
            resp = await http.put(uriRute, headers: headers, body: jsonEncode(body));
          } else {
            resp = await http.put(uriRute, headers: headers, body: body);
          }
          break;
        case MethodeRequest.delete:
          if(contentIsJson) {
            resp = await http.delete(uriRute, headers: headers, body: jsonEncode(body));
          } else {
            resp = await http.delete(uriRute, headers: headers, body: body);
          }
          break;
        case MethodeRequest.multipartRequest:
          var req = http.MultipartRequest('POST', uriRute);
          req.headers.addAll(headers);
          if (body != null) {
            body.forEach((key, value) {
              req.fields[key] = value;
            });
          }
          if (filePaths != null) {
            filePaths.forEach((key, value) async {
              var pic = await http.MultipartFile.fromPath(key, value);
              req.files.add(pic);
            });
          }
          if (fileBytes != null) {
            fileBytes.forEach((key, value) {
              var pic = http.MultipartFile.fromBytes(key, value);
              req.files.add(pic);
            });
          }
          var streamResp = await req.send();
          resp = await http.Response.fromStream(streamResp);
          break;
        default:
          if (body != null) {
            rute += '?';
            body.forEach((key, value) {
              rute += '&$key=$value';
            });
          }
          resp = await http.get(Uri.parse(rute), headers: headers);
      }
      // print({
      //   "rute": rute,
      //   "methode": methodeRequest,
      //   "headers": headers,
      //   "body": body,
      //   "respon code": resp.statusCode,
      //   "respon isi": jsonDecode(resp.body),
      // });
      int statusCode = resp.statusCode;
      if(statusCode >= 200 && statusCode <= 206) {
        var a = jsonDecode(resp.body);
        if(a["status"] == "success") {
          hasil.success = true;
          hasil.message = a["message"];
          if(a["data"] is Map) {
            hasil.data = a["data"];
          }
          if(a["data"] is List) {
            hasil.daftar = a["data"];
          }
        } else {
          hasil.message = a["message"];
        }
      } else if(resp.statusCode == 401) {
        var relogin = await _authControl.relogin();
        if(relogin) {
          var again = await send(
            url: url,
            methodeRequest: methodeRequest,
            body: body,
            filePaths: filePaths,
            fileBytes: fileBytes,
            defaultAPI: defaultAPI,
          );
          return again;
        } else {
          await _authControl.sessionEnd(showDialog: true);
          hasil.message = 'Session anda telah berakhir, anda akan ter-logout. Silakan login kembali.';
        }
      } else {
        var a = jsonDecode(resp.body);
        if(a["message"] != null) {
          hasil.message = a["message"];
        } else {
          hasil.message = "Mohon maaf, sistem sedang maintenance ${resp.statusCode}";
        }
      }
    } catch (err) {
      hasil.message = "Mohon maaf, sistem sedang maintenance [err $err]";
    }
    return hasil;
  }

  static Future<Hasil> download({
    required String url,
    bool defaultAPI = true,
  }) async {
    String rute = defaultAPI ? "$_api$url" : url;
    final task = await DownloadTask(
      url: rute,
      filename: DownloadTask.suggestedFilename,
      headers: {
        "Authorization" : "Bearer ${_authControl.user.tokenJWT}",
      },
    ).withSuggestedFilename(unique: true);
    final result = await FileDownloader().download(task);
    if(result.status == TaskStatus.complete) {
      final a = await FileDownloader().moveToSharedStorage(task, SharedStorage.downloads);
      if( a!= null) {
        final Uri uri = Uri.file(a);
        if(File(uri.toFilePath()).existsSync()){
          await launchUrl(uri);
        }
      }
      return Hasil(
        success: true,
        message: result.task.filename,
      );
    } else {
      return Hasil(
        message: '${result.status}',
      );
    }
  }

}