import 'package:fjghrd/utils/af_database.dart';
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
          'keperluan': PlutoCell(value: rowData[index].keperluan),
          'tanggal_kembali': PlutoCell(value: AFconvert.matDate(rowData[index].tanggalKembali)),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<PlutoColumn> columns = [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 160,
        backgroundColor: Colors.brown.shade100,
        enableFilterMenuItem: false,
        enableContextMenu: false,
        enableDropToResize: false,
        renderer: (rdrCtx) {
          return Row(
            children: [
              IconButton(
                onPressed: () {
                  AFdatabase.download(url: 'cuti/excel/form/${rdrCtx.row.cells['id']!.value}');
                },
                icon: const Icon(Icons.print),
                iconSize: 18,
                color: Colors.blue,
                padding: const EdgeInsets.all(0),
              ),
              IconButton(
                onPressed: () {
                  String id = rdrCtx.row.cells['id']!.value;
                  String jenisForm = rdrCtx.row.cells['jenis_form']!.value;
                  controller.editForm(id);
                  _openForm(jenisForm);
                },
                icon: const Icon(Icons.edit_square),
                iconSize: 18,
                color: Colors.green,
                padding: const EdgeInsets.all(0),
              ),
              IconButton(
                onPressed: () {
                  controller.hapusData(rdrCtx.row.cells['id']!.value);
                },
                icon: const Icon(Icons.delete),
                iconSize: 18,
                color: Colors.red,
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
        title: 'Jenis Form',
        field: 'jenis_form',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 200,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'Keperluan',
        field: 'keperluan',
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
        width: 120,
        backgroundColor: Colors.brown.shade100,
      ),
    ];

    return Column(
      children: [
        AFwidget.pageHeader(
          title: 'DATA CUTI & IJIN',
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
              label: 'Unpaid Leave',
              icon: Icons.money_off,
              onPressed: () { controller.clearForm(); _openForm('UNPAID_LEAVE'); },
            ),
            _tombol(
              label: 'Cuti Masal',
              icon: Icons.groups,
              onPressed: () {
                Get.to(() => const cuti_masal.CutiMasalView());
              },
            ),
            _tombol(
              label: 'Jatah Tahunan',
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
            SizedBox(
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
                        controller.loadCutis();
                      }
                    },
                  );
                },
              ),
            ),
            const Spacer(),
            PopupMenuButton<String>(
              icon: const Icon(Icons.download, color: Colors.green),
              tooltip: 'Download Laporan Excel',
              onSelected: (value) async {
                final tahun = controller.filterTahun.value;
                if(value == 'jadwal') {
                  AFdatabase.download(url: 'cuti/excel/jadwal/$tahun');
                } else if(value == 'list') {
                  AFdatabase.download(url: 'cuti/excel/list/$tahun');
                } else if(value == 'tanpa_potongan') {
                  AFdatabase.download(url: 'cuti/excel/tanpa-potongan/$tahun');
                } else if(value == 'unpaid') {
                  AFdatabase.download(url: 'cuti/excel/unpaid/$tahun');
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(value: 'jadwal', child: Text('Jadwal Cuti')),
                const PopupMenuItem<String>(value: 'list', child: Text('List Cuti')),
                const PopupMenuItem<String>(value: 'tanpa_potongan', child: Text('Cuti Tanpa Potongan')),
                const PopupMenuItem<String>(value: 'unpaid', child: Text('Unpaid Leave & Ganti Libur')),
              ],
            ),
          ],
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              image: bgLineBlue,
            ),
            child: GetBuilder<CutiControl>(
              builder: (_) {
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
