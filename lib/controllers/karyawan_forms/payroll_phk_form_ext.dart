import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/models/opsi.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

extension PayrollPhkFormExt on KaryawanControl {
  void payrollPhkForm(BuildContext context) {
    txtPayrollPhkGaji.text = AFconvert.matNumber(payrollPhk.gaji);
    txtPayrollPhkKenaikanGaji.text = AFconvert.matNumber(payrollPhk.kenaikanGaji);
    txtPayrollPhkHariMakan.text = AFconvert.matNumber(payrollPhk.hariMakan);
    txtPayrollPhkUangMakanHarian.text = AFconvert.matNumber(payrollPhk.uangMakanHarian);
    txtPayrollPhkUangMakanJumlah.text = AFconvert.matNumber(payrollPhk.uangMakanJumlah);
    txtPayrollPhkOvertimeFjg.text = AFconvert.matNumber(payrollPhk.overtimeFjg);
    txtPayrollPhkOvertimeCus.text = AFconvert.matNumber(payrollPhk.overtimeCus);
    txtPayrollPhkMedical.text = AFconvert.matNumber(payrollPhk.medical);
    txtPayrollPhkThr.text = AFconvert.matNumber(payrollPhk.thr);
    txtPayrollPhkBonus.text = AFconvert.matNumber(payrollPhk.bonus);
    txtPayrollPhkInsentif.text = AFconvert.matNumber(payrollPhk.insentif);
    txtPayrollPhkTelkomsel.text = AFconvert.matNumber(payrollPhk.telkomsel);
    txtPayrollPhkLain.text = AFconvert.matNumber(payrollPhk.lain);
    txtPayrollPhkPot25hari.text = AFconvert.matNumber(payrollPhk.pot25hari);
    txtPayrollPhkPot25jumlah.text = AFconvert.matNumber(payrollPhk.pot25jumlah);
    txtPayrollPhkPotTelepon.text = AFconvert.matNumber(payrollPhk.potTelepon);
    txtPayrollPhkPotBensin.text = AFconvert.matNumber(payrollPhk.potBensin);
    txtPayrollPhkPotKas.text = AFconvert.matNumber(payrollPhk.potKas);
    txtPayrollPhkPotCicilan.text = AFconvert.matNumber(payrollPhk.potCicilan);
    txtPayrollPhkPotBpjs.text = AFconvert.matNumber(payrollPhk.potBpjs);
    txtPayrollPhkPotCutiHari.text = AFconvert.matNumber(payrollPhk.potCutiHari);
    txtPayrollPhkPotCutiJumlah.text = AFconvert.matNumber(payrollPhk.potCutiJumlah);
    txtPayrollPhkPotKompensasiJam.text = AFconvert.matNumberWithDecimal(payrollPhk.potKompensasiJam, decimal: 1);
    txtPayrollPhkPotKompensasiJumlah.text = AFconvert.matNumber(payrollPhk.potKompensasiJumlah);
    txtPayrollPhkPotLain.text = AFconvert.matNumber(payrollPhk.potLain);
    txtPayrollPhkTotalDiterima.text = AFconvert.matNumber(payrollPhk.totalDiterima);
    txtPayrollPhkKeterangan.text = payrollPhk.keterangan;
    txtPayrollPhkTglAwal.text = payrollPhk.tanggalAwal == null ? AFconvert.matYMD(DateTime(DateTime.now().month == 1 ? (DateTime.now().year-1) : DateTime.now().year, DateTime.now().month == 1 ? 12 : DateTime.now().month-1, 19)) : AFconvert.matYMD(payrollPhk.tanggalAwal);
    txtPayrollPhkTglAkhir.text = payrollPhk.tanggalAkhir == null ? AFconvert.matYMD(DateTime(DateTime.now().year, DateTime.now().month, 18)) : AFconvert.matYMD(payrollPhk.tanggalAkhir);
    tahunPhk = payrollPhk.tahun == 0 ? Opsi(value: '${DateTime.now().year}', label: '${DateTime.now().year}') : Opsi(value: '${payrollPhk.tahun}', label: '${payrollPhk.tahun}');
    bulanPhk = payrollPhk.bulan == 0 ? Opsi(value: '${DateTime.now().month}', label: mapBulan[DateTime.now().month]!) : Opsi(value: '${payrollPhk.bulan}', label: mapBulan[payrollPhk.bulan]!);
    payrollPhkMakanHarian = payrollPhk.makanHarian;
    AFwidget.dialog(
      Container(
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
                  nilai: current.nama,
                  labelWidth: 230,
                  paddingTop: 70,
                ),
                AFwidget.barisInfo(
                  label: 'Jabatan',
                  nilai: current.jabatan.nama,
                  labelWidth: 230,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 230,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Periode Payroll / Penggajian'),
                      ),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: bulanPhk.label,
                              label: '',
                              onTap: () async {
                                var a = await pilihBulan(value: bulanPhk.value);
                                if(a != null && a.value != bulanPhk.value) {
                                  bulanPhk = a;
                                  int vTahun = AFconvert.keInt(tahunPhk.value);
                                  int vBulan = AFconvert.keInt(a.value);
                                  txtPayrollPhkTglAwal.text = AFconvert.matYMD(DateTime(vBulan == 1 ? vTahun-1 : vTahun, vBulan == 1 ? 12 : vBulan-1, 19));
                                  txtPayrollPhkTglAkhir.text = AFconvert.matYMD(DateTime(vTahun, vBulan, 18));
                                  update();
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: tahunPhk.label,
                              label: '',
                              onTap: () async {
                                var a = await pilihTahun(value: tahunPhk.value);
                                if(a != null && a.value != tahunPhk.value) {
                                  tahunPhk = a;
                                  int vTahun = AFconvert.keInt(a.value);
                                  int vBulan = AFconvert.keInt(bulanPhk.value);
                                  txtPayrollPhkTglAwal.text = AFconvert.matYMD(DateTime(vBulan == 1 ? vTahun-1 : vTahun, vBulan == 1 ? 12 : vBulan-1, 19));
                                  txtPayrollPhkTglAkhir.text = AFconvert.matYMD(DateTime(vTahun, vBulan, 18));
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 230,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Periode Batas (Cut-Off)'),
                      ),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: txtPayrollPhkTglAwal,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(txtPayrollPhkTglAwal.text),
                            );
                            if(a != null) {
                              txtPayrollPhkTglAwal.text = AFconvert.matYMD(a);
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
                          controller: txtPayrollPhkTglAkhir,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(txtPayrollPhkTglAkhir.text),
                            );
                            if(a != null) {
                              txtPayrollPhkTglAkhir.text = AFconvert.matYMD(a);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                AFwidget.barisText(
                  label: 'Kehadiran (Hari)',
                  controller: txtPayrollPhkHariMakan,
                  isNumber: true,
                  onchanged: (nilai) {
                    if(payrollPhkMakanHarian) {
                      var jumlah = AFconvert.keInt(nilai) * AFconvert.keInt(txtPayrollPhkUangMakanHarian.text);
                      txtPayrollPhkUangMakanJumlah.text = AFconvert.matNumber(jumlah);
                      hitungPayrollPhkPenerimaanBersih(nilai);
                    }
                  },
                  labelWidth: 230,
                ),
                AFwidget.barisInfo(
                  label: 'A. PENGHASILAN',
                  labelWidth: 230,
                  labelSyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                ),
                AFwidget.barisText(
                  label: 'Gaji Pokok',
                  controller: txtPayrollPhkGaji,
                  isNumber: true,
                  onchanged: hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Kenaikan Gaji',
                  controller: txtPayrollPhkKenaikanGaji,
                  isNumber: true,
                  onchanged: hitungPayrollPhkPenerimaanBersih,
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
                        child: const Text('Jenis Uang Makan'),
                      ),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return RadioGroup<bool>(
                              groupValue: payrollPhkMakanHarian,
                              onChanged: (a) {
                                if(a != null && a != payrollPhkMakanHarian) {
                                  payrollPhkMakanHarian = a;
                                  update();
                                }
                              },
                              child: Row(
                                children: const [
                                  Radio<bool>(value: true),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                    child: Text('Harian'),
                                  ),
                                  Radio<bool>(value: false),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                    child: Text('Tetap'),
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
                GetBuilder<KaryawanControl>(
                  builder: (_) {
                    if(payrollPhkMakanHarian) {
                      return Padding(
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
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('@Hari IDR :'),
                                  AFwidget.textField(
                                    marginTop: 0,
                                    controller: txtPayrollPhkUangMakanHarian,
                                    inputformatters: [
                                      CurrencyTextInputFormatter.currency(
                                        symbol: '',
                                        decimalDigits: 0,
                                      ),
                                    ],
                                    textAlign: TextAlign.end,
                                    onchanged: (nilai) {
                                      var jumlah = AFconvert.keInt(nilai) * AFconvert.keInt(txtPayrollPhkHariMakan.text);
                                      txtPayrollPhkUangMakanJumlah.text = AFconvert.matNumber(jumlah);
                                      hitungPayrollPhkPenerimaanBersih(nilai);
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
                                    controller: txtPayrollPhkUangMakanJumlah,
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
                      );
                    } else {
                      return Padding(
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Jumlah IDR :'),
                                  AFwidget.textField(
                                    marginTop: 0,
                                    controller: txtPayrollPhkUangMakanJumlah,
                                    inputformatters: [
                                      CurrencyTextInputFormatter.currency(
                                        symbol: '',
                                        decimalDigits: 0,
                                      ),
                                    ],
                                    textAlign: TextAlign.end,
                                    onchanged: hitungPayrollPhkPenerimaanBersih,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                AFwidget.barisText(
                  label: 'Overtime Fratekindo',
                  controller: txtPayrollPhkOvertimeFjg,
                  isNumber: true,
                  onchanged: hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Overtime Customer',
                  controller: txtPayrollPhkOvertimeCus,
                  isNumber: true,
                  onchanged: hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Reimbursement Medical',
                  controller: txtPayrollPhkMedical,
                  isNumber: true,
                  onchanged: hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Tunjangan Hari Raya',
                  controller: txtPayrollPhkThr,
                  isNumber: true,
                  onchanged: hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Bonus',
                  controller: txtPayrollPhkBonus,
                  isNumber: true,
                  onchanged: hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Insentif',
                  controller: txtPayrollPhkInsentif,
                  isNumber: true,
                  onchanged: hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Telkomsel',
                  controller: txtPayrollPhkTelkomsel,
                  isNumber: true,
                  onchanged: hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Lain-Lain',
                  controller: txtPayrollPhkLain,
                  isNumber: true,
                  onchanged: hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisInfo(
                  label: 'B. POTONGAN',
                  labelWidth: 230,
                  labelSyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                ),
                payrollPhk.makanHarian ?
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
                              controller: txtPayrollPhkPot25hari,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                              onchanged: (nilai) {
                                var jumlah = (AFconvert.keInt(txtPayrollPhkUangMakanHarian.text)/4) * AFconvert.keInt(nilai) ;
                                txtPayrollPhkPot25jumlah.text = AFconvert.matNumber(jumlah);
                                hitungPayrollPhkPenerimaanBersih(nilai);
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
                              controller: txtPayrollPhkPot25jumlah,
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
                  controller: txtPayrollPhkPotTelepon,
                  isNumber: true,
                  onchanged: hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Pemakaian Bensin',
                  controller: txtPayrollPhkPotBensin,
                  isNumber: true,
                  onchanged: hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Pinjaman Kas',
                  controller: txtPayrollPhkPotKas,
                  isNumber: true,
                  onchanged: hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Pinjaman Cicilan',
                  controller: txtPayrollPhkPotCicilan,
                  isNumber: true,
                  onchanged: hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'BPJS Kesehatan',
                  controller: txtPayrollPhkPotBpjs,
                  isNumber: true,
                  onchanged: hitungPayrollPhkPenerimaanBersih,
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
                              controller: txtPayrollPhkPotCutiHari,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                              onchanged: (nilai) {
                                var jumlah = (AFconvert.keInt(txtPayrollPhkGaji.text)/21) * AFconvert.keInt(nilai);
                                txtPayrollPhkPotCutiJumlah.text = AFconvert.matNumber(jumlah);
                                hitungPayrollPhkPenerimaanBersih(nilai);
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
                              controller: txtPayrollPhkPotCutiJumlah,
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
                              controller: txtPayrollPhkPotKompensasiJam,
                              textAlign: TextAlign.end,
                              onchanged: (nilai) {
                                var jumlah = (AFconvert.keInt(txtPayrollPhkGaji.text)/168) * AFconvert.keDouble(nilai);
                                txtPayrollPhkPotKompensasiJumlah.text = AFconvert.matNumber(jumlah);
                                hitungPayrollPhkPenerimaanBersih(nilai);
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
                              controller: txtPayrollPhkPotKompensasiJumlah,
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
                  label: 'Lain-Lain',
                  controller: txtPayrollPhkPotLain,
                  isNumber: true,
                  onchanged: hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Peneriman Bersih (A-B)',
                  labelStyle: const TextStyle(
                    color: Colors.blue,
                  ),
                  controller: txtPayrollPhkTotalDiterima,
                  isNumber: true,
                  readOnly: true,
                  paddingTop: 31,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Keterangan',
                  controller: txtPayrollPhkKeterangan,
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
                        onPressed: simpanPayrollPhkData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AFwidget.formHeader('Form Payroll PHK'),
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
