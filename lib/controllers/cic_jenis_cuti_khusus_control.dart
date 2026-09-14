import 'package:fjghrd/models/jenis_cuti_khusus.dart';
import 'package:fjghrd/repositories/cic_jenis_cuti_khusus_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class CicJenisCutiKhususControl extends GetxController {
  final AuthControl authControl = Get.find<AuthControl>();
  final CicJenisCutiKhususRepository _repo = CicJenisCutiKhususRepository();

  RxList<JenisCutiKhusus> listJenisCuti = <JenisCutiKhusus>[].obs;

  Opsi satuan = Opsi(value: 'hari', label: 'Hari');

  late TextEditingController txtId, txtNama, txtLamaHari, txtUrutan;

  Future<void> loadJenisCuti() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      List<JenisCutiKhusus> tempList = [];
      for (var data in hasil.daftar) {
        tempList.add(JenisCutiKhusus.fromMap(data));
      }
      listJenisCuti.assignAll(tempList);
    }
  }

  Future<void> simpanData() async {
    try {
      if (txtNama.text.isEmpty) {
        throw ValidationException('Nama harus diisi');
      }
      if (txtLamaHari.text.isEmpty) {
        throw ValidationException('Lama hari harus diisi');
      }
      if (txtUrutan.text.isEmpty) {
        throw ValidationException('Urutan harus diisi');
      }

      var item = JenisCutiKhusus(
        id: txtId.text,
        nama: txtNama.text,
        lamaHari: AFconvert.keInt(txtLamaHari.text),
        satuan: satuan.value,
        urutan: AFconvert.keInt(txtUrutan.text),
      );

      AFwidget.loading();
      var hasil = item.id == ''
          ? await _repo.create(item.toMap())
          : await _repo.update(item.id, item.toMap());
      Get.back();
      if (hasil.success) {
        loadJenisCuti();
        Get.back();
        authControl.cicMasterDataUpdateTrigger.value++;
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> hapusData(String id) async {
    AFwidget.formHapus(
      label: 'Jenis Cuti Khusus',
      aksi: () async {
        try {
          AFwidget.loading();
          var hasil = await _repo.delete(id);
          Get.back();
          if (hasil.success) {
            loadJenisCuti();
            Get.back();
            Get.back();
            authControl.cicMasterDataUpdateTrigger.value++;
        AFwidget.snackbar(hasil.message);
          } else {
            AFwidget.formWarning(label: hasil.message);
          }
        } catch (er) {
          AFwidget.formWarning(label: '$er');
        }
      },
    );
  }

    Future<Opsi?> pilihSatuan({String value = ''}) async {
    return await AFcombobox.bottomSheet(
      listOpsi: [
        Opsi(value: 'hari', label: 'Hari'),
        Opsi(value: 'bulan', label: 'Bulan'),
      ],
      valueSelected: value,
      judul: 'Pilih Satuan',
      withCari: false,
    );
  }

  @override
  void onInit() {
    txtId = TextEditingController();
    txtNama = TextEditingController();
    txtLamaHari = TextEditingController();
        txtUrutan = TextEditingController();
    super.onInit();
    loadJenisCuti();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtNama.dispose();
    txtLamaHari.dispose();
        txtUrutan.dispose();
    super.onClose();
  }
}
