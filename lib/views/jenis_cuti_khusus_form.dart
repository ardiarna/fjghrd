import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/jenis_cuti_khusus_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/models/jenis_cuti_khusus.dart';

class JenisCutiKhususForm extends StatelessWidget {
  const JenisCutiKhususForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JenisCutiKhususControl>();
    return Container(
      width: 700,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: GetBuilder<JenisCutiKhususControl>(
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AFwidget.formHeader('Form ${controller.txtId.text == '' ? 'Tambah' : 'Ubah'} Jenis Cuti Khusus'),
            AFwidget.barisText(
              label: 'Nama',
              controller: controller.txtNama,
            ),
            AFwidget.barisText(
              label: 'Lama Hari',
              controller: controller.txtLamaHari,
              isNumber: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
              child: Row(
                children: [
                  const SizedBox(width: 150, child: Text('Satuan')),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: controller.txtSatuan.text == '' ? 'hari' : controller.txtSatuan.text,
                      items: const [
                        DropdownMenuItem(value: 'hari', child: Text('Hari')),
                        DropdownMenuItem(value: 'bulan', child: Text('Bulan')),
                      ],
                      onChanged: (val) {
                        controller.txtSatuan.text = val ?? 'hari';
                        controller.update();
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
              controller: controller.txtUrutan,
              isNumber: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  controller.txtId.text == ''
                      ? Container()
                      : AFwidget.tombol(
                          label: 'Hapus Data',
                          color: Colors.red,
                          onPressed: () {
                            AFwidget.formHapus(
                              label: 'data jenis cuti khusus ini',
                              aksi: () {
                                controller.hapusData(controller.txtId.text);
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
      ),
    );
  }
}

void showJenisCutiKhususForm(String id) {
  final controller = Get.find<JenisCutiKhususControl>();
  JenisCutiKhusus item = id == ''
      ? JenisCutiKhusus()
      : controller.listJenisCuti.where((e) => e.id == id).first;

  controller.txtId.text = item.id;
  controller.txtNama.text = item.nama;
  controller.txtLamaHari.text = item.lamaHari == 0 ? '' : item.lamaHari.toString();
  controller.txtSatuan.text = item.satuan;
  controller.txtUrutan.text = item.urutan == 0 ? '' : item.urutan.toString();

  AFwidget.dialog(
    const JenisCutiKhususForm(),
    barrierDismissible: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
