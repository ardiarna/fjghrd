import 'package:fjghrd/controllers/upah_control.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/utils/af_plutogrid_config.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class UpahView extends StatelessWidget {
  UpahView({super.key});

  final UpahControl controller = Get.put(UpahControl());

  List<PlutoRow> _buildRows(List<Karyawan> rowData) {
    return List.generate(
      rowData.length,
          (index) => PlutoRow(
        cells: {
          'area': PlutoCell(value: rowData[index].area.nama),
          'id': PlutoCell(value: rowData[index].id),
          'nama': PlutoCell(value: rowData[index].nama),
          'jabatan': PlutoCell(value: rowData[index].jabatan.nama),
          'gaji': PlutoCell(value: rowData[index].upah.gaji),
          'uang_makan': PlutoCell(value: rowData[index].upah.uangMakan),
          'makan_harian': PlutoCell(value: rowData[index].upah.makanHarian ? 'Harian' : 'Tetap'),
          'overtime': PlutoCell(value: rowData[index].upah.overtime ? 'OT' : 'NON OT'),
        },
      ),
    );
  }

  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(
      title: 'UANG MAKAN',
      fields: ['uang_makan', 'makan_harian'],
      expandedColumn: false,
      backgroundColor: Colors.brown.shade100,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<PlutoColumn> columns = [
      PlutoColumn(
        title: '',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 70,
        backgroundColor: Colors.brown.shade100,
        enableFilterMenuItem: false,
        enableContextMenu: false,
        enableDropToResize: false,
        suppressedAutoSize: true,
        frozen: PlutoColumnFrozen.start,
        renderer: (rdrCtx) {
          if(rdrCtx.row.cells['id']!.value == null) {
            return const Text('');
          }
          return Row(
            children: [
              IconButton(
                onPressed: () {
                  controller.ubahForm(rdrCtx.row.cells['id']!.value, context);
                },
                icon: const Icon(
                  Icons.edit_square,
                ),
                iconSize: 18,
                color: Colors.green,
                padding: const EdgeInsets.all(0),
              ),
            ],
          );
        },
      ),
      PlutoColumn(
        title: 'NAMA',
        field: 'nama',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 200,
        backgroundColor: Colors.brown.shade100,
        frozen: PlutoColumnFrozen.start,
        titleTextAlign: PlutoColumnTextAlign.center,
        suppressedAutoSize: true,
      ),
      PlutoColumn(
        title: 'AREA',
        field: 'area',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 230,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'JABATAN',
        field: 'jabatan',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 200,
        backgroundColor: Colors.brown.shade100,
        titleTextAlign: PlutoColumnTextAlign.center,
        suppressedAutoSize: true,
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.count,
            alignment: Alignment.centerLeft,
            titleSpanBuilder: (text) {
              return [
                const TextSpan(text: 'TOTAL GAJI POKOK'),
              ];
            },
          );
        },
      ),
      PlutoColumn(
        title: 'GAJI / UPAH',
        field: 'gaji',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 180,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        titleTextAlign: PlutoColumnTextAlign.center,
        suppressedAutoSize: true,
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.sum,
            format: '#,###',
            alignment: Alignment.centerRight,
            titleSpanBuilder: (text) {
              return [
                TextSpan(text: text),
              ];
            },
          );
        },
      ),
      PlutoColumn(
        title: 'JUMLAH',
        field: 'uang_makan',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 150,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        titleTextAlign: PlutoColumnTextAlign.center,
        suppressedAutoSize: true,
      ),
      PlutoColumn(
        title: 'JENIS',
        field: 'makan_harian',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 120,
        backgroundColor: Colors.brown.shade100,
        titleTextAlign: PlutoColumnTextAlign.center,
        suppressedAutoSize: true,
      ),
      PlutoColumn(
        title: 'OVERTIME',
        field: 'overtime',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 120,
        minWidth: 120,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.count,
            filter: (cell) => cell.value == 'OT',
            format: 'OT : #,###',
            alignment: Alignment.center,
          );
        },
      ),
    ];
    controller.loadKaryawans();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: [
              const Text('LIST SALARY',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 200,
                child: GetBuilder<UpahControl>(
                  builder: (_) {
                    return AFwidget.comboField(
                      value: controller.cariStaf.label,
                      label: '',
                      onTap: () async {
                        var a = await controller.pilihStaf(value: controller.cariStaf.value);
                        if(a != null && a.value != controller.cariStaf.value) {
                          controller.cariStaf = a;
                          controller.loadKaryawans();
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: GetBuilder<UpahControl>(
                  builder: (_) {
                    return Wrap(
                      spacing: 15,
                      runSpacing: 5,
                      children: controller.totalKaryawanPerArea.entries.map((e) {
                        return Text(
                          '💫${e.key}: ${e.value}',
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GetBuilder<UpahControl>(
            builder: (_) {
              return PlutoGrid(
                key: UniqueKey(),
                columns: columns,
                rows: _buildRows(controller.listKaryawan),
                columnGroups: columnGroups,
                onChanged: (PlutoGridOnChangedEvent event) {},
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  event.stateManager.setShowColumnFilter(true);
                  event.stateManager.autoFitColumn(context, columns[1]);
                  event.stateManager.autoFitColumn(context, columns[2]);
                  event.stateManager.autoFitColumn(context, columns[3]);
                },
                configuration: AFplutogridConfig.configDua(),
              );
            },
          ),
        ),
      ],
    );
  }
}
