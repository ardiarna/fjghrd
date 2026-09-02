import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/status_kerja.dart';
import 'package:fjghrd/repositories/status_kerja_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class StatusKerjaControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final StatusKerjaRepository _repo = StatusKerjaRepository();

  RxList<StatusKerja> listStatusKerja = <StatusKerja>[].obs;

  late TextEditingController txtId, txtNama, txtUrutan;

  Future<void> loadStatusKerjas() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listStatusKerja.assignAll(hasil.daftar.map<StatusKerja>((data) => StatusKerja.fromMap(data)).toList());
      
    }
  }

  

  

  Future<void> simpanData() async {
    try {
      if(txtNama.text.isEmpty) {
        throw ValidationException('Nama harus diisi');
      }
      if(txtUrutan.text.isEmpty) {
        throw ValidationException('Urutan harus diisi');
      }

      var a = StatusKerja(
        id: txtId.text,
        nama: txtNama.text,
        urutan: AFconvert.keInt(txtUrutan.text),
      );

      AFwidget.loading();
      var hasil = a.id == ''
          ? await _repo.create(a.toMap())
          : await _repo.update(a.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadStatusKerjas();
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
        throw ValidationException('ID StatusKerja null');
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadStatusKerjas();
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
    txtNama = TextEditingController();
    txtUrutan = TextEditingController();
    loadStatusKerjas();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtNama.dispose();
    txtUrutan.dispose();
    super.onClose();
  }
}
