import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/area.dart';
import 'package:fjghrd/repositories/area_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class AreaControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final AreaRepository _repo = AreaRepository();

  RxList<Area> listArea = <Area>[].obs;

  late TextEditingController txtId, txtKode, txtNama, txtUrutan;

  Future<void> loadAreas() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listArea.assignAll(hasil.daftar.map<Area>((data) => Area.fromMap(data)).toList());
      
    }
  }

  

  

  Future<void> simpanData() async {
    try {
      if(txtKode.text.isEmpty) {
        throw ValidationException('Kode harus diisi');
      }
      if(txtNama.text.isEmpty) {
        throw ValidationException('Nama harus diisi');
      }
      if(txtUrutan.text.isEmpty) {
        throw ValidationException('Urutan harus diisi');
      }

      var a = Area(
        id: txtId.text,
        kode: txtKode.text,
        nama: txtNama.text,
        urutan: AFconvert.keInt(txtUrutan.text),
      );

      AFwidget.loading();
      var hasil = a.id == ''
          ? await _repo.create(a.toMap())
          : await _repo.update(a.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadAreas();
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
        throw ValidationException('ID Area null');
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadAreas();
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
    txtNama = TextEditingController();
    txtUrutan = TextEditingController();
    loadAreas();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtKode.dispose();
    txtNama.dispose();
    txtUrutan.dispose();
    super.onClose();
  }
}
