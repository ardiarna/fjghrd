import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/divisi.dart';
import 'package:fjghrd/repositories/divisi_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class DivisiControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final DivisiRepository _repo = DivisiRepository();

  RxList<Divisi> listDivisi = <Divisi>[].obs;

  late TextEditingController txtId, txtKode, txtNama, txtUrutan;

  Future<void> loadDivisis() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listDivisi.assignAll(hasil.daftar.map<Divisi>((data) => Divisi.fromMap(data)).toList());
      
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

      var a = Divisi(
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
        loadDivisis();
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
        throw ValidationException('ID Divisi null');
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadDivisis();
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
    loadDivisis();
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
