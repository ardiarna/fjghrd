import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/medical_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
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
                      ),
                      AFwidget.barisText(
                        label: 'Keterangan',
                        controller: controller.txtKeterangan,
                        isTextArea: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                              onPressed: controller.tambahData,
                              minimumSize: const Size(120, 40),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AFwidget.formHeader(
                    'Form Tambah Medical - ${controller.bulan.label} ${controller.tahun.label}',
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
              child: GetBuilder<MedicalControl>(
                builder: (_) {
                  if(controller.jenis.value == 'R') {
                    controller.tunjangan = controller.karyawan.kelamin == 'L' ? controller.medicalRekap.gaji*2 : controller.medicalRekap.gaji;
                    controller.jumlahKlaim = controller.medicalRekap.bln1 + controller.medicalRekap.bln2 + controller.medicalRekap.bln3 +
                        controller.medicalRekap.bln4 + controller.medicalRekap.bln5 + controller.medicalRekap.bln6 +
                        controller.medicalRekap.bln7 + controller.medicalRekap.bln8 + controller.medicalRekap.bln9 +
                        controller.medicalRekap.bln10 + controller.medicalRekap.bln11 + controller.medicalRekap.bln12;
                    controller.sisaTunjangan = controller.tunjangan - controller.jumlahKlaim;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Nama controller.karyawan:'),
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
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('History:'),
                        const SizedBox(height: 10),
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
  controller.bulan = Opsi(value: controller.filterBulan.value, label: controller.filterBulan.label);
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
