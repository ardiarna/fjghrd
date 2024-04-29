import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/views/home_view.dart';
import 'package:fjghrd/views/karyawan_form.dart';
import 'package:fjghrd/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  final AuthControl authControl = Get.put(AuthControl(), permanent: true);
  await authControl.loadUser();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HRD Fratekindo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      initialRoute: authControl.user.email == "" ? Rute.login : Rute.home,
      getPages: [
        GetPage(name: Rute.home, page: () => HomeView()),
        GetPage(name: Rute.login, page: () => LoginView()),
        GetPage(name: Rute.karyawanForm, page: () => KaryawanForm()),
      ],
    ),
  );
}
