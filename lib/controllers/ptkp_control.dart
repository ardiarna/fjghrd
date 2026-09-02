import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/ptkp.dart';
import 'package:fjghrd/repositories/ptkp_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class PtkpControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final PtkpRepository _repo = PtkpRepository();

  RxList<Ptkp> listPtkp = <Ptkp>[].obs;

  late TextEditingController txtId, txtKode, txtJumlah;
  RxString kategoriTER = ''.obs;

  Future<void> loadPtkps() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listPtkp.assignAll(hasil.daftar.map<Ptkp>((data) => Ptkp.fromMap(data)).toList());
      
    }
  }

  

  

  Future<void> simpanData() async {
    try {
      if(txtKode.text.isEmpty) {
        throw ValidationException('Kode harus diisi');
      }
      if(txtJumlah.text.isEmpty) {
        throw ValidationException('Jumlah harus diisi');
      }
      if(kategoriTER.value.isEmpty) {
        throw ValidationException('Kategori TER harus diisi');
      }

      var a = Ptkp(
        id: txtId.text,
        kode: txtKode.text,
        ter: kategoriTER.value,
        jumlah: AFconvert.keInt(txtJumlah.text),
      );

      AFwidget.loading();
      var hasil = a.id == ''
          ? await _repo.create(a.toMap())
          : await _repo.update(a.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadPtkps();
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
        throw ValidationException('ID PTKP null');
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadPtkps();
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

  @override
  void onInit() {
    txtId = TextEditingController();
    txtKode = TextEditingController();
    txtJumlah = TextEditingController();
    loadPtkps();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtKode.dispose();
    txtJumlah.dispose();
    super.onClose();
  }
}
