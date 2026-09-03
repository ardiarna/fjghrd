import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/payroll_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/models/opsi.dart';

class PayrollUbahForm extends StatelessWidget {
  const PayrollUbahForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PayrollControl>();
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 200,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Periode Penggajian'),
                      ),
                      Expanded(
                        child: GetBuilder<PayrollControl>(
                          id: 'form_ubah_payroll',
                          builder: (_) {
                            return AFwidget.comboField(
                              value: controller.bulan.label,
                              label: '',
                              onTap: () async {
                                var a = await controller.pilihBulan(value: controller.bulan.value);
                                if(a != null && a.value != controller.bulan.value) {
                                  controller.bulan = a;
                                  controller.update(['form_ubah_payroll']);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: GetBuilder<PayrollControl>(
                          id: 'form_ubah_payroll',
                          builder: (_) {
                            return AFwidget.comboField(
                              value: controller.tahun.label,
                              label: '',
                              onTap: () async {
                                var a = await controller.pilihTahun(value: controller.tahun.value);
                                if(a != null && a.value != controller.tahun.value) {
                                  controller.tahun = a;
                                  controller.update(['form_ubah_payroll']);
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
                        width: 200,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Periode Batas (Cut-off)'),
                      ),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: controller.txtTanggalAwal,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(AFconvert.matDMYtoYMD(controller.txtTanggalAwal.text)),
                            );
                            if(a != null) {
                              controller.txtTanggalAwal.text = AFconvert.matDate(a);
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                        child: Text('s/d', textAlign: TextAlign.center),
                      ),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: controller.txtTanggalAkhir,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(AFconvert.matDMYtoYMD(controller.txtTanggalAkhir.text)),
                            );
                            if(a != null) {
                              controller.txtTanggalAkhir.text = AFconvert.matDate(a);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                AFwidget.barisText(
                  label: 'Keterangan',
                  controller: controller.txtKeterangan,
                  isTextArea: true,
                  labelWidth: 200,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AFwidget.tombol(
                        label: 'Hapus',
                        color: Colors.red,
                        onPressed: () {
                          AFwidget.formHapus(
                            label: 'payroll ${mapBulan[controller.currentPayroll.bulan]} ${controller.currentPayroll.tahun}',
                            aksi: () {
                              controller.hapusData(controller.currentPayroll.id);
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
                        onPressed: controller.ubahData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AFwidget.formHeader('Form Ubah Payroll'),
          ],
        ),
      );
  }
}

void showPayrollUbahForm(BuildContext context) {
  final controller = Get.find<PayrollControl>();
    controller.txtTanggalAwal.text = AFconvert.matDate(controller.currentPayroll.tanggalAwal);
    controller.txtTanggalAkhir.text = AFconvert.matDate(controller.currentPayroll.tanggalAkhir);
    controller.tahun = Opsi(value: '${controller.currentPayroll.tahun}', label: '${controller.currentPayroll.tahun}');
    controller.bulan = Opsi(value: '${controller.currentPayroll.bulan}', label: mapBulan[controller.currentPayroll.bulan]!);
    controller.txtKeterangan.text = controller.currentPayroll.keterangan;
  AFwidget.dialog(
      const PayrollUbahForm(),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  
}
