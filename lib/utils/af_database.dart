import 'dart:convert';
import 'dart:io';

import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/utils/hasil.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide MultipartFile, FormData, Response;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

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

  // Create a singleton Dio instance with interceptors
  static final Dio _dio = _createDio();

  static Dio _createDio() {
    Dio dio = Dio(BaseOptions(
      baseUrl: _api,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_authControl.user.tokenJWT != "") {
          options.headers['Authorization'] = 'Bearer ${_authControl.user.tokenJWT}';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Attempt token refresh or relogin
          bool relogin = await _authControl.relogin();
          if (relogin) {
            try {
              // Retry the exact same request with the new token
              var retryResponse = await dio.request(
                e.requestOptions.path,
                data: e.requestOptions.data,
                queryParameters: e.requestOptions.queryParameters,
                options: Options(
                  method: e.requestOptions.method,
                  headers: e.requestOptions.headers..['Authorization'] = 'Bearer ${_authControl.user.tokenJWT}',
                ),
              );
              return handler.resolve(retryResponse);
            } catch (retryError) {
              debugPrint('--- RETRY ERROR: $retryError');
              return handler.next(e);
            }
          } else {
            await _authControl.sessionEnd(showDialog: true);
            e = e.copyWith(message: 'Session anda telah berakhir, anda akan ter-logout. Silakan login kembali.');
          }
        }
        return handler.next(e);
      },
    ));

    return dio;
  }

  static Future<Hasil> send({
    required String url,
    MethodeRequest methodeRequest = MethodeRequest.get,
    Map<String, dynamic>? body,
    Map<String, String>? filePaths,
    Map<String, List<int>>? fileBytes,
    bool defaultAPI = true,
    bool contentIsJson = false,
  }) async {
    String rute = defaultAPI ? url : url; // Dio baseUrl handles the prefix if it's a relative URL
    if (!defaultAPI && !rute.startsWith('http')) {
        // Just in case defaultAPI is false but it's not a full URL
        rute = _api + rute;
    }
    var hasil = Hasil();
    try {
      Options options = Options();
      if (contentIsJson) {
        options.headers = {'Content-Type': 'application/json'};
      } else {
        options.headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      }

      dynamic requestData = body;
      
      if (methodeRequest == MethodeRequest.multipartRequest) {
        Map<String, dynamic> formDataMap = body != null ? Map.from(body) : {};
        
        if (filePaths != null) {
          for (var entry in filePaths.entries) {
            formDataMap[entry.key] = await MultipartFile.fromFile(entry.value);
          }
        }
        if (fileBytes != null) {
          for (var entry in fileBytes.entries) {
            formDataMap[entry.key] = MultipartFile.fromBytes(entry.value, filename: entry.key);
          }
        }
        requestData = FormData.fromMap(formDataMap);
        methodeRequest = MethodeRequest.post;
      }

      Response response;
      String methodString = methodeRequest.name.toUpperCase();
      
      response = await _dio.request(
        rute,
        data: (methodeRequest == MethodeRequest.get || methodeRequest == MethodeRequest.delete) ? null : requestData,
        queryParameters: (methodeRequest == MethodeRequest.get || methodeRequest == MethodeRequest.delete) ? (body?.map((k, v) => MapEntry(k, v.toString()))) : null,
        options: options.copyWith(method: methodString),
      );

      debugPrint('--- API REQUEST (Dio) ---');
      debugPrint('URL: $rute');
      debugPrint('Method: $methodString');
      if (body != null) debugPrint('Body: $body');
      debugPrint('--- API RESPONSE ---');
      debugPrint('Status: ${response.statusCode}');
      debugPrint('Response: ${response.data}');
      debugPrint('--------------------');

      int statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode <= 206) {
        var a = response.data;
        if (a is String) {
            try { a = jsonDecode(a); } catch(_) {}
        }
        if (a is Map) {
          if (a["status"] == "success" || a["status"] == true) {
            hasil.success = true;
            hasil.message = a["message"] ?? 'Success';
            if (a["data"] is Map) {
              hasil.data = a["data"];
            }
            if (a["data"] is List) {
              hasil.daftar = a["data"];
            }
          } else {
            hasil.message = a["message"] ?? "Terjadi kesalahan";
          }
        }
      } else {
          var a = response.data;
          hasil.message = (a is Map && a["message"] != null) ? a["message"] : "HTTP ${response.statusCode}";
      }

    } on DioException catch (e) {
      debugPrint('--- API ERROR (Dio) ---');
      debugPrint('URL: $url');
      debugPrint('Error: ${e.message}');
      
      if (e.response != null) {
          debugPrint('Response: ${e.response?.data}');
          var a = e.response?.data;
          if (a is String) {
              try { a = jsonDecode(a); } catch(_) {}
          }
          if (a is Map && a["message"] != null) {
              hasil.message = a["message"];
          } else if (e.message != null && e.message!.contains('Session anda telah berakhir')) {
              hasil.message = e.message!;
          } else {
              hasil.message = "Mohon maaf, terjadi kesalahan. HTTP ${e.response?.statusCode}";
          }
      } else {
          hasil.message = e.message ?? "Tidak dapat terhubung ke server";
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
    try {
      String rute = defaultAPI ? url : url;
      if (!defaultAPI && !rute.startsWith('http')) {
          rute = _api + rute;
      }
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        return Hasil(message: 'Tidak bisa akses folder Downloads');
      }
      
      String savePath = '${downloadsDir.path}/file_download.xlsx';
      
      var response = await _dio.get(
          rute, 
          options: Options(
              responseType: ResponseType.bytes,
          )
      );

      debugPrint('--- API DOWNLOAD REQUEST ---');
      debugPrint('URL: $rute');
      debugPrint('Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final disposition = response.headers.value('content-disposition');
        if (disposition != null && disposition.contains('filename=')) {
          String filename = disposition.split('filename=').last.replaceAll('"', '');
          savePath = '${downloadsDir.path}/$filename';
        }
        
        final file = File(savePath);
        if (await file.exists()) {
          await file.delete();
        }
        await file.writeAsBytes(response.data);
        final Uri uri = Uri.file(file.path);
        if (await file.exists()) {
          await launchUrl(uri);
        }
        return Hasil(
          success: true,
          message: file.path,
        );
      } else {
        return Hasil(message: 'HTTP ${response.statusCode}');
      }
    } catch (e) {
      return Hasil(message: e.toString());
    }
  }
}
