import 'package:fjghrd/controllers/ptkp_control.dart';
import 'package:fjghrd/models/ptkp.dart';
import 'package:fjghrd/utils/af_plutogrid_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PtkpView extends StatelessWidget {
  PtkpView({super.key});

  final PtkpControl controller = Get.put(PtkpControl());

  List<PlutoRow> _buildRows(List<Ptkp> rowData) {
    return List.generate(
      rowData.length,
          (index) => PlutoRow(
        cells: {
          'id': PlutoCell(value: rowData[index].id),
          'kode': PlutoCell(value: rowData[index].kode),
          'jumlah': PlutoCell(value: rowData[index].jumlah),
          'ter': PlutoCell(value: 'TER ${rowData[index].ter}'),
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
        title: 'Kode',
        field: 'kode',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 150,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'Jumlah',
        field: 'jumlah',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 200,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'Kategori TER',
        field: 'ter',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 150,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.center,
      ),
    ];
    controller.loadPtkps();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          decoration: BoxDecoration(
            color: const Color(0xFFf2fbfe),
            border: Border.all(
              color: Colors.brown.shade100, width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                margin: const EdgeInsets.only(right: 40),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    color: Colors.brown
                ),
                child: const Text('PTKP',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.inputForm('');
                },
                icon: const Icon(
                  Icons.add_circle,
                ),
                iconSize: 30,
                color: Colors.blue,
                padding: const EdgeInsets.all(0),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/line-blue.png'),
                alignment: Alignment.topRight,
                repeat: ImageRepeat.repeatY,
                fit: BoxFit.fitWidth,
                opacity: 0.1,
              ),
            ),
            child: GetBuilder<PtkpControl>(
              builder: (_) {
                return PlutoGrid(
                  key: UniqueKey(),
                  columns: columns,
                  rows: _buildRows(controller.listPtkp),
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
