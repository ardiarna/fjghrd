import 'package:fjghrd/controllers/ptkp_control.dart';
import 'package:fjghrd/models/ptkp.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PtkpForm extends StatelessWidget {
  final String id;
  const PtkpForm({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PtkpControl>();
    
    Ptkp item = id == '' ? Ptkp() : controller.listPtkp.where((element) => element.id == id).first;
    controller.txtId.text = item.id;
    controller.txtKode.text = item.kode;
    controller.txtJumlah.text = AFconvert.matNumber(item.jumlah);
    controller.kategoriTER.value = item.ter;
    return Container(
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Form ${item.id == '' ? 'Tambah' : 'Ubah'} PTKP'),
            AFwidget.barisText(
              label: 'Kode',
              controller: controller.txtKode,
            ),
            AFwidget.barisText(
              label: 'Jumlah',
              controller: controller.txtJumlah,
              isNumber: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text('Kategori TER'),
                  ),
                  Expanded(
                    child: Obx(() {
                        return RadioGroup<String>(
                          groupValue: controller.kategoriTER.value,
                          onChanged: (a) {
                            if (a != null && a != controller.kategoriTER.value) {
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
      label: 'PTKP ${item.kode}',
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

void showPtkpForm(String id) {
  AFwidget.dialog(
    PtkpForm(id: id),
    barrierDismissible: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
