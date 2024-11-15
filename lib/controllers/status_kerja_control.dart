import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/status_kerja.dart';
import 'package:fjghrd/repositories/status_kerja_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatusKerjaControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final StatusKerjaRepository _repo = StatusKerjaRepository();

  List<StatusKerja> listStatusKerja = [];

  late TextEditingController txtId, txtNama, txtUrutan;

  Future<void> loadStatusKerjas() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listStatusKerja.clear();
      for (var data in hasil.daftar) {
        listStatusKerja.add(StatusKerja.fromMap(data));
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  void inputForm(String id) {
    StatusKerja item = id == '' ? StatusKerja() : listStatusKerja.where((element) => element.id == id).first;
    txtId.text = item.id;
    txtNama.text = item.nama;
    txtUrutan.text = item.urutan.toString();
    AFwidget.dialog(
      Container(
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Form ${id == '' ? 'Tambah' : 'Ubah'} Status Karyawan'),
            AFwidget.barisText(
              label: 'Nama',
              controller: txtNama,
            ),
            AFwidget.barisText(
              label: 'Urutan',
              controller: txtUrutan,
              isNumber: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  id == '' ? Container() :
                  AFwidget.tombol(
                    label: 'Hapus Data',
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
                    onPressed: id == '' ? tambahData : ubahData,
                    minimumSize: const Size(120, 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void hapusForm(StatusKerja item) {
    AFwidget.formHapus(
      label: 'status_kerja ${item.nama}',
      aksi: () {
        hapusData(item.id);
      },
    );
  }

  Future<void> tambahData() async {
    try {
      if(txtNama.text.isEmpty) {
        throw 'Nama harus diisi';
      }
      if(txtUrutan.text.isEmpty) {
        throw 'Urutan harus diisi';
      }

      var a = StatusKerja(
        nama: txtNama.text,
        urutan: AFconvert.keInt(txtUrutan.text),
      );

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadStatusKerjas();
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
        throw 'ID harus diisi';
      }
      if(txtNama.text.isEmpty) {
        throw 'Nama harus diisi';
      }
      if(txtUrutan.text.isEmpty) {
        throw 'Urutan harus diisi';
      }

      var a = StatusKerja(
        id: txtId.text,
        nama: txtNama.text,
        urutan: AFconvert.keInt(txtUrutan.text),
      );

      AFwidget.loading();
      var hasil = await _repo.update(a.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadStatusKerjas();
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
        throw 'ID StatusKerja null';
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadStatusKerjas();
        Get.back();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  @override
  void onInit() {
    txtId = TextEditingController();
    txtNama = TextEditingController();
    txtUrutan = TextEditingController();
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
