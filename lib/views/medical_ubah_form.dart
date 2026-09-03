import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/medical_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/models/opsi.dart';

class MedicalUbahForm extends StatelessWidget {
  const MedicalUbahForm({super.key});

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
                      AFwidget.barisInfo(
                        label: 'Nama Karyawan',
                        nilai: controller.karyawan.nama,
                        paddingTop: 70,
                      ),
                      AFwidget.barisInfo(
                        label: 'Jabatan',
                        nilai: controller.karyawan.jabatan.nama,
                      ),
                      AFwidget.barisInfo(
                        label: 'Masa Kerja',
                        nilai: AFconvert.matDate(controller.karyawan.tanggalMasuk),
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
                                    onTap: null,
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
                              child: const Text('Periode'),
                            ),
                            Expanded(
                              child: GetBuilder<MedicalControl>(
                                id: 'form_medical',
                                builder: (_) {
                                  return AFwidget.comboField(
                                    value: controller.bulan.label,
                                    label: '',
                                    onTap: null,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 40),
                            Expanded(
                              child: GetBuilder<MedicalControl>(
                                id: 'form_medical',
                                builder: (_) {
                                  return AFwidget.comboField(
                                    value: controller.tahun.label,
                                    label: '',
                                    onTap: null,
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AFwidget.tombol(
                              label: 'Hapus',
                              color: Colors.red,
                              onPressed: () {
                                AFwidget.formHapus(label: 'data medical ini', aksi: () { controller.hapusData(controller.txtId.text); });
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
                              onPressed: controller.ubahData,
                              minimumSize: const Size(120, 40),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AFwidget.formHeader(
                    'Form Ubah Medical',
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


void showMedicalUbahForm(String id, BuildContext context) {
  final controller = Get.find<MedicalControl>();
  var item = controller.listMedical.where((element) => element.id == id).first;
  controller.txtId.text = item.id;
  controller.tahun = Opsi(value: '${item.tahun}', label: '${item.tahun}');
  controller.bulan = Opsi(value: '${item.bulan}', label: mapBulan[item.bulan]!);
  controller.txtKeterangan.text = item.keterangan;
  controller.txtJumlah.text = AFconvert.matNumber(item.jumlah);
  controller.karyawan = item.karyawan;
  controller.jenis = controller.listJenis.where((element) => element.value == item.jenis).first;
  controller.loadInfoMedical();
  
  AFwidget.dialog(
    const MedicalUbahForm(),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
