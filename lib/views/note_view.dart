import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/controllers/note_control.dart';
import 'package:fjghrd/views/note_form.dart';
import 'package:fjghrd/models/note.dart';
import 'package:fjghrd/utils/af_plutogrid_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class NoteView extends StatelessWidget {
  NoteView({super.key});

  final NoteControl controller = Get.put(NoteControl());

  List<PlutoRow> _buildRows(List<Note> rowData) {
    return List.generate(
      rowData.length,
      (index) => PlutoRow(
        cells: {
          'id': PlutoCell(value: rowData[index].id),
          'nama': PlutoCell(value: rowData[index].nama),
          'teks': PlutoCell(value: rowData[index].teks),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AFwidget.pageHeader(
          title: 'NOTE',
          icon: Icons.note_alt_outlined,
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              image: bgLineBlue,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const double editWidth = 60.0;
                const double namaWidth = 200.0;
                final double availableWidth = constraints.maxWidth;
                final double teksWidth = (availableWidth - editWidth - namaWidth).clamp(300.0, double.infinity);

                final List<PlutoColumn> columns = [
                  PlutoColumn(
                    title: '',
                    field: 'id',
                    type: PlutoColumnType.text(),
                    readOnly: true,
                    width: editWidth,
                    minWidth: editWidth,
                    backgroundColor: Colors.brown.shade100,
                    enableFilterMenuItem: false,
                    enableContextMenu: false,
                    enableDropToResize: false,
                    enableSorting: false,
                    suppressedAutoSize: true,
                    renderer: (rdrCtx) {
                      return IconButton(
                        onPressed: () {
                          showNoteForm(rdrCtx.row.cells['id']!.value);
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
                    width: namaWidth,
                    minWidth: 150,
                    suppressedAutoSize: true,
                    backgroundColor: Colors.brown.shade100,
                    renderer: (rdrCtx) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          rdrCtx.cell.value.toString(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                  PlutoColumn(
                    title: 'Teks',
                    field: 'teks',
                    type: PlutoColumnType.text(),
                    readOnly: true,
                    width: teksWidth,
                    minWidth: 300,
                    backgroundColor: Colors.brown.shade100,
                    renderer: (rdrCtx) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          rdrCtx.cell.value.toString(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.35,
                          ),
                        ),
                      );
                    },
                  ),
                ];

                return Obx(() {
                  return PlutoGrid(
                    key: UniqueKey(),
                    columns: columns,
                    rows: _buildRows(controller.listNote),
                    onChanged: (PlutoGridOnChangedEvent event) {},
                    onLoaded: (PlutoGridOnLoadedEvent event) {
                      event.stateManager.setShowColumnFilter(true);
                    },
                    configuration: AFplutogridConfig.configSatu(
                      rowHeight: 80,
                      autoSizeMode: PlutoAutoSizeMode.equal,
                    ),
                  );
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
