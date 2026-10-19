import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/models/status_phk.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class PhkForm extends StatelessWidget {
  const PhkForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KaryawanControl>();
    final formWidth = Get.width > 1250 ? 1200.0 : Get.width * 0.96;
    const double labelWidth = 185;
    final stylePenghasilan = TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w500);
    final stylePotongan = TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w500);

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      width: formWidth,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Stack(
        children: [
          ListView(
            children: [
              // HEADER INFO KARYAWAN (2 KOLOM)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AFwidget.barisInfo(
                      label: 'Nama Karyawan',
                      nilai: controller.current.nama,
                      labelWidth: labelWidth,
                      paddingLeft: 20,
                      paddingRight: 10,
                      paddingTop: 65,
                    ),
                  ),
                  Expanded(
                    child: AFwidget.barisInfo(
                      label: 'Status Karyawan',
                      nilai: controller.current.statusKerja.nama,
                      labelWidth: labelWidth,
                      paddingLeft: 10,
                      paddingRight: 20,
                      paddingTop: 65,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 11, 10, 0),
                      child: Row(
                        children: [
                          Container(
                            width: labelWidth,
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
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('s/d'),
                          ),
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
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 11, 20, 0),
                      child: Row(
                        children: [
                          Container(
                            width: labelWidth,
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
                  ),
                ],
              ),
              AFwidget.barisText(
                label: 'Keterangan PHK',
                controller: controller.txtPhkKeterangan,
                isTextArea: true,
                labelWidth: labelWidth,
                paddingLeft: 20,
                paddingRight: 20,
              ),
              const SizedBox(height: 15),

              // 1. KALKULASI PHK (2 KOLOM)
              Container(
                padding: const EdgeInsets.only(bottom: 15),
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade200, width: 1.2),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AFwidget.barisInfo(
                      label: 'KALKULASI PHK',
                      labelWidth: 200,
                      labelSyle: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold, fontSize: 14),
                      paddingTop: 12,
                      paddingLeft: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AFwidget.barisText(
                            label: 'Kompensasi',
                            controller: controller.txtKompensasi,
                            isNumber: true,
                            onchanged: (val) => controller.hitungTotalPhk(),
                            labelWidth: labelWidth,
                            paddingLeft: 15,
                            paddingRight: 10,
                          ),
                        ),
                        Expanded(
                          child: AFwidget.barisText(
                            label: 'Masa Kerja',
                            controller: controller.txtMasaKerja,
                            isNumber: true,
                            onchanged: (val) => controller.hitungTotalPhk(),
                            labelWidth: labelWidth,
                            paddingLeft: 10,
                            paddingRight: 15,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AFwidget.barisText(
                            label: 'Pesangon',
                            controller: controller.txtPesangon,
                            isNumber: true,
                            onchanged: (val) => controller.hitungTotalPhk(),
                            labelWidth: labelWidth,
                            paddingLeft: 15,
                            paddingRight: 10,
                          ),
                        ),
                        Expanded(
                          child: AFwidget.barisText(
                            label: 'Uang Pisah',
                            controller: controller.txtUangPisah,
                            isNumber: true,
                            onchanged: (val) => controller.hitungTotalPhk(),
                            labelWidth: labelWidth,
                            paddingLeft: 10,
                            paddingRight: 15,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AFwidget.barisText(
                            label: 'Note Pesangon',
                            controller: controller.txtKetPesangon,
                            labelWidth: labelWidth,
                            paddingLeft: 15,
                            paddingRight: 10,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 11, 15, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: labelWidth,
                                  padding: const EdgeInsets.only(right: 15),
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
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Jumlah IDR :'),
                                      AFwidget.textField(
                                        marginTop: 0,
                                        controller: controller.txtSisaCutiJumlah,
                                        onchanged: (val) => controller.hitungTotalPhk(),
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // 2. PAYROLL PHK
              Container(
                padding: const EdgeInsets.only(bottom: 15),
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green.shade500, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AFwidget.barisInfo(
                      label: 'PAYROLL PHK',
                      labelWidth: 200,
                      labelSyle: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 14),
                      paddingTop: 12,
                      paddingLeft: 15,
                    ),
                    // Periode Payroll & Periode Gaji (Row 1)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 11, 10, 0),
                            child: Row(
                              children: [
                                Container(
                                  width: labelWidth,
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
                                        if(a != null && a.value != controller.bulanPhk.value) {
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
                                        if(a != null && a.value != controller.tahunPhk.value) {
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
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 11, 15, 0),
                            child: Row(
                              children: [
                                Container(
                                  width: labelWidth,
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
                                      if(a != null) {
                                        controller.txtPayrollPhkTglGajiAwal.text = AFconvert.matYMD(a);
                                      }
                                    },
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
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
                                      if(a != null) {
                                        controller.txtPayrollPhkTglGajiAkhir.text = AFconvert.matYMD(a);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Kehadiran (Hari) & Periode Cut-Off (Row 2)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AFwidget.barisText(
                            label: 'Kehadiran (Hari)',
                            controller: controller.txtPayrollPhkHariMakan,
                            isNumber: true,
                            onchanged: (nilai) {
                              if(controller.payrollPhkMakanHarian) {
                                var jumlah = AFconvert.keInt(nilai) * AFconvert.keInt(controller.txtPayrollPhkUangMakanHarian.text);
                                controller.txtPayrollPhkUangMakanJumlah.text = AFconvert.matNumber(jumlah);
                                controller.hitungPayrollPhkPenerimaanBersih(nilai);
                              }
                            },
                            labelWidth: labelWidth,
                            paddingLeft: 15,
                            paddingRight: 10,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 11, 15, 0),
                            child: Row(
                              children: [
                                Container(
                                  width: labelWidth,
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
                                      if(a != null) {
                                        controller.txtPayrollPhkTglAwal.text = AFconvert.matYMD(a);
                                      }
                                    },
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
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
                                      if(a != null) {
                                        controller.txtPayrollPhkTglAkhir.text = AFconvert.matYMD(a);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    AFwidget.barisText(
                      label: 'Keterangan',
                      controller: controller.txtPayrollPhkKeterangan,
                      isTextArea: true,
                      labelWidth: labelWidth,
                      paddingLeft: 15,
                      paddingRight: 15,
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 6),

                    // 2 KOLOM UTAMA: PENGHASILAN (KIRI) & POTONGAN (KANAN)
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // KOLOM KIRI: A. PENGHASILAN
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AFwidget.barisInfo(
                                  label: 'A. PENGHASILAN',
                                  labelWidth: labelWidth,
                                  labelSyle: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold),
                                  paddingTop: 8,
                                  paddingLeft: 15,
                                  paddingRight: 10,
                                ),
                                AFwidget.barisText(
                                  label: 'Gaji Pokok',
                                  controller: controller.txtPayrollPhkGaji,
                                  isNumber: true,
                                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePenghasilan,
                                  paddingLeft: 15,
                                  paddingRight: 10,
                                ),
                                AFwidget.barisText(
                                  label: 'Kenaikan Gaji',
                                  controller: controller.txtPayrollPhkKenaikanGaji,
                                  isNumber: true,
                                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePenghasilan,
                                  paddingLeft: 15,
                                  paddingRight: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 11, 10, 0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: labelWidth,
                                        padding: const EdgeInsets.only(right: 15),
                                        child: Text('Jenis Uang Makan', style: stylePenghasilan),
                                      ),
                                      Expanded(
                                        child: GetBuilder<KaryawanControl>(
                                          builder: (_) {
                                            return RadioGroup<bool>(
                                              groupValue: controller.payrollPhkMakanHarian,
                                              onChanged: (a) {
                                                if(a != null && a != controller.payrollPhkMakanHarian) {
                                                  controller.payrollPhkMakanHarian = a;
                                                  controller.update();
                                                }
                                              },
                                              child: Row(
                                                children: const [
                                                  Radio<bool>(value: true),
                                                  Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 0, 18, 0),
                                                    child: Text('Harian'),
                                                  ),
                                                  Radio<bool>(value: false),
                                                  Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 0, 18, 0),
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
                                    if(controller.payrollPhkMakanHarian) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(15, 11, 10, 0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: labelWidth,
                                              padding: const EdgeInsets.only(right: 15),
                                              child: Text('U/makan & Transport', style: stylePenghasilan),
                                            ),
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
                                                      controller.hitungPayrollPhkPenerimaanBersih(nilai);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
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
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(15, 11, 10, 0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: labelWidth,
                                              padding: const EdgeInsets.only(right: 15),
                                              child: Text('U/makan & Transport', style: stylePenghasilan),
                                            ),
                                            Expanded(
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
                                                    onchanged: controller.hitungPayrollPhkPenerimaanBersih,
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
                                  controller: controller.txtPayrollPhkOvertimeFjg,
                                  isNumber: true,
                                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePenghasilan,
                                  paddingLeft: 15,
                                  paddingRight: 10,
                                ),
                                AFwidget.barisText(
                                  label: 'Overtime Customer',
                                  controller: controller.txtPayrollPhkOvertimeCus,
                                  isNumber: true,
                                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePenghasilan,
                                  paddingLeft: 15,
                                  paddingRight: 10,
                                ),
                                AFwidget.barisText(
                                  label: 'Reimbursement Medical',
                                  controller: controller.txtPayrollPhkMedical,
                                  isNumber: true,
                                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePenghasilan,
                                  paddingLeft: 15,
                                  paddingRight: 10,
                                ),
                                AFwidget.barisText(
                                  label: 'Tunjangan Hari Raya',
                                  controller: controller.txtPayrollPhkThr,
                                  isNumber: true,
                                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePenghasilan,
                                  paddingLeft: 15,
                                  paddingRight: 10,
                                ),
                                AFwidget.barisText(
                                  label: 'Bonus',
                                  controller: controller.txtPayrollPhkBonus,
                                  isNumber: true,
                                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePenghasilan,
                                  paddingLeft: 15,
                                  paddingRight: 10,
                                ),
                                AFwidget.barisText(
                                  label: 'Insentif',
                                  controller: controller.txtPayrollPhkInsentif,
                                  isNumber: true,
                                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePenghasilan,
                                  paddingLeft: 15,
                                  paddingRight: 10,
                                ),
                                AFwidget.barisText(
                                  label: 'Telkomsel',
                                  controller: controller.txtPayrollPhkTelkomsel,
                                  isNumber: true,
                                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePenghasilan,
                                  paddingLeft: 15,
                                  paddingRight: 10,
                                ),
                                AFwidget.barisText(
                                  label: 'Lain-Lain',
                                  controller: controller.txtPayrollPhkLain,
                                  isNumber: true,
                                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePenghasilan,
                                  paddingLeft: 15,
                                  paddingRight: 10,
                                ),
                                AFwidget.barisText(
                                  label: 'Keterangan Lain-Lain',
                                  controller: controller.txtKetLain,
                                  isTextArea: true,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePenghasilan,
                                  paddingLeft: 15,
                                  paddingRight: 10,
                                ),
                              ],
                            ),
                          ),

                          VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade300),

                          // KOLOM KANAN: B. POTONGAN
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AFwidget.barisInfo(
                                  label: 'B. POTONGAN',
                                  labelWidth: labelWidth,
                                  labelSyle: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
                                  paddingTop: 8,
                                  paddingLeft: 10,
                                  paddingRight: 15,
                                ),
                                GetBuilder<KaryawanControl>(
                                  builder: (_) {
                                    if (!controller.payrollPhkMakanHarian) return const SizedBox.shrink();
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(10, 11, 15, 0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: labelWidth,
                                            padding: const EdgeInsets.only(right: 15),
                                            child: Text('Terlambat Hadir 25%', style: stylePotongan),
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
                                                    var jumlah = (AFconvert.keInt(controller.txtPayrollPhkUangMakanHarian.text)/4) * AFconvert.keInt(nilai);
                                                    controller.txtPayrollPhkPot25jumlah.text = AFconvert.matNumber(jumlah);
                                                    controller.hitungPayrollPhkPenerimaanBersih(nilai);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
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
                                    );
                                  },
                                ),
                                AFwidget.barisText(
                                  label: 'Pemakaian Telepon',
                                  controller: controller.txtPayrollPhkPotTelepon,
                                  isNumber: true,
                                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePotongan,
                                  paddingLeft: 10,
                                  paddingRight: 15,
                                ),
                                AFwidget.barisText(
                                  label: 'Pemakaian Bensin',
                                  controller: controller.txtPayrollPhkPotBensin,
                                  isNumber: true,
                                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePotongan,
                                  paddingLeft: 10,
                                  paddingRight: 15,
                                ),
                                AFwidget.barisText(
                                  label: 'Pinjaman Kas',
                                  controller: controller.txtPayrollPhkPotKas,
                                  isNumber: true,
                                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePotongan,
                                  paddingLeft: 10,
                                  paddingRight: 15,
                                ),
                                AFwidget.barisText(
                                  label: 'Pinjaman Cicilan',
                                  controller: controller.txtPayrollPhkPotCicilan,
                                  isNumber: true,
                                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePotongan,
                                  paddingLeft: 10,
                                  paddingRight: 15,
                                ),
                                AFwidget.barisText(
                                  label: 'BPJS Kesehatan',
                                  controller: controller.txtPayrollPhkPotBpjs,
                                  isNumber: true,
                                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePotongan,
                                  paddingLeft: 10,
                                  paddingRight: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 11, 15, 0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: labelWidth,
                                        padding: const EdgeInsets.only(right: 15),
                                        child: Text('Unpaid Leave', style: stylePotongan),
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
                                                var jumlah = (AFconvert.keInt(controller.txtPayrollPhkGaji.text)/21) * AFconvert.keInt(nilai);
                                                controller.txtPayrollPhkPotCutiJumlah.text = AFconvert.matNumber(jumlah);
                                                controller.hitungPayrollPhkPenerimaanBersih(nilai);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
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
                                  padding: const EdgeInsets.fromLTRB(10, 11, 15, 0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: labelWidth,
                                        padding: const EdgeInsets.only(right: 15),
                                        child: Text('Kompensasi Hadir', style: stylePotongan),
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
                                                var jumlah = (AFconvert.keInt(controller.txtPayrollPhkGaji.text)/168) * AFconvert.keDouble(nilai);
                                                controller.txtPayrollPhkPotKompensasiJumlah.text = AFconvert.matNumber(jumlah);
                                                controller.hitungPayrollPhkPenerimaanBersih(nilai);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
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
                                  label: 'Lain-Lain',
                                  controller: controller.txtPayrollPhkPotLain,
                                  isNumber: true,
                                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePotongan,
                                  paddingLeft: 10,
                                  paddingRight: 15,
                                ),
                                AFwidget.barisText(
                                  label: 'Keterangan Lain-Lain',
                                  controller: controller.txtKetPotLain,
                                  isTextArea: true,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePotongan,
                                  paddingLeft: 10,
                                  paddingRight: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 3. RINGKASAN TOTAL (4 KOLOM)
              Obx(() => Container(
                margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Total Kalkulasi PHK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text('Rp ${AFconvert.matNumber(controller.totalPhkKalkulasi.value)}', style: const TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Total Penghasilan Payroll', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text('Rp ${AFconvert.matNumber(controller.totalPenghasilanPayroll.value)}', style: const TextStyle(color: Colors.teal, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Total Potongan Payroll', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text('Rp ${AFconvert.matNumber(controller.totalPotonganPayroll.value)}', style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Total Diterima', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text('Rp ${AFconvert.matNumber(controller.totalPhkDiterima.value)}', style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              )),

              // 4. TOMBOL AKSI
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    const Spacer(),
                    if (controller.current.phkId.isNotEmpty || controller.current.phk.id.isNotEmpty) ...[
                      AFwidget.tombol(
                        label: 'Cetak Slip PHK',
                        color: Colors.green,
                        onPressed: controller.downloadExcelSlipPhk,
                        minimumSize: const Size(120, 40),
                      ),
                      const SizedBox(width: 25),
                    ],
                    AFwidget.tombol(
                      label: 'Batal',
                      color: Colors.orange,
                      onPressed: Get.back,
                      minimumSize: const Size(120, 40),
                    ),
                    const SizedBox(width: 25),
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
  controller.txtPhkKeterangan.text = controller.current.phk.keterangan;
  controller.txtTanggalMasuk.text = AFconvert.matYMD(controller.current.phk.tanggalAwal ?? controller.current.tanggalMasuk);
  controller.txtTanggalKeluar.text = AFconvert.matYMD(controller.current.phk.tanggalAKhir ?? DateTime.now());
  controller.statusPhk = controller.current.phk.statusPhk;
  controller.txtKompensasi.text = AFconvert.matNumber(controller.current.uangPhk.kompensasi);
  controller.txtPesangon.text = AFconvert.matNumber(controller.current.uangPhk.pesangon);
  controller.txtKetPesangon.text = controller.current.uangPhk.ketPesangon;
  controller.txtMasaKerja.text = AFconvert.matNumber(controller.current.uangPhk.masaKerja);
  controller.txtUangPisah.text = AFconvert.matNumber(controller.current.uangPhk.uangPisah);
  controller.txtSisaCutiHari.text = AFconvert.matNumber(controller.current.uangPhk.sisaCutiHari);
  controller.txtSisaCutiJumlah.text = AFconvert.matNumber(controller.current.uangPhk.sisaCutiJumlah);
  controller.txtKetLain.text = controller.current.uangPhk.ketLain;
  controller.txtKetPotLain.text = controller.current.uangPhk.ketPotLain;

  if (controller.current.phk.payrollPhk.id.isNotEmpty) {
    controller.isPayrollPhkBaru.value = false;
    controller.isiFormPayrollPhk(controller.current.phk.payrollPhk);
  } else if (controller.current.payrollPhk.id.isNotEmpty) {
    controller.isPayrollPhkBaru.value = false;
    controller.isiFormPayrollPhk(controller.current.payrollPhk);
  } else {
    controller.isPayrollPhkBaru.value = true;
    controller.setPayrollPhkBaru();
  }

  controller.loadPayrollPhkData();
  controller.hitungTotalPhk();
  AFwidget.dialog(
    const PhkForm(),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
