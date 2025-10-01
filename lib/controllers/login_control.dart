import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/user.dart';
import 'package:fjghrd/repositories/login_repository.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginControl extends GetxController {
  final AuthControl authControl = Get.find();
  final LoginRepository _repo = LoginRepository();

  var isTampilPassword = false.obs;
  var isTampilPassConfirm = false.obs;
  var isCanDaftar = false.obs;

  late TextEditingController txtEmail, txtPassword, txtPassConfirm, txtNama;
  
  Future<void> signIn() async {
    try {
      if (txtEmail.text.isEmpty) {
        throw 'Email harus diisi';
      }
      if (txtPassword.text.isEmpty) {
        throw 'Password harus diisi';
      }

      AFwidget.loading();
      var hasil = await _repo.login(email: txtEmail.text, password: txtPassword.text);
      Get.back();
      if(!hasil.success) {
        throw hasil.message;
      }
      SharedPreferences pref = await SharedPreferences.getInstance();
      authControl.user = User.fromMap(hasil.data['user']);
      authControl.user.tokenJWT = hasil.data['access_token'];
      authControl.user.password = txtPassword.text;
      await pref.setString('tokenjwt', hasil.data['access_token']);
      await pref.setString('email', txtEmail.text);
      await pref.setString('password', txtPassword.text);
      Get.offAllNamed(Rute.home);
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> signUp() async {
    try {
      if (txtEmail.text.isEmpty) {
        throw 'Email harus diisi';
      }
      if (txtNama.text.isEmpty) {
        throw 'Nama lengkap harus diisi';
      }
      if (txtPassword.text.isEmpty) {
        throw 'Password harus diisi';
      }
      if (txtPassConfirm.text.isEmpty) {
        throw 'Ulangi password harus diisi';
      }
      var user = User(
        email: txtEmail.text,
        nama: txtNama.text,
        password: txtPassword.text,
      );
      AFwidget.loading();
      var hasil = await _repo.register(user.toMap(txtPassConfirm.text));
      Get.back();
      if(!hasil.success) {
        throw hasil.message;
      }
      await signIn();
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }

  }

  @override
  void onInit() {
    txtEmail = TextEditingController();
    txtPassword = TextEditingController();
    txtPassConfirm = TextEditingController();
    txtNama = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    txtEmail.dispose();
    txtPassword.dispose();
    txtPassConfirm.dispose();
    txtNama.dispose();
    super.onClose();
  }
}
