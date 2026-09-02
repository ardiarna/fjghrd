import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/tarif_efektif.dart';
import 'package:fjghrd/repositories/tarif_efektif_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class TarifEfektifControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final TarifEfektifRepository _repo = TarifEfektifRepository();

  RxList<TarifEfektif> listTarifEfektif = <TarifEfektif>[].obs;

  late TextEditingController txtId, txtPersen, txtPenghasilan;
  RxString kategoriTER = ''.obs;

  Future<void> loadTarifEfektifs() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listTarifEfektif.assignAll(hasil.daftar.map<TarifEfektif>((data) => TarifEfektif.fromMap(data)).toList());
      
    }
  }

  

  

  Future<void> simpanData() async {
    try {
      if(kategoriTER.value.isEmpty) {
        throw ValidationException('Kategori TER harus diisi');
      }
      if(txtPenghasilan.text.isEmpty) {
        throw ValidationException('Penghasilan harus diisi');
      }
      if(txtPersen.text.isEmpty) {
        throw ValidationException('Persen harus diisi');
      }
      var a = TarifEfektif(
        id: txtId.text,
        ter: kategoriTER.value,
        penghasilan: AFconvert.keInt(txtPenghasilan.text),
        persen: AFconvert.keDouble(txtPersen.text),
      );

      AFwidget.loading();
      var hasil = a.id == ''
          ? await _repo.create(a.toMap())
          : await _repo.update(a.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadTarifEfektifs();
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
        throw ValidationException('ID TER null');
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadTarifEfektifs();
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
    txtPersen = TextEditingController();
    txtPenghasilan = TextEditingController();
    loadTarifEfektifs();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtPersen.dispose();
    txtPenghasilan.dispose();
    super.onClose();
  }
}
