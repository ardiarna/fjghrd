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

class UangPhkControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final homeControl = Get.find<HomeControl>();
  final UangPhkRepository _repo = UangPhkRepository();

  final DateTime _now = DateTime.now();

  List<UangPhk> listUangPhk = [];
  List<Opsi> listKaryawan = [];
  late List<Opsi> listTahun;
  late Opsi filterTahun;

  late TextEditingController txtId, txtKompensasi, txtUangPisah, txtPesangon, txtMasaKerja, txtPenggantianHak;
  Karyawan karyawan = Karyawan();
  late Opsi tahun;

  Future<void> loadUangPhks() async {
    var hasil = await _repo.findAll(tahun: filterTahun.value);
    if (hasil.success) {
      listUangPhk.clear();
      for (var data in hasil.daftar) {
        listUangPhk.add(UangPhk.fromMap(data));
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
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
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  void tambahForm(BuildContext context) {
    txtId.text = '';
    tahun = Opsi(value: filterTahun.value, label: filterTahun.label);
    txtKompensasi.text = '';
    txtUangPisah.text = '';
    txtPesangon.text = '';
    txtMasaKerja.text = '';
    txtPenggantianHak.text = '';
    karyawan = Karyawan();
    AFwidget.dialog(
      Container(
        width: Get.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 200,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Karyawan'),
                      ),
                      Expanded(
                        child: GetBuilder<UangPhkControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: karyawan.nama,
                              label: '',
                              onTap: () async {
                                var a = await pilihKaryawan(value: karyawan.id);
                                if(a != null && a.value != karyawan.id) {
                                  karyawan = Karyawan.fromMap(a.data!);
                                  update();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                AFwidget.barisText(
                  label: 'Uang Kompensasi',
                  controller: txtKompensasi,
                  isNumber: true,
                  labelWidth: 200,
                ),
                AFwidget.barisText(
                  label: 'Uang Pisah',
                  controller: txtUangPisah,
                  isNumber: true,
                  labelWidth: 200,
                ),
                AFwidget.barisText(
                  label: 'Uang Pesangon',
                  controller: txtPesangon,
                  isNumber: true,
                  labelWidth: 200,
                ),
                AFwidget.barisText(
                  label: 'Uang Masa Kerja',
                  controller: txtMasaKerja,
                  isNumber: true,
                  labelWidth: 200,
                ),
                AFwidget.barisText(
                  label: 'Uang Penggantian Hak',
                  controller: txtPenggantianHak,
                  isNumber: true,
                  labelWidth: 200,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AFwidget.tombol(
                        label: 'Batal',
                        color: Colors.orange,
                        onPressed: Get.back,
                        minimumSize: const Size(120, 40),
                      ),
                      const SizedBox(width: 40),
                      AFwidget.tombol(
                        label: 'Simpan',
                        color: Colors.blue,
                        onPressed: tambahData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AFwidget.formHeader('Form Tambah Uang PHK - ${tahun.label}'),
          ],
        ),
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void ubahForm(String id, BuildContext context) {
    var item = listUangPhk.where((element) => element.id == id).first;
    txtId.text = item.id;
    tahun = Opsi(value: '${item.tahun}', label: '${item.tahun}');
    txtKompensasi.text = AFconvert.matNumber(item.kompensasi);
    txtUangPisah.text = AFconvert.matNumber(item.uangPisah);
    txtPesangon.text = AFconvert.matNumber(item.pesangon);
    txtMasaKerja.text = AFconvert.matNumber(item.masaKerja);
    txtPenggantianHak.text = AFconvert.matNumber(item.penggantianHak);
    karyawan = item.karyawan;
    AFwidget.dialog(
      Container(
        width: Get.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Stack(
          children: [
            ListView(
              children: [
                AFwidget.barisInfo(
                  label: 'Nama Karyawan',
                  nilai: karyawan.nama,
                  paddingTop: 70,
                  labelWidth: 200,
                ),
                AFwidget.barisInfo(
                  label: 'Jabatan',
                  nilai: karyawan.jabatan.nama,
                  labelWidth: 200,
                ),
                AFwidget.barisInfo(
                  label: 'Masa Kerja',
                  nilai: AFconvert.matDate(karyawan.tanggalMasuk),
                  labelWidth: 200,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 200,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Periode'),
                      ),
                      Expanded(
                        child: GetBuilder<UangPhkControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: tahun.label,
                              label: '',
                              onTap: () async {
                                var a = await pilihTahun(value: tahun.value);
                                if(a != null && a.value != tahun.value) {
                                  tahun = a;
                                  update();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                AFwidget.barisText(
                  label: 'Uang Kompensasi',
                  controller: txtKompensasi,
                  isNumber: true,
                  labelWidth: 200,
                ),
                AFwidget.barisText(
                  label: 'Uang Pisah',
                  controller: txtUangPisah,
                  isNumber: true,
                  labelWidth: 200,
                ),
                AFwidget.barisText(
                  label: 'Uang Pesangon',
                  controller: txtPesangon,
                  isNumber: true,
                  labelWidth: 200,
                ),
                AFwidget.barisText(
                  label: 'Uang Masa Kerja',
                  controller: txtMasaKerja,
                  isNumber: true,
                  labelWidth: 200,
                ),
                AFwidget.barisText(
                  label: 'Uang Penggantian Hak',
                  controller: txtPenggantianHak,
                  isNumber: true,
                  labelWidth: 200,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AFwidget.tombol(
                        label: 'Hapus',
                        color: Colors.red,
                        onPressed: () {
                          hapusForm(item);
                        },
                        minimumSize: const Size(120, 40),
                      ),
                      const Spacer(),
                      AFwidget.tombol(
                        label: 'Batal',
                        color: Colors.orange,
                        onPressed: Get.back,
                        minimumSize: const Size(120, 40),
                      ),
                      const SizedBox(width: 40),
                      AFwidget.tombol(
                        label: 'Simpan',
                        color: Colors.blue,
                        onPressed: ubahData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AFwidget.formHeader('Form Ubah Uang Phk'),
          ],
        ),
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void hapusForm(UangPhk item) {
    AFwidget.formHapus(
      label: 'uang PHK ${item.karyawan.nama} pada periode ${tahun.value} ',
      aksi: () {
        hapusData(item.id);
      },
    );
  }

  Future<void> tambahData() async {
    try {
      if(karyawan.id.isEmpty) {
        throw 'Silakan pilih karyawan';
      }
      if(txtKompensasi.text.isEmpty && txtUangPisah.text.isEmpty && txtPesangon.text.isEmpty && txtMasaKerja.text.isEmpty && txtPenggantianHak.text.isEmpty) {
        throw 'silakan isi minimal satu jenis uang PHK';
      }

      var a = UangPhk(
        tahun: AFconvert.keInt(tahun.value),
        kompensasi: AFconvert.keInt(txtKompensasi.text),
        uangPisah: AFconvert.keInt(txtUangPisah.text),
        pesangon: AFconvert.keInt(txtPesangon.text),
        masaKerja: AFconvert.keInt(txtMasaKerja.text),
        penggantianHak: AFconvert.keInt(txtPenggantianHak.text),
      );
      a.karyawan = karyawan;

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadUangPhks();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> ubahData() async {
    try {
      if(txtId.text.isEmpty) {
        throw 'ID uang PHK tidak ditemukan';
      }
      if(karyawan.id.isEmpty) {
        throw 'Silakan pilih karyawan';
      }
      if(tahun.value.isEmpty) {
        throw 'Periode harus diisi';
      }
      if(txtKompensasi.text.isEmpty && txtUangPisah.text.isEmpty && txtPesangon.text.isEmpty && txtMasaKerja.text.isEmpty && txtPenggantianHak.text.isEmpty) {
        throw 'silakan isi minimal satu jenis uang PHK';
      }
      var a = UangPhk(
        tahun: AFconvert.keInt(tahun.value),
        kompensasi: AFconvert.keInt(txtKompensasi.text),
        uangPisah: AFconvert.keInt(txtUangPisah.text),
        pesangon: AFconvert.keInt(txtPesangon.text),
        masaKerja: AFconvert.keInt(txtMasaKerja.text),
        penggantianHak: AFconvert.keInt(txtPenggantianHak.text),
      );
      a.karyawan = karyawan;

      AFwidget.loading();
      var hasil = await _repo.update(txtId.text, a.toMap());
      Get.back();
      if(hasil.success) {
        loadUangPhks();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> hapusData(String id) async {
    try {
      if(id == '') {
        throw 'ID uang PHK tidak ditemukan';
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadUangPhks();
        Get.back();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
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
    loadKaryawans();
    filterTahun = Opsi(value: '${_now.year}', label: '${_now.year}');
    tahun = Opsi(value: '${_now.year}', label: '${_now.year}');
    listTahun = List.generate(_now.year-2019, (index) => Opsi(value: '${_now.year-index}', label: '${_now.year-index}'));
    txtId = TextEditingController();
    txtKompensasi = TextEditingController();
    txtUangPisah = TextEditingController();
    txtPesangon = TextEditingController();
    txtMasaKerja = TextEditingController();
    txtPenggantianHak = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtKompensasi.dispose();
    txtUangPisah.dispose();
    txtPesangon.dispose();
    txtMasaKerja.dispose();
    txtPenggantianHak.dispose();
    super.onClose();
  }
}
