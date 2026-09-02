import 'package:fjghrd/controllers/jabatan_control.dart';
import 'package:fjghrd/models/jabatan.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JabatanForm extends StatelessWidget {
  final String id;
  const JabatanForm({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JabatanControl>();
    
    Jabatan item = id == '' ? Jabatan() : controller.listJabatan.where((element) => element.id == id).first;
    controller.txtId.text = item.id;
    controller.txtNama.text = item.nama;
    controller.txtUrutan.text = item.urutan.toString();
    return Container(
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Form ${item.id == '' ? 'Tambah' : 'Ubah'} Jabatan'),
            AFwidget.barisText(
              label: 'Nama',
              controller: controller.txtNama,
            ),
            AFwidget.barisText(
              label: 'Urutan',
              controller: controller.txtUrutan,
              isNumber: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  item.id == '' ? Container() :
                  AFwidget.tombol(
                    label: 'Hapus Data',
                    color: Colors.red,
                    onPressed: () {
                      AFwidget.formHapus(
      label: 'jabatan ${item.nama}',
      aksi: () {
        controller.hapusData(item.id);
      },
    );
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
                    onPressed: controller.simpanData,
                    minimumSize: const Size(120, 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  
  }
}

void showJabatanForm(String id) {
  AFwidget.dialog(
    JabatanForm(id: id),
    barrierDismissible: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
