import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/area.dart';
import 'package:fjghrd/repositories/area_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AreaControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final AreaRepository _repo = AreaRepository();

  List<Area> listArea = [];

  late TextEditingController txtId, txtKode, txtNama, txtUrutan;

  Future<void> loadAreas() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listArea.clear();
      for (var data in hasil.daftar) {
        listArea.add(Area.fromMap(data));
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
      Container(
        padding: const EdgeInsets.all(20),
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            const Text('Form Tambah Area',
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
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void ubahForm(String id) {
    var item = listArea.where((element) => element.id == id).first;
    txtId.text = item.id;
    txtKode.text = item.kode;
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
            const Text('Form Ubah Area',
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
                    hapusForm(item);
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

  void hapusForm(Area item) {
    AFwidget.formHapus(
      label: 'area ${item.nama}',
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

      var a = Area(
        kode: txtKode.text,
        nama: txtNama.text,
        urutan: AFconvert.keInt(txtUrutan.text),
      );

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadAreas();
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

      var a = Area(
        id: txtId.text,
        kode: txtKode.text,
        nama: txtNama.text,
        urutan: AFconvert.keInt(txtUrutan.text),
      );

      AFwidget.loading();
      var hasil = await _repo.update(a.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadAreas();
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
        throw 'ID Area null';
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadAreas();
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
