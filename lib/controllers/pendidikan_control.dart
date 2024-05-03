import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/pendidikan.dart';
import 'package:fjghrd/repositories/pendidikan_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class PendidikanControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final PendidikanRepository _repo = PendidikanRepository();

  List<Pendidikan> listPendidikan = [];

  late TextEditingController txtId, txtNama, txtUrutan;

  Future<void> loadPendidikans() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listPendidikan.clear();
      for (var data in hasil.daftar) {
        listPendidikan.add(Pendidikan.fromMap(data));
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  void tambahForm() {
    txtId.text = 'Otomatis';
    txtNama.text = '';
    txtUrutan.text = '';
    AFwidget.dialog(
      Container(
        padding: const EdgeInsets.all(20),
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            const Text('Form Tambah Pendidikan',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(height: 11),
            // Row(
            //   children: [
            //     Container(
            //       width: 100,
            //       padding: const EdgeInsets.only(right: 15),
            //       child: const Text('ID'),
            //     ),
            //     Expanded(
            //       child: AFwidget.textField(
            //         marginTop: 0,
            //         controller: txtId,
            //         readOnly: true,
            //       ),
            //     )
            //   ],
            // ),
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
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void ubahForm(int idx) {
    Pendidikan item = listPendidikan[idx];
    txtId.text = item.id;
    txtNama.text = item.nama;
    txtUrutan.text = item.urutan.toString();
    AFwidget.dialog(
      Container(
        padding: const EdgeInsets.all(20),
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            const Text('Form Ubah Pendidikan',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(height: 11),
            // Row(
            //   children: [
            //     Container(
            //       width: 100,
            //       padding: const EdgeInsets.only(right: 15),
            //       child: const Text('ID'),
            //     ),
            //     Expanded(
            //       child: AFwidget.textField(
            //         marginTop: 0,
            //         controller: txtId,
            //         readOnly: true,
            //       ),
            //     )
            //   ],
            // ),
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
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void hapusForm(int idx) {
    Pendidikan item = listPendidikan[idx];
    AFwidget.formHapus(
      label: 'pendidikan ${item.nama}',
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

      var a = Pendidikan(
        nama: txtNama.text,
        urutan: AFconvert.keInt(txtUrutan.text),
      );

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadPendidikans();
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

      var a = Pendidikan(
        id: txtId.text,
        nama: txtNama.text,
        urutan: AFconvert.keInt(txtUrutan.text),
      );

      AFwidget.loading();
      var hasil = await _repo.update(a.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadPendidikans();
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
        throw 'ID Pendidikan null';
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadPendidikans();
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
