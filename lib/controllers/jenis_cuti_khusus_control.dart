import 'package:fjghrd/models/jenis_cuti_khusus.dart';
import 'package:fjghrd/repositories/jenis_cuti_khusus_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class JenisCutiKhususControl extends GetxController {
  final JenisCutiKhususRepository _repo = JenisCutiKhususRepository();

  List<JenisCutiKhusus> listJenisCuti = [];

  late TextEditingController txtId, txtNama, txtLamaHari, txtSatuan, txtUrutan;

  Future<void> loadJenisCuti() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listJenisCuti.clear();
      for (var data in hasil.daftar) {
        listJenisCuti.add(JenisCutiKhusus.fromMap(data));
      }
      update();
    }
  }

  void inputForm(String id) {
    JenisCutiKhusus item = id == ''
        ? JenisCutiKhusus()
        : listJenisCuti.where((e) => e.id == id).first;

    txtId.text = item.id;
    txtNama.text = item.nama;
    txtLamaHari.text = item.lamaHari == 0 ? '' : item.lamaHari.toString();
    txtSatuan.text = item.satuan;
    txtUrutan.text = item.urutan == 0 ? '' : item.urutan.toString();

    AFwidget.dialog(
      Container(
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: GetBuilder<JenisCutiKhususControl>(
          builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AFwidget.formHeader('Form ${item.id == '' ? 'Tambah' : 'Ubah'} Jenis Cuti Khusus'),
            AFwidget.barisText(
              label: 'Nama',
              controller: txtNama,
            ),
            AFwidget.barisText(
              label: 'Lama Hari',
              controller: txtLamaHari,
              isNumber: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
              child: Row(
                children: [
                  const SizedBox(width: 150, child: Text('Satuan')),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: txtSatuan.text == '' ? 'hari' : txtSatuan.text,
                      items: const [
                        DropdownMenuItem(value: 'hari', child: Text('Hari')),
                        DropdownMenuItem(value: 'bulan', child: Text('Bulan')),
                      ],
                      onChanged: (val) {
                        txtSatuan.text = val ?? 'hari';
                        update();
                      },
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                  item.id == ''
                      ? Container()
                      : AFwidget.tombol(
                          label: 'Hapus Data',
                          color: Colors.red,
                          onPressed: () {
                            hapusData(item.id);
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
                    onPressed: simpanData,
                    minimumSize: const Size(120, 40),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
      barrierDismissible: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
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
        satuan: txtSatuan.text,
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

  @override
  void onInit() {
    txtId = TextEditingController();
    txtNama = TextEditingController();
    txtLamaHari = TextEditingController();
    txtSatuan = TextEditingController();
    txtUrutan = TextEditingController();
    super.onInit();
    loadJenisCuti();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtNama.dispose();
    txtLamaHari.dispose();
    txtSatuan.dispose();
    txtUrutan.dispose();
    super.onClose();
  }
}
