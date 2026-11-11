import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class LoginRepository {

  Future<Hasil> register(Map<String, String>? body) async {
    return await AFdatabase.send(
      url: "register",
      methodeRequest: MethodeRequest.post,
      body: body,
    );
  }

  Future<Hasil> login({required String email, required String password}) async {
    return await AFdatabase.send(
      url: "login",
      methodeRequest: MethodeRequest.post,
      body: { "email": email, "password": password },
    );
  }

  Future<Hasil> logout() async {
    return await AFdatabase.send(url: "logout");
  }

}
