import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/models/keluarga_kontak.dart';

class KontakForm extends StatelessWidget {
  final String id;
  const KontakForm({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KaryawanControl>();
    KeluargaKontak item = KeluargaKontak();
    if (id != '') item = controller.listKontak.where((element) => element.id == id).first;
    
    return Container(
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
                  nilai: controller.current.nama,
                  paddingTop: 70,
                ),
                AFwidget.barisText(
                  label: 'No. Telepon',
                  controller: controller.txtKontakTelepon,
                ),
                AFwidget.barisText(
                  label: 'Keterangan',
                  controller: controller.txtKontakNama,
                ),
                AFwidget.barisText(
                  label: 'Email Pribadi',
                  controller: controller.txtKontakEmail,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                  child: Row(
                    children: [
                      id != '' ? AFwidget.tombol(
                        label: 'Hapus',
                        color: Colors.red,
                        onPressed: () {
                          AFwidget.formHapus(
                            label: 'kontak keluarga ${item.telepon} (${item.nama})',
                            aksi: () {
                              controller.hapusKontakData(item.id);
                            },
                          );
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
                        onPressed: controller.simpanKontakData,
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
      );
  }
}

void showKontakForm(String id, BuildContext context) {
  final controller = Get.find<KaryawanControl>();
  KeluargaKontak item = KeluargaKontak();
  if (id != '') item = controller.listKontak.where((element) => element.id == id).first;
  controller.txtKontakId.text = item.id;
  controller.txtKontakNama.text = item.nama;
  controller.txtKontakTelepon.text = item.telepon;
  controller.txtKontakEmail.text = item.email;

  AFwidget.dialog(
    KontakForm(id: id),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
