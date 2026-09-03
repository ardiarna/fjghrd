import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/upah.dart';
import 'package:fjghrd/repositories/upah_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/hasil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class UpahControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final homeControl = Get.find<HomeControl>();
  final UpahRepository _repo = UpahRepository();

  Karyawan current = Karyawan();
  RxList<Karyawan> listKaryawan = <Karyawan>[].obs;
  Opsi cariStaf = Opsi(value: 'Y', label: 'Staf');
  Map<String, int> totalKaryawanPerArea = {};

  late TextEditingController txtUangMakan;

  bool? makanHarian = false;
  bool? overtime = true;

  Future<void> loadKaryawans() async {
    var hasil = await _repo.findAll(isStaf: cariStaf.value);
    if (hasil.success) {
      listKaryawan.clear();
      totalKaryawanPerArea.clear();
      for (var data in hasil.daftar) {
        var k = Karyawan.fromMap(data);
        listKaryawan.add(k);
        if (totalKaryawanPerArea.containsKey('TOTAL KARYAWAN')) {
          totalKaryawanPerArea['TOTAL KARYAWAN'] = totalKaryawanPerArea['TOTAL KARYAWAN']! + 1;
        } else {
          totalKaryawanPerArea['TOTAL KARYAWAN'] = 1;
        }
        if (totalKaryawanPerArea.containsKey(k.area.nama)) {
          totalKaryawanPerArea[k.area.nama] = totalKaryawanPerArea[k.area.nama]! + 1;
        } else {
          totalKaryawanPerArea[k.area.nama] = 1;
        }
      }
      update(['summary_upah']);
    }
  }

  Future<void> ubahData() async {
    try {
      if(current.id.isEmpty) {
        throw ValidationException('ID karyawan tidak ditemukan');
      }
      if(txtUangMakan.text.isEmpty) {
        throw ValidationException('Uang Makan harus diisi');
      }
      if(makanHarian == null) {
        throw ValidationException('Silakan pilih apakah uang makan harian atau tidak');
      }
      if(overtime == null) {
        throw ValidationException('Silakan pilih status overtime ya atau tidak');
      }
      var a = Upah(
        id: current.upah.id,
        karyawanId: current.id,
        uangMakan: AFconvert.keInt(txtUangMakan.text),
        makanHarian: makanHarian ?? true,
        overtime: overtime ?? false,
      );
      AFwidget.loading();
      var hasil = Hasil();
      if(a.id == '') {
        hasil = await _repo.create(a.karyawanId, a.toMap());
      } else {
        hasil = await _repo.updateByKaryawanId(a.karyawanId, a.toMap());
      }
      Get.back();
      if(hasil.success) {
        loadKaryawans();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<Opsi?> pilihStaf({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: [
        Opsi(value: 'Y', label: 'Staf'),
        Opsi(value: 'N', label: 'Non Staf'),
        Opsi(value: '', label: 'Staf & Non Staf'),
      ],
      valueSelected: value,
      judul: 'Pilih Jenis Karyawan',
      withCari: false,
    );
    return a;
  }

  @override
  void onInit() {
    loadKaryawans();
    ever(authControl.karyawanUpdateTrigger, (_) => loadKaryawans());
    txtUangMakan = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    txtUangMakan.dispose();
    super.onClose();
  }
}
