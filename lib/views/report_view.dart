import 'package:fjghrd/controllers/report_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ReportView extends StatelessWidget {
  ReportView({super.key});

  final ReportControl controller = Get.put(ReportControl());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF334155), Color(0xFF475569)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.analytics_outlined, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              const Text('Laporan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 150,
                child: GetBuilder<ReportControl>(
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
        Expanded(
          child: Container(
            width: double.infinity,
            color: const Color(0xFFF8FAFC),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  barisBox(
                    label: 'List Payroll',
                    onPressed: controller.dowloadListpayroll,
                  ),
                  barisBox(
                    label: 'List PHK',
                    onPressed: controller.dowloadListPHK,
                  ),
                  barisBox(
                    label: 'Rekap Gaji',
                    onPressed: controller.dowloadRekapPayroll,
                  ),
                  barisBox(
                    label: 'Rekap Medical',
                    onPressed: controller.dowloadRekapMedical,
                  ),
                  barisBox(
                    label: 'Rekap Overtime',
                    onPressed: controller.dowloadRekapOvertime,
                  ),
                  barisBox(
                    label: 'Rekap Payroll Per Karyawan',
                    onPressed: dialogRekapPayroll,
                  ),
                  barisBox(
                    label: 'Rekap PPh 21',
                    onPressed: dialogRekapPPh21,
                  ),
                  barisBox(
                    label: 'Slip Gaji',
                    onPressed: dialogSlipGaji,
                  ),
                  const SizedBox(height: 24),
                ].animate(interval: 50.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void dialogRekapPayroll() {
    controller.filterJenis = '';
    AFwidget.dialog(
      Container(
        width: 500,
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Excel Rekap Payroll Per Karyawan ${controller.filterTahun.label}'),
            pilihDivisi(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Area'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterArea.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihArea(value: controller.filterArea.value, withSemua: true);
                            if(a != null && a.value != controller.filterArea.value) {
                              controller.filterArea = a;
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
                    label: 'Download',
                    color: Colors.blueGrey,
                    onPressed: controller.dowloadRekapPayrollPerKaryawan,
                    minimumSize: const Size(120, 40),
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

  void dialogRekapPPh21() {
    controller.filterJenis = '';
    AFwidget.dialog(
      Container(
        width: 500,
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Excel Rekap PPh21 Tahun ${controller.filterTahun.label}'),
            pilihDivisi(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Area'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterArea.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihArea(value: controller.filterArea.value, withSemua: true);
                            if(a != null && a.value != controller.filterArea.value) {
                              controller.filterArea = a;
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 20, 25),
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
                    label: 'Download',
                    color: Colors.blueGrey,
                    onPressed: controller.dowloadRekapPPh21,
                    minimumSize: const Size(120, 40),
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

  void dialogSlipGaji() {
    controller.filterJenis = '';
    AFwidget.dialog(
      Container(
        width: 500,
        height: 370,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Excel Slip Gaji ${controller.filterTahun.label}'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Bulan'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterBulan.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihBulan(value: controller.filterBulan.value);
                            if(a != null && a.value != controller.filterBulan.value) {
                              controller.filterBulan = a;
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
            pilihDivisi(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Area'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterArea.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihArea(value: controller.filterArea.value, withSemua: true);
                            if(a != null && a.value != controller.filterArea.value) {
                              controller.filterArea = a;
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
                    label: 'Download',
                    color: Colors.blueGrey,
                    onPressed: () {
                      controller.downloadSlipGaji();
                    },
                    minimumSize: const Size(120, 40),
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

  Widget barisBox({
    required String label,
    required Function()? onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onPressed,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.description_outlined, color: Color(0xFF64748B)),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155), fontSize: 15)),
        trailing: const Icon(Icons.download_rounded, color: Color(0xFF94A3B8), size: 22),
      ),
    );
  }

  Widget pilihDivisi() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Container(
            width: 100,
            padding: const EdgeInsets.only(right: 15),
            child: const Text('Divisi'),
          ),
          Expanded(
            child: GetBuilder<ReportControl>(
              builder: (_) {
                return RadioGroup<String>(
                  groupValue: controller.filterJenis,
                  onChanged: (a) {
                    if(a != null && a != controller.filterJenis) {
                      controller.filterJenis = a;
                      controller.update();
                    }
                  },
                  child: Column(
                    children: const [
                      Row(
                        children: [
                          Radio<String>(value: '1'),
                          SizedBox(
                            width: 130,
                            child: Text('Engineering'),
                          ),
                          Radio<String>(value: '3'),
                          SizedBox(
                            width: 130,
                            child: Text('Non Staf'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String>(value: '2'),
                          SizedBox(
                            width: 130,
                            child: Text('Staf'),
                          ),
                          Radio<String>(value: '4'),
                          SizedBox(
                            width: 130,
                            child: Text('Semua'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
