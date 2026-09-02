import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/models/keluarga_kontak.dart';

extension KontakFormExt on KaryawanControl {
  void kontakForm(String id, BuildContext context) {
    KeluargaKontak item = KeluargaKontak();
    if (id != '') item = listKontak.where((element) => element.id == id).first;
    txtKontakId.text = item.id;
    txtKontakNama.text = item.nama;
    txtKontakTelepon.text = item.telepon;
    txtKontakEmail.text = item.email;
    AFwidget.dialog(
      Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Stack(
          children: [
            ListView(
              children: [
                AFwidget.barisInfo(
                  label: 'Nama Karyawan',
                  nilai: current.nama,
                  paddingTop: 70,
                ),
                AFwidget.barisText(
                  label: 'No. Telepon',
                  controller: txtKontakTelepon,
                ),
                AFwidget.barisText(
                  label: 'Keterangan',
                  controller: txtKontakNama,
                ),
                AFwidget.barisText(
                  label: 'Email Pribadi',
                  controller: txtKontakEmail,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                  child: Row(
                    children: [
                      id != '' ? AFwidget.tombol(
                        label: 'Hapus',
                        color: Colors.red,
                        onPressed: () {
                          hapusKontakForm(item);
                        },
                        minimumSize: const Size(120, 40),
                      ) : Container(),
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
                        onPressed: simpanKontakData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AFwidget.formHeader('Form ${id == '' ? 'Tambah' : 'Ubah'} Kontak Keluarga'),
          ],
        ),
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }
}
