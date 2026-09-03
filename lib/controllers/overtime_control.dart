import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/overtime.dart';
import 'package:fjghrd/repositories/karyawan_repository.dart';
import 'package:fjghrd/repositories/overtime_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/hasil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class OvertimeControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final homeControl = Get.find<HomeControl>();
  final OvertimeRepository _repo = OvertimeRepository();

  final DateTime _now = DateTime.now();

  RxList<Overtime> listOvertime = <Overtime>[].obs;
  List<Opsi> listKaryawan = [];
  List<Opsi> listJenis = [
    Opsi(value: '', label: 'Semua'),
    Opsi(value: 'F', label: 'Fratekindo'),
    Opsi(value: 'C', label: 'Customer'),
  ];
  List<Opsi> listBulan = mapBulan.entries.map((e) => Opsi(value: e.key.toString(), label: e.value)).toList();
  late List<Opsi> listTahun;

  Opsi filterJenis = Opsi(value: '', label: 'Semua');
  late Opsi filterTahun;
  late Opsi filterBulan;

  late TextEditingController txtId, txtTanggal, txtJumlah, txtJum2, txtKeterangan;
  Karyawan karyawan = Karyawan();
  String jenis = '';
  late Opsi tahun;
  late Opsi bulan;

  Future<void> loadOvertimes() async {
    var hasil = await _repo.findAll(
      tahun: filterTahun.value,
      bulan: filterBulan.value,
      jenis: filterJenis.value,
    );
    if (hasil.success) {
      List<Overtime> tempList = [];
      for (var data in hasil.daftar) {
        tempList.add(Overtime.fromMap(data));
      }
      listOvertime.assignAll(tempList);
    }
  }

  Future<void> loadKaryawans() async {
    KaryawanRepository repo = KaryawanRepository();
    var hasil = await repo.findAll();
    if(hasil.success) {
      listKaryawan.clear();
      for (var data in hasil.daftar) {
        listKaryawan.add(
          Opsi(value: AFconvert.keString(data['id']), label: data['nama'], data: data),
        );
      }
    }
  }

  Future<void> tambahData() async {
    try {
      if(bulan.value.isEmpty || tahun.value.isEmpty) {
        throw ValidationException('Periode harus diisi');
      }
      if(txtTanggal.text.isEmpty) {
        throw ValidationException('Tanggal harus diisi');
      }
      if(karyawan.id.isEmpty) {
        throw ValidationException('Silakan pilih karyawan');
      }
      if(txtJumlah.text.isEmpty && txtJum2.text.isEmpty) {
        throw ValidationException('Jumlah Overtime Fratekindo atau Customer, salah satu harus diisi');
      }

      Hasil hasil = Hasil();
      Hasil hasil2 = Hasil();
      AFwidget.loading();

      if(AFconvert.keInt(txtJumlah.text) > 0) {
        var a = Overtime(
          jenis: 'F',
          tanggal: AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggal.text)} 08:00:00'),
          bulan: AFconvert.keInt(bulan.value),
          tahun: AFconvert.keInt(tahun.value),
          jumlah: AFconvert.keInt(txtJumlah.text),
          keterangan: txtKeterangan.text,
        );
        a.karyawan = karyawan;
        hasil = await _repo.create(a.toMap());
      } else {
        hasil.success = true;
      }

      if(AFconvert.keInt(txtJum2.text) > 0) {
        var b = Overtime(
          jenis: 'C',
          tanggal: AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggal.text)} 08:00:00'),
          bulan: AFconvert.keInt(bulan.value),
          tahun: AFconvert.keInt(tahun.value),
          jumlah: AFconvert.keInt(txtJum2.text),
          keterangan: txtKeterangan.text,
        );
        b.karyawan = karyawan;
        hasil2 = await _repo.create(b.toMap());
      } else {
        hasil2.success = true;
      }

      Get.back();
      List<String> vMessages = [];
      if(hasil.message != '') vMessages.add(hasil.message);
      if(hasil2.message != '') vMessages.add(hasil2.message);
      if(hasil.success && hasil2.success) {
        loadOvertimes();
        Get.back();
        AFwidget.snackbar(vMessages.join(', '));
      } else {
        AFwidget.formWarning(label: vMessages.join(', '));
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> ubahData() async {
    try {
      if(txtId.text.isEmpty) {
        throw ValidationException('ID overtime tidak ditemukan');
      }
      if(karyawan.id.isEmpty) {
        throw ValidationException('Silakan pilih karyawan');
      }
      if(jenis.isEmpty) {
        throw ValidationException('Silakan pilih jenis overtime');
      }
      if(bulan.value.isEmpty || tahun.value.isEmpty) {
        throw ValidationException('Periode harus diisi');
      }
      if(txtTanggal.text.isEmpty) {
        throw ValidationException('Tanggal harus diisi');
      }
      if(txtJumlah.text.isEmpty) {
        throw ValidationException('Jumlah harus diisi');
      }
      var a = Overtime(
        jenis: jenis,
        tanggal: AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggal.text)} 08:00:00'),
        bulan: AFconvert.keInt(bulan.value),
        tahun: AFconvert.keInt(tahun.value),
        jumlah: AFconvert.keInt(txtJumlah.text),
        keterangan: txtKeterangan.text,
      );
      a.karyawan = karyawan;

      AFwidget.loading();
      var hasil = await _repo.update(txtId.text, a.toMap());
      Get.back();
      if(hasil.success) {
        loadOvertimes();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> hapusData(String id) async {
    try {
      if(id == '') {
        throw ValidationException('ID overtime tidak ditemukan');
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadOvertimes();
        Get.back();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> hapusBanyakData() async {
    try {
      AFwidget.loading();
      var hasil = await _repo.deleteAll(
        tahun: filterTahun.value,
        bulan: filterBulan.value,
        jenis: filterJenis.value,
      );
      Get.back();
      if(hasil.success) {
        loadOvertimes();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<Opsi?> pilihKaryawan({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listKaryawan,
      valueSelected: value,
      judul: 'Pilih Karyawan',
    );
    return a;
  }

  Future<Opsi?> pilihJenis({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listJenis,
      valueSelected: value,
      judul: 'Pilih Jenis Overtime',
    );
    return a;
  }

  Future<Opsi?> pilihTahun({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listTahun,
      valueSelected: value,
      judul: 'Pilih Tahun',
      withCari: false,
    );
    return a;
  }

  Future<Opsi?> pilihBulan({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listBulan,
      valueSelected: value,
      judul: 'Pilih Bulan',
      withCari: false,
    );
    return a;
  }

  @override
  void onInit() {
    loadKaryawans();
    ever(authControl.karyawanUpdateTrigger, (_) => loadKaryawans());
    filterTahun = Opsi(value: '${_now.year}', label: '${_now.year}');
    filterBulan = Opsi(value: '${_now.month}', label: mapBulan[_now.month]!);
    tahun = Opsi(value: '${_now.year}', label: '${_now.year}');
    bulan = Opsi(value: '${_now.month}', label: mapBulan[_now.month]!);
    listTahun = List.generate(_now.year-2019, (index) => Opsi(value: '${_now.year-index}', label: '${_now.year-index}'));
    txtId = TextEditingController();
    txtTanggal = TextEditingController();
    txtJumlah = TextEditingController();
    txtJum2 = TextEditingController();
    txtKeterangan = TextEditingController();
    loadOvertimes();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtTanggal.dispose();
    txtJumlah.dispose();
    txtJum2.dispose();
    txtKeterangan.dispose();
    super.onClose();
  }
}
