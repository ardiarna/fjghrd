import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/medical_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/models/opsi.dart';
import 'package:fjghrd/models/karyawan.dart';

class MedicalTambahForm extends StatelessWidget {
  const MedicalTambahForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MedicalControl>();
    return Container(
        width: Get.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
                        child: Row(
                          children: [
                            Container(
                              width: 150,
                              padding: const EdgeInsets.only(right: 15),
                              child: const Text('Periode'),
                            ),
                            Expanded(
                              child: GetBuilder<MedicalControl>(
                                id: 'form_medical',
                                builder: (_) {
                                  return AFwidget.comboField(
                                    value: controller.bulan.label,
                                    label: '',
                                    onTap: () async {
                                      var a = await controller.pilihBulan(value: controller.bulan.value);
                                      if(a != null && a.value != controller.bulan.value) {
                                        controller.bulan = a;
                                        controller.update(['form_medical']);
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: GetBuilder<MedicalControl>(
                                id: 'form_medical',
                                builder: (_) {
                                  return AFwidget.comboField(
                                    value: controller.tahun.label,
                                    label: '',
                                    onTap: () async {
                                      var a = await controller.pilihTahun(value: controller.tahun.value);
                                      if(a != null && a.value != controller.tahun.value) {
                                        controller.tahun = a;
                                        controller.update(['form_medical']);
                                        if (controller.jenis.value == 'R') controller.loadInfoMedical();
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
                            Container(
                              width: 150,
                              padding: const EdgeInsets.only(right: 15),
                              child: const Text('Jenis Medical'),
                            ),
                            Expanded(
                              child: GetBuilder<MedicalControl>(
                                id: 'form_medical',
                                builder: (_) {
                                  return AFwidget.comboField(
                                    value: controller.jenis.label,
                                    label: '',
                                    onTap: () async {
                                      var a = await controller.pilihJenis(value: controller.jenis.value);
                                      if(a != null && a.value != controller.jenis.value) {
                                        controller.jenis = a;
                                        controller.update(['form_medical']);
                                        controller.loadInfoMedical();
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
                            Container(
                              width: 150,
                              padding: const EdgeInsets.only(right: 15),
                              child: const Text('Karyawan'),
                            ),
                            Expanded(
                              child: GetBuilder<MedicalControl>(
                                id: 'form_medical',
                                builder: (_) {
                                  return AFwidget.comboField(
                                    value: controller.karyawan.nama,
                                    label: '',
                                    onTap: () async {
                                      var a = await controller.pilihKaryawan(value: controller.karyawan.id);
                                      if(a != null && a.value != controller.karyawan.id) {
                                        controller.karyawan = Karyawan.fromMap(a.data!);
                                        controller.update(['form_medical']);
                                        controller.loadInfoMedical();
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      AFwidget.barisText(
                        label: 'Jumlah',
                        controller: controller.txtJumlah,
                        isNumber: true,
                        onchanged: (v) => controller.update(['form_medical']),
                      ),
                      AFwidget.barisText(
                        label: 'Keterangan',
                        controller: controller.txtKeterangan,
                        isTextArea: true,
                      ),
                      GetBuilder<MedicalControl>(
                        id: 'form_medical',
                        builder: (_) {
                          String msg = controller.pesanValidasi;
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                            child: Row(
                              children: [
                                if(msg.isNotEmpty)
                                  Expanded(
                                    child: Text(msg, style: const TextStyle(color: Colors.red, fontStyle: FontStyle.italic)),
                                  ),
                                if(msg.isEmpty) const Spacer(),
                                AFwidget.tombol(
                                  label: 'Batal',
                                  color: Colors.orange,
                                  onPressed: Get.back,
                                  minimumSize: const Size(120, 40),
                                ),
                                const SizedBox(width: 40),
                                AFwidget.tombol(
                                  label: 'Simpan',
                                  color: msg.isEmpty ? Colors.blue : Colors.grey,
                                  onPressed: msg.isEmpty ? controller.tambahData : null,
                                  minimumSize: const Size(120, 40),
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                  AFwidget.formHeader(
                    'Form Tambah Medical',
                    radiusRight: false,
                  ),
                ],
              ),
            ),
            Container(
              width: 200,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: GetBuilder<MedicalControl>(id: 'info_medical',
                builder: (_) {
                  if(controller.jenis.value == 'R') {
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Nama Karyawan:'),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 5, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(controller.karyawan.nama),
                        ),
                        const Text('Gaji:'),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 5, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(AFconvert.matNumber(controller.medicalRekap.gaji)),
                        ),
                        const Text('Tunjangan:'),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 5, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(AFconvert.matNumber(controller.tunjangan)),
                        ),
                        const Text('Jumlah Klaim:'),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 5, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(AFconvert.matNumber(controller.jumlahKlaim)),
                        ),
                        const Text('Sisa IDR:'),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 5, bottom: 15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(AFconvert.matNumber(controller.sisaTunjangan)),
                        ),
                      ],
                    );
                  } else {
                    String jenisLabel = '';
                    if (controller.jenis.value == 'K') { jenisLabel = 'kacamata'; }
                    else if (controller.jenis.value == 'I') { jenisLabel = 'melahirkan'; }
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('History:'),
                        const SizedBox(height: 10),
                        if (controller.medicalHistory.isEmpty && jenisLabel.isNotEmpty && controller.karyawan.id.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 5, top: 10),
                            child: Text(
                              'Tidak ada history medical $jenisLabel',
                              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                            ),
                          )
                        else
                          Expanded(
                            child: ListView.builder(
                            itemCount: controller.medicalHistory.length,
                            itemBuilder: (_, i) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(left: 5, bottom: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AFconvert.matMonthYear(controller.medicalHistory[i].tanggal)),
                                    Text('Rp. ${AFconvert.matNumber(controller.medicalHistory[i].jumlah)}'),
                                    Text(controller.medicalHistory[i].keterangan),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
  }
}


void showMedicalTambahForm(BuildContext context) {
  final controller = Get.find<MedicalControl>();
  controller.txtId.text = '';
    controller.tahun = Opsi(value: controller.filterTahun.value, label: controller.filterTahun.label);
  if(controller.filterBulan.value == '') {
    DateTime now = DateTime.now();
    controller.bulan = Opsi(value: now.month.toString(), label: mapBulan[now.month] ?? '');
  } else {
    controller.bulan = Opsi(value: controller.filterBulan.value, label: controller.filterBulan.label);
  }

  controller.txtKeterangan.text = '';
  controller.txtJumlah.text = '';
  controller.karyawan = Karyawan();
  if(controller.filterJenis.value == '') {
    controller.jenis = Opsi(value: '', label: '');
  } else {
    controller.jenis = Opsi(value: controller.filterJenis.value, label: controller.filterJenis.label);
  }
  AFwidget.dialog(
    const MedicalTambahForm(),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
