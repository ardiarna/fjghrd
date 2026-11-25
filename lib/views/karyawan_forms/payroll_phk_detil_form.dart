import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/models/payroll.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayrollPhkDetilForm extends StatelessWidget {
  final bool isEdit;
  const PayrollPhkDetilForm({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KaryawanControl>();

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
              AFwidget.barisInfo(
                label: 'Nama Karyawan',
                nilai: controller.current.nama,
                labelWidth: 230,
                paddingTop: 70,
              ),
              AFwidget.barisInfo(
                label: 'Jabatan',
                nilai: controller.current.jabatan.nama,
                labelWidth: 230,
              ),
              AFwidget.barisInfo(
                label: 'Masa Kerja',
                nilai: AFconvert.matDate(controller.current.tanggalMasuk),
                labelWidth: 230,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                child: Row(
                  children: [
                    Container(
                      width: 230,
                      padding: const EdgeInsets.only(right: 15),
                      child: const Text('Periode Payroll'),
                    ),
                    Expanded(
                      child: GetBuilder<KaryawanControl>(
                        builder: (_) => AFwidget.comboField(
                          value: controller.bulanPhk.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihBulan(value: controller.bulanPhk.value);
                            if (a != null && a.value != controller.bulanPhk.value) {
                              controller.bulanPhk = a;
                              int vTahun = AFconvert.keInt(controller.tahunPhk.value);
                              int vBulan = AFconvert.keInt(a.value);
                              int prevBulan = vBulan == 1 ? 12 : vBulan - 1;
                              int prevTahun = vBulan == 1 ? vTahun - 1 : vTahun;
                              controller.txtPayrollPhkTglAwal.text = AFconvert.matYMD(DateTime(prevTahun, prevBulan, 19));
                              controller.txtPayrollPhkTglAkhir.text = AFconvert.matYMD(DateTime(vTahun, vBulan, 18));
                              controller.txtPayrollPhkTglGajiAwal.text = AFconvert.matYMD(DateTime(prevTahun, prevBulan, 26));
                              controller.txtPayrollPhkTglGajiAkhir.text = AFconvert.matYMD(DateTime(vTahun, vBulan, 25));
                              controller.update();
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: GetBuilder<KaryawanControl>(
                        builder: (_) => AFwidget.comboField(
                          value: controller.tahunPhk.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.tahunPhk.value);
                            if (a != null && a.value != controller.tahunPhk.value) {
                              controller.tahunPhk = a;
                              int vTahun = AFconvert.keInt(a.value);
                              int vBulan = AFconvert.keInt(controller.bulanPhk.value);
                              int prevBulan = vBulan == 1 ? 12 : vBulan - 1;
                              int prevTahun = vBulan == 1 ? vTahun - 1 : vTahun;
                              controller.txtPayrollPhkTglAwal.text = AFconvert.matYMD(DateTime(prevTahun, prevBulan, 19));
                              controller.txtPayrollPhkTglAkhir.text = AFconvert.matYMD(DateTime(vTahun, vBulan, 18));
                              controller.txtPayrollPhkTglGajiAwal.text = AFconvert.matYMD(DateTime(prevTahun, prevBulan, 26));
                              controller.txtPayrollPhkTglGajiAkhir.text = AFconvert.matYMD(DateTime(vTahun, vBulan, 25));
                              controller.update();
                            }
                          },
                        ),
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
                      width: 230,
                      padding: const EdgeInsets.only(right: 15),
                      child: const Text('Periode Gaji'),
                    ),
                    Expanded(
                      child: AFwidget.textField(
                        marginTop: 0,
                        controller: controller.txtPayrollPhkTglGajiAwal,
                        readOnly: true,
                        prefixIcon: const Icon(Icons.calendar_month),
                        ontap: () async {
                          var a = await AFwidget.pickDate(
                            context: context,
                            initialDate: AFconvert.keTanggal(controller.txtPayrollPhkTglGajiAwal.text),
                          );
                          if (a != null) {
                            controller.txtPayrollPhkTglGajiAwal.text = AFconvert.matYMD(a);
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
                        controller: controller.txtPayrollPhkTglGajiAkhir,
                        readOnly: true,
                        prefixIcon: const Icon(Icons.calendar_month),
                        ontap: () async {
                          var a = await AFwidget.pickDate(
                            context: context,
                            initialDate: AFconvert.keTanggal(controller.txtPayrollPhkTglGajiAkhir.text),
                          );
                          if (a != null) {
                            controller.txtPayrollPhkTglGajiAkhir.text = AFconvert.matYMD(a);
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
                      width: 230,
                      padding: const EdgeInsets.only(right: 15),
                      child: const Text('Periode Cut-Off'),
                    ),
                    Expanded(
                      child: AFwidget.textField(
                        marginTop: 0,
                        controller: controller.txtPayrollPhkTglAwal,
                        readOnly: true,
                        prefixIcon: const Icon(Icons.calendar_month),
                        ontap: () async {
                          var a = await AFwidget.pickDate(
                            context: context,
                            initialDate: AFconvert.keTanggal(controller.txtPayrollPhkTglAwal.text),
                          );
                          if (a != null) {
                            controller.txtPayrollPhkTglAwal.text = AFconvert.matYMD(a);
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
                        controller: controller.txtPayrollPhkTglAkhir,
                        readOnly: true,
                        prefixIcon: const Icon(Icons.calendar_month),
                        ontap: () async {
                          var a = await AFwidget.pickDate(
                            context: context,
                            initialDate: AFconvert.keTanggal(controller.txtPayrollPhkTglAkhir.text),
                          );
                          if (a != null) {
                            controller.txtPayrollPhkTglAkhir.text = AFconvert.matYMD(a);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              AFwidget.barisInfo(
                label: 'A. PENGHASILAN',
                labelWidth: 230,
                labelSyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              ),
              AFwidget.barisText(
                label: 'Gaji Pokok',
                controller: controller.txtPayrollPhkGaji,
                isNumber: true,
                onchanged: controller.hitungPayrollPhkStandalone,
                labelWidth: 230,
              ),
              AFwidget.barisText(
                label: 'Kenaikan Gaji',
                controller: controller.txtPayrollPhkKenaikanGaji,
                isNumber: true,
                onchanged: controller.hitungPayrollPhkStandalone,
                labelWidth: 230,
              ),
              controller.payrollPhkMakanHarian
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 21, 20, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 230,
                            padding: const EdgeInsets.only(right: 15),
                            child: const Text('U/makan & Transport'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Hari :'),
                                AFwidget.textField(
                                  marginTop: 0,
                                  controller: controller.txtPayrollPhkHariMakan,
                                  inputformatters: [
                                    CurrencyTextInputFormatter.currency(
                                      symbol: '',
                                      decimalDigits: 0,
                                    ),
                                  ],
                                  textAlign: TextAlign.end,
                                  onchanged: (nilai) {
                                    var jumlah = AFconvert.keInt(nilai) * AFconvert.keInt(controller.txtPayrollPhkUangMakanHarian.text);
                                    controller.txtPayrollPhkUangMakanJumlah.text = AFconvert.matNumber(jumlah);
                                    controller.hitungPayrollPhkStandalone(nilai);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('@Hari IDR :'),
                                AFwidget.textField(
                                  marginTop: 0,
                                  controller: controller.txtPayrollPhkUangMakanHarian,
                                  inputformatters: [
                                    CurrencyTextInputFormatter.currency(
                                      symbol: '',
                                      decimalDigits: 0,
                                    ),
                                  ],
                                  textAlign: TextAlign.end,
                                  onchanged: (nilai) {
                                    var jumlah = AFconvert.keInt(nilai) * AFconvert.keInt(controller.txtPayrollPhkHariMakan.text);
                                    controller.txtPayrollPhkUangMakanJumlah.text = AFconvert.matNumber(jumlah);
                                    controller.hitungPayrollPhkStandalone(nilai);
                                  },
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
                                  controller: controller.txtPayrollPhkUangMakanJumlah,
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
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(20, 21, 20, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 230,
                            padding: const EdgeInsets.only(right: 15),
                            child: const Text('U/makan & Transport'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Hari :'),
                                AFwidget.textField(
                                  marginTop: 0,
                                  controller: controller.txtPayrollPhkHariMakan,
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
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Jumlah IDR :'),
                                AFwidget.textField(
                                  marginTop: 0,
                                  controller: controller.txtPayrollPhkUangMakanJumlah,
                                  inputformatters: [
                                    CurrencyTextInputFormatter.currency(
                                      symbol: '',
                                      decimalDigits: 0,
                                    ),
                                  ],
                                  textAlign: TextAlign.end,
                                  onchanged: controller.hitungPayrollPhkStandalone,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              AFwidget.barisText(
                label: 'Overtime Fratekindo',
                controller: controller.txtPayrollPhkOvertimeFjg,
                isNumber: true,
                onchanged: controller.hitungPayrollPhkStandalone,
                labelWidth: 230,
              ),
              AFwidget.barisText(
                label: 'Overtime Customer',
                controller: controller.txtPayrollPhkOvertimeCus,
                isNumber: true,
                onchanged: controller.hitungPayrollPhkStandalone,
                labelWidth: 230,
              ),
              AFwidget.barisText(
                label: 'Reimbursement Medical',
                controller: controller.txtPayrollPhkMedical,
                isNumber: true,
                onchanged: controller.hitungPayrollPhkStandalone,
                labelWidth: 230,
              ),
              AFwidget.barisText(
                label: 'Tunjangan Hari Raya',
                controller: controller.txtPayrollPhkThr,
                isNumber: true,
                onchanged: controller.hitungPayrollPhkStandalone,
                labelWidth: 230,
              ),
              AFwidget.barisText(
                label: 'Bonus',
                controller: controller.txtPayrollPhkBonus,
                isNumber: true,
                onchanged: controller.hitungPayrollPhkStandalone,
                labelWidth: 230,
              ),
              AFwidget.barisText(
                label: 'Insentif',
                controller: controller.txtPayrollPhkInsentif,
                isNumber: true,
                onchanged: controller.hitungPayrollPhkStandalone,
                labelWidth: 230,
              ),
              AFwidget.barisText(
                label: 'Telkomsel',
                controller: controller.txtPayrollPhkTelkomsel,
                isNumber: true,
                onchanged: controller.hitungPayrollPhkStandalone,
                labelWidth: 230,
              ),
              AFwidget.barisText(
                label: 'Lain-Lain',
                controller: controller.txtPayrollPhkLain,
                isNumber: true,
                onchanged: controller.hitungPayrollPhkStandalone,
                labelWidth: 230,
              ),
              AFwidget.barisInfo(
                label: 'B. POTONGAN',
                labelWidth: 230,
                labelSyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              ),
              controller.payrollPhkMakanHarian
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 21, 20, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 230,
                            padding: const EdgeInsets.only(right: 15),
                            child: const Text('Keterlambatan Kehadiran 25%'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Hari :'),
                                AFwidget.textField(
                                  marginTop: 0,
                                  controller: controller.txtPayrollPhkPot25hari,
                                  inputformatters: [
                                    CurrencyTextInputFormatter.currency(
                                      symbol: '',
                                      decimalDigits: 0,
                                    ),
                                  ],
                                  textAlign: TextAlign.end,
                                  onchanged: (nilai) {
                                    var jumlah = (AFconvert.keInt(controller.txtPayrollPhkUangMakanHarian.text) / 4) * AFconvert.keInt(nilai);
                                    controller.txtPayrollPhkPot25jumlah.text = AFconvert.matNumber(jumlah);
                                    controller.hitungPayrollPhkStandalone(nilai);
                                  },
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
                                  controller: controller.txtPayrollPhkPot25jumlah,
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
                    )
                  : Container(),
              AFwidget.barisText(
                label: 'Pemakaian Telepon',
                controller: controller.txtPayrollPhkPotTelepon,
                isNumber: true,
                onchanged: controller.hitungPayrollPhkStandalone,
                labelWidth: 230,
              ),
              AFwidget.barisText(
                label: 'Pemakaian Bensin',
                controller: controller.txtPayrollPhkPotBensin,
                isNumber: true,
                onchanged: controller.hitungPayrollPhkStandalone,
                labelWidth: 230,
              ),
              AFwidget.barisText(
                label: 'Pinjaman Kas',
                controller: controller.txtPayrollPhkPotKas,
                isNumber: true,
                onchanged: controller.hitungPayrollPhkStandalone,
                labelWidth: 230,
              ),
              AFwidget.barisText(
                label: 'Pinjaman Cicilan',
                controller: controller.txtPayrollPhkPotCicilan,
                isNumber: true,
                onchanged: controller.hitungPayrollPhkStandalone,
                labelWidth: 230,
              ),
              AFwidget.barisText(
                label: 'BPJS Kesehatan',
                controller: controller.txtPayrollPhkPotBpjs,
                isNumber: true,
                onchanged: controller.hitungPayrollPhkStandalone,
                labelWidth: 230,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 21, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 230,
                      padding: const EdgeInsets.only(right: 15),
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
                            controller: controller.txtPayrollPhkPotCutiHari,
                            inputformatters: [
                              CurrencyTextInputFormatter.currency(
                                symbol: '',
                                decimalDigits: 0,
                              ),
                            ],
                            textAlign: TextAlign.end,
                            onchanged: (nilai) {
                              var jumlah = ((AFconvert.keInt(controller.txtPayrollPhkGaji.text) + AFconvert.keInt(controller.txtPayrollPhkKenaikanGaji.text)) / 21) * AFconvert.keInt(nilai);
                              controller.txtPayrollPhkPotCutiJumlah.text = AFconvert.matNumber(jumlah);
                              controller.hitungPayrollPhkStandalone(nilai);
                            },
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
                            controller: controller.txtPayrollPhkPotCutiJumlah,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 21, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 230,
                      padding: const EdgeInsets.only(right: 15),
                      child: const Text('Kompensasi Hadir (Jam)'),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Jam :'),
                          AFwidget.textField(
                            marginTop: 0,
                            controller: controller.txtPayrollPhkPotKompensasiJam,
                            textAlign: TextAlign.end,
                            onchanged: (nilai) {
                              var jumlah = ((AFconvert.keInt(controller.txtPayrollPhkGaji.text) + AFconvert.keInt(controller.txtPayrollPhkKenaikanGaji.text)) / 168) * AFconvert.keDouble(nilai);
                              controller.txtPayrollPhkPotKompensasiJumlah.text = AFconvert.matNumber(jumlah);
                              controller.hitungPayrollPhkStandalone(nilai);
                            },
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
                            controller: controller.txtPayrollPhkPotKompensasiJumlah,
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
                label: 'Lain Lain',
                controller: controller.txtPayrollPhkPotLain,
                isNumber: true,
                onchanged: controller.hitungPayrollPhkStandalone,
                labelWidth: 230,
              ),
              AFwidget.barisText(
                label: 'Peneriman Bersih (A-B)',
                labelStyle: const TextStyle(color: Colors.blue),
                controller: controller.txtPayrollPhkTotalDiterima,
                isNumber: true,
                readOnly: true,
                paddingTop: 31,
                labelWidth: 230,
              ),
              AFwidget.barisText(
                label: 'Keterangan',
                controller: controller.txtPayrollPhkKeterangan,
                isTextArea: true,
                labelWidth: 230,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
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
                      onPressed: controller.simpanPayrollPhkStandalone,
                      minimumSize: const Size(120, 40),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AFwidget.formHeader(isEdit ? 'Form Edit Payroll Karyawan' : 'Form Add Payroll Karyawan'),
        ],
      ),
    );
  }
}

Future<void> showDialogPayrollPhkForm(
  BuildContext context,
  KaryawanControl controller, {
  Payroll? item,
}) async {
  await controller.initFormPayrollPhkStandalone(item: item);
  AFwidget.dialog(
    PayrollPhkDetilForm(isEdit: item != null),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
