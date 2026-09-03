import 'package:fjghrd/utils/af_constant.dart';
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
                      id: 'filter_1',
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
                          controller.update(['filter_1']);
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
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              image: bgLineBlue,
            ),
            child: SingleChildScrollView(
              child: Builder(
                builder: (context) {
                  List<Widget> items = [
                    barisBox(
                      label: 'List Data Karyawan',
                      onPressed: controller.dowloadListDataKaryawan,
                    ),
                    barisBox(
                      label: 'List Data Ex Karyawan',
                      onPressed: dialogListExKaryawan,
                    ),
                    barisBox(
                      label: 'List Payroll',
                      onPressed: controller.dowloadListpayroll,
                    ),
                    barisBox(
                      label: 'List PHK',
                      onPressed: dialogListPHK,
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
                    barisBox(
                      label: 'Jadwal Cuti',
                      onPressed: controller.downloadJadwalCuti,
                    ),
                    barisBox(
                      label: 'List Cuti',
                      onPressed: dialogListCuti,
                    ),
                    barisBox(
                      label: 'Cuti Tanpa Potongan',
                      onPressed: dialogCutiTanpaPotongan,
                    ),
                    barisBox(
                      label: 'Cuti Unpaid Leave & Ganti Hari Libur',
                      onPressed: dialogUnpaidLeave,
                    ),
                  ].animate(interval: 50.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOut).toList();

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      int columnCount = 1;
                      if (constraints.maxWidth >= 900) {
                        columnCount = 3;
                      } else if (constraints.maxWidth >= 600) {
                        columnCount = 2;
                      }

                      int itemsPerColumn = (items.length / columnCount).ceil();
                      List<Widget> columns = [];

                      for (int i = 0; i < columnCount; i++) {
                        int start = i * itemsPerColumn;
                        int end = start + itemsPerColumn;
                        if (end > items.length) end = items.length;

                        if (start < items.length) {
                          columns.add(
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: items.sublist(start, end),
                              ),
                            ),
                          );
                        } else {
                          columns.add(const Expanded(child: SizedBox()));
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: columns,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void dialogListExKaryawan() {
    AFwidget.dialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      Container(
        width: 500,
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Excel List Data Ex Karyawan'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Tahun Awal'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      id: 'filter_2',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterTahunAwal.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.filterTahunAwal.value);
                            if(a != null && a.value != controller.filterTahunAwal.value) {
                              controller.filterTahunAwal = a;
                              controller.update(['filter_2']);
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
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Tahun Akhir'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      id: 'filter_3',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterTahunAkhir.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.filterTahunAkhir.value);
                            if(a != null && a.value != controller.filterTahunAkhir.value) {
                              controller.filterTahunAkhir = a;
                              controller.update(['filter_3']);
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
                    onPressed: controller.dowloadListExKaryawan,
                    minimumSize: const Size(120, 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void dialogCutiTanpaPotongan() {
    controller.filterTahunAwal = controller.filterTahun;
    controller.filterTahunAkhir = controller.filterTahun;
    AFwidget.dialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      Container(
        width: 500,
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Excel Cuti Tanpa Potongan'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Tahun Awal'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      id: 'filter_4',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterTahunAwal.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.filterTahunAwal.value);
                            if(a != null && a.value != controller.filterTahunAwal.value) {
                              controller.filterTahunAwal = a;
                              controller.update(['filter_4']);
                            }
                          }
                        );
                      }
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
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Tahun Akhir'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      id: 'filter_5',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterTahunAkhir.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.filterTahunAkhir.value);
                            if(a != null && a.value != controller.filterTahunAkhir.value) {
                              controller.filterTahunAkhir = a;
                              controller.update(['filter_5']);
                            }
                          }
                        );
                      }
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
                    color: Colors.blue,
                    onPressed: controller.downloadCutiTanpaPotongan,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void dialogUnpaidLeave() {
    controller.filterTahunAwal = controller.filterTahun;
    controller.filterTahunAkhir = controller.filterTahun;
    AFwidget.dialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      Container(
        width: 500,
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Excel Cuti Unpaid Leave & Ganti Hari Libur'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Tahun Awal'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      id: 'filter_6',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterTahunAwal.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.filterTahunAwal.value);
                            if(a != null && a.value != controller.filterTahunAwal.value) {
                              controller.filterTahunAwal = a;
                              controller.update(['filter_6']);
                            }
                          }
                        );
                      }
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
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Tahun Akhir'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      id: 'filter_7',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterTahunAkhir.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.filterTahunAkhir.value);
                            if(a != null && a.value != controller.filterTahunAkhir.value) {
                              controller.filterTahunAkhir = a;
                              controller.update(['filter_7']);
                            }
                          }
                        );
                      }
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
                    color: Colors.blue,
                    onPressed: controller.downloadUnpaidLeave,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void dialogListCuti() {
    controller.filterTahunAwal = controller.filterTahun;
    controller.filterTahunAkhir = controller.filterTahun;
    AFwidget.dialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      Container(
        width: 500,
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Excel List Cuti Karyawan'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Tahun Awal'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      id: 'filter_8',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterTahunAwal.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.filterTahunAwal.value);
                            if(a != null && a.value != controller.filterTahunAwal.value) {
                              controller.filterTahunAwal = a;
                              controller.update(['filter_8']);
                            }
                          }
                        );
                      }
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
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Tahun Akhir'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      id: 'filter_9',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterTahunAkhir.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.filterTahunAkhir.value);
                            if(a != null && a.value != controller.filterTahunAkhir.value) {
                              controller.filterTahunAkhir = a;
                              controller.update(['filter_9']);
                            }
                          }
                        );
                      }
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
                    color: Colors.blue,
                    onPressed: controller.downloadListCuti,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void dialogListPHK() {
    AFwidget.dialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      Container(
        width: 500,
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Excel List PHK'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Tahun Awal'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      id: 'filter_10',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterTahunAwal.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.filterTahunAwal.value);
                            if(a != null && a.value != controller.filterTahunAwal.value) {
                              controller.filterTahunAwal = a;
                              controller.update(['filter_10']);
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
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Tahun Akhir'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      id: 'filter_11',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterTahunAkhir.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.filterTahunAkhir.value);
                            if(a != null && a.value != controller.filterTahunAkhir.value) {
                              controller.filterTahunAkhir = a;
                              controller.update(['filter_11']);
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
                    onPressed: controller.dowloadListPHK,
                    minimumSize: const Size(120, 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      scrollable: false,
    );
  }

  void dialogRekapPayroll() {
    controller.filterJenis = '';
    AFwidget.dialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
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
                      id: 'filter_12',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterArea.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihArea(value: controller.filterArea.value, withSemua: true);
                            if(a != null && a.value != controller.filterArea.value) {
                              controller.filterArea = a;
                              controller.update(['filter_12']);
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
    );
  }

  void dialogRekapPPh21() {
    controller.filterJenis = '';
    AFwidget.dialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
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
                      id: 'filter_13',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterArea.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihArea(value: controller.filterArea.value, withSemua: true);
                            if(a != null && a.value != controller.filterArea.value) {
                              controller.filterArea = a;
                              controller.update(['filter_13']);
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
    );
  }

  void dialogSlipGaji() {
    controller.filterJenis = '';
    AFwidget.dialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      Container(
        width: 500,
        height: 370,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Slip Gaji ${controller.filterTahun.label}'),
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
                      id: 'filter_14',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterBulan.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihBulan(value: controller.filterBulan.value);
                            if(a != null && a.value != controller.filterBulan.value) {
                              controller.filterBulan = a;
                              controller.update(['filter_14']);
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
                      id: 'filter_15',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterArea.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihArea(value: controller.filterArea.value, withSemua: true);
                            if(a != null && a.value != controller.filterArea.value) {
                              controller.filterArea = a;
                              controller.update(['filter_15']);
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
                  const Spacer(),
                  AFwidget.tombol(
                    label: 'Download PDF',
                    color: Colors.red,
                    onPressed: () {
                      controller.downloadSlipGajiPdf();
                    },
                    minimumSize: const Size(120, 40),
                  ),
                  const SizedBox(width: 10),
                  AFwidget.tombol(
                    label: 'Download Excel',
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
                      id: 'filter_16',
              builder: (_) {
                return RadioGroup<String>(
                  groupValue: controller.filterJenis,
                  onChanged: (a) {
                    if(a != null && a != controller.filterJenis) {
                      controller.filterJenis = a;
                      controller.update(['filter_16']);
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
