import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/uang_phk_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/models/opsi.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class UangPhkTambahForm extends StatelessWidget {
  const UangPhkTambahForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UangPhkControl>();
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                  child: Row(
                    children: [
                      Container(
                        width: 200,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Karyawan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: GetBuilder<UangPhkControl>(
                          id: 'form_uangphk',
                          builder: (_) {
                            return AFwidget.comboField(
                              value: controller.karyawan.nama,
                              label: '',
                              onTap: () async {
                                var a = await controller.pilihKaryawan(value: controller.karyawan.id);
                                if(a != null && a.value != controller.karyawan.id) {
                                  controller.karyawan = Karyawan.fromMap(a.data!);
                                  controller.update(['form_uangphk']);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
                                            readOnly: true,
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
                                            readOnly: true,
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
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
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
            AFwidget.formHeader('Form Tambah Uang PHK - ${controller.tahun.label}'),
          ],
        ),
      );
  }
}


void showUangPhkTambahForm(BuildContext context) {
  final controller = Get.find<UangPhkControl>();
  controller.txtId.text = '';
  controller.tahun = Opsi(value: controller.filterTahun.value, label: controller.filterTahun.label);
  controller.txtKompensasi.text = '';
  controller.txtUangPisah.text = '';
  controller.txtPesangon.text = '';
  controller.txtMasaKerja.text = '';
  controller.txtSisaCutiHari.text = '';
  controller.txtSisaCutiJumlah.text = '';
  controller.txtLain.text = '';
  controller.txtPotKas.text = '';
  controller.txtPotCutiHari.text = '';
  controller.txtPotCutiJumlah.text = '';
  controller.txtPotLain.text = '';
  controller.karyawan = Karyawan();
  
  AFwidget.dialog(
    const UangPhkTambahForm(),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
