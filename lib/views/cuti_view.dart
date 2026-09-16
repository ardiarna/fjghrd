import 'package:fjghrd/controllers/home_control.dart' as fjghrd;
import 'package:fjghrd/views/cic_cuti_view.dart' as fjghrd2;

import 'package:fjghrd/controllers/cuti_control.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/models/cuti.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_plutogrid_config.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/cuti_form_view.dart';
import 'package:fjghrd/views/cuti_masal_view.dart' as cuti_masal;

import 'package:fjghrd/views/jatah_cuti_tahunan_view.dart';
import 'package:fjghrd/views/jenis_cuti_khusus_view.dart';
import 'package:fjghrd/views/cuti_masal_edit_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class CutiView extends StatelessWidget {
  CutiView({super.key});

  final CutiControl controller = Get.put(CutiControl());

  List<PlutoRow> _buildRows(List<Cuti> rowData) {
    return List.generate(
      rowData.length,
          (index) => PlutoRow(
        cells: {
          'id': PlutoCell(value: rowData[index].id),
          'karyawan': PlutoCell(value: rowData[index].karyawan?.nama ?? ''),
          'jenis_form': PlutoCell(value: rowData[index].jenisForm),
          'kategori_display': PlutoCell(value: rowData[index].details.map((e) => e.kategori).toSet().join(', ')),
          'lama_cuti': PlutoCell(value: rowData[index].jenisForm == 'CUTI_MASAL_GLOBAL' ? (rowData[index].details.first.lamaHari == rowData[index].details.first.lamaHari.toInt() ? rowData[index].details.first.lamaHari.toInt().toString() : rowData[index].details.first.lamaHari.toString()) : _getLamaCuti(rowData[index].details)),
          'tanggal_cuti': PlutoCell(value: rowData[index].tanggalCutiStr.isNotEmpty ? rowData[index].tanggalCutiStr : _getTanggalCuti(rowData[index].details)),
          'keterangan': PlutoCell(value: rowData[index].jenisForm == 'CUTI_MASAL_GLOBAL' ? rowData[index].details.first.keterangan : _getKeterangan(rowData[index])),
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
                    Get.to(() => CutiMasalEditView(id: id));
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
        field: 'karyawan',
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
          title: 'CUTI & IJIN',
          icon: Icons.beach_access,
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
              label: 'Form Cuti Masal',
              icon: Icons.groups,
              onPressed: () {
                Get.to(() => const cuti_masal.CutiMasalView());
              },
            ),
            _tombol(
              label: 'Jatah Cuti Tahunan',
              icon: Icons.date_range,
              onPressed: () {
                Get.find<HomeControl>().kontener = JatahCutiTahunanView();
                Get.find<HomeControl>().update();
              },
            ),
            _tombol(
              label: 'Jenis Cuti Khusus',
              icon: Icons.category_outlined,
              onPressed: () {
                Get.find<HomeControl>().kontener = JenisCutiKhususView();
                Get.find<HomeControl>().update();
              },
            ),
            const SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                width: 120,
                child: GetBuilder<CutiControl>(
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
                          controller.loadCutis();
                        }
                      },
                    );
                  },
                ),
              ),
            ),

            const Spacer(),
            _tombol(
              label: 'CIC',
              icon: Icons.business,
              onPressed: () {
                Get.find<fjghrd.HomeControl>().kontener = fjghrd2.CicCutiView();
                Get.find<fjghrd.HomeControl>().update();
              },
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
            child: CutiFormView(formType: formType),
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
