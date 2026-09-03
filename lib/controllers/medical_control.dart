import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/medical.dart';
import 'package:fjghrd/models/medical_rekap.dart';
import 'package:fjghrd/repositories/karyawan_repository.dart';
import 'package:fjghrd/repositories/medical_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class MedicalControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final homeControl = Get.find<HomeControl>();
  final MedicalRepository _repo = MedicalRepository();

  final DateTime _now = DateTime.now();

  RxList<Medical> listMedical = <Medical>[].obs;
  List<Opsi> listKaryawan = [];
  List<Opsi> listJenis = [
    Opsi(value: 'R', label: 'Rawat Jalan'),
    Opsi(value: 'K', label: 'Kacamata'),
    Opsi(value: 'I', label: 'Melahirkan'),
  ];
  List<Opsi> listBulan = mapBulan.entries.map((e) => Opsi(value: e.key.toString(), label: e.value)).toList();
  late List<Opsi> listTahun;

  Opsi filterJenis = Opsi(value: '', label: 'Semua');
  late Opsi filterTahun;
  late Opsi filterBulan;

  late TextEditingController txtId, txtJumlah, txtKeterangan;
  Karyawan karyawan = Karyawan();
  Opsi jenis = Opsi(value: 'R', label: 'Rawat Jalan');
  late Opsi tahun;
  late Opsi bulan;

  MedicalRekap medicalRekap = MedicalRekap();
  int tunjangan = 0, jumlahKlaim = 0, sisaTunjangan = 0;
  List<Medical> medicalHistory = [];

  Future<void> loadMedicals() async {
    var hasil = await _repo.findAll(
      tahun: filterTahun.value,
      bulan: filterBulan.value,
      jenis: filterJenis.value,
    );
    if (hasil.success) {
      List<Medical> tempList = [];
      for (var data in hasil.daftar) {
        tempList.add(Medical.fromMap(data));
      }
      listMedical.assignAll(tempList);
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

  Future<void> loadInfoMedical() async {
    try {
      medicalRekap = MedicalRekap();
      medicalHistory.clear();
      if(karyawan.id != '') {
        if(jenis.value == 'R') {
          KaryawanRepository repo = KaryawanRepository();
          var hasil = await repo.medicalRekap(karyawan.id, tahun.value);
          if(!hasil.success) throw hasil.message;
          medicalRekap = MedicalRekap.fromMap(hasil.data);
        } else {
          var hasil = await _repo.findAll(
            jenis: jenis.value,
            karyawanId: karyawan.id,
          );
          if(!hasil.success) throw hasil.message;
          for (var data in hasil.daftar) {
            medicalHistory.add(Medical.fromMap(data));
          }
        }
      }

      if(karyawan.id != '' && jenis.value == 'R') {
        tunjangan = karyawan.kelamin == 'L' ? medicalRekap.gaji*2 : medicalRekap.gaji;
        jumlahKlaim = medicalRekap.bln1 + medicalRekap.bln2 + medicalRekap.bln3 +
            medicalRekap.bln4 + medicalRekap.bln5 + medicalRekap.bln6 +
            medicalRekap.bln7 + medicalRekap.bln8 + medicalRekap.bln9 +
            medicalRekap.bln10 + medicalRekap.bln11 + medicalRekap.bln12;
        sisaTunjangan = tunjangan - jumlahKlaim;
      }
      update(['info_medical']);
    } catch (er) {
      update(['info_medical']);
      AFwidget.formWarning(label: '$er');
    }
  }


  String get pesanValidasi {
    if(bulan.value.isEmpty) return 'Pilih bulan';
    if(tahun.value.isEmpty) return 'Pilih tahun';
    if(jenis.value.isEmpty) return 'Pilih jenis medical';
    if(karyawan.id.isEmpty) return 'Pilih karyawan';
    if(txtJumlah.text.isEmpty) return 'Isi jumlah IDR';
    
    int valJumlah = AFconvert.keInt(txtJumlah.text);
    if(valJumlah <= 0) return 'Jumlah IDR tidak boleh 0';
    if(jenis.value == 'R' && valJumlah > sisaTunjangan) return 'Jumlah melebihi sisa klaim';
    
    return '';
  }

  Future<void> tambahData() async {

    try {
      if(jenis.value.isEmpty) {
        throw ValidationException('Silakan pilih jenis medical');
      }
      if(bulan.value.isEmpty || tahun.value.isEmpty) {
        throw ValidationException('Periode harus diisi');
      }
      if(karyawan.id.isEmpty) {
        throw ValidationException('Silakan pilih karyawan');
      }
      if(txtJumlah.text.isEmpty) {
        throw ValidationException('Jumlah harus diisi');
      }
      int year = AFconvert.keInt(tahun.value);
      int month = AFconvert.keInt(bulan.value);
      var a = Medical(
        jenis: jenis.value,
        tanggal: DateTime(year, month, 1, 8),
        bulan: month,
        tahun: year,
        jumlah: AFconvert.keInt(txtJumlah.text),
        keterangan: txtKeterangan.text,
      );
      a.karyawan = karyawan;

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadMedicals();
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
        throw ValidationException('ID medical tidak ditemukan');
      }
      if(karyawan.id.isEmpty) {
        throw ValidationException('Silakan pilih karyawan');
      }
      if(jenis.value.isEmpty) {
        throw ValidationException('Silakan pilih jenis medical');
      }
      if(bulan.value.isEmpty || tahun.value.isEmpty) {
        throw ValidationException('Periode harus diisi');
      }
      if(txtJumlah.text.isEmpty) {
        throw ValidationException('Jumlah harus diisi');
      }
      int year = AFconvert.keInt(tahun.value);
      int month = AFconvert.keInt(bulan.value);
      var a = Medical(
        jenis: jenis.value,
        tanggal: DateTime(year, month, 1, 8),
        bulan: month,
        tahun: year,
        jumlah: AFconvert.keInt(txtJumlah.text),
        keterangan: txtKeterangan.text,
      );
      a.karyawan = karyawan;

      AFwidget.loading();
      var hasil = await _repo.update(txtId.text, a.toMap());
      Get.back();
      if(hasil.success) {
        loadMedicals();
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
        throw ValidationException('ID medical tidak ditemukan');
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadMedicals();
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
        loadMedicals();
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

  Future<Opsi?> pilihJenis({String value = '', bool withSemua = false}) async {
    List<Opsi> list = [...listJenis];
    if(withSemua) {
      list.insert(0, Opsi(value: '', label: 'Semua'));
    }
    var a = await AFcombobox.bottomSheet(
      listOpsi: list,
      valueSelected: value,
      judul: 'Pilih Jenis Medical',
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

  Future<Opsi?> pilihBulan({String value = '', bool withSemua = false}) async {
    List<Opsi> list = [...listBulan];
    if(withSemua) {
      list.add(Opsi(value: '', label: 'Semua'));
    }
    var a = await AFcombobox.bottomSheet(
      listOpsi: list,
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
    txtJumlah = TextEditingController();
    txtKeterangan = TextEditingController();
    loadMedicals();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtJumlah.dispose();
    txtKeterangan.dispose();
    super.onClose();
  }
}
