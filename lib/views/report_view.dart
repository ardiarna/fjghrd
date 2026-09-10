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
                      onModalTap: dialogListDataKaryawan,
                    ),

                    barisBox(
                      label: 'List Salary',
                      onDownloadExcel: controller.dowloadListSalary,
                      onDownloadPdf: controller.dowloadListSalaryPdf,
                    ),
                    barisBox(
                      label: 'List Payroll',
                      onDownloadExcel: controller.dowloadListpayroll,
                    ),
                    barisBox(
                      label: 'List PHK',
                      onModalTap: dialogListPHK,
                    ),
                    barisBox(
                      label: 'Rekap Gaji',
                      onDownloadExcel: controller.dowloadRekapPayroll,
                    ),
                    barisBox(
                      label: 'Rekap Medical',
                      onDownloadExcel: controller.dowloadRekapMedical,
                    ),
                    barisBox(
                      label: 'Rekap Overtime',
                      onDownloadExcel: controller.dowloadRekapOvertime,
                    ),
                    barisBox(
                      label: 'Rekap Payroll Per Karyawan',
                      onModalTap: dialogRekapPayroll,
                    ),
                    barisBox(
                      label: 'Rekap PPh 21',
                      onModalTap: dialogRekapPPh21,
                    ),
                    barisBox(
                      label: 'Slip Gaji',
                      onModalTap: dialogSlipGaji,
                    ),
                    barisBox(
                      label: 'Jadwal Cuti',
                      onDownloadExcel: controller.downloadJadwalCuti,
                    ),
                    barisBox(
                      label: 'List Cuti',
                      onModalTap: dialogListCuti,
                    ),
                    barisBox(
                      label: 'Cuti Tanpa Potongan',
                      onModalTap: dialogCutiTanpaPotongan,
                    ),
                    barisBox(
                      label: 'Cuti Unpaid Leave & Ganti Hari Libur',
                      onModalTap: dialogUnpaidLeave,
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
                    color: Colors.grey,
                    onPressed: Get.back,
                    minimumSize: const Size(110, 40),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download PDF',
                      color: Colors.red,
                      onPressed: () { AFwidget.snackbar('BELUM_DIBUAT'); },
                      minimumSize: const Size(0, 40),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download Excel',
                      color: Colors.green,
                      onPressed: controller.dowloadListExKaryawan,
                      minimumSize: const Size(0, 40),
                    ),
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
                    color: Colors.grey,
                    onPressed: Get.back,
                    minimumSize: const Size(110, 40),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download PDF',
                      color: Colors.red,
                      onPressed: () { AFwidget.snackbar('BELUM_DIBUAT'); },
                      minimumSize: const Size(0, 40),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download Excel',
                      color: Colors.green,
                      onPressed: controller.downloadCutiTanpaPotongan,
                      minimumSize: const Size(0, 40),
                    ),
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
                    color: Colors.grey,
                    onPressed: Get.back,
                    minimumSize: const Size(110, 40),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download PDF',
                      color: Colors.red,
                      onPressed: () { AFwidget.snackbar('BELUM_DIBUAT'); },
                      minimumSize: const Size(0, 40),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download Excel',
                      color: Colors.green,
                      onPressed: controller.downloadUnpaidLeave,
                      minimumSize: const Size(0, 40),
                    ),
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
                    color: Colors.grey,
                    onPressed: Get.back,
                    minimumSize: const Size(110, 40),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download PDF',
                      color: Colors.red,
                      onPressed: () { AFwidget.snackbar('BELUM_DIBUAT'); },
                      minimumSize: const Size(0, 40),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download Excel',
                      color: Colors.green,
                      onPressed: controller.downloadListCuti,
                      minimumSize: const Size(0, 40),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void dialogDataKaryawanPerJoint() {
    AFwidget.dialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      Container(
        width: 500,
        height: 350,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Excel Data Karyawan Per Joint'),
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
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                children: [
                  const SizedBox(width: 115),
                  GetBuilder<ReportControl>(
                    id: 'filter_joint_ex',
                    builder: (_) {
                      return Row(
                        children: [
                          Checkbox(
                            value: controller.includeExKaryawanJoint,
                            onChanged: (val) {
                              controller.includeExKaryawanJoint = val ?? false;
                              controller.update(['filter_joint_ex']);
                            },
                          ),
                          const Text('Termasuk Ex Karyawan'),
                        ],
                      );
                    },
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
                    color: Colors.grey,
                    onPressed: Get.back,
                    minimumSize: const Size(110, 40),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download PDF',
                      color: Colors.red,
                      onPressed: () { AFwidget.snackbar('BELUM_DIBUAT'); },
                      minimumSize: const Size(0, 40),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download Excel',
                      color: Colors.green,
                      onPressed: controller.dowloadDataKaryawanPerJoint,
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
    );
  }

      void dialogListDataKaryawan() async {
    if (controller.listDivisi.isEmpty) {
      AFwidget.loading();
      await controller.loadDivisis();
      Get.back();
    }
    
    List<Map<String, dynamic>> allMenus = [
      {'label': 'Data General Karyawan', 'onDownloadExcel': () { Get.back(); controller.dowloadListDataKaryawan(); }},
      {'label': 'Data Ex Karyawan', 'onModalTap': () { Get.back(); dialogListExKaryawan(); }},
      {'label': 'NIK & TLP Karyawan', 'onDownloadExcel': () { Get.back(); controller.dowloadNikTlpKaryawan(); }},
      {'label': 'Data Status Karyawan', 'onDownloadExcel': () { Get.back(); controller.dowloadDataStatusKaryawan(); }},
      {'label': 'Data Jabatan Karyawan', 'onDownloadExcel': () { Get.back(); controller.dowloadDataJabatanKaryawan(); }},
      {'label': 'Data Karyawan Per Joint', 'onModalTap': () { Get.back(); dialogDataKaryawanPerJoint(); }},
    ];
    
    for (var div in controller.listDivisi) {
      allMenus.add({'label': 'Data ${div.label}', 'onDownloadExcel': () { Get.back(); controller.dowloadDataDivisi(div.value, div.label); }});
      allMenus.add({'label': 'Alamat ${div.label}', 'onDownloadExcel': () { Get.back(); controller.dowloadAlamatDivisi(div.value, div.label); }});
    }
    
    allMenus.add({'label': 'Data PROFESSIONAL SERVICE', 'onDownloadExcel': () { Get.back(); controller.dowloadDataProfessionalService(); }});
    allMenus.add({'label': 'Alamat PROFESSIONAL SERVICE', 'onDownloadExcel': () { Get.back(); controller.dowloadAlamatProfessionalService(); }});

    TextEditingController txtCari = TextEditingController();

    AFwidget.dialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      StatefulBuilder(
        builder: (context, setState) {
          var filteredMenus = allMenus.where((m) => m['label'].toLowerCase().contains(txtCari.text.toLowerCase())).toList();
          
          return Container(
            width: 1000,
            height: Get.height * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              children: [
                AFwidget.formHeader('Menu Data Karyawan'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: SizedBox(
                    height: 35,
                    child: TextField(
                      controller: txtCari,
                      onChanged: (val) => setState(() {}),
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        hintText: 'Cari laporan...',
                        hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.black26)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.black26)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.orange)),
                        suffixIconConstraints: const BoxConstraints(minWidth: 35, minHeight: 35),
                        suffixIcon: txtCari.text.isNotEmpty 
                          ? InkWell(
                              onTap: () {
                                txtCari.clear();
                                setState(() {});
                              },
                              child: const Icon(Icons.close, size: 16, color: Colors.black54),
                            )
                          : const SizedBox(width: 35, height: 35),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Wrap(
                      children: filteredMenus.map((m) => SizedBox(
                        width: (1000 - 40) / 2,
                        child: barisBox(label: m['label'], onModalTap: m['onModalTap'], onDownloadExcel: m['onDownloadExcel'], onDownloadPdf: m['onDownloadPdf']),
                      )).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AFwidget.tombol(
                        label: 'Tutup',
                        color: Colors.orange,
                        onPressed: Get.back,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
      scrollable: false,
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
                    color: Colors.grey,
                    onPressed: Get.back,
                    minimumSize: const Size(110, 40),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download PDF',
                      color: Colors.red,
                      onPressed: () { AFwidget.snackbar('BELUM_DIBUAT'); },
                      minimumSize: const Size(0, 40),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download Excel',
                      color: Colors.green,
                      onPressed: controller.dowloadListPHK,
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
                    color: Colors.grey,
                    onPressed: Get.back,
                    minimumSize: const Size(110, 40),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download PDF',
                      color: Colors.red,
                      onPressed: () { AFwidget.snackbar('BELUM_DIBUAT'); },
                      minimumSize: const Size(0, 40),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download Excel',
                      color: Colors.green,
                      onPressed: controller.dowloadRekapPayrollPerKaryawan,
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
                      onPressed: () { AFwidget.snackbar('BELUM_DIBUAT'); },
                      minimumSize: const Size(0, 40),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download Excel',
                      color: Colors.green,
                      onPressed: controller.dowloadRekapPPh21,
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
                      controller.downloadSlipGajiPdf();
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
    );
  }

  Widget barisBox({
    required String label,
    Function()? onModalTap,
    Function()? onDownloadExcel,
    Function()? onDownloadPdf,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155), fontSize: 15)),
        trailing: onModalTap != null 
          ? IconButton(
              icon: const Icon(Icons.download_rounded, color: Color(0xFF94A3B8), size: 22),
              onPressed: onModalTap,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  onPressed: onDownloadPdf ?? () { AFwidget.snackbar('BELUM_DIBUAT'); },
                ),
                IconButton(
                  icon: const Icon(Icons.table_view, color: Colors.green),
                  onPressed: onDownloadExcel ?? () { AFwidget.snackbar('BELUM_DIBUAT'); },
                ),
              ],
            ),
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
