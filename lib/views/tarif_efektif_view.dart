import 'package:fjghrd/controllers/tarif_efektif_control.dart';
import 'package:fjghrd/models/tarif_efektif.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TarifEfektifView extends StatelessWidget {
  TarifEfektifView({super.key});

  final TarifEfektifControl controller = Get.put(TarifEfektifControl());

  List<PlutoRow> _buildRows(List<TarifEfektif> rowData) {
    return List.generate(
      rowData.length,
          (index) => PlutoRow(
        cells: {
          'id': PlutoCell(value: rowData[index].id),
          'ter': PlutoCell(value: 'TER ${rowData[index].ter}'),
          'penghasilan': PlutoCell(value: rowData[index].penghasilan),
          'persen': PlutoCell(value: '${rowData[index].persen}%'),
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
            ],
          );
        },
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
      PlutoColumn(
        title: 'Penghasilan',
        field: 'penghasilan',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 200,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'Tarif Pajak',
        field: 'persen',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 150,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
    ];
    controller.loadTarifEfektifs();
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
                child: Text('TER (Tarif Efektif Rata-rata)',
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
          child: GetBuilder<TarifEfektifControl>(
            builder: (_) {
              return PlutoGrid(
                key: UniqueKey(),
                columns: columns,
                rows: _buildRows(controller.listTarifEfektif),
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
