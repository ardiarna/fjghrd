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

  void tambahForm() {
    txtId.text = 'Otomatis';
    txtKode.text = '';
    txtNama.text = '';
    txtUrutan.text = '';
    AFwidget.dialog(
      SizedBox(
        width: 700,
        child: Column(
          children: [
            const Text('Form Tambah Divisi',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.only(right: 15),
                  child: const Text('ID'),
                ),
                Expanded(
                  child: AFwidget.textField(
                    marginTop: 0,
                    controller: txtId,
                    readOnly: true,
                  ),
                )
              ],
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.only(right: 15),
                  child: const Text('Kode'),
                ),
                Expanded(
                  child: AFwidget.textField(
                    marginTop: 0,
                    controller: txtKode,
                  ),
                )
              ],
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.only(right: 15),
                  child: const Text('Nama'),
                ),
                Expanded(
                  child: AFwidget.textField(
                    marginTop: 0,
                    controller: txtNama,
                  ),
                )
              ],
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.only(right: 15),
                  child: const Text('Urutan'),
                ),
                Expanded(
                  child: AFwidget.textField(
                    marginTop: 0,
                    controller: txtUrutan,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AFwidget.tombol(
                  label: 'Simpan',
                  color: Colors.blue,
                  onPressed: tambahData,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void ubahForm(int idx) {
    Divisi item = listDivisi[idx];
    txtId.text = item.id;
    txtKode.text = item.kode;
    txtNama.text = item.nama;
    txtUrutan.text = item.urutan.toString();
    AFwidget.dialog(
      SizedBox(
        width: 700,
        child: Column(
          children: [
            const Text('Form Ubah Divisi',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.only(right: 15),
                  child: const Text('ID'),
                ),
                Expanded(
                  child: AFwidget.textField(
                    marginTop: 0,
                    controller: txtId,
                    readOnly: true,
                  ),
                )
              ],
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.only(right: 15),
                  child: const Text('Kode'),
                ),
                Expanded(
                  child: AFwidget.textField(
                    marginTop: 0,
                    controller: txtKode,
                  ),
                )
              ],
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.only(right: 15),
                  child: const Text('Nama'),
                ),
                Expanded(
                  child: AFwidget.textField(
                    marginTop: 0,
                    controller: txtNama,
                  ),
                )
              ],
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.only(right: 15),
                  child: const Text('Urutan'),
                ),
                Expanded(
                  child: AFwidget.textField(
                    marginTop: 0,
                    controller: txtUrutan,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AFwidget.tombol(
                  label: 'Hapus Data',
                  color: Colors.red,
                  onPressed: () {
                    hapusForm(idx);
                  },
                ),
                AFwidget.tombol(
                  label: 'Simpan',
                  color: Colors.blue,
                  onPressed: ubahData,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void hapusForm(int idx) {
    Divisi item = listDivisi[idx];
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
