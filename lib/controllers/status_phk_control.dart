import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/status_phk.dart';
import 'package:fjghrd/repositories/status_phk_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class StatusPhkControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final StatusPhkRepository _repo = StatusPhkRepository();

  RxList<StatusPhk> listStatusPhk = <StatusPhk>[].obs;

  late TextEditingController txtId, txtNama, txtUrutan;

  Future<void> loadStatusPhks() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listStatusPhk.assignAll(hasil.daftar.map<StatusPhk>((data) => StatusPhk.fromMap(data)).toList());
      
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

      var a = StatusPhk(
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
        loadStatusPhks();
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
        throw ValidationException('ID StatusPhk null');
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadStatusPhks();
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
    loadStatusPhks();
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
