import 'package:fjghrd/controllers/tarif_efektif_control.dart';
import 'package:fjghrd/models/tarif_efektif.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TarifEfektifForm extends StatelessWidget {
  final String id;
  const TarifEfektifForm({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TarifEfektifControl>();
    TarifEfektif item = id == '' ? TarifEfektif() : controller.listTarifEfektif.firstWhere((element) => element.id == id, orElse: () => TarifEfektif());
    
    controller.txtId.text = item.id;
    controller.txtPersen.text = item.persen.toString();
    controller.txtPenghasilan.text = AFconvert.matNumber(item.penghasilan);
    controller.kategoriTER.value = item.ter;
    
    return Container(
      width: 700,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AFwidget.formHeader('Form ${item.id == '' ? 'Tambah' : 'Ubah'} TER'),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
            child: Row(
              children: [
                const SizedBox(
                  width: 150,
                  child: Text('Kategori TER'),
                ),
                Expanded(
                  child: Obx(
                    () {
                      return RadioGroup<String>(
                        groupValue: controller.kategoriTER.value,
                        onChanged: (a) {
                          if(a != null && a != controller.kategoriTER.value) {
                            controller.kategoriTER.value = a;
                          }
                        },
                        child: Row(
                          children: const [
                            Radio<String>(value: 'A'),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                              child: Text('TER A'),
                            ),
                            Radio<String>(value: 'B'),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                              child: Text('TER B'),
                            ),
                            Radio<String>(value: 'C'),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Text('TER C'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          AFwidget.barisText(
            label: 'Penghasilan',
            controller: controller.txtPenghasilan,
            isNumber: true,
          ),
          AFwidget.barisText(
            label: 'Tarif Pajak (%)',
            controller: controller.txtPersen,
            isNumber: true,
            decimalDigits: 2,
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
                      label: 'TER ${item.ter} penghasilan Rp. ${AFconvert.matNumber(item.penghasilan)}',
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

void showTarifEfektifForm(String id) {
  AFwidget.dialog(
    TarifEfektifForm(id: id),
    barrierDismissible: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}

