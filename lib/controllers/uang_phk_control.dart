import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/uang_phk.dart';
import 'package:fjghrd/repositories/karyawan_repository.dart';
import 'package:fjghrd/repositories/uang_phk_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class UangPhkControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final homeControl = Get.find<HomeControl>();
  final UangPhkRepository _repo = UangPhkRepository();

  final DateTime _now = DateTime.now();

  RxList<UangPhk> listUangPhk = <UangPhk>[].obs;
  List<Opsi> listKaryawan = [];
  late List<Opsi> listTahun;
  late Opsi filterTahun;

  late TextEditingController txtId, txtKompensasi, txtUangPisah, txtPesangon, txtMasaKerja, txtSisaCutiHari, txtSisaCutiJumlah, txtLain, txtPotKas, txtPotCutiHari, txtPotCutiJumlah, txtPotLain, txtKeterangan;
  Karyawan karyawan = Karyawan();
  late Opsi tahun;

  Future<void> loadUangPhks() async {
    var hasil = await _repo.findAll(tahun: filterTahun.value);
    if (hasil.success) {
      List<UangPhk> tempList = [];
      for (var data in hasil.daftar) {
        tempList.add(UangPhk.fromMap(data));
      }
      listUangPhk.assignAll(tempList);
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
      update();
    }
  }  

  Future<void> tambahData() async {
    try {
      if(karyawan.id.isEmpty) {
        throw ValidationException('Silakan pilih karyawan');
      }
      if(txtKompensasi.text.isEmpty && txtUangPisah.text.isEmpty && txtPesangon.text.isEmpty && txtMasaKerja.text.isEmpty && txtLain.text.isEmpty) {
        throw ValidationException('silakan isi minimal satu jenis uang PHK');
      }

      var a = UangPhk(
        tahun: AFconvert.keInt(tahun.value),
        kompensasi: AFconvert.keInt(txtKompensasi.text),
        uangPisah: AFconvert.keInt(txtUangPisah.text),
        pesangon: AFconvert.keInt(txtPesangon.text),
        masaKerja: AFconvert.keInt(txtMasaKerja.text),
        lain: AFconvert.keInt(txtLain.text),
      );
      a.karyawan = karyawan;

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadUangPhks();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> ubahData() async {
    try {
      if(txtId.text.isEmpty) {
        throw ValidationException('ID uang PHK tidak ditemukan');
      }
      if(karyawan.id.isEmpty) {
        throw ValidationException('Silakan pilih karyawan');
      }
      if(tahun.value.isEmpty) {
        throw ValidationException('Periode harus diisi');
      }
      if(txtKompensasi.text.isEmpty && txtUangPisah.text.isEmpty && txtPesangon.text.isEmpty && txtMasaKerja.text.isEmpty && txtLain.text.isEmpty) {
        throw ValidationException('silakan isi minimal satu jenis uang PHK');
      }
      var a = UangPhk(
        tahun: AFconvert.keInt(tahun.value),
        kompensasi: AFconvert.keInt(txtKompensasi.text),
        uangPisah: AFconvert.keInt(txtUangPisah.text),
        pesangon: AFconvert.keInt(txtPesangon.text),
        masaKerja: AFconvert.keInt(txtMasaKerja.text),
        lain: AFconvert.keInt(txtLain.text),
      );
      a.karyawan = karyawan;

      AFwidget.loading();
      var hasil = await _repo.update(txtId.text, a.toMap());
      Get.back();
      if(hasil.success) {
        loadUangPhks();
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
        throw ValidationException('ID uang PHK tidak ditemukan');
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadUangPhks();
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

  Future<Opsi?> pilihKaryawan({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listKaryawan,
      valueSelected: value,
      judul: 'Pilih Karyawan',
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

  @override
  void onInit() {
    ever(authControl.karyawanUpdateTrigger, (_) => loadKaryawans());
    loadKaryawans();
    filterTahun = Opsi(value: '${_now.year}', label: '${_now.year}');
    tahun = Opsi(value: '${_now.year}', label: '${_now.year}');
    listTahun = List.generate(_now.year-2019, (index) => Opsi(value: '${_now.year-index}', label: '${_now.year-index}'));
    txtId = TextEditingController();
    txtKompensasi = TextEditingController();
    txtUangPisah = TextEditingController();
    txtPesangon = TextEditingController();
    txtMasaKerja = TextEditingController();
    txtSisaCutiHari = TextEditingController();
    txtSisaCutiJumlah = TextEditingController();
    txtLain = TextEditingController();
    txtPotKas = TextEditingController();
    txtPotCutiHari = TextEditingController();
    txtPotCutiJumlah = TextEditingController();
    txtPotLain = TextEditingController();
    txtKeterangan = TextEditingController();
    loadUangPhks();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtKompensasi.dispose();
    txtUangPisah.dispose();
    txtPesangon.dispose();
    txtMasaKerja.dispose();
    txtSisaCutiHari.dispose();
    txtSisaCutiJumlah.dispose();
    txtLain.dispose();
    txtPotKas.dispose();
    txtPotCutiHari.dispose();
    txtPotCutiJumlah.dispose();
    txtPotLain.dispose();
    txtKeterangan.dispose();
    super.onClose();
  }
}
