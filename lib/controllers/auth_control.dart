import 'package:fjghrd/models/user.dart';
import 'package:fjghrd/repositories/login_repository.dart';
import 'package:fjghrd/repositories/user_repository.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthControl extends GetxController {
  
  User user = User();
  final UserRepository _userRepository = UserRepository();

  Future<void> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    user.tokenJWT = pref.getString('tokenjwt') ?? '';
    user.email = pref.getString('email') ?? '';
    user.password = pref.getString('password') ?? '';
  }

  Future<void> loadUser() async {
    if(user.email == '') {
      await getSession();
    }
    if(user.email != '') {
      var hasil = await _userRepository.find();
      if(hasil.success) {
        String j = user.tokenJWT;
        String p = user.password;
        user = User.fromMap(hasil.data);
        user.tokenJWT = j;
        user.password = p;
      } else {
        await logout();
      }
      update();
    }
  }

  Future<bool> logout() async {
    _userRepository.logout();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var a = await pref.clear();
    user = User();
    return a;
  }

  Future<void> sessionEnd({bool showDialog = false}) async {
    if(user.email != '') {
      await logout();
      Get.offAllNamed(Rute.login);
      if(showDialog) {
        AFwidget.dialog(
          const Text('Session anda telah berakhir, anda akan ter-logout. Silakan login kembali.'),
        );
      }
    }
  }

  Future<bool> relogin() async {
    final LoginRepository loginRepo = LoginRepository();
    var hasil = await loginRepo.login(email: user.email, password: user.password);
    if(hasil.success) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      user.tokenJWT = hasil.data['access_token'];
      await pref.setString('tokenjwt', hasil.data['access_token']);
      update();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> seTokenFCM(String token) async {
    var hasil = await _userRepository.seTokenFCM(token);
    return hasil.success;
  }

}
