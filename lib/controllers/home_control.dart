import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/karyawan_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeControl extends GetxController {
  AuthControl authControl = Get.find();

  int tabId = 0;
  Widget kontener = const Text('Test');

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
      kontener = const Text('Tab Payroll');
    } else if(idx == 3) {
      if(scaffoldKey.currentState!.isEndDrawerOpen) {
        scaffoldKey.currentState!.closeEndDrawer();
      } else {
        scaffoldKey.currentState!.openEndDrawer();
      }
    } else if(idx == 99) {
      AFwidget.dialog(
        Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15),
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Apakah Kamu Yakin?',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 20),
                      child: Text(
                          'Ingin keluar dari aplikasi HRD Fratekindo?'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AFwidget.tombol(
                            label: 'BATAL',
                            color: Colors.orangeAccent,
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 10)),
                        Expanded(
                          child: AFwidget.tombol(
                            label: 'YA',
                            color: Colors.red,
                            onPressed: () {
                              Get.back();
                              authControl.sessionEnd();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                height: 5,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(7),
                    topLeft: Radius.circular(7),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: const Icon(Icons.logout_rounded,
                    color: Colors.white),
              ),
            ],
          ),
        contentPadding: const EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
      );
    }
    update();
  }

}