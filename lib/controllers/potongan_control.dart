import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/potongan.dart';
import 'package:fjghrd/models/upah.dart';
import 'package:fjghrd/repositories/karyawan_repository.dart';
import 'package:fjghrd/repositories/potongan_repository.dart';
import 'package:fjghrd/repositories/upah_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';
import 'package:fjghrd/controllers/auth_control.dart';

class PotonganControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final homeControl = Get.find<HomeControl>();
  final PotonganRepository _repo = PotonganRepository();

  final DateTime _now = DateTime.now();

  RxList<Potongan> listPotongan = <Potongan>[].obs;
  List<Opsi> listKaryawan = [];
  List<Opsi> listJenis = [
    Opsi(value: 'TB', label: 'Keterlambatan Hadir'),
    Opsi(value: 'KJ', label: 'Kompensasi Hadir (Jam)'),
    Opsi(value: 'TP', label: 'Telepon'),
    Opsi(value: 'BN', label: 'Bensin'),
    Opsi(value: 'KS', label: 'Pinjaman Kas'),
    Opsi(value: 'CC', label: 'Pinjaman cicilan'),
    Opsi(value: 'BP', label: 'BPJS'),
    Opsi(value: 'UL', label: 'Unpaid Leave / Cuti Bersama'),
    Opsi(value: 'LL', label: 'Lain-Lain'),
  ];
  List<Opsi> listBulan = mapBulan.entries.map((e) => Opsi(value: e.key.toString(), label: e.value)).toList();
  late List<Opsi> listTahun;

  Opsi filterJenis = Opsi(value: '', label: 'Semua');
  late Opsi filterTahun;
  late Opsi filterBulan;

  late TextEditingController txtId, txtTanggal, txtHari, txtJumlah, txtKeterangan;
  Karyawan karyawan = Karyawan();
  Opsi jenis = Opsi(value: '', label: '');
  late Opsi tahun;
  late Opsi bulan;
  Upah upah = Upah();

  Future<void> loadPotongans() async {
    var hasil = await _repo.findAll(
      tahun: filterTahun.value,
      bulan: filterBulan.value,
      jenis: filterJenis.value,
    );
    if (hasil.success) {
      List<Potongan> tempList = [];
      for (var data in hasil.daftar) {
        tempList.add(Potongan.fromMap(data));
      }
      listPotongan.assignAll(tempList);
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

  Future<void> loadPayroll() async {
    UpahRepository repo = UpahRepository();
    var hasil = await repo.find(karyawan.id);
    if(hasil.success) {
      upah = Upah.fromMap(hasil.data);
    } else {
      upah = Upah();
    }
    update();
  }

  Future<void> tambahData() async {
    try {
      if(jenis.value.isEmpty) {
        throw ValidationException('Silakan pilih jenis potongan');
      }
      if(bulan.value.isEmpty || tahun.value.isEmpty) {
        throw ValidationException('Periode harus diisi');
      }
      if(txtTanggal.text.isEmpty) {
        throw ValidationException('Tanggal harus diisi');
      }
      if(karyawan.id.isEmpty) {
        throw ValidationException('Silakan pilih karyawan');
      }
      if((jenis.value == 'TB' || jenis.value == 'UL') && txtHari.text.isEmpty) {
        throw ValidationException('Jumlah hari harus diisi');
      }
      if(txtJumlah.text.isEmpty) {
        throw ValidationException('Jumlah IDR harus diisi');
      }

      var a = Potongan(
        jenis: jenis.value,
        tanggal: AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggal.text)} 08:00:00'),
        tahun: AFconvert.keInt(tahun.value),
        bulan: AFconvert.keInt(bulan.value),
        hari: AFconvert.keDouble(txtHari.text),
        jumlah: AFconvert.keInt(txtJumlah.text),
        keterangan: txtKeterangan.text,
      );
      a.karyawan = karyawan;

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadPotongans();
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
        throw ValidationException('ID potongan tidak ditemukan');
      }
      if(karyawan.id.isEmpty) {
        throw ValidationException('Silakan pilih karyawan');
      }
      if(jenis.value.isEmpty) {
        throw ValidationException('Silakan pilih jenis potongan');
      }
      if(bulan.value.isEmpty || tahun.value.isEmpty) {
        throw ValidationException('Periode harus diisi');
      }
      if(txtTanggal.text.isEmpty) {
        throw ValidationException('Tanggal harus diisi');
      }
      if((jenis.value == 'TB' || jenis.value == 'UL') && txtHari.text.isEmpty) {
        throw ValidationException('Jumlah hari harus diisi');
      }
      if(txtJumlah.text.isEmpty) {
        throw ValidationException('Jumlah IDR harus diisi');
      }
      var a = Potongan(
        jenis: jenis.value,
        tanggal: AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggal.text)} 08:00:00'),
        tahun: AFconvert.keInt(tahun.value),
        bulan: AFconvert.keInt(bulan.value),
        hari: AFconvert.keDouble(txtHari.text),
        jumlah: AFconvert.keInt(txtJumlah.text),
        keterangan: txtKeterangan.text,
      );
      a.karyawan = karyawan;

      AFwidget.loading();
      var hasil = await _repo.update(txtId.text, a.toMap());
      Get.back();
      if(hasil.success) {
        loadPotongans();
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
        throw ValidationException('ID potongan tidak ditemukan');
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadPotongans();
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
        loadPotongans();
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
      judul: 'Pilih Jenis Potongan',
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

  void hitungJumlahIdr(String nilai) {
    if(jenis.value == 'TB') {
      int jumlahHari = AFconvert.keInt(nilai);
      double jumlahIdr = (upah.uangMakan/4)*jumlahHari;
      txtJumlah.text = AFconvert.matNumber(jumlahIdr.toInt());
    } else if(jenis.value == 'UL') {
      int jumlahHari = AFconvert.keInt(nilai);
      double jumlahIdr = (upah.gaji/21)*jumlahHari;
      txtJumlah.text = AFconvert.matNumber(jumlahIdr.toInt());
    } else if(jenis.value == 'KJ') {
      double jumlahJam = AFconvert.keDouble(nilai);
      double jumlahIdr = (upah.gaji/168)*jumlahJam;
      txtJumlah.text = AFconvert.matNumber(jumlahIdr.toInt());
    } else {
      txtHari.text = '';
    }
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
    txtHari = TextEditingController();
    txtJumlah = TextEditingController();
    txtKeterangan = TextEditingController();
    loadPotongans();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtTanggal.dispose();
    txtHari.dispose();
    txtJumlah.dispose();
    txtKeterangan.dispose();
    super.onClose();
  }
}
