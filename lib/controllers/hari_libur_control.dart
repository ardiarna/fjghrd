import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/hari_libur.dart';
import 'package:fjghrd/repositories/hari_libur_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class HariLiburControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final HariLiburRepository _repo = HariLiburRepository();

  RxList<HariLibur> listHariLibur = <HariLibur>[].obs;
  Rx<Opsi> filterTahun = Opsi(value: '${DateTime.now().year}', label: '${DateTime.now().year}').obs;

  late TextEditingController txtId, txtNama, txtTanggal;

  Future<void> loadHariLiburs() async {
    var hasil = await _repo.findAll(tahun: filterTahun.value.value);
    if (hasil.success) {
      listHariLibur.assignAll(hasil.daftar.map<HariLibur>((data) => HariLibur.fromMap(data)).toList());
      
    }
  }

  

  

  Future<void> simpanData() async {
    try {
      if(txtTanggal.text.isEmpty) {
        throw ValidationException('Tanggal harus diisi');
      }
      if(txtNama.text.isEmpty) {
        throw ValidationException('Nama harus diisi');
      }
      var a = HariLibur(
        id: txtId.text,
        nama: txtNama.text,
        tanggal: AFconvert.keTanggal('${txtTanggal.text} 08:00:00'),
      );

      AFwidget.loading();
      var hasil = a.id == ''
          ? await _repo.create(a.toMap())
          : await _repo.update(a.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadHariLiburs();
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
        throw ValidationException('ID Hari Libur null');
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadHariLiburs();
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

  Future<Opsi?> pilihTahun({String value = ''}) async {
    int tahunNow = DateTime.now().year;
    var a = await AFcombobox.bottomSheet(
      listOpsi: List.generate(tahunNow-2019, (index) => Opsi(value: '${tahunNow-index}', label: '${tahunNow-index}')),
      valueSelected: value,
      judul: 'Pilih Tahun',
      withCari: false,
    );
    return a;
  }

  @override
  void onInit() {
    txtId = TextEditingController();
    txtNama = TextEditingController();
    txtTanggal = TextEditingController();
    loadHariLiburs();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtNama.dispose();
    txtTanggal.dispose();
    super.onClose();
  }
}
