import 'package:flutter/material.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/cic_jenis_cuti_khusus_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/models/jenis_cuti_khusus.dart';

class CicJenisCutiKhususForm extends StatelessWidget {
  const CicJenisCutiKhususForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CicJenisCutiKhususControl>();
    return Container(
      width: 700,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: GetBuilder<CicJenisCutiKhususControl>(
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AFwidget.formHeader('Form ${controller.txtId.text == '' ? 'Tambah' : 'Ubah'} Jenis Cuti Khusus CIC'),
            AFwidget.barisText(
              label: 'Nama',
              controller: controller.txtNama,
            ),
            GetBuilder<CicJenisCutiKhususControl>(
              builder: (controller) {
                return AFwidget.barisText(
                  label: 'Lama Hari',
                  controller: controller.txtLamaHari,
                  isNumber: true,
                  decimalDigits: controller.satuan.value == 'bulan' ? 2 : 0,
                );
              }
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
              child: Row(
                children: [
                  const SizedBox(width: 150, child: Text('Satuan')),
                  Expanded(
                    child: GetBuilder<CicJenisCutiKhususControl>(
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.satuan.label,
                          label: '',
                          onTap: () async {
                            var res = await controller.pilihSatuan(value: controller.satuan.value);
                            if (res != null) {
                              controller.satuan = res;
                              controller.update();
                            }
                          }
                        );
                      }
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
                            controller.hapusData(controller.txtId.text);
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

void showCicJenisCutiKhususForm(String id) {
  final controller = Get.find<CicJenisCutiKhususControl>();
  JenisCutiKhusus item = id == ''
      ? JenisCutiKhusus()
      : controller.listJenisCuti.where((e) => e.id == id).first;

  controller.txtId.text = item.id;
  controller.txtNama.text = item.nama;
  controller.txtLamaHari.text = item.lamaHari == 0 ? '' : (item.lamaHari == item.lamaHari.toInt() ? item.lamaHari.toInt().toString() : item.lamaHari.toString());
  String sat = item.satuan == '' ? 'hari' : item.satuan;
  controller.satuan = Opsi(value: sat, label: sat == 'hari' ? 'Hari' : 'Bulan');
  controller.txtUrutan.text = item.urutan == 0 ? '' : item.urutan.toString();

  AFwidget.dialog(
    const CicJenisCutiKhususForm(),
    barrierDismissible: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
