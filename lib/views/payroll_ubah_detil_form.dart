import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/payroll_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class PayrollUbahDetilForm extends StatelessWidget {
  const PayrollUbahDetilForm({super.key});

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
                AFwidget.barisInfo(
                  label: 'Nama Karyawan',
                  nilai: controller.currentDetilPayroll.karyawan.nama,
                  labelWidth: 230,
                  paddingTop: 70,
                ),
                AFwidget.barisInfo(
                  label: 'Jabatan',
                  nilai: controller.currentDetilPayroll.karyawan.jabatan.nama,
                  labelWidth: 230,
                ),
                AFwidget.barisInfo(
                  label: 'Masa Kerja',
                  nilai: AFconvert.matDate(controller.currentDetilPayroll.karyawan.tanggalMasuk),
                  labelWidth: 230,
                ),
                AFwidget.barisInfo(
                  label: 'A. PENGHASILAN',
                  labelWidth: 230,
                  labelSyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                ),
                AFwidget.barisText(
                  label: 'Gaji Pokok',
                  controller: controller.txtGaji,
                  isNumber: true,
                  onchanged: controller.hitungPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Kenaikan Gaji',
                  controller: controller.txtKenaikanGaji,
                  isNumber: true,
                  onchanged: controller.hitungPenerimaanBersih,
                  labelWidth: 230,
                ),
                controller.currentDetilPayroll.makanHarian ?
                Padding(
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
                              controller: controller.txtHariMakan,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                              onchanged: (nilai) {
                                var jumlah = AFconvert.keInt(nilai) * AFconvert.keInt(controller.txtUangMakanHarian.text);
                                controller.txtUangMakanJumlah.text = AFconvert.matNumber(jumlah);
                                controller.hitungPenerimaanBersih(nilai);
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
                              controller: controller.txtUangMakanHarian,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                              onchanged: (nilai) {
                                var jumlah = AFconvert.keInt(nilai) * AFconvert.keInt(controller.txtHariMakan.text);
                                controller.txtUangMakanJumlah.text = AFconvert.matNumber(jumlah);
                                controller.hitungPenerimaanBersih(nilai);
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
                              controller: controller.txtUangMakanJumlah,
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
                ) :
                Padding(
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
                              controller: controller.txtHariMakan,
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
                              controller: controller.txtUangMakanJumlah,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                              onchanged: controller.hitungPenerimaanBersih,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AFwidget.barisText(
                  label: 'Overtime Fratekindo',
                  controller: controller.txtOvertimeFjg,
                  isNumber: true,
                  onchanged: controller.hitungPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Overtime Customer',
                  controller: controller.txtOvertimeCus,
                  isNumber: true,
                  onchanged: controller.hitungPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Reimbursement Medical',
                  controller: controller.txtMedical,
                  isNumber: true,
                  onchanged: controller.hitungPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Tunjangan Hari Raya',
                  controller: controller.txtThr,
                  isNumber: true,
                  onchanged: controller.hitungPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Bonus',
                  controller: controller.txtBonus,
                  isNumber: true,
                  onchanged: controller.hitungPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Insentif',
                  controller: controller.txtInsentif,
                  isNumber: true,
                  onchanged: controller.hitungPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Telkomsel',
                  controller: controller.txtTelkomsel,
                  isNumber: true,
                  onchanged: controller.hitungPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Lain-Lain',
                  controller: controller.txtLain,
                  isNumber: true,
                  onchanged: controller.hitungPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisInfo(
                  label: 'B. POTONGAN',
                  labelWidth: 230,
                  labelSyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                ),
                controller.currentDetilPayroll.makanHarian ?
                Padding(
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
                              controller: controller.txtPot25hari,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                              onchanged: (nilai) {
                                var jumlah = (AFconvert.keInt(controller.txtUangMakanHarian.text)/4) * AFconvert.keInt(nilai) ;
                                controller.txtPot25jumlah.text = AFconvert.matNumber(jumlah);
                                controller.hitungPenerimaanBersih(nilai);
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
                              controller: controller.txtPot25jumlah,
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
                ) :
                Container(),
                AFwidget.barisText(
                  label: 'Pemakaian Telepon',
                  controller: controller.txtPotTelepon,
                  isNumber: true,
                  onchanged: controller.hitungPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Pemakaian Bensin',
                  controller: controller.txtPotBensin,
                  isNumber: true,
                  onchanged: controller.hitungPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Pinjaman Kas',
                  controller: controller.txtPotKas,
                  isNumber: true,
                  onchanged: controller.hitungPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Pinjaman Cicilan',
                  controller: controller.txtPotCicilan,
                  isNumber: true,
                  onchanged: controller.hitungPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'BPJS Kesehatan',
                  controller: controller.txtPotBpjs,
                  isNumber: true,
                  onchanged: controller.hitungPenerimaanBersih,
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
                              controller: controller.txtPotCutiHari,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                              onchanged: (nilai) {
                                var jumlah = ((AFconvert.keInt(controller.txtGaji.text)+AFconvert.keInt(controller.txtKenaikanGaji.text))/21) * AFconvert.keInt(nilai) ;
                                controller.txtPotCutiJumlah.text = AFconvert.matNumber(jumlah);
                                controller.hitungPenerimaanBersih(nilai);
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
                              controller: controller.txtPotKompensasiJam,
                              textAlign: TextAlign.end,
                              onchanged: (nilai) {
                                var jumlah = ((AFconvert.keInt(controller.txtGaji.text)+AFconvert.keInt(controller.txtKenaikanGaji.text))/168) * AFconvert.keDouble(nilai) ;
                                controller.txtPotKompensasiJumlah.text = AFconvert.matNumber(jumlah);
                                controller.hitungPenerimaanBersih(nilai);
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
                              controller: controller.txtPotKompensasiJumlah,
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
                  controller: controller.txtPotLain,
                  isNumber: true,
                  onchanged: controller.hitungPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Peneriman Bersih (A-B)',
                  labelStyle: const TextStyle(
                    color: Colors.blue,
                  ),
                  controller: controller.txtTotalDiterima,
                  isNumber: true,
                  readOnly: true,
                  paddingTop: 31,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Keterangan',
                  controller: controller.txtKeterangan,
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
                        onPressed: controller.ubahDetilData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AFwidget.formHeader('Form Ubah Payroll Karyawan'),
          ],
        ),
      );
  }
}

void showPayrollUbahDetilForm(String id, BuildContext context) {
  final controller = Get.find<PayrollControl>();
    controller.currentDetilPayroll = controller.listDetilPayroll.where((element) => element.id == id).first;
    controller.txtGaji.text = AFconvert.matNumber(controller.currentDetilPayroll.gaji);
    controller.txtKenaikanGaji.text = AFconvert.matNumber(controller.currentDetilPayroll.kenaikanGaji);
    controller.txtHariMakan.text = AFconvert.matNumber(controller.currentDetilPayroll.hariMakan);
    controller.txtUangMakanHarian.text = AFconvert.matNumber(controller.currentDetilPayroll.uangMakanHarian);
    controller.txtUangMakanJumlah.text = AFconvert.matNumber(controller.currentDetilPayroll.uangMakanJumlah);
    controller.txtOvertimeFjg.text = AFconvert.matNumber(controller.currentDetilPayroll.overtimeFjg);
    controller.txtOvertimeCus.text = AFconvert.matNumber(controller.currentDetilPayroll.overtimeCus);
    controller.txtMedical.text = AFconvert.matNumber(controller.currentDetilPayroll.medical);
    controller.txtThr.text = AFconvert.matNumber(controller.currentDetilPayroll.thr);
    controller.txtBonus.text = AFconvert.matNumber(controller.currentDetilPayroll.bonus);
    controller.txtInsentif.text = AFconvert.matNumber(controller.currentDetilPayroll.insentif);
    controller.txtTelkomsel.text = AFconvert.matNumber(controller.currentDetilPayroll.telkomsel);
    controller.txtLain.text = AFconvert.matNumber(controller.currentDetilPayroll.lain);
    controller.txtPot25hari.text = AFconvert.matNumber(controller.currentDetilPayroll.pot25hari);
    controller.txtPot25jumlah.text = AFconvert.matNumber(controller.currentDetilPayroll.pot25jumlah);
    controller.txtPotTelepon.text = AFconvert.matNumber(controller.currentDetilPayroll.potTelepon);
    controller.txtPotBensin.text = AFconvert.matNumber(controller.currentDetilPayroll.potBensin);
    controller.txtPotKas.text = AFconvert.matNumber(controller.currentDetilPayroll.potKas);
    controller.txtPotCicilan.text = AFconvert.matNumber(controller.currentDetilPayroll.potCicilan);
    controller.txtPotBpjs.text = AFconvert.matNumber(controller.currentDetilPayroll.potBpjs);
    controller.txtPotCutiHari.text = AFconvert.matNumber(controller.currentDetilPayroll.potCutiHari);
    controller.txtPotCutiJumlah.text = AFconvert.matNumber(controller.currentDetilPayroll.potCutiJumlah);
    controller.txtPotKompensasiJam.text = AFconvert.matNumberWithDecimal(controller.currentDetilPayroll.potKompensasiJam, decimal: 1);
    controller.txtPotKompensasiJumlah.text = AFconvert.matNumber(controller.currentDetilPayroll.potKompensasiJumlah);
    controller.txtPotLain.text = AFconvert.matNumber(controller.currentDetilPayroll.potLain);
    controller.txtTotalDiterima.text = AFconvert.matNumber(controller.currentDetilPayroll.totalDiterima);
    controller.txtKeterangan.text = controller.currentDetilPayroll.keterangan;
  AFwidget.dialog(
      const PayrollUbahDetilForm(),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  
}
