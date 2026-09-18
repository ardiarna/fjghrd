import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/views/home_view.dart';
import 'package:fjghrd/views/karyawan_form.dart';
import 'package:fjghrd/views/karyawan_payroll_view.dart';
import 'package:fjghrd/views/login_view.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      center: true,
      title: 'HRD FRATEKINDO - Your Partner',
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.maximize();
    });
  }

  final AuthControl authControl = Get.put(AuthControl(), permanent: true);
  await authControl.getSession();
  authControl.loadUser(); // Non-blocking background check

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HRD FRATEKINDO - Your Partner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
      initialRoute: authControl.user.email == "" ? Rute.login : Rute.home,
      getPages: [
        GetPage(name: Rute.home, page: () => HomeView()),
        GetPage(name: Rute.login, page: () => LoginView()),
        GetPage(name: Rute.karyawanForm, page: () => KaryawanForm()),
        GetPage(name: Rute.karyawanPayrollView, page: () => KaryawanPayrollView()),
      ],
    ),
  );
}
