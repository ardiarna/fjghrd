import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class UserRepository {

  Future<Hasil> find() async {
    return await AFdatabase.send(url: "user");
  }

  Future<Hasil> create(Map<String, String>? body) async {
    return await AFdatabase.send(
      url: "user",
      methodeRequest: MethodeRequest.post,
      body: body,
    );
  }

  Future<Hasil> update(Map<String, String>? body) async {
    return await AFdatabase.send(
      url: "user",
      methodeRequest: MethodeRequest.put,
      body: body,
    );
  }

  Future<Hasil> photo(String filePath) async {
    return await AFdatabase.send(
      url: 'user/photo',
      methodeRequest: MethodeRequest.multipartRequest,
      filePaths: { 'foto' : filePath},
    );
  }

  Future<Hasil> changePassword({
    String oldPassword = '',
    String newPassword = '',
    String confirmPassword = '',
  }) async {
    return await AFdatabase.send(
      url: 'user/editpwd',
      methodeRequest: MethodeRequest.put,
      body: {
        'old_password': oldPassword,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      },
    );
  }

  Future<Hasil> seTokenFCM(String token) async {
    return await AFdatabase.send(
      url: 'user/tokenpush',
      methodeRequest: MethodeRequest.put,
      body: { 'token_push': token },
    );
  }

  Future<Hasil> logout() async {
    return await AFdatabase.send(url: "logout");
  }

}
