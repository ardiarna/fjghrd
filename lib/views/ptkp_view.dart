import 'package:fjghrd/controllers/ptkp_control.dart';
import 'package:fjghrd/models/ptkp.dart';
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
          return Row(
            children: [
              IconButton(
                onPressed: () {
                  controller.ubahForm(rdrCtx.row.cells['id']!.value);
                },
                icon: const Icon(
                  Icons.edit_square,
                ),
                iconSize: 18,
                color: Colors.green,
                padding: const EdgeInsets.all(0),
              ),
              // Expanded(
              //   child: Text(
              //     rdrCtx.row.cells['id']!.value
              //         .toString(),
              //     maxLines: 1,
              //     overflow: TextOverflow.ellipsis,
              //   ),
              // ),
            ],
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
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 30, 10),
                child: Text('PTKP',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.tambahForm();
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
                configuration: PlutoGridConfiguration(
                  scrollbar: const PlutoGridScrollbarConfig(
                    isAlwaysShown: true,
                  ),
                  localeText: const PlutoGridLocaleText(
                    filterColumn: 'Kolom Pencarian',
                    filterAllColumns: 'Semua Kolom',
                    filterType: 'Tipe Pencarian',
                    filterValue: 'Nilai / Kata Dicari',
                    filterContains: '🔍 cari',
                    filterEquals: '🔍 cari sama dengan',
                    filterStartsWith: '🔍 cari dimulai dengan',
                    filterEndsWith: '🔍 cari diakhiri dengan',
                    filterGreaterThan: '🔍 lebih besar dari',
                    filterGreaterThanOrEqualTo: '🔍 lebih besar dari atau =',
                    filterLessThan: '🔍 lebih kecil dari',
                    filterLessThanOrEqualTo: '🔍 lebih kecil dari atau =',
                    loadingText: 'Mohon tunggu...',
                    sunday: 'Mig',
                    monday: 'Sen',
                    tuesday: 'Sel',
                    wednesday: 'Rab',
                    thursday: 'Kam',
                    friday: 'Jum',
                    saturday: 'Sab',

                  ),
                  style: PlutoGridStyleConfig(
                    rowHeight: 35,
                    borderColor: Colors.brown.shade100,
                    gridBorderColor: Colors.transparent,
                    gridBackgroundColor: Colors.transparent,
                    defaultColumnFilterPadding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
