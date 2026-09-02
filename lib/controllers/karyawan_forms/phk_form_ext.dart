import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:fjghrd/models/status_phk.dart';
import 'package:fjghrd/controllers/karyawan_forms/payroll_phk_form_ext.dart';

extension PhkFormExt on KaryawanControl {
  void phkForm(BuildContext context) {
    loadPayrollPhkData();
    txtPhkKeterangan.text = current.phk.keterangan;
    txtTanggalMasuk.text = AFconvert.matYMD(current.phk.tanggalAwal ?? current.tanggalMasuk);
    txtTanggalKeluar.text = AFconvert.matYMD(current.phk.tanggalAKhir ?? DateTime.now());
    statusPhk = current.phk.statusPhk;
    txtKompensasi.text = AFconvert.matNumber(current.uangPhk.kompensasi);
    txtPesangon.text = AFconvert.matNumber(current.uangPhk.pesangon);
    txtMasaKerja.text = AFconvert.matNumber(current.uangPhk.masaKerja);
    txtUangPisah.text = AFconvert.matNumber(current.uangPhk.uangPisah);
    txtSisaCutiHari.text = AFconvert.matNumber(current.uangPhk.sisaCutiHari);
    txtSisaCutiJumlah.text = AFconvert.matNumber(current.uangPhk.sisaCutiJumlah);
    txtLain.text = AFconvert.matNumber(current.uangPhk.lain);
    txtPotKas.text = AFconvert.matNumber(current.uangPhk.potKas);
    txtPotCutiHari.text = AFconvert.matNumber(current.uangPhk.potCutiHari);
    txtPotCutiJumlah.text = AFconvert.matNumber(current.uangPhk.potCutiJumlah);
    txtPotLain.text = AFconvert.matNumber(current.uangPhk.potLain);
    AFwidget.dialog(
      Container(
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
                  nilai: current.nama,
                  paddingTop: 70,
                ),
                AFwidget.barisInfo(
                  label: 'Status Karyawan',
                  nilai: current.statusKerja.nama,
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
                          controller: txtTanggalMasuk,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(txtTanggalMasuk.text),
                            );
                            if(a != null) {
                              txtTanggalMasuk.text = AFconvert.matYMD(a);
                            }
                          },
                        ),
                      ),
                      const Text('   s/d   '),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: txtTanggalKeluar,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(txtTanggalKeluar.text),
                            );
                            if(a != null) {
                              txtTanggalKeluar.text = AFconvert.matYMD(a);
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
                              value: statusPhk.nama,
                              label: '',
                              onTap: () async {
                                var a = await pilihStatusPhk(value: statusPhk.id);
                                if(a != null && a.value != statusPhk.id) {
                                  statusPhk = StatusPhk.fromMap(a.data!);
                                  update();
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
                  controller: txtPhkKeterangan,
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
                          if (payrollPhk.id.isNotEmpty) {
                            label = 'Payroll PHK : Rp. ${AFconvert.matNumber(payrollPhk.totalDiterima)}';
                          }
                          return AFwidget.tombol(
                            label: label,
                            onPressed: () => payrollPhkForm(context),
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
                                controller: txtKompensasi,
                                isNumber: true,
                                labelWidth: 130,
                                paddingLeft: 40,
                              ),
                              AFwidget.barisText(
                                label: 'Pesangon',
                                controller: txtPesangon,
                                isNumber: true,
                                labelWidth: 130,
                                paddingLeft: 40,
                              ),
                              AFwidget.barisText(
                                label: 'Masa Kerja',
                                controller: txtMasaKerja,
                                isNumber: true,
                                labelWidth: 130,
                                paddingLeft: 40,
                              ),
                              AFwidget.barisText(
                                label: 'Uang Pisah',
                                controller: txtUangPisah,
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
                                            controller: txtSisaCutiHari,
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
                                            controller: txtSisaCutiJumlah,
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
                                controller: txtLain,
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
                                controller: txtPotKas,
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
                                            controller: txtPotCutiHari,
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
                                            controller: txtPotCutiJumlah,
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
                                controller: txtPotLain,
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
                        onPressed: simpanPhkData,
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
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }
}
