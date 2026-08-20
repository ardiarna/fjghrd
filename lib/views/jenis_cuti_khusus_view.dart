import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/controllers/jenis_cuti_khusus_control.dart';
import 'package:fjghrd/models/jenis_cuti_khusus.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_plutogrid_config.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/cuti_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

// ignore: must_be_immutable
class JenisCutiKhususView extends StatelessWidget {
  JenisCutiKhususView({super.key});

  final JenisCutiKhususControl controller = Get.put(JenisCutiKhususControl());

  List<PlutoRow> _buildRows(List<JenisCutiKhusus> rowData) {
    return List.generate(
      rowData.length,
      (index) => PlutoRow(
        cells: {
          'id': PlutoCell(value: rowData[index].id),
          'nama': PlutoCell(value: rowData[index].nama),
          'lama_hari': PlutoCell(value: rowData[index].lamaHari),
          'satuan': PlutoCell(value: rowData[index].satuan),
          'urutan': PlutoCell(value: rowData[index].urutan),
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
        width: 70,
        backgroundColor: Colors.brown.shade100,
        enableFilterMenuItem: false,
        enableContextMenu: false,
        enableDropToResize: false,
        renderer: (rdrCtx) {
          return IconButton(
            onPressed: () {
              controller.inputForm(rdrCtx.row.cells['id']!.value);
            },
            icon: const Icon(Icons.edit_square),
            iconSize: 18,
            color: Colors.green,
            padding: const EdgeInsets.all(0),
          );
        },
      ),
      PlutoColumn(
        title: 'Nama',
        field: 'nama',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 200,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'Lama Hari',
        field: 'lama_hari',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 120,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'Satuan',
        field: 'satuan',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 120,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'Urutan',
        field: 'urutan',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 100,
        backgroundColor: Colors.brown.shade100,
      ),
    ];
    return Column(
      children: [
        AFwidget.pageHeader(
          onBack: () {
            Get.find<HomeControl>().kontener = CutiView();
            Get.find<HomeControl>().update();
          },
          title: 'JENIS CUTI KHUSUS',
          icon: Icons.category_outlined,
          children: [
            const Spacer(),
            IconButton(
              onPressed: () {
                controller.inputForm('');
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
            child: GetBuilder<JenisCutiKhususControl>(
              builder: (_) {
                return PlutoGrid(
                  key: UniqueKey(),
                  columns: columns,
                  rows: _buildRows(controller.listJenisCuti),
                  onChanged: (PlutoGridOnChangedEvent event) {},
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    event.stateManager.setShowColumnFilter(true);
                  },
                  configuration: AFplutogridConfig.configSatu(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
