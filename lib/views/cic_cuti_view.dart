import 'package:fjghrd/controllers/home_control.dart' as fjghrd;
import 'package:fjghrd/views/cuti_view.dart' as fjghrd3;
import 'package:fjghrd/views/cic_karyawan_view.dart';

import 'package:fjghrd/controllers/cic_cuti_control.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/models/cuti.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_plutogrid_config.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/cic_cuti_form_view.dart';
import 'package:fjghrd/views/cic_cuti_masal_edit_view.dart';
import 'package:fjghrd/views/cic_cuti_masal_view.dart' as cuti_masal;

import 'package:fjghrd/views/cic_jatah_cuti_tahunan_view.dart';
import 'package:fjghrd/views/cic_jenis_cuti_khusus_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class CicCutiView extends StatelessWidget {
  CicCutiView({super.key});

  void dialogJadwalCuti(BuildContext context) {
    final controller = Get.find<CicCutiControl>();
    AFwidget.dialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      Container(
        width: 500,
        height: 150,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('Jadwal Cuti CIC'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AFwidget.tombol(
                    label: 'Batal',
                    color: Colors.orange,
                    onPressed: () => Get.back(),
                    minimumSize: const Size(100, 40),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download PDF',
                      color: Colors.red,
                      onPressed: controller.downloadJadwalCutiPdf,
                      minimumSize: const Size(0, 40),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download Excel',
                      color: Colors.green,
                      onPressed: controller.downloadJadwalCuti,
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

  void dialogListCuti(BuildContext context) {
    final controller = Get.find<CicCutiControl>();
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
            AFwidget.formHeader('List Cuti CIC'),
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
                    child: GetBuilder<CicCutiControl>(
                      id: 'filter_awal',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterTahunAwal.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.filterTahunAwal.value);
                            if(a != null && a.value != controller.filterTahunAwal.value) {
                              controller.filterTahunAwal = a;
                              controller.update(['filter_awal']);
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
                    child: GetBuilder<CicCutiControl>(
                      id: 'filter_akhir',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterTahunAkhir.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.filterTahunAkhir.value);
                            if(a != null && a.value != controller.filterTahunAkhir.value) {
                              controller.filterTahunAkhir = a;
                              controller.update(['filter_akhir']);
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
                    onPressed: () => Get.back(),
                    minimumSize: const Size(100, 40),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download PDF',
                      color: Colors.red,
                      onPressed: controller.downloadListCutiPdf,
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

  void dialogCutiTanpaPotongan(BuildContext context) {
    final controller = Get.find<CicCutiControl>();
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
            AFwidget.formHeader('Cuti Tanpa Potongan CIC'),
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
                    child: GetBuilder<CicCutiControl>(
                      id: 'filter_awal2',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterTahunAwal.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.filterTahunAwal.value);
                            if(a != null && a.value != controller.filterTahunAwal.value) {
                              controller.filterTahunAwal = a;
                              controller.update(['filter_awal2']);
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
                    child: GetBuilder<CicCutiControl>(
                      id: 'filter_akhir2',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterTahunAkhir.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.filterTahunAkhir.value);
                            if(a != null && a.value != controller.filterTahunAkhir.value) {
                              controller.filterTahunAkhir = a;
                              controller.update(['filter_akhir2']);
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
                    onPressed: () => Get.back(),
                    minimumSize: const Size(100, 40),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download PDF',
                      color: Colors.red,
                      onPressed: controller.downloadCutiTanpaPotonganPdf,
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

  void dialogUnpaidLeave(BuildContext context) {
    final controller = Get.find<CicCutiControl>();
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
            AFwidget.formHeader('Cuti Unpaid Leave & Ganti Hari Libur CIC'),
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
                    child: GetBuilder<CicCutiControl>(
                      id: 'filter_awal3',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterTahunAwal.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.filterTahunAwal.value);
                            if(a != null && a.value != controller.filterTahunAwal.value) {
                              controller.filterTahunAwal = a;
                              controller.update(['filter_awal3']);
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
                    child: GetBuilder<CicCutiControl>(
                      id: 'filter_akhir3',
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterTahunAkhir.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihTahun(value: controller.filterTahunAkhir.value);
                            if(a != null && a.value != controller.filterTahunAkhir.value) {
                              controller.filterTahunAkhir = a;
                              controller.update(['filter_akhir3']);
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
                    onPressed: () => Get.back(),
                    minimumSize: const Size(100, 40),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: AFwidget.tombol(
                      label: 'Download PDF',
                      color: Colors.red,
                      onPressed: controller.downloadUnpaidLeavePdf,
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


  final CicCutiControl controller = Get.put(CicCutiControl());

  List<PlutoRow> _buildRows(List<Cuti> rowData) {
    return List.generate(
      rowData.length,
          (index) => PlutoRow(
        cells: {
          'id': PlutoCell(value: rowData[index].id),
          'cic/karyawan': PlutoCell(value: rowData[index].karyawan?.nama ?? ''),
          'jenis_form': PlutoCell(value: rowData[index].jenisForm),
          'kategori_display': PlutoCell(value: rowData[index].details.map((e) => e.kategori).toSet().join(', ')),
          'lama_cuti': PlutoCell(value: _getLamaCuti(rowData[index].details)),
          'tanggal_cuti': PlutoCell(value: _getTanggalCuti(rowData[index].details)),
          'keterangan': PlutoCell(value: _getKeterangan(rowData[index])),
          'tanggal_kembali': PlutoCell(value: AFconvert.matDate(rowData[index].tanggalKembali)),
        },
      ),
    );
  }



  String _getKeterangan(Cuti cuti) {
    var listKet = cuti.details.map((e) => e.keterangan.trim()).where((e) => e.isNotEmpty).toList();
    return listKet.toSet().join(', ');
  }

  String _getLamaCuti(List<CutiDetail> details) {
    double hari = 0;
    double bulan = 0;
    
    for (var det in details) {
      String satuan = 'hari';
      if (det.jenisKhusus != null && det.jenisKhusus!['satuan'] != null) {
        satuan = det.jenisKhusus!['satuan'].toString().toLowerCase();
      }
      
      double lama = det.lamaHari;
      if (satuan == 'bulan') {
        bulan += lama;
      } else {
        hari += lama;
      }
    }
    
    List<String> parts = [];
    String hStr = hari == hari.toInt() ? hari.toInt().toString() : hari.toString();
    String bStr = bulan == bulan.toInt() ? bulan.toInt().toString() : bulan.toString();
    
    if (hari > 0 && bulan > 0) {
      parts.add(hStr);
      parts.add(bStr);
    } else if (bulan > 0) {
      parts.add(bStr);
    } else if (hari > 0) {
      parts.add(hStr);
    } else {
      parts.add("0");
    }
    
    return parts.join(', ');
  }

  String _formatDateShort(DateTime dt) {
    const months = ['', 'Jan', 'Peb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nop', 'Des'];
    return "${dt.day} ${months[dt.month]}";
  }

  String _getTanggalCuti(List<CutiDetail> details) {
    List<String> resultLines = [];
    
    for (var det in details) {
      if (det.dates.isEmpty) continue;
      
      List<DateTime> parsedDates = [];
      for (var d in det.dates) {
        DateTime? dt = d.tanggal;
        if (dt != null) parsedDates.add(dt);
      }
      if (parsedDates.isEmpty) continue;
      
      parsedDates.sort((a, b) => a.compareTo(b));
      
      if (parsedDates.length == 1) {
        resultLines.add(_formatDateShort(parsedDates.first));
      } else if (parsedDates.length > 5) {
        resultLines.add("${_formatDateShort(parsedDates.first)} s/d ${_formatDateShort(parsedDates.last)}");
      } else {
        Map<int, List<int>> grouped = {};
        for (var dt in parsedDates) {
          if (!grouped.containsKey(dt.month)) {
            grouped[dt.month] = [];
          }
          grouped[dt.month]!.add(dt.day);
        }
        
        List<String> monthStrings = [];
        const months = ['', 'Jan', 'Peb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nop', 'Des'];
        
        grouped.forEach((m, days) {
          monthStrings.add("${days.join(', ')} ${months[m]}");
        });
        
        resultLines.add(monthStrings.join(', '));
      }
    }
    
    return resultLines.join(' | ');
  }

  @override
  Widget build(BuildContext context) {
    final List<PlutoColumn> columns = [
      PlutoColumn(
        title: '',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 53,
        minWidth: 53,
        backgroundColor: Colors.brown.shade100,
        enableFilterMenuItem: false,
        enableContextMenu: false,
        enableDropToResize: false,
        renderer: (rdrCtx) {
          return Row(
            children: [

              IconButton(
                onPressed: () {
                  String id = rdrCtx.row.cells['id']!.value;
                  String jenisForm = rdrCtx.row.cells['jenis_form']!.value;
                  if (jenisForm == 'CUTI_MASAL_GLOBAL') {
                    Get.to(() => CicCutiMasalEditView(id: id));
                  } else {
                    controller.editForm(id, jenisFormRow: jenisForm);
                    _openForm(jenisForm);
                  }
                },
                icon: const Icon(Icons.edit_square),
                iconSize: 18,
                color: Colors.green,
                padding: const EdgeInsets.all(0),
              ),

            ],
          );
        },
      ),
      PlutoColumn(
        title: 'Karyawan',
        field: 'cic/karyawan',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 250,
        minWidth: 150,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'Kategori',
        field: 'kategori_display',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 160,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'Jenis Form',
        field: 'jenis_form',
        type: PlutoColumnType.text(),
        hide: true, // Hide it but keep for logic
      ),
      PlutoColumn(
        title: 'Lama',
        field: 'lama_cuti',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 70,
        textAlign: PlutoColumnTextAlign.center,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'Tanggal Cuti',
        field: 'tanggal_cuti',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 250,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'Keterangan',
        field: 'keterangan',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 350,
        minWidth: 200,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'Tgl Kembali',
        field: 'tanggal_kembali',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 100,
        backgroundColor: Colors.brown.shade100,
      ),
    ];

    return Column(
      children: [
        AFwidget.pageHeader(
          title: 'CIC CUTI & IJIN',
          icon: Icons.beach_access,
          onBack: () {
            Get.find<fjghrd.HomeControl>().kontener = fjghrd3.CutiView();
            Get.find<fjghrd.HomeControl>().update();
          },
          children: [
            _tombol(
              label: 'Form Cuti',
              icon: Icons.flight_takeoff,
              onPressed: () { controller.clearForm(); _openForm('CUTI'); },
            ),
            _tombol(
              label: 'Form Ijin',
              icon: Icons.assignment_late,
              onPressed: () { controller.clearForm(); _openForm('IJIN'); },
            ),
            _tombol(
              label: 'Cuti Masal',
              icon: Icons.groups,
              onPressed: () {
                Get.to(() => const cuti_masal.CicCutiMasalView());
              },
            ),
            _tombol(
              label: 'Jatah Tahunan',
              icon: Icons.date_range,
              onPressed: () {
                Get.find<HomeControl>().kontener = CicJatahCutiTahunanView();
                Get.find<HomeControl>().update();
              },
            ),
            _tombol(
              label: 'Jenis Cuti Khusus',
              icon: Icons.category_outlined,
              onPressed: () {
                Get.find<HomeControl>().kontener = CicJenisCutiKhususView();
                Get.find<HomeControl>().update();
              },
            ),
            _tombol(
              label: 'Data Karyawan',
              icon: Icons.people_alt,
              onPressed: () {
                Get.find<HomeControl>().kontener = CicKaryawanView();
                Get.find<HomeControl>().update();
              },
            ),
            const SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                width: 120,
                child: GetBuilder<CicCutiControl>(
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
                          controller.loadCutis();
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            PopupMenuButton<String>(
              icon: const Icon(Icons.download, color: Colors.white),
              tooltip: 'Download Laporan',
              constraints: const BoxConstraints(minWidth: 350, maxWidth: 400),
              onSelected: (value) {
                if(value == 'jadwal') {
                  dialogJadwalCuti(context);
                } else if(value == 'list') {
                  dialogListCuti(context);
                } else if(value == 'tanpa_potongan') {
                  dialogCutiTanpaPotongan(context);
                } else if(value == 'unpaid') {
                  dialogUnpaidLeave(context);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(value: 'jadwal', child: Text('Jadwal Cuti CIC')),
                const PopupMenuItem<String>(value: 'list', child: Text('List Cuti CIC')),
                const PopupMenuItem<String>(value: 'tanpa_potongan', child: Text('Cuti Tanpa Potongan CIC')),
                const PopupMenuItem<String>(value: 'unpaid', child: Text('Cuti Unpaid Leave & Ganti Hari Libur CIC')),
              ],
            ),
          ],
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              image: bgLineBlue,
            ),
            child: Obx(() {
                return PlutoGrid(
                  key: UniqueKey(),
                  columns: columns,
                  rows: _buildRows(controller.listCuti),
                  onChanged: (PlutoGridOnChangedEvent event) {},
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    event.stateManager.setShowColumnFilter(true);
                  },
                  configuration: AFplutogridConfig.configDua(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _openForm(String formType) {
    AFwidget.dialog(
      Container(
        width: 800,
        height: 600,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CicCutiFormView(formType: formType),
        ),
      ),
      barrierDismissible: false,
      backgroundColor: Colors.transparent,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  Widget _tombol({
    required String label,
    required IconData? icon,
    required void Function()? onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 45),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.white.withValues(alpha: 0.1),
          elevation: 0,
        ),
      ),
    );
  }
}
