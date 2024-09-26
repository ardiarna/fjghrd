import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/repositories/user_repository.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/beranda_view.dart';
import 'package:fjghrd/views/karyawan_view.dart';
import 'package:fjghrd/views/payroll_view.dart';
import 'package:fjghrd/views/report_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeControl extends GetxController {
  AuthControl authControl = Get.find();
  final UserRepository _userRepository = UserRepository();

  int tabId = 0;
  Widget kontener = Container();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var isTampilPassword = false;
  var isTampilPassConfirm = false;
  var isTampilPassOld = false;

  late TextEditingController txtEmail, txtPassword, txtPassConfirm, txtPassOld;

  void pindahTab(int idx) {
    if(idx == 0) {
      tabId = idx;
      kontener = BerandaView();
    } else if(idx == 1) {
      tabId = idx;
      kontener = KaryawanView();
    } else if(idx == 2) {
      tabId = idx;
      kontener = PayrollView();
    } else if(idx == 3) {
      tabId = idx;
      kontener = ReportView();
    } else if(idx == 4) {
      if(scaffoldKey.currentState!.isEndDrawerOpen) {
        scaffoldKey.currentState!.closeEndDrawer();
      } else {
        scaffoldKey.currentState!.openEndDrawer();
      }
    }
    update();
  }

  void resetEmailForm() {
    txtEmail.text = authControl.user.email;
  }

  void resetPasswordForm() {
    txtPassword.text = '';
    txtPassConfirm.text = '';
    txtPassOld.text = '';
    isTampilPassword = false;
    isTampilPassConfirm = false;
    isTampilPassOld = false;
  }

  Future<void> changeEmail() async {
    try {
      if(txtEmail.text.isEmpty) {
        throw 'Email harus diisi';
      }
      AFwidget.loading();
      var hasil = await _userRepository.update({ 'email': txtEmail.text });
      Get.back();
      if(hasil.success) {
        await authControl.updateEmail(txtEmail.text);
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    }  catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> changePassword() async {
    try {
      if(txtPassOld.text.isEmpty) {
        throw 'Password lama harus diisi';
      }
      if(txtPassword.text.isEmpty) {
        throw 'Password baru harus diisi';
      }
      if(txtPassConfirm.text.isEmpty) {
        throw 'Konfirmasi password baru harus diisi';
      }
      AFwidget.loading();
      var hasil = await _userRepository.changePassword(
        oldPassword: txtPassOld.text,
        newPassword: txtPassword.text,
        confirmPassword: txtPassConfirm.text,
      );
      Get.back();
      if(hasil.success) {
        await authControl.updatePassword(txtPassword.text);
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    }  catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  @override
  void onInit() {
    txtEmail = TextEditingController();
    txtPassword = TextEditingController();
    txtPassOld = TextEditingController();
    txtPassConfirm = TextEditingController();

    super.onInit();
  }

  @override
  void onClose() {
    txtEmail.dispose();
    txtPassword.dispose();
    txtPassOld.dispose();
    txtPassConfirm.dispose();
    super.onClose();
  }

}