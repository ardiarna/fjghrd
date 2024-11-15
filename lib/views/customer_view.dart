import 'package:fjghrd/controllers/customer_control.dart';
import 'package:fjghrd/models/customer.dart';
import 'package:fjghrd/utils/af_plutogrid_config.dart';
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
        title: 'Alamat',
        field: 'alamat',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 180,
        backgroundColor: Colors.brown.shade100,
      ),
    ];
    controller.loadCustomers();
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
                child: const Text('CUSTOMER',
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
