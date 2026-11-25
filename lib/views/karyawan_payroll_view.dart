import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/models/payroll.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/karyawan_forms/payroll_phk_detil_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KaryawanPayrollView extends StatelessWidget {
  KaryawanPayrollView({super.key});

  final KaryawanControl controller = Get.isRegistered<KaryawanControl>()
      ? Get.find<KaryawanControl>()
      : Get.put(KaryawanControl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AFwidget.pageHeader(
          onBack: Get.back,
          title: controller.authControl.user.role == 'user' ? 'CUTI' : 'PAYROLL & CUTI',
          icon: Icons.list_alt_outlined,
          children: [
            const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.current.nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Jabatan : ${controller.current.jabatan.nama}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                tombol(
                  label: 'Biodata',
                  icon: Icons.download,
                  color: Colors.white,
                  onPressed: dialogBiodata,
                ),
                if (controller.authControl.user.role != 'user') ...[
                  tombol(
                    label: 'Slip Gaji',
                    icon: Icons.download,
                    color: Colors.white,
                    onPressed: dialogSlipGaji,
                  ),
                  if (controller.current.aktif == 'N')
                    tombol(
                      label: 'Add Payroll',
                      icon: Icons.add,
                      color: Colors.white,
                      onPressed: () {
                        showDialogPayrollPhkForm(context, controller);
                      },
                    ),
                  tombol(
                    label: 'Payroll',
                    icon: Icons.download,
                    color: Colors.white,
                    onPressed: dialogExcelPayroll,
                  ),
                ],
                tombol(
                  label: 'List Cuti',
                  icon: Icons.download,
                  color: Colors.white,
                  onPressed: dialogListCuti,
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: 100,
                    child: GetBuilder<KaryawanControl>(
                    builder: (_) {
                      return AFwidget.comboField(
                        value: controller.filterTahun.label,
                        label: '',
                        warna: Colors.white,
                        warnaBackground: Colors.white.withValues(alpha: 0.1),
                        onTap: () async {
                          var a = await controller.pilihTahun(value: controller.filterTahun.value);
                          if(a != null && a.value != controller.filterTahun.value) {
                            controller.filterTahun = a;
                            controller.loadPayrolls();
                          }
                        },
                      );
                    },
                  ),
                ),
                ),
          ],
        ),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              controller: controller.scrollPayroll,
              child: SingleChildScrollView(
                controller: controller.scrollPayroll,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        image: bgLineBlue,
                      ),
                      child: Obx(() {
                          if (controller.authControl.user.role == 'user') {
                            return _buildListCutiPerTanggal();
                          }
                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: controller.listPayroll.map((e) {
                              return boxKonten(context, e);
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCutiPerTanggal() {
    List<Map<String, dynamic>> allDates = [];

    for (var cuti in controller.listCutiKaryawan) {
      for (var det in cuti.details) {
        String baseKet = det.keterangan.trim();
        String ket = baseKet;
        
        if (det.kategori == 'UNPAID') {
          ket = 'UNPAID LEAVE $baseKet'.trim();
        } else if (det.kategori == 'KHUSUS') {
          ket = 'CUTI KHUSUS $baseKet'.trim();
        } else if (det.kategori == 'GANTI_HARI_LIBUR') {
          ket = 'GANTI HARI LIBUR $baseKet'.trim();
        } else {
          if (baseKet.isEmpty) {
            if (det.kategori == 'CUTI_MASAL') {
              ket = 'Cuti Bersama';
            } else if (det.kategori == 'TAHUNAN') {
              ket = 'Cuti Tahunan';
            } else {
              ket = 'Ijin';
            }
          }
        }

        for (var d in det.dates) {
          if (d.tanggal != null) {
            allDates.add({
              'tanggal': d.tanggal!,
              'kategori': det.kategori,
              'keterangan': ket,
            });
          }
        }
      }
    }

    allDates.sort((a, b) => (a['tanggal'] as DateTime).compareTo(b['tanggal'] as DateTime));

    int currentSisa = controller.totalHakCuti;
    List<Widget> children = [];

    for (var item in allDates) {
      DateTime dt = item['tanggal'];
      String kategori = item['kategori'];
      String keterangan = item['keterangan'];

      String? sisaStr;
      if (kategori == 'TAHUNAN' || kategori == 'CUTI_MASAL' || kategori == 'IJIN') {
        currentSisa -= 1;
        sisaStr = currentSisa.toString();
      }

      children.add(
        Container(
          width: 430,
          height: 135,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            boxShadow: const [
              BoxShadow(
                color: Colors.blue,
                blurRadius: 1,
                blurStyle: BlurStyle.outer,
                offset: Offset(1, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_month, color: Colors.blue, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AFconvert.matDate(dt),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  keterangan,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (sisaStr != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Sisa Cuti : $sisaStr',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (children.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text('Belum ada data cuti.', style: TextStyle(fontSize: 16)),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: children,
    );
  }

  Widget boxKonten(BuildContext context, Payroll item) {
    final uangPhk = item.isPhk ? item.uangPhk : null;
    final hasKalkulasiPhk = uangPhk != null &&
        (uangPhk.kompensasi > 0 ||
            uangPhk.uangPisah > 0 ||
            uangPhk.pesangon > 0 ||
            uangPhk.masaKerja > 0 ||
            uangPhk.sisaCutiJumlah > 0);
    int totalKalkulasi = hasKalkulasiPhk ? uangPhk.totalKalkulasi : 0;
    int totalA = item.gaji + item.kenaikanGaji + item.uangMakanJumlah + item.overtimeFjg + item.overtimeCus + item.medical + item.thr + item.bonus + item.insentif + item.telkomsel + item.lain;
    int totalB = item.pot25jumlah + item.potTelepon + item.potKas + item.potCicilan + item.potBpjs + item.potBensin + item.potCutiJumlah + item.potKompensasiJumlah + item.potLain;
    int totalDiterimaCalc = totalKalkulasi + totalA - totalB;
    int totalBenefit = item.kantorJp + item.kantorJht + item.kantorJkk + item.kantorJkm + item.kantorBpjs + item.pph21;
    int totalGrand = totalDiterimaCalc + totalBenefit;

    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Container(
          width: 430,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: item.isPhk ? Colors.red : Colors.blue,
                blurRadius: 1,
                blurStyle: BlurStyle.outer,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      child: Text(
                        '${mapBulan[item.bulan]} ${item.tahun}'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (hasKalkulasiPhk) ...[
                Text('KALKULASI PHK',
                  style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 7),
                if (uangPhk.kompensasi > 0)
                  barisKonten(
                    label: 'Kompensasi',
                    value: AFconvert.matNumber(uangPhk.kompensasi),
                    color: Colors.green.shade700,
                  ),
                if (uangPhk.uangPisah > 0)
                  barisKonten(
                    label: 'Uang Pisah',
                    value: AFconvert.matNumber(uangPhk.uangPisah),
                    color: Colors.green.shade700,
                  ),
                if (uangPhk.pesangon > 0)
                  barisKonten(
                    label: 'Pesangon',
                    value: AFconvert.matNumber(uangPhk.pesangon),
                    color: Colors.green.shade700,
                  ),
                if (uangPhk.masaKerja > 0)
                  barisKonten(
                    label: 'Masa Kerja',
                    value: AFconvert.matNumber(uangPhk.masaKerja),
                    color: Colors.green.shade700,
                  ),
                if (uangPhk.sisaCutiJumlah > 0)
                  barisKonten(
                    label: uangPhk.sisaCutiHari > 0 ? 'Sisa Cuti (${uangPhk.sisaCutiHari} hari)' : 'Sisa Cuti',
                    value: AFconvert.matNumber(uangPhk.sisaCutiJumlah),
                    color: Colors.green.shade700,
                  ),
                barisKonten(
                  label: 'Total Kalkulasi',
                  value: AFconvert.matNumber(totalKalkulasi),
                  bgColor: Colors.green.shade300,
                  color: Colors.white,
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 13),
              ],
              Text('PENGHASILAN',
                style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 7),
              if (item.gaji != 0)
                barisKonten(
                  label: 'Gaji Pokok',
                  value: AFconvert.matNumber(item.gaji),
                  color: Colors.blue.shade700,
                ),
              if (item.kenaikanGaji != 0)
                barisKonten(
                  label: 'Kenaikan Gaji',
                  value: AFconvert.matNumber(item.kenaikanGaji),
                  color: Colors.blue.shade700,
                ),
              if (item.uangMakanJumlah != 0)
                barisKonten(
                  label: 'U/makan & Transport',
                  value: AFconvert.matNumber(item.uangMakanJumlah),
                  color: Colors.blue.shade700,
                ),
              if ((item.overtimeFjg + item.overtimeCus) != 0)
                barisKonten(
                  label: 'Lembur/Overtime',
                  value: AFconvert.matNumber(item.overtimeFjg+item.overtimeCus),
                  color: Colors.blue.shade700,
                ),
              if (item.medical != 0)
                barisKonten(
                  label: 'Reimbursement Medical',
                  value: AFconvert.matNumber(item.medical),
                  color: Colors.blue.shade700,
                ),
              if (item.thr != 0)
                barisKonten(
                  label: 'Tunjangan Hari Raya',
                  value: AFconvert.matNumber(item.thr),
                  color: Colors.blue.shade700,
                ),
              if (item.bonus != 0)
                barisKonten(
                  label: 'Bonus',
                  value: AFconvert.matNumber(item.bonus),
                  color: Colors.blue.shade700,
                ),
              if (item.insentif != 0)
                barisKonten(
                  label: 'Insentif',
                  value: AFconvert.matNumber(item.insentif),
                  color: Colors.blue.shade700,
                ),
              if (item.telkomsel != 0)
                barisKonten(
                  label: 'Telkomsel',
                  value: AFconvert.matNumber(item.telkomsel),
                  color: Colors.blue.shade700,
                ),
              if (item.lain != 0)
                barisKonten(
                  label: 'Lain-lain',
                  value: AFconvert.matNumber(item.lain),
                  color: Colors.blue.shade700,
                ),
              barisKonten(
                label: 'Total Penghasilan',
                value: AFconvert.matNumber(totalA),
                bgColor: Colors.blue.shade300,
                color: Colors.white,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 13),
              Text('POTONGAN',
                style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 7),
              if (item.pot25jumlah != 0)
                barisKonten(
                  label: 'Keterlambatan Kehadiran 25%',
                  value: AFconvert.matNumber(item.pot25jumlah),
                  color: Colors.red.shade700,
                ),
              if (item.potTelepon != 0)
                barisKonten(
                  label: 'Pemakaian Telepon/Telkomsel',
                  value: AFconvert.matNumber(item.potTelepon),
                  color: Colors.red.shade700,
                ),
              if (item.potKas != 0)
                barisKonten(
                  label: 'Pinjaman Kas',
                  value: AFconvert.matNumber(item.potKas),
                  color: Colors.red.shade700,
                ),
              if (item.potCicilan != 0)
                barisKonten(
                  label: 'Pinjaman / Cicilan ',
                  value: AFconvert.matNumber(item.potCicilan),
                  color: Colors.red.shade700,
                ),
              if (item.potBpjs != 0)
                barisKonten(
                  label: 'BPJS Kesehatan',
                  value: AFconvert.matNumber(item.potBpjs),
                  color: Colors.red.shade700,
                ),
              if (item.potBensin != 0)
                barisKonten(
                  label: 'Pemakaian Bensin',
                  value: AFconvert.matNumber(item.potBensin),
                  color: Colors.red.shade700,
                ),
              if (item.potCutiJumlah != 0)
                barisKonten(
                  label: 'Unpaid Leave / Cuti Bersama',
                  value: AFconvert.matNumber(item.potCutiJumlah),
                  color: Colors.red.shade700,
                ),
              if (item.potKompensasiJumlah != 0)
                barisKonten(
                  label: 'Kompensasi Kehadiran (Jam)',
                  value: AFconvert.matNumber(item.potKompensasiJumlah),
                  color: Colors.red.shade700,
                ),
              if (item.potLain != 0)
                barisKonten(
                  label: 'Lain-lain',
                  value: AFconvert.matNumber(item.potLain),
                  color: Colors.red.shade700,
                ),
              barisKonten(
                label: 'Total Potongan',
                value: AFconvert.matNumber(totalB),
                bgColor: Colors.red.shade300,
                color: Colors.white,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  const SizedBox(
                    width: 230,
                    child: Text('TOTAL DITERIMA',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Text('='),
                  Expanded(
                    child: Text(AFconvert.matNumber(totalDiterimaCalc),
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 23),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
                      child: Text('BENEFIT LAINNYA',
                        style: TextStyle(color: Colors.amber.shade800, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 7),
                    if (item.kantorJp != 0)
                      barisKonten(
                        label: 'JP',
                        value: AFconvert.matNumber(item.kantorJp),
                        textAlign: TextAlign.right,
                        color: Colors.amber.shade800,
                      ),
                    if (item.kantorJht != 0)
                      barisKonten(
                        label: 'JHT',
                        value: AFconvert.matNumber(item.kantorJht),
                        textAlign: TextAlign.right,
                        color: Colors.amber.shade800,
                      ),
                    if (item.kantorJkk != 0)
                      barisKonten(
                        label: 'JKK',
                        value: AFconvert.matNumber(item.kantorJkk),
                        textAlign: TextAlign.right,
                        color: Colors.amber.shade800,
                      ),
                    if (item.kantorJkm != 0)
                      barisKonten(
                        label: 'JKM',
                        value: AFconvert.matNumber(item.kantorJkm),
                        textAlign: TextAlign.right,
                        color: Colors.amber.shade800,
                      ),
                    if (item.kantorBpjs != 0)
                      barisKonten(
                        label: 'BPJS Kesehatan',
                        value: AFconvert.matNumber(item.kantorBpjs),
                        textAlign: TextAlign.right,
                        color: Colors.amber.shade800,
                      ),
                    if (item.pph21 != 0)
                      barisKonten(
                        label: 'PPh 21',
                        value: AFconvert.matNumber(item.pph21),
                        textAlign: TextAlign.right,
                        color: Colors.amber.shade800,
                      ),
                    barisKonten(
                      label: 'Total Benefit',
                      value: AFconvert.matNumber(totalBenefit),
                      bgColor: Colors.amber.shade400,
                      color: Colors.white,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const SizedBox(
                    width: 230,
                    child: Text('TOTAL',
                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Text('=', style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w600)),
                  Expanded(
                    child: Text(AFconvert.matNumber(totalGrand),
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Colors.black45, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (item.isPhk && controller.authControl.user.role != 'user')
          Positioned(
            top: 12,
            right: 14,
            child: IconButton(
              onPressed: () {
                showDialogPayrollPhkForm(context, controller, item: item);
              },
              icon: const Icon(Icons.edit, color: Colors.black, size: 20),
              tooltip: 'Edit Payroll PHK',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
      ],
    );
  }

  Widget barisKonten({
    String label = '',
    String value = '',
    TextAlign? textAlign,
    Color? color,
    Color? bgColor,
    bool withBorder = false,
  }) {
    if (bgColor != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '=',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      decoration: withBorder
          ? BoxDecoration(
              border: Border.symmetric(horizontal: BorderSide(color: color ?? const Color(0xFF000000))),
            )
          : null,
      child: Row(
        children: [
          Container(
            width: 230,
            padding: const EdgeInsets.only(right: 10),
            child: Text(label,
              textAlign: textAlign,
              style: TextStyle(
                color: color,
              ),
            ),
          ),
          Text('=',
            style: TextStyle(
              color: color,
            ),
          ),
          Expanded(
            child: Text(value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void dialogBiodata() {
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
            AFwidget.formHeader('Cetak Biodata Karyawan'),
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
                        controller.downloadPdfBiodata(controller.current.id);
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
                        controller.downloadBiodata(controller.current.id);
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

  void dialogListCuti() {
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
            AFwidget.formHeader('List Cuti ${controller.filterTahun.label}'),
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
                        controller.downloadPdfListCuti();
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
                        controller.downloadListCuti();
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
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void dialogExcelPayroll() {
    // Default ke pertahun
    String modePilihan = 'tahun'; // 'tahun' atau 'periode'
    bool cantumkanBenefit = false;

    AFwidget.dialog(
      StatefulBuilder(
        builder: (ctx, setStateDialog) {
          return Container(
            width: 520,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AFwidget.formHeader('Payroll ${controller.current.nama}'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pilihan mode
                      RadioGroup<String>(
                        groupValue: modePilihan,
                        onChanged: (val) {
                          if (val != null) {
                            setStateDialog(() { modePilihan = val; });
                          }
                        },
                        child: Row(
                          children: const [
                            Radio<String>(
                              value: 'tahun',
                            ),
                            Text('Per Tahun', style: TextStyle(fontWeight: FontWeight.w600)),
                            SizedBox(width: 30),
                            Radio<String>(
                              value: 'periode',
                            ),
                            Text('Per Periode', style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Konten berdasarkan pilihan
                      if(modePilihan == 'tahun') ...[
                        Row(
                          children: [
                            const Text('Tahun : ', style: TextStyle(fontWeight: FontWeight.w500)),
                            const SizedBox(width: 10),
                            GetBuilder<KaryawanControl>(
                              builder: (_) {
                                return SizedBox(
                                  width: 150,
                                  child: AFwidget.comboField(
                                    value: controller.filterTahun.label,
                                    label: '',
                                    warna: Colors.brown.shade400,
                                    onTap: () async {
                                      var a = await controller.pilihTahun(value: controller.filterTahun.value);
                                      if(a != null && a.value != controller.filterTahun.value) {
                                        controller.filterTahun = a;
                                        controller.loadPayrolls();
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ] else ...[
                        // Mode Per Periode - 2 baris: Awal dan Akhir
                        GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return Column(
                              children: [
                                // Baris Awal
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 60,
                                      child: Text('Dari :', style: TextStyle(fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 160,
                                      child: AFwidget.comboField(
                                        value: controller.payrollBulanAwal.label,
                                        label: 'Bulan',
                                        warna: Colors.indigo.shade300,
                                        onTap: () async {
                                          var a = await controller.pilihBulan(value: controller.payrollBulanAwal.value);
                                          if(a != null) {
                                            controller.payrollBulanAwal = a;
                                            controller.update();
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 110,
                                      child: AFwidget.comboField(
                                        value: controller.payrollTahunAwal.label,
                                        label: 'Tahun',
                                        warna: Colors.brown.shade400,
                                        onTap: () async {
                                          var a = await controller.pilihTahun(value: controller.payrollTahunAwal.value);
                                          if(a != null) {
                                            controller.payrollTahunAwal = a;
                                            controller.update();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Baris Akhir
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 60,
                                      child: Text('S/D :', style: TextStyle(fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 160,
                                      child: AFwidget.comboField(
                                        value: controller.payrollBulanAkhir.label,
                                        label: 'Bulan',
                                        warna: Colors.indigo.shade300,
                                        onTap: () async {
                                          var a = await controller.pilihBulan(value: controller.payrollBulanAkhir.value);
                                          if(a != null) {
                                            controller.payrollBulanAkhir = a;
                                            controller.update();
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 110,
                                      child: AFwidget.comboField(
                                        value: controller.payrollTahunAkhir.label,
                                        label: 'Tahun',
                                        warna: Colors.brown.shade400,
                                        onTap: () async {
                                          var a = await controller.pilihTahun(value: controller.payrollTahunAkhir.value);
                                          if(a != null) {
                                            controller.payrollTahunAkhir = a;
                                            controller.update();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],

                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          setStateDialog(() {
                            cantumkanBenefit = !cantumkanBenefit;
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: cantumkanBenefit,
                              onChanged: (val) {
                                setStateDialog(() {
                                  cantumkanBenefit = val ?? false;
                                });
                              },
                            ),
                            const Text('Cantumkan Benefit Lainnya', style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AFwidget.tombol(
                            label: 'Batal',
                            color: Colors.grey,
                            onPressed: Get.back,
                            minimumSize: const Size(110, 40),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: AFwidget.tombol(
                              label: 'Download PDF',
                              color: Colors.red,
                              onPressed: () {
                                Get.back();
                                if(modePilihan == 'tahun') {
                                  controller.dowloadPayrollPdf(cantumkanBenefit: cantumkanBenefit);
                                } else {
                                  controller.dowloadPayrollPeriodePdf(cantumkanBenefit: cantumkanBenefit);
                                }
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
                                if(modePilihan == 'tahun') {
                                  controller.dowloadPayroll(cantumkanBenefit: cantumkanBenefit);
                                } else {
                                  controller.dowloadPayrollPeriode(cantumkanBenefit: cantumkanBenefit);
                                }
                              },
                              minimumSize: const Size(0, 40),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void dialogSlipGaji() {
    AFwidget.dialog(
      Container(
        width: 500,
        height: 370,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AFwidget.formHeader('Slip Gaji ${controller.filterTahun.label}'),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 15, 42, 20),
              child: Row(
                children: [
                  Text('Silakan pilih bulan :'),
                  const Spacer(),
                  GetBuilder<KaryawanControl>(
                    builder: (_) {
                      return Checkbox(
                        value: controller.bulanTerpilih.values.every((v) => v),
                        onChanged: (value) {
                          if (value != null) {
                            controller.bulanTerpilih.updateAll((key, val) => value);
                            controller.update();
                          }
                        },
                      );
                    },
                  ),
                  const Text("pilih semua"),
                ],
              ),
            ),
            GetBuilder<KaryawanControl>(
              builder: (_) {
                return SizedBox(
                  height: 150,
                  width: 500,
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 5,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    padding: const EdgeInsets.only(left: 10),
                    children: controller.bulanTerpilih.entries.map((el) {
                      return Row(
                        children: [
                          Checkbox(
                            value: el.value,
                            onChanged: (value) {
                              if(value != null) {
                                controller.bulanTerpilih[el.key] = value;
                                controller.update();
                              }
                            },
                          ),
                          Text(mapBulan[el.key]!),
                        ],
                      );
                    }).toList(),
                  ),
                );
              }
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AFwidget.tombol(
                    label: 'Batal',
                    color: Colors.grey,
                    onPressed: Get.back,
                    minimumSize: const Size(110, 40),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download PDF',
                      color: Colors.red,
                      onPressed: () {
                        Get.back();
                        controller.downloadPdfSlipGaji();
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
                        controller.downloadSlipGaji();
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
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  Widget tombol({
    required String label,
    required IconData? icon,
    required void Function()? onPressed,
    Color? color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(100, 70),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        foregroundColor: color,
        backgroundColor: color?.withValues(alpha: 0.1),
      ),
    );
  }
}
