import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/pendidikan.dart';
import 'package:fjghrd/repositories/pendidikan_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class PendidikanControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final PendidikanRepository _repo = PendidikanRepository();

  RxList<Pendidikan> listPendidikan = <Pendidikan>[].obs;

  late TextEditingController txtId, txtNama, txtUrutan;

  Future<void> loadPendidikans() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listPendidikan.assignAll(hasil.daftar.map<Pendidikan>((data) => Pendidikan.fromMap(data)).toList());
      
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

      var a = Pendidikan(
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
        loadPendidikans();
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
        throw ValidationException('ID Pendidikan null');
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadPendidikans();
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
    loadPendidikans();
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
