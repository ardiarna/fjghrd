import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';

import 'package:fjghrd/models/status_phk.dart';
import 'package:fjghrd/views/karyawan_forms/payroll_phk_form.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class PhkForm extends StatelessWidget {
  const PhkForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KaryawanControl>();
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
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
                  nilai: controller.current.nama,
                  paddingTop: 70,
                ),
                AFwidget.barisInfo(
                  label: 'Status Karyawan',
                  nilai: controller.current.statusKerja.nama,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Masa Kerja'),
                      ),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: controller.txtTanggalMasuk,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(controller.txtTanggalMasuk.text),
                            );
                            if(a != null) {
                              controller.txtTanggalMasuk.text = AFconvert.matYMD(a);
                            }
                          },
                        ),
                      ),
                      const Text('   s/d   '),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: controller.txtTanggalKeluar,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(controller.txtTanggalKeluar.text),
                            );
                            if(a != null) {
                              controller.txtTanggalKeluar.text = AFconvert.matYMD(a);
                            }
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
                        child: const Text('Status PHK'),
                      ),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: controller.statusPhk.nama,
                              label: '',
                              onTap: () async {
                                var a = await controller.pilihStatusPhk(value: controller.statusPhk.id);
                                if(a != null && a.value != controller.statusPhk.id) {
                                  controller.statusPhk = StatusPhk.fromMap(a.data!);
                                  controller.update();
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
                  label: 'Keterangan',
                  controller: controller.txtPhkKeterangan,
                  isTextArea: true,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      const SizedBox(width: 150),
                      GetBuilder<KaryawanControl>(
                        id: 'payroll_phk_button',
                        builder: (_) {
                          String label = 'Payroll PHK';
                          if (controller.payrollPhk.id.isNotEmpty) {
                            label = 'Payroll PHK : Rp. ${AFconvert.matNumber(controller.payrollPhk.totalDiterima)}';
                          }
                          return AFwidget.tombol(
                            label: label,
                            onPressed: () => showPayrollPhkForm(context),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 20),
                          margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue.shade100),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Column(
                            children: [
                              AFwidget.barisInfo(
                                label: 'KALKULASI',
                                labelWidth: 130,
                                labelSyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                              ),
                              AFwidget.barisText(
                                label: 'Kompensasi',
                                controller: controller.txtKompensasi,
                                isNumber: true,
                                labelWidth: 130,
                                paddingLeft: 40,
                              ),
                              AFwidget.barisText(
                                label: 'Pesangon',
                                controller: controller.txtPesangon,
                                isNumber: true,
                                labelWidth: 130,
                                paddingLeft: 40,
                              ),
                              AFwidget.barisText(
                                label: 'Masa Kerja',
                                controller: controller.txtMasaKerja,
                                isNumber: true,
                                labelWidth: 130,
                                paddingLeft: 40,
                              ),
                              AFwidget.barisText(
                                label: 'Uang Pisah',
                                controller: controller.txtUangPisah,
                                isNumber: true,
                                labelWidth: 130,
                                paddingLeft: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(40, 21, 20, 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 130,
                                      child: const Text('Sisa Cuti'),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Hari :'),
                                          AFwidget.textField(
                                            marginTop: 0,
                                            controller: controller.txtSisaCutiHari,
                                            inputformatters: [
                                              CurrencyTextInputFormatter.currency(
                                                symbol: '',
                                                decimalDigits: 0,
                                              ),
                                            ],
                                            textAlign: TextAlign.end,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Jumlah IDR :'),
                                          AFwidget.textField(
                                            marginTop: 0,
                                            controller: controller.txtSisaCutiJumlah,
                                            inputformatters: [
                                              CurrencyTextInputFormatter.currency(
                                                symbol: '',
                                                decimalDigits: 0,
                                              ),
                                            ],
                                            textAlign: TextAlign.end,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AFwidget.barisText(
                                label: 'Lain-lain',
                                controller: controller.txtLain,
                                isNumber: true,
                                labelWidth: 130,
                                paddingLeft: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 20),
                          margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red.shade100),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Column(
                            children: [
                              AFwidget.barisInfo(
                                label: 'POTONGAN',
                                labelWidth: 130,
                                labelSyle: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                              ),
                              AFwidget.barisText(
                                label: 'Kas / Cicilan',
                                controller: controller.txtPotKas,
                                isNumber: true,
                                labelWidth: 130,
                                paddingLeft: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(40, 21, 20, 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 130,
                                      child: const Text('Unpaid Leave'),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Hari :'),
                                          AFwidget.textField(
                                            marginTop: 0,
                                            controller: controller.txtPotCutiHari,
                                            inputformatters: [
                                              CurrencyTextInputFormatter.currency(
                                                symbol: '',
                                                decimalDigits: 0,
                                              ),
                                            ],
                                            textAlign: TextAlign.end,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Jumlah IDR :'),
                                          AFwidget.textField(
                                            marginTop: 0,
                                            controller: controller.txtPotCutiJumlah,
                                            inputformatters: [
                                              CurrencyTextInputFormatter.currency(
                                                symbol: '',
                                                decimalDigits: 0,
                                              ),
                                            ],
                                            textAlign: TextAlign.end,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AFwidget.barisText(
                                label: 'Lain-lain',
                                controller: controller.txtPotLain,
                                isNumber: true,
                                labelWidth: 130,
                                paddingLeft: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
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
                        onPressed: controller.simpanPhkData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AFwidget.formHeader('Form PHK Karyawan'),
          ],
        ),
      );
  }
}

void showPhkForm(BuildContext context) {
  final controller = Get.find<KaryawanControl>();
    controller.loadPayrollPhkData();
    controller.txtPhkKeterangan.text = controller.current.phk.keterangan;
    controller.txtTanggalMasuk.text = AFconvert.matYMD(controller.current.phk.tanggalAwal ?? controller.current.tanggalMasuk);
    controller.txtTanggalKeluar.text = AFconvert.matYMD(controller.current.phk.tanggalAKhir ?? DateTime.now());
    controller.statusPhk = controller.current.phk.statusPhk;
    controller.txtKompensasi.text = AFconvert.matNumber(controller.current.uangPhk.kompensasi);
    controller.txtPesangon.text = AFconvert.matNumber(controller.current.uangPhk.pesangon);
    controller.txtMasaKerja.text = AFconvert.matNumber(controller.current.uangPhk.masaKerja);
    controller.txtUangPisah.text = AFconvert.matNumber(controller.current.uangPhk.uangPisah);
    controller.txtSisaCutiHari.text = AFconvert.matNumber(controller.current.uangPhk.sisaCutiHari);
    controller.txtSisaCutiJumlah.text = AFconvert.matNumber(controller.current.uangPhk.sisaCutiJumlah);
    controller.txtLain.text = AFconvert.matNumber(controller.current.uangPhk.lain);
    controller.txtPotKas.text = AFconvert.matNumber(controller.current.uangPhk.potKas);
    controller.txtPotCutiHari.text = AFconvert.matNumber(controller.current.uangPhk.potCutiHari);
    controller.txtPotCutiJumlah.text = AFconvert.matNumber(controller.current.uangPhk.potCutiJumlah);
    controller.txtPotLain.text = AFconvert.matNumber(controller.current.uangPhk.potLain);
  AFwidget.dialog(
      const PhkForm(),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  
}
