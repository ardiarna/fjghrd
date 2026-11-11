import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/repositories/user_repository.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/beranda_view.dart';
import 'package:fjghrd/views/cuti_view.dart';
import 'package:fjghrd/views/karyawan_view.dart';
import 'package:fjghrd/views/payroll_view.dart';
import 'package:fjghrd/views/report_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class HomeControl extends GetxController {
  AuthControl authControl = Get.find();
  final UserRepository _userRepository = UserRepository();

  int tabId = 0;
  final Set<int> loadedTabs = {0};
  Widget? _subKontener;

  Widget? _berandaTab;
  Widget? _karyawanTab;
  Widget? _payrollTab;
  Widget? _cutiTab;
  Widget? _reportTab;

  Widget get kontener => _subKontener ?? _getTabWidget(tabId);

  set kontener(Widget widget) {
    if (widget is BerandaView) {
      tabId = 0;
      _subKontener = null;
      loadedTabs.add(0);
    } else if (widget is KaryawanView) {
      tabId = 1;
      _subKontener = null;
      loadedTabs.add(1);
    } else if (widget is PayrollView) {
      tabId = 2;
      _subKontener = null;
      loadedTabs.add(2);
    } else if (widget is CutiView) {
      tabId = 3;
      _subKontener = null;
      loadedTabs.add(3);
    } else if (widget is ReportView) {
      tabId = 4;
      _subKontener = null;
      loadedTabs.add(4);
    } else {
      _subKontener = widget;
    }
  }

  bool get isSubPage => _subKontener != null;

  int get currentIndex {
    if (isSubPage) {
      return 5;
    }
    if (tabId >= 0 && tabId <= 4) {
      return tabId;
    }
    return 0;
  }

  Widget _getTabWidget(int index) {
    switch (index) {
      case 0:
        return _berandaTab ??= const BerandaView();
      case 1:
        if (!loadedTabs.contains(1)) return const SizedBox.shrink();
        return _karyawanTab ??= KaryawanView();
      case 2:
        if (!loadedTabs.contains(2)) return const SizedBox.shrink();
        return _payrollTab ??= (authControl.user.role == 'user'
            ? const SizedBox.shrink()
            : PayrollView());
      case 3:
        if (!loadedTabs.contains(3)) return const SizedBox.shrink();
        return _cutiTab ??= CutiView();
      case 4:
        if (!loadedTabs.contains(4)) return const SizedBox.shrink();
        return _reportTab ??= ReportView();
      default:
        return const SizedBox.shrink();
    }
  }

  List<Widget> get allTabs => [
    _getTabWidget(0),
    _getTabWidget(1),
    _getTabWidget(2),
    _getTabWidget(3),
    _getTabWidget(4),
    _subKontener != null
        ? KeyedSubtree(key: ObjectKey(_subKontener), child: _subKontener!)
        : const SizedBox.shrink(),
  ];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  var isTampilPassword = false;
  var isTampilPassConfirm = false;
  var isTampilPassOld = false;

  late TextEditingController txtEmail, txtPassword, txtPassConfirm, txtPassOld;

  List<int> get availableTabs {
    if (authControl.user.role == 'user') {
      return [0, 1, 3, 4, 5];
    }
    return [0, 1, 2, 3, 4, 5];
  }

  void pindahTab(int idx) {
    if (idx >= 0 && idx <= 4) {
      tabId = idx;
      _subKontener = null;
      loadedTabs.add(idx);
    } else if (idx == 5) {
      if (scaffoldKey.currentState!.isEndDrawerOpen) {
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
        throw ValidationException('Email harus diisi');
      }
      AFwidget.loading();
      var hasil = await _userRepository.update({ 'email': txtEmail.text });
      Get.back();
      if(hasil.success) {
        await authControl.updateEmail(txtEmail.text);
        update();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    }  catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> changePassword() async {
    try {
      if(txtPassOld.text.isEmpty) {
        throw ValidationException('Password lama harus diisi');
      }
      if(txtPassword.text.isEmpty) {
        throw ValidationException('Password baru harus diisi');
      }
      if(txtPassConfirm.text.isEmpty) {
        throw ValidationException('Konfirmasi password baru harus diisi');
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
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    }  catch (er) {
      AFwidget.formWarning(label: '$er');
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