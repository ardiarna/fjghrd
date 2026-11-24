import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/models/phk.dart';
import 'package:fjghrd/models/status_phk.dart';
import 'package:fjghrd/models/upah.dart';
import 'package:fjghrd/repositories/upah_repository.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

typedef PhkForm = PhkPage;

class PhkPage extends StatelessWidget {
  const PhkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KaryawanControl>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AFwidget.pageHeader(
            title: 'FORM PHK KARYAWAN',
            icon: Icons.person_off_outlined,
            onBack: Get.back,
            children: [
              const Spacer(),
              Obx(() {
                if (controller.listHistoryPhk.isEmpty) {
                  return const SizedBox.shrink();
                }
                return ElevatedButton.icon(
                  onPressed: () {
                    showDialogHistoryPhk(context, controller);
                  },
                  icon: const Icon(Icons.history, color: Colors.blue, size: 20),
                  label: const Text(
                    'History PHK',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 25),
              child: PhkFormBody(
                isHistoryEdit: false,
                onSimpan: controller.simpanPhkData,
                onBatal: Get.back,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PhkFormBody extends StatelessWidget {
  final bool isHistoryEdit;
  final Phk? historyPhk;
  final void Function()? onSimpan;
  final void Function()? onBatal;

  const PhkFormBody({
    super.key,
    this.isHistoryEdit = false,
    this.historyPhk,
    this.onSimpan,
    this.onBatal,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KaryawanControl>();
    const double labelWidth = 185;
    final stylePenghasilan = TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w500);
    final stylePotongan = TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w500);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                paddingTop: 10,
              ),
            ),
            Expanded(
              child: AFwidget.barisInfo(
                label: 'Status Karyawan',
                nilai: (isHistoryEdit && historyPhk != null && historyPhk!.statusKerja.nama.isNotEmpty)
                    ? historyPhk!.statusKerja.nama
                    : controller.current.statusKerja.nama,
                labelWidth: labelWidth,
                paddingLeft: 10,
                paddingRight: 20,
                paddingTop: 10,
              ),
            ),
          ],
        ),
              GetBuilder<KaryawanControl>(
                builder: (_) {
                  final upah = controller.current.upah;
                  final pPhk = controller.current.phk.payrollPhk.id.isNotEmpty
                      ? controller.current.phk.payrollPhk
                      : controller.current.payrollPhk;
                  final int gaji = upah.gaji > 0 ? upah.gaji : pPhk.gaji;
                  final int uangMakan = upah.uangMakan > 0 ? upah.uangMakan : pPhk.uangMakanHarian;
                  final bool makanHarian = upah.id.isNotEmpty
                      ? upah.makanHarian
                      : pPhk.makanHarian;

                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AFwidget.barisInfo(
                              label: 'Jabatan',
                              nilai: controller.current.jabatan.nama,
                              labelWidth: labelWidth,
                              paddingLeft: 20,
                              paddingRight: 10,
                              paddingTop: 11,
                            ),
                          ),
                          Expanded(
                            child: AFwidget.barisInfo(
                              label: 'Gaji',
                              nilai: 'Rp. ${AFconvert.matNumber(gaji)}',
                              labelWidth: labelWidth,
                              paddingLeft: 10,
                              paddingRight: 20,
                              paddingTop: 11,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AFwidget.barisInfo(
                              label: 'Divisi',
                              nilai: controller.current.divisi.nama,
                              labelWidth: labelWidth,
                              paddingLeft: 20,
                              paddingRight: 10,
                              paddingTop: 11,
                            ),
                          ),
                          Expanded(
                            child: AFwidget.barisInfo(
                              label: 'Uang Makan',
                              nilai: 'Rp. ${AFconvert.matNumber(uangMakan)} (${makanHarian ? 'Harian' : 'Tetap'})',
                              labelWidth: labelWidth,
                              paddingLeft: 10,
                              paddingRight: 20,
                              paddingTop: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
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
              Obx(() => Container(
                padding: EdgeInsets.only(bottom: controller.sertakanKalkulasiPhk.value ? 15 : 0),
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                decoration: BoxDecoration(
                  color: controller.sertakanKalkulasiPhk.value ? Colors.white : Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade200, width: 1.2),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      onTap: () {
                        controller.sertakanKalkulasiPhk.toggle();
                        controller.hitungTotalPhk();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: controller.sertakanKalkulasiPhk.value,
                                onChanged: (val) {
                                  controller.sertakanKalkulasiPhk.value = val ?? false;
                                  controller.hitungTotalPhk();
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'KALKULASI PHK',
                              style: TextStyle(
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              controller.sertakanKalkulasiPhk.value
                                  ? '(Disertakan)'
                                  : '(Tidak Disertakan / Klik untuk mengisi kalkulasi PHK)',
                              style: TextStyle(
                                color: controller.sertakanKalkulasiPhk.value ? Colors.blue.shade700 : Colors.grey.shade600,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              controller.sertakanKalkulasiPhk.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: Colors.blue.shade700,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (controller.sertakanKalkulasiPhk.value) ...[
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
                            label: 'Note Kompensasi',
                            controller: controller.txtKetKompensasi,
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
                            label: 'Uang Pisah',
                            controller: controller.txtUangPisah,
                            isNumber: true,
                            onchanged: (val) => controller.hitungTotalPhk(),
                            labelWidth: labelWidth,
                            paddingLeft: 15,
                            paddingRight: 10,
                          ),
                        ),
                        Expanded(
                          child: AFwidget.barisText(
                            label: 'Note Uang Pisah',
                            controller: controller.txtKetUangPisah,
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
                            label: 'Note Pesangon',
                            controller: controller.txtKetPesangon,
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
                            label: 'Masa Kerja',
                            controller: controller.txtMasaKerja,
                            isNumber: true,
                            onchanged: (val) => controller.hitungTotalPhk(),
                            labelWidth: labelWidth,
                            paddingLeft: 15,
                            paddingRight: 10,
                          ),
                        ),
                        Expanded(
                          child: AFwidget.barisText(
                            label: 'Note Masa Kerja',
                            controller: controller.txtKetMasaKerja,
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
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 11, 10, 0),
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
                                        onchanged: (nilai) {
                                          int hari = AFconvert.keInt(nilai);
                                          int gaji = controller.current.upah.gaji;
                                          var jumlah = (gaji / 21) * hari;
                                          controller.txtSisaCutiJumlah.text = AFconvert.matNumber(jumlah.round());
                                          controller.hitungTotalPhk();
                                        },
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
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                    ],
                  ],
                ),
              )),

              const SizedBox(height: 15),

              // 2. PAYROLL PHK
              Obx(() => Container(
                padding: EdgeInsets.only(bottom: controller.sertakanPayrollPhk.value ? 15 : 0),
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                decoration: BoxDecoration(
                  color: controller.sertakanPayrollPhk.value ? Colors.white : Colors.green.shade50,
                  border: Border.all(color: Colors.green.shade500, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      onTap: () {
                        controller.sertakanPayrollPhk.toggle();
                        controller.hitungTotalPhk();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: controller.sertakanPayrollPhk.value,
                                onChanged: (val) {
                                  controller.sertakanPayrollPhk.value = val ?? false;
                                  controller.hitungTotalPhk();
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'PAYROLL PHK',
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              controller.sertakanPayrollPhk.value
                                  ? '(Disertakan)'
                                  : '(Tidak Disertakan / Klik untuk mengisi payroll PHK)',
                              style: TextStyle(
                                color: controller.sertakanPayrollPhk.value ? Colors.green.shade700 : Colors.grey.shade600,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              controller.sertakanPayrollPhk.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: Colors.green.shade700,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (controller.sertakanPayrollPhk.value) ...[
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
                              if (controller.current.upah.makanHarian) {
                                var jumlah = AFconvert.keInt(nilai) * controller.current.upah.uangMakan;
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
                      label: 'Keterangan Payroll',
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

                                AFwidget.barisText(
                                  label: 'U/makan & Transport',
                                  controller: controller.txtPayrollPhkUangMakanJumlah,
                                  isNumber: true,
                                  readOnly: controller.current.upah.makanHarian,
                                  onchanged: controller.hitungPayrollPhkPenerimaanBersih,
                                  labelWidth: labelWidth,
                                  labelStyle: stylePenghasilan,
                                  paddingLeft: 15,
                                  paddingRight: 10,
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
                                    if (!controller.current.upah.makanHarian) return const SizedBox.shrink();
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
                                                    var jumlah = (controller.current.upah.uangMakan / 4) * AFconvert.keInt(nilai);
                                                    controller.txtPayrollPhkPot25jumlah.text = AFconvert.matNumber(jumlah.round());
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
                                                var jumlah = (controller.current.upah.gaji / 21) * AFconvert.keInt(nilai);
                                                controller.txtPayrollPhkPotCutiJumlah.text = AFconvert.matNumber(jumlah.round());
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
                                                var jumlah = (controller.current.upah.gaji / 168) * AFconvert.keDouble(nilai);
                                                controller.txtPayrollPhkPotKompensasiJumlah.text = AFconvert.matNumber(jumlah.round());
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
                  ],
                ),
              )),

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
                    Builder(
                      builder: (_) {
                        bool adaDataSlip;
                        if (isHistoryEdit && historyPhk != null) {
                          adaDataSlip = historyPhk!.uangPhkId.isNotEmpty ||
                              historyPhk!.payrollPhkId.isNotEmpty ||
                              historyPhk!.uangPhk.id.isNotEmpty ||
                              historyPhk!.payrollPhk.id.isNotEmpty ||
                              controller.sertakanKalkulasiPhk.value ||
                              controller.sertakanPayrollPhk.value;
                        } else {
                          adaDataSlip = controller.current.phk.uangPhkId.isNotEmpty ||
                              controller.current.phk.payrollPhkId.isNotEmpty ||
                              controller.current.phk.uangPhk.id.isNotEmpty ||
                              controller.current.phk.payrollPhk.id.isNotEmpty;
                        }
                        if (adaDataSlip) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AFwidget.tombol(
                                label: 'Cetak Slip PHK',
                                color: Colors.green,
                                onPressed: () => dialogSlipPhk(controller, phkId: isHistoryEdit ? historyPhk?.id : null),
                                minimumSize: const Size(120, 40),
                              ),
                              const SizedBox(width: 25),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    AFwidget.tombol(
                      label: 'Batal',
                      color: Colors.orange,
                      onPressed: onBatal ?? Get.back,
                      minimumSize: const Size(120, 40),
                    ),
                    const SizedBox(width: 25),
                    AFwidget.tombol(
                      label: isHistoryEdit
                          ? 'Simpan Perubahan'
                          : ((controller.current.phk.id.isEmpty || controller.current.aktif == 'Y')
                              ? 'Simpan'
                              : 'Simpan Perubahan'),
                      color: Colors.blue,
                      onPressed: onSimpan ?? controller.simpanPhkData,
                      minimumSize: const Size(120, 40),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}

void dialogSlipPhk(KaryawanControl controller, {String? phkId}) {
  AFwidget.dialog(
    Container(
      width: 500,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AFwidget.formHeader('Cetak Slip PHK'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AFwidget.tombol(
                  label: 'Batal',
                  color: Colors.grey,
                  onPressed: Get.back,
                  minimumSize: const Size(100, 40),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: AFwidget.tombol(
                    label: 'Download PDF',
                    color: Colors.red,
                    onPressed: () {
                      Get.back();
                      controller.downloadPdfSlipPhk(phkId: phkId);
                    },
                    minimumSize: const Size(0, 40),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AFwidget.tombol(
                    label: 'Download Excel',
                    color: Colors.green,
                    onPressed: () {
                      Get.back();
                      controller.downloadExcelSlipPhk(phkId: phkId);
                    },
                    minimumSize: const Size(0, 40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    barrierDismissible: false,
    backgroundColor: Colors.transparent,
    contentPadding: const EdgeInsets.all(0),
  );
}

void showPhkForm(BuildContext context) async {
  final controller = Get.find<KaryawanControl>();
  if (controller.current.upah.id.isEmpty || (controller.current.upah.gaji == 0 && controller.current.upah.uangMakan == 0)) {
    AFwidget.loading();
    try {
      UpahRepository upahRepo = UpahRepository();
      var hasilUpah = await upahRepo.find(controller.current.id);
      if (hasilUpah.success && hasilUpah.data.isNotEmpty) {
        controller.current.upah = Upah.fromMap(hasilUpah.data);
      }
    } catch (_) {}
    Get.back();
  }
  await controller.initPhkForm();
  await controller.loadHistoryPhk();
  Get.to(() => const PhkPage());
}

void showDialogHistoryPhk(BuildContext context, KaryawanControl controller) {
  AFwidget.dialog(
    Container(
      width: Get.width > 1050 ? 1000.0 : Get.width * 0.95,
      height: Get.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 65, 20, 20),
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    if (controller.listHistoryPhk.isEmpty) {
                      return const Center(
                        child: Text(
                          'Tidak ada data riwayat PHK.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: controller.listHistoryPhk.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, index) {
                        final phk = controller.listHistoryPhk[index];
                        final tglAwal = phk.tanggalAwal != null ? AFconvert.matYMD(phk.tanggalAwal) : '-';
                        final tglAkhir = phk.tanggalAKhir != null ? AFconvert.matYMD(phk.tanggalAKhir) : '-';
                        final hasUangPhk = phk.uangPhk.id.isNotEmpty || phk.uangPhkId.isNotEmpty;
                        final hasPayrollPhk = phk.payrollPhk.id.isNotEmpty || phk.payrollPhkId.isNotEmpty;

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 8,
                                      runSpacing: 6,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.history_toggle_off, color: Colors.blue, size: 20),
                                            const SizedBox(width: 6),
                                            Text(
                                              '$tglAwal  s/d  $tglAkhir',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            phk.statusPhk.nama.isNotEmpty ? phk.statusPhk.nama : 'Status PHK',
                                            style: TextStyle(color: Colors.blue.shade900, fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        if (phk.statusKerja.nama.isNotEmpty)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.shade100,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              phk.statusKerja.nama,
                                              style: TextStyle(color: Colors.orange.shade900, fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 95,
                                        child: AFwidget.tombol(
                                          label: 'Cetak',
                                          color: Colors.green,
                                          minimumSize: const Size(95, 30),
                                          onPressed: () {
                                            dialogSlipPhk(controller, phkId: phk.id);
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      SizedBox(
                                        width: 95,
                                        child: AFwidget.tombol(
                                          label: 'Edit',
                                          color: Colors.blue,
                                          minimumSize: const Size(95, 30),
                                          onPressed: () {
                                            showDialogEditHistoryPhk(context, controller, phk);
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      SizedBox(
                                        width: 95,
                                        child: AFwidget.tombol(
                                          label: 'Hapus',
                                          color: Colors.red,
                                          minimumSize: const Size(95, 30),
                                          onPressed: () {
                                            AFwidget.formWarning(
                                              label: 'Apakah Anda yakin ingin menghapus data riwayat PHK periode $tglAwal s/d $tglAkhir? Data kalkulasi dan payroll terkait juga akan terhapus.',
                                              ikon: Icons.delete_forever,
                                              warna: Colors.red,
                                              isKonfirmasi: true,
                                              labelBatal: 'Batal',
                                              labelYa: 'Ya, Hapus',
                                              aksi: () async {
                                                Get.back();
                                                await controller.hapusHistoryPhk(phk.id);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (phk.keterangan.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Keterangan: ${phk.keterangan}',
                                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                                ),
                              ],
                              if (hasUangPhk || hasPayrollPhk) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    if (hasUangPhk) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: Colors.green.shade200),
                                        ),
                                        child: Text(
                                          'Kalkulasi PHK: Rp ${AFconvert.matNumber(phk.uangPhk.totalKalkulasi)}',
                                          style: TextStyle(color: Colors.green.shade800, fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                    if (hasPayrollPhk) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.teal.shade50,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: Colors.teal.shade200),
                                        ),
                                        child: Text(
                                          'Payroll PHK: Rp ${AFconvert.matNumber(phk.payrollPhk.totalDiterima)}',
                                          style: TextStyle(color: Colors.teal.shade800, fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AFwidget.tombol(
                      label: 'Tutup',
                      color: Colors.grey,
                      onPressed: Get.back,
                      minimumSize: const Size(100, 38),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AFwidget.formHeader('Form History PHK'),
        ],
      ),
    ),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.transparent,
    contentPadding: const EdgeInsets.all(0),
  );
}

void showDialogEditHistoryPhk(BuildContext context, KaryawanControl controller, Phk phk) async {
  await controller.initHistoryPhkForm(phk);
  final formWidth = Get.width > 1250 ? 1200.0 : Get.width * 0.96;
  AFwidget.dialog(
    Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      width: formWidth,
      height: Get.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(15, 65, 15, 20),
            child: PhkFormBody(
              isHistoryEdit: true,
              historyPhk: phk,
              onSimpan: () => controller.simpanHistoryPhkData(phk),
              onBatal: () async {
                Get.back();
                await controller.initPhkForm();
              },
            ),
          ),
          AFwidget.formHeader('Form History PHK - ${phk.id}'),
        ],
      ),
    ),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.transparent,
    contentPadding: const EdgeInsets.all(0),
  );
}
