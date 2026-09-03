import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/cuti_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/models/opsi.dart';
import 'package:fjghrd/models/jatah_cuti_tahunan.dart';

class JatahCutiTahunanForm extends StatelessWidget {
  const JatahCutiTahunanForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CutiControl>();
    return Container(
      width: 700,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AFwidget.formHeader('Form Jatah Cuti Tahunan'),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
            child: Row(
              children: [
                SizedBox(width: 150, child: const Text('Karyawan')),
                Expanded(
                  child: GetBuilder<CutiControl>(
                    id: 'total_jatah',
                    builder: (ctrl) {
                      return AFwidget.comboField(
                        value: ctrl.selectedKaryawanJatah?.label ?? '',
                        label: '',
                        onTap: () async {
                          var a = await ctrl.pilihKaryawan(value: ctrl.selectedKaryawanJatah?.value ?? '');
                          if (a != null) {
                            ctrl.selectedKaryawanJatah = a;
                            ctrl.update(['total_jatah']);
                            await ctrl.hitungSisaJatah();
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
            child: Row(
              children: [
                SizedBox(width: 150, child: const Text('Tahun')),
                Expanded(
                  child: GetBuilder<CutiControl>(
                    id: 'total_jatah',
                    builder: (ctrl) {
                      return AFwidget.comboField(
                        value: ctrl.selectedTahunFormJatah?.label ?? '',
                        label: '',
                        onTap: () async {
                          var a = await ctrl.pilihTahun(value: ctrl.selectedTahunFormJatah?.value ?? '');
                          if (a != null) {
                            ctrl.selectedTahunFormJatah = a;
                            ctrl.update(['total_jatah']);
                            await ctrl.hitungSisaJatah();
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          AFwidget.barisText(label: 'Jumlah Cuti', controller: controller.txtJatahJumlahCuti, isNumber: true),
          AFwidget.barisText(label: '+ Tahun Lalu', controller: controller.txtPlusTahunLalu, isNumber: true),
          AFwidget.barisText(label: '- Tahun Lalu', controller: controller.txtMinTahunLalu, isNumber: true),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Total Cuti', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(width: 20),
                  GetBuilder<CutiControl>(
                    id: 'total_jatah',
                    builder: (ctrl) {
                      return Text('${ctrl.totalCutiJatah}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.blue));
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: Row(
              children: [
                GetBuilder<CutiControl>(
                    id: 'total_jatah',
                  builder: (ctrl) {
                    return Checkbox(
                      value: ctrl.cekJatahBolehMinus,
                      onChanged: (val) {
                        ctrl.cekJatahBolehMinus = val ?? false;
                        ctrl.update(['total_jatah']);
                      },
                    );
                  },
                ),
                const Expanded(child: Text('Boleh memakai jatah cuti tahun depan (Boleh Minus) ?', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                controller.txtJatahId.text == '' ? Container() : AFwidget.tombol(
                  label: 'Hapus Data', color: Colors.red,
                  onPressed: () { 
                    AFwidget.formHapus(
                      label: 'data jatah cuti tahunan ini',
                      aksi: () {
                        controller.hapusJatah(controller.txtJatahId.text);
                      },
                    );
                  },
                  minimumSize: const Size(120, 40),
                ),
                const Spacer(),
                AFwidget.tombol(label: 'Batal', color: Colors.orange, onPressed: Get.back, minimumSize: const Size(120, 40)),
                const SizedBox(width: 40),
                AFwidget.tombol(label: 'Simpan', color: Colors.blue, onPressed: controller.simpanJatah, minimumSize: const Size(120, 40)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showJatahCutiTahunanForm(String id, {String? defaultKaryawanId, String? defaultKaryawanNama, String? defaultTahun}) {
  final controller = Get.find<CutiControl>();
  JatahCutiTahunan item = id == ''
      ? JatahCutiTahunan()
      : controller.listJatah.where((e) => e.id == id).first;

  controller.txtJatahId.text = item.id;
  controller.txtJatahJumlahCuti.text = item.jumlahCuti == 0 ? '' : item.jumlahCuti.toString();
  controller.txtPlusTahunLalu.text = (item.id == '' || item.plusTahunLalu == 0) ? '' : item.plusTahunLalu.toString();
  controller.txtMinTahunLalu.text = (item.id == '' || item.minTahunLalu == 0) ? '' : item.minTahunLalu.toString();
  controller.cekJatahBolehMinus = item.bolehMinus == 'Y';

  if (id != '' && item.karyawan != null) {
    controller.selectedKaryawanJatah = Opsi(
      value: item.karyawanId,
      label: item.karyawan!.nama,
    );
  } else if (defaultKaryawanId != null && defaultKaryawanNama != null) {
    controller.selectedKaryawanJatah = Opsi(value: defaultKaryawanId, label: defaultKaryawanNama);
  } else {
    controller.selectedKaryawanJatah = null;
  }

  if (id != '' && item.tahun.isNotEmpty) {
    controller.selectedTahunFormJatah = Opsi(value: item.tahun, label: item.tahun);
  } else if (defaultTahun != null) {
    controller.selectedTahunFormJatah = Opsi(value: defaultTahun, label: defaultTahun);
  } else {
    controller.selectedTahunFormJatah = controller.filterTahun;
  }

  if (id == '' && controller.selectedKaryawanJatah != null && controller.selectedTahunFormJatah != null) {
      controller.hitungSisaJatah();
  }

  AFwidget.dialog(
    const JatahCutiTahunanForm(),
    barrierDismissible: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
