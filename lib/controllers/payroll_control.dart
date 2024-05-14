import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/models/hari_libur.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/repositories/hari_libur_repository.dart';
import 'package:fjghrd/repositories/payroll_repository.dart';
import 'package:fjghrd/repositories/upah_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayrollControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final homeControl = Get.find<HomeControl>();
  final PayrollRepository _payrollRepo = PayrollRepository();
  final UpahRepository _upahRepo = UpahRepository();
  
  List<Karyawan> listKaryawan = [];
  Map<String, int> totalKaryawanPerArea = {};
  List<HariLibur> listHariLibur = [];

  late TextEditingController txtTglGajiAwal, txtTglGajiAkhir, txtTglMakanAwal, txtTglMakanAkhir;

  Future<void> loadKaryawans() async {
    var hasil = await _upahRepo.findAll();
    if (hasil.success) {
      listKaryawan.clear();
      totalKaryawanPerArea.clear();
      for (var data in hasil.daftar) {
        var k = Karyawan.fromMap(data);
        listKaryawan.add(k);
        if(k.staf) {
          if (totalKaryawanPerArea.containsKey(k.area.nama)) {
            totalKaryawanPerArea[k.area.nama] = totalKaryawanPerArea[k.area.nama]! + 1;
          } else {
            totalKaryawanPerArea[k.area.nama] = 1;
          }
        }
      }
      for (var k in listKaryawan) {
        if(k.staf == false) {
          if (totalKaryawanPerArea.containsKey('NON STAF')) {
            totalKaryawanPerArea['NON STAF'] = totalKaryawanPerArea['NON STAF']! + 1;
          } else {
            totalKaryawanPerArea['NON STAF'] = 1;
          }
        }
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  Future<void> loadHariLiburs(String tahun) async {
    final HariLiburRepository repo = HariLiburRepository();
    var hasil = await repo.findAll(tahun: tahun);
    if (hasil.success) {
      listHariLibur.clear();
      for (var data in hasil.daftar) {
        listHariLibur.add(HariLibur.fromMap(data));
      }
    }
  }

  int countWorkingDays() {
    DateTime startDate = AFconvert.keTanggal('${txtTglMakanAwal.text} 00:00:00') ?? DateTime.now();
    DateTime endDate = AFconvert.keTanggal('${txtTglMakanAkhir.text} 00:00:00') ?? DateTime.now();
    int workingDays = 0;
    for (DateTime date = startDate; date.isBefore(endDate.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
      if (date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday &&
          !listHariLibur.any((liburan) => liburan.tanggal != null && liburan.tanggal!.year == date.year && liburan.tanggal!.month == date.month && liburan.tanggal!.day == date.day)) {
        workingDays++;
      }
    }
    return workingDays;
  }
  
  @override
  void onInit() {
    txtTglGajiAwal = TextEditingController();
    txtTglGajiAkhir = TextEditingController();
    txtTglMakanAwal = TextEditingController();
    txtTglMakanAkhir = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    txtTglGajiAwal.dispose();
    txtTglGajiAkhir.dispose();
    txtTglMakanAwal.dispose();
    txtTglMakanAkhir.dispose();
    super.onClose();
  }
}
