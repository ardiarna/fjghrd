import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/divisi.dart';
import 'package:fjghrd/repositories/divisi_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DivisiControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final DivisiRepository _repo = DivisiRepository();

  List<Divisi> listDivisi = [];

  late TextEditingController txtId, txtKode, txtNama, txtUrutan;

  Future<void> loadDivisis() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listDivisi.clear();
      for (var data in hasil.daftar) {
        listDivisi.add(Divisi.fromMap(data));
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  void inputForm(String id) {
    var item = id == '' ? Divisi() : listDivisi.where((element) => element.id == id).first;
    txtId.text = item.id;
    txtKode.text = item.kode;
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
            AFwidget.formHeader('Form ${id == '' ? 'Tambah' : 'Ubah'} Divisi'),
            AFwidget.barisText(
              label: 'Kode',
              controller: txtKode,
            ),
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

  void hapusForm(Divisi item) {
    AFwidget.formHapus(
      label: 'divisi ${item.nama}',
      aksi: () {
        hapusData(item.id);
      },
    );
  }

  Future<void> tambahData() async {
    try {
      if(txtKode.text.isEmpty) {
        throw 'Kode harus diisi';
      }
      if(txtNama.text.isEmpty) {
        throw 'Nama harus diisi';
      }
      if(txtUrutan.text.isEmpty) {
        throw 'Urutan harus diisi';
      }

      var a = Divisi(
        kode: txtKode.text,
        nama: txtNama.text,
        urutan: AFconvert.keInt(txtUrutan.text),
      );

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadDivisis();
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
      if(txtKode.text.isEmpty) {
        throw 'Kode harus diisi';
      }
      if(txtNama.text.isEmpty) {
        throw 'Nama harus diisi';
      }
      if(txtUrutan.text.isEmpty) {
        throw 'Urutan harus diisi';
      }

      var a = Divisi(
        id: txtId.text,
        kode: txtKode.text,
        nama: txtNama.text,
        urutan: AFconvert.keInt(txtUrutan.text),
      );

      AFwidget.loading();
      var hasil = await _repo.update(a.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadDivisis();
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
        throw 'ID Divisi null';
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadDivisis();
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
    txtKode = TextEditingController();
    txtNama = TextEditingController();
    txtUrutan = TextEditingController();
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
