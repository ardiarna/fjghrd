import 'package:fjghrd/controllers/customer_control.dart';
import 'package:fjghrd/models/customer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class CustomerView extends StatelessWidget {
  CustomerView({super.key});

  final CustomerControl controller = Get.put(CustomerControl());

  List<PlutoRow> _buildRows(List<Customer> rowData) {
    return List.generate(
      rowData.length,
          (index) => PlutoRow(
        cells: {
          'id': PlutoCell(value: rowData[index].id),
          'nama': PlutoCell(value: rowData[index].nama),
          'alamat': PlutoCell(value: rowData[index].alamat),
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
        title: 'Nama',
        field: 'nama',
        type: PlutoColumnType.text(),
        minWidth: 180,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'Alamat',
        field: 'alamat',
        type: PlutoColumnType.text(),
        minWidth: 180,
        backgroundColor: Colors.brown.shade100,
      ),
    ];
    controller.loadCustomers();
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
                child: Text('Customer',
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
          child: GetBuilder<CustomerControl>(
            builder: (_) {
              return PlutoGrid(
                key: UniqueKey(),
                columns: columns,
                rows: _buildRows(controller.listCustomer),
                onChanged: (PlutoGridOnChangedEvent event) {},
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  event.stateManager.setShowColumnFilter(true);
                  event.stateManager.autoFitColumn(context, columns[1]);
                  event.stateManager.autoFitColumn(context, columns[2]);
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