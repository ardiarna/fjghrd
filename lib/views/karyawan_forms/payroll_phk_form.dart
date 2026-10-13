import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class PayrollPhkForm extends StatelessWidget {
  const PayrollPhkForm({super.key});

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
                Obx(() {
                  if (controller.listPayrollPhk.isEmpty) {
                    return const SizedBox(height: 70);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 65),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(controller.listPayrollPhk.length, (index) {
                              final item = controller.listPayrollPhk[index];
                              final isSelected = !controller.isPayrollPhkBaru.value && controller.selectedPayrollPhkIndex.value == index;
                              final bName = mapBulan[item.bulan] ?? '${item.bulan}';
                              final tabTitle = '$bName ${item.tahun}';
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: InkWell(
                                  onTap: () => controller.pilihPayrollPhkTab(index),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Colors.blue : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.receipt_long,
                                          size: 16,
                                          color: isSelected ? Colors.white : Colors.grey.shade700,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          tabTitle,
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : Colors.grey.shade800,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                AFwidget.barisInfo(
                  label: 'Nama Karyawan',
                  nilai: controller.current.nama,
                  labelWidth: 230,
                  paddingTop: 10,
                ),
                AFwidget.barisInfo(
                  label: 'Jabatan',
                  nilai: controller.current.jabatan.nama,
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
                        child: Obx(() {
                          final isReadOnly = !controller.isPayrollPhkBaru.value;
                          return AFwidget.comboField(
                            value: controller.bulanPhk.label,
                            label: '',
                            warnaBackground: isReadOnly ? Colors.grey.shade200 : null,
                            warna: isReadOnly ? Colors.grey.shade600 : null,
                            onTap: isReadOnly
                                ? null
                                : () async {
                                    var a = await controller.pilihBulan(value: controller.bulanPhk.value);
                                    if(a != null && a.value != controller.bulanPhk.value) {
                                      controller.bulanPhk = a;
                                      int vTahun = AFconvert.keInt(controller.tahunPhk.value);
                                      int vBulan = AFconvert.keInt(a.value);
                                      controller.txtPayrollPhkTglAwal.text = AFconvert.matYMD(DateTime(vBulan == 1 ? vTahun-1 : vTahun, vBulan == 1 ? 12 : vBulan-1, 19));
                                      controller.txtPayrollPhkTglAkhir.text = AFconvert.matYMD(DateTime(vTahun, vBulan, 18));
                                      controller.update();
                                    }
                                  },
                          );
                        }),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: Obx(() {
                          final isReadOnly = !controller.isPayrollPhkBaru.value;
                          return AFwidget.comboField(
                            value: controller.tahunPhk.label,
                            label: '',
                            warnaBackground: isReadOnly ? Colors.grey.shade200 : null,
                            warna: isReadOnly ? Colors.grey.shade600 : null,
                            onTap: isReadOnly
                                ? null
                                : () async {
                                    var a = await controller.pilihTahun(value: controller.tahunPhk.value);
                                    if(a != null && a.value != controller.tahunPhk.value) {
                                      controller.tahunPhk = a;
                                      int vTahun = AFconvert.keInt(a.value);
                                      int vBulan = AFconvert.keInt(controller.bulanPhk.value);
                                      controller.txtPayrollPhkTglAwal.text = AFconvert.matYMD(DateTime(vBulan == 1 ? vTahun-1 : vTahun, vBulan == 1 ? 12 : vBulan-1, 19));
                                      controller.txtPayrollPhkTglAkhir.text = AFconvert.matYMD(DateTime(vTahun, vBulan, 18));
                                      controller.update();
                                    }
                                  },
                          );
                        }),
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
                            if(a != null) {
                              controller.txtPayrollPhkTglAkhir.text = AFconvert.matYMD(a);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                AFwidget.barisText(
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
                  labelWidth: 230,
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
                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Kenaikan Gaji',
                  controller: controller.txtPayrollPhkKenaikanGaji,
                  isNumber: true,
                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
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
                    if(controller.payrollPhkMakanHarian) {
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
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Overtime Customer',
                  controller: controller.txtPayrollPhkOvertimeCus,
                  isNumber: true,
                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Reimbursement Medical',
                  controller: controller.txtPayrollPhkMedical,
                  isNumber: true,
                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Tunjangan Hari Raya',
                  controller: controller.txtPayrollPhkThr,
                  isNumber: true,
                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Bonus',
                  controller: controller.txtPayrollPhkBonus,
                  isNumber: true,
                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Insentif',
                  controller: controller.txtPayrollPhkInsentif,
                  isNumber: true,
                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Telkomsel',
                  controller: controller.txtPayrollPhkTelkomsel,
                  isNumber: true,
                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Lain-Lain',
                  controller: controller.txtPayrollPhkLain,
                  isNumber: true,
                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisInfo(
                  label: 'B. POTONGAN',
                  labelWidth: 230,
                  labelSyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                ),
                controller.payrollPhk.makanHarian ?
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
                              controller: controller.txtPayrollPhkPot25hari,
                              inputformatters: [
                                CurrencyTextInputFormatter.currency(
                                  symbol: '',
                                  decimalDigits: 0,
                                ),
                              ],
                              textAlign: TextAlign.end,
                              onchanged: (nilai) {
                                var jumlah = (AFconvert.keInt(controller.txtPayrollPhkUangMakanHarian.text)/4) * AFconvert.keInt(nilai) ;
                                controller.txtPayrollPhkPot25jumlah.text = AFconvert.matNumber(jumlah);
                                controller.hitungPayrollPhkPenerimaanBersih(nilai);
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
                ) :
                Container(),
                AFwidget.barisText(
                  label: 'Pemakaian Telepon',
                  controller: controller.txtPayrollPhkPotTelepon,
                  isNumber: true,
                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Pemakaian Bensin',
                  controller: controller.txtPayrollPhkPotBensin,
                  isNumber: true,
                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Pinjaman Kas',
                  controller: controller.txtPayrollPhkPotKas,
                  isNumber: true,
                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Pinjaman Cicilan',
                  controller: controller.txtPayrollPhkPotCicilan,
                  isNumber: true,
                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'BPJS Kesehatan',
                  controller: controller.txtPayrollPhkPotBpjs,
                  isNumber: true,
                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
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
                                var jumlah = (AFconvert.keInt(controller.txtPayrollPhkGaji.text)/21) * AFconvert.keInt(nilai);
                                controller.txtPayrollPhkPotCutiJumlah.text = AFconvert.matNumber(jumlah);
                                controller.hitungPayrollPhkPenerimaanBersih(nilai);
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
                                var jumlah = (AFconvert.keInt(controller.txtPayrollPhkGaji.text)/168) * AFconvert.keDouble(nilai);
                                controller.txtPayrollPhkPotKompensasiJumlah.text = AFconvert.matNumber(jumlah);
                                controller.hitungPayrollPhkPenerimaanBersih(nilai);
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
                  label: 'Lain-Lain',
                  controller: controller.txtPayrollPhkPotLain,
                  isNumber: true,
                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                  labelWidth: 230,
                ),
                AFwidget.barisText(
                  label: 'Peneriman Bersih (A-B)',
                  labelStyle: const TextStyle(
                    color: Colors.blue,
                  ),
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
                  child: Obx(() {
                    return Row(
                      children: [
                        if (!controller.isPayrollPhkBaru.value && controller.payrollPhk.id.isNotEmpty)
                          AFwidget.tombol(
                            label: 'Hapus',
                            color: Colors.red,
                            onPressed: () {
                              final bulanName = mapBulan[controller.payrollPhk.bulan] ?? '${controller.payrollPhk.bulan}';
                              final periodeStr = '$bulanName ${controller.payrollPhk.tahun}';
                              AFwidget.formHapus(
                                label: 'data Payroll PHK periode $periodeStr',
                                aksi: () {
                                  controller.hapusPayrollPhkData(controller.payrollPhk.id);
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
                          onPressed: controller.simpanPayrollPhkData,
                          minimumSize: const Size(120, 40),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
            Obx(() {
              return AFwidget.formHeader(
                'Form Payroll PHK',
                actions: controller.listPayrollPhk.isNotEmpty
                    ? [
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.white, size: 24),
                          tooltip: 'Input Baru',
                          onPressed: () {
                            controller.tambahPayrollPhkBaru();
                          },
                        ),
                      ]
                    : null,
              );
            }),
          ],
        ),
      );
  }
}

void showPayrollPhkForm(BuildContext context) {
  final controller = Get.find<KaryawanControl>();
  if (controller.listPayrollPhk.isNotEmpty) {
    if (controller.selectedPayrollPhkIndex.value >= 0 &&
        controller.selectedPayrollPhkIndex.value < controller.listPayrollPhk.length &&
        !controller.isPayrollPhkBaru.value) {
      controller.isiFormPayrollPhk(controller.listPayrollPhk[controller.selectedPayrollPhkIndex.value]);
    } else {
      controller.pilihPayrollPhkTab(0);
    }
  } else {
    controller.setPayrollPhkBaru();
  }
  AFwidget.dialog(
    const PayrollPhkForm(),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
