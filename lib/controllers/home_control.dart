import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/views/karyawan_view.dart';
import 'package:fjghrd/views/payroll_view.dart';
import 'package:fjghrd/views/report_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeControl extends GetxController {
  AuthControl authControl = Get.find();

  int tabId = 0;
  Widget kontener = const Text('');

  final scaffoldKey = GlobalKey<ScaffoldState>();


  void pindahTab(int idx) {
    if(idx == 0) {
      tabId = idx;
      kontener = const Text('Tab Beranda');
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

}