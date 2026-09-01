import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/controllers/training_control.dart';
import 'package:fjghrd/models/training.dart';
import 'package:fjghrd/utils/af_plutogrid_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TrainingView extends StatelessWidget {
  TrainingView({super.key});

  final TrainingControl controller = Get.put(TrainingControl());

  List<PlutoRow> _buildRows(List<Training> rowData) {
    return List.generate(
      rowData.length,
          (index) => PlutoRow(
        cells: {
          'id': PlutoCell(value: rowData[index].id),
          'nama': PlutoCell(value: rowData[index].nama),
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
            icon: const Icon(
              Icons.edit_square,
            ),
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
        minWidth: 180,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'Urutan',
        field: 'urutan',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 120,
        backgroundColor: Colors.brown.shade100,
      ),
    ];
    controller.loadTrainings();
    return Column(
      children: [
        AFwidget.pageHeader(
          title: 'TRAINING',
          icon: Icons.list_alt_outlined,
          children: [
            const Spacer(),
            IconButton(
                onPressed: () {
                  controller.inputForm('');
                },
                icon: const Icon(
                  Icons.add_circle,
                ),
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
            child: GetBuilder<TrainingControl>(
              builder: (_) {
                return PlutoGrid(
                  key: UniqueKey(),
                  columns: columns,
                  rows: _buildRows(controller.listTraining),
                  onChanged: (PlutoGridOnChangedEvent event) {},
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    event.stateManager.setShowColumnFilter(true);
                    event.stateManager.autoFitColumn(context, columns[1]);
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
