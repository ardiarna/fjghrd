import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/user.dart';
import 'package:fjghrd/repositories/user_repository.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AkunControl extends GetxController {
  final AuthControl authControl = Get.find();
  final UserRepository _repo = UserRepository();

  var isTampilPassword = false;
  var isTampilPassConfirm = false;
  var isTampilPassOld = false;

  late TextEditingController txtEmail, txtPassword, txtPassConfirm, txtPassOld, txtNama;
  
  void akunForm() {
    txtNama.text = authControl.user.nama;
    Get.toNamed(Rute.akunForm);
  }

  void passwordForm() {
    txtPassword.text = '';
    txtPassConfirm.text = '';
    txtPassOld.text = '';
    isTampilPassword = false;
    isTampilPassConfirm = false;
    isTampilPassOld = false;
    Get.toNamed(Rute.passwordForm);
  }

  Future<void> akunUpdate() async {
    try {
      if (txtNama.text.isEmpty) {
        throw 'Nama lengkap harus diisi';
      }
      var user = User(
        email: authControl.user.email,
        nama: txtNama.text,
      );
      AFwidget.loading();
      var hasil = await _repo.update(user.toMap(''));
      Get.back();
      if(hasil.success) {
        await authControl.loadUser();
        update();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> photoUpdate(String path) async {
    AFwidget.loading();
    var a = await _repo.photo(path);
    Get.back();
    if(a.success) {
      await authControl.loadUser();
      update();
    }
    AFwidget.snackbar(a.message);
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
