import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/overtime_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/models/opsi.dart';

class OvertimeUbahForm extends StatelessWidget {
  const OvertimeUbahForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OvertimeControl>();
    return Container(
        width: Get.width,
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
                        child: const Text('Jenis Overtime'),
                      ),
                      Expanded(
                        child: GetBuilder<OvertimeControl>(
                          builder: (_) {
                            return RadioGroup<String>(
                              groupValue: controller.jenis,
                              onChanged: (a) {},
                              child: Row(
                                children: const [
                                  Radio<String>(value: 'F'),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                    child: Text('Fratekindo'),
                                  ),
                                  Radio<String>(value: 'C'),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text('Customer'),
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
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Periode'),
                      ),
                      Expanded(
                        child: GetBuilder<OvertimeControl>(
                            id: 'form_overtime',
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
                        child: GetBuilder<OvertimeControl>(
                            id: 'form_overtime',
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
                Visibility(
                  visible: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          padding: const EdgeInsets.only(right: 15),
                          child: const Text('Tanggal'),
                        ),
                        Expanded(
                          child: AFwidget.textField(
                            marginTop: 0,
                            controller: controller.txtTanggal,
                            readOnly: true,
                            prefixIcon: const Icon(Icons.calendar_month),
                            ontap: null,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                AFwidget.barisText(
                  label: 'Jumlah',
                  controller: controller.txtJumlah,
                  isNumber: true,
                  onchanged: (_) => controller.update(['form_overtime']),
                ),
                AFwidget.barisText(
                  label: 'Keterangan',
                  controller: controller.txtKeterangan,
                  isTextArea: true,
                ),
                GetBuilder<OvertimeControl>(
                  id: 'form_overtime',
                  builder: (_) {
                    String msg = controller.pesanValidasi;
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                      child: Row(
                        children: [
                          AFwidget.tombol(
                            label: 'Hapus',
                            color: Colors.red,
                            onPressed: () {
                              AFwidget.formHapus(
                                label: 'data overtime ini',
                                aksi: () {
                                  controller.hapusData(controller.txtId.text);
                                },
                              );
                            },
                            minimumSize: const Size(120, 40),
                          ),
                          const SizedBox(width: 20),
                          if(msg.isNotEmpty)
                            Expanded(
                              child: Text(msg, style: const TextStyle(color: Colors.red, fontStyle: FontStyle.italic)),
                            )
                          else
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
                            color: msg.isEmpty ? Colors.blue : Colors.grey,
                            onPressed: msg.isEmpty ? controller.ubahData : null,
                            minimumSize: const Size(120, 40),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ],
            ),
            AFwidget.formHeader('Form Ubah Overtime'),
          ],
        ),
      );
  }
}

void showOvertimeUbahForm(String id, BuildContext context) {
  final controller = Get.find<OvertimeControl>();
    var item = controller.listOvertime.where((element) => element.id == id).first;
    controller.txtId.text = item.id;
    controller.tahun = Opsi(value: '${item.tahun}', label: '${item.tahun}');
    controller.bulan = Opsi(value: '${item.bulan}', label: mapBulan[item.bulan]!);
    controller.txtTanggal.text = AFconvert.matDate(item.tanggal);
    controller.txtKeterangan.text = item.keterangan;
    controller.txtJumlah.text = AFconvert.matNumber(item.jumlah);
    controller.karyawan = item.karyawan;
    controller.jenis = item.jenis;
  AFwidget.dialog(
      const OvertimeUbahForm(),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  
}
