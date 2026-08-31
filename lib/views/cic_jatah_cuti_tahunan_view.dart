// ignore: must_be_immutable
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/controllers/cic_cuti_control.dart';
import 'package:fjghrd/models/jatah_cuti_tahunan.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_plutogrid_config.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/cic_cuti_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

// ignore: must_be_immutable
class CicJatahCutiTahunanView extends StatelessWidget {
  CicJatahCutiTahunanView({super.key});

  final CicCutiControl controller = Get.find<CicCutiControl>();

  List<PlutoRow> _buildRows(List<JatahCutiTahunan> rowData) {
    return List.generate(
      rowData.length,
      (index) => PlutoRow(
        cells: {
          'id': PlutoCell(value: rowData[index].id),
          'cic/karyawan': PlutoCell(value: rowData[index].karyawan?.nama ?? ''),
          'tahun': PlutoCell(value: rowData[index].tahun),
          'jumlah_cuti': PlutoCell(value: rowData[index].jumlahCuti),
          'plus_tahun_lalu': PlutoCell(value: rowData[index].plusTahunLalu),
          'min_tahun_lalu': PlutoCell(value: rowData[index].minTahunLalu),
          'total_cuti': PlutoCell(value: rowData[index].totalCuti),
          'boleh_minus': PlutoCell(value: rowData[index].bolehMinus),
        },
      ),
    );
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
          return IconButton(
            onPressed: () {
              controller.inputJatahForm(rdrCtx.row.cells['id']!.value);
            },
            icon: const Icon(Icons.edit_square),
            iconSize: 18,
            color: Colors.green,
            padding: const EdgeInsets.all(0),
          );
        },
      ),
      PlutoColumn(
        title: 'Karyawan',
        field: 'cic/karyawan',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 200,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'Tahun',
        field: 'tahun',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 80,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'Jumlah Cuti',
        field: 'jumlah_cuti',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 120,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'Plus Tahun Lalu',
        field: 'plus_tahun_lalu',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 130,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'Min Tahun Lalu',
        field: 'min_tahun_lalu',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 130,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'Total Cuti',
        field: 'total_cuti',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 100,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'Boleh Minus',
        field: 'boleh_minus',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 100,
        backgroundColor: Colors.brown.shade100,
      ),
    ];
    return Column(
      children: [
        AFwidget.pageHeader(
          onBack: () {
            Get.find<HomeControl>().kontener = CicCutiView();
            Get.find<HomeControl>().update();
          },
          title: 'JATAH CUTI TAHUNAN CIC',
          icon: Icons.date_range,
          children: [
            const SizedBox(width: 20),
            SizedBox(
              width: 120,
              child: GetBuilder<CicCutiControl>(
                builder: (_) {
                  return AFwidget.comboField(
                    value: controller.filterTahun.label,
                    label: '',
                    warna: Colors.white,
                    warnaBackground: Colors.white.withValues(alpha: 0.1),
                    onTap: () async {
                      var a = await controller.pilihTahun(
                          value: controller.filterTahun.value);
                      if (a != null &&
                          a.value != controller.filterTahun.value) {
                        controller.filterTahun = a;
                        controller.loadCutis();
                      }
                    },
                  );
                },
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                controller.inputJatahForm('');
              },
              icon: const Icon(Icons.add_circle),
              iconSize: 30,
              color: Colors.lightBlueAccent,
              padding: const EdgeInsets.all(0),
            ),
          ],
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              image: bgLineBlue,
            ),
            child: GetBuilder<CicCutiControl>(
              builder: (_) {
                return PlutoGrid(
                  key: UniqueKey(),
                  columns: columns,
                  rows: _buildRows(controller.listJatah),
                  onChanged: (PlutoGridOnChangedEvent event) {},
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    event.stateManager.setShowColumnFilter(true);
                  },
                  configuration: AFplutogridConfig.configSatu().copyWith(columnSize: const PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.scale)),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
