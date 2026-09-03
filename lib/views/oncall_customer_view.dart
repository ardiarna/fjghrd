import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/views/payroll_view.dart';
import 'package:fjghrd/controllers/oncall_customer_control.dart';
import 'package:fjghrd/views/oncall_customer_tambah_form.dart';
import 'package:fjghrd/views/oncall_customer_ubah_form.dart';
import 'package:fjghrd/models/oncall_customer.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_plutogrid_config.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class OncallCustomerView extends StatelessWidget {
  OncallCustomerView({super.key});

  final OncallCustomerControl controller = Get.put(OncallCustomerControl());
  final DateTime now = DateTime.now();

  List<PlutoRow> _buildRows(List<OncallCustomer> rowData) {
    return List.generate(
      rowData.length,
          (index) => PlutoRow(
        cells: {
          'id': PlutoCell(value: rowData[index].id),
          'customer_id': PlutoCell(value: rowData[index].customer.id),
          'nama': PlutoCell(value: rowData[index].customer.nama),
          'alamat': PlutoCell(value: rowData[index].customer.alamat),
          'tanggal': PlutoCell(value: AFconvert.matDate(rowData[index].tanggal)),
          'bulan': PlutoCell(value: rowData[index].bulan),
          'tahun': PlutoCell(value: rowData[index].tahun),
          'jumlah': PlutoCell(value: rowData[index].jumlah),
          'keterangan': PlutoCell(value: rowData[index].keterangan),
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
          return IconButton(
            onPressed: () {
              showOncallCustomerUbahForm(rdrCtx.row.cells['id']!.value, context);
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
      // PlutoColumn(
      //   title: 'TANGGAL',
      //   field: 'tanggal',
      //   type: PlutoColumnType.text(),
      //   readOnly: true,
      //   width: 120,
      //   backgroundColor: Colors.brown.shade100,
      //   textAlign: PlutoColumnTextAlign.center,
      //   suppressedAutoSize: true,
      //   footerRenderer: (rendererContext) {
      //     return PlutoAggregateColumnFooter(
      //       rendererContext: rendererContext,
      //       type: PlutoAggregateColumnType.count,
      //       alignment: Alignment.centerLeft,
      //       titleSpanBuilder: (text) {
      //         return [
      //           const TextSpan(text: 'TOTAL'),
      //         ];
      //       },
      //     );
      //   },
      // ),
      PlutoColumn(
        title: 'JUMLAH',
        field: 'jumlah',
        type: PlutoColumnType.number(),
        readOnly: true,
        minWidth: 150,
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
        title: 'KETERANGAN',
        field: 'keterangan',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 180,
        backgroundColor: Colors.brown.shade100,
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
    ];
    return Column(
      children: [
        AFwidget.pageHeader(
          onBack: () {
            final hc = Get.find<HomeControl>();
            hc.kontener = PayrollView();
            hc.update();
          },
          title: 'OVERTIME & ON CALL CUSTOMER',
          icon: Icons.list_alt_outlined,
          children: [
            const Spacer(),
            const SizedBox(width: 40),
              IconButton(
                onPressed: () {
                  showOncallCustomerTambahForm(context);
                },
                icon: const Icon(
                  Icons.add_circle,
                ),
                iconSize: 30,
                color: Colors.lightBlueAccent,
                padding: const EdgeInsets.all(0),
              ),
              const Spacer(),
              const Text('Periode:  ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 150,
                child: GetBuilder<OncallCustomerControl>(
                  id: 'filter_oncall',
                  builder: (_) {
                    return AFwidget.comboField(
                      value: controller.filterBulan.label,
                      label: '',
                      warnaBackground: Colors.white,
                      onTap: () async {
                        var a = await controller.pilihBulan(value: controller.filterBulan.value);
                        if(a != null && a.value != controller.filterBulan.value) {
                          controller.filterBulan = a;
                          controller.update(['filter_oncall']);
                          controller.loadOncallCustomers();
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: GetBuilder<OncallCustomerControl>(
                  id: 'filter_oncall',
                  builder: (_) {
                    return AFwidget.comboField(
                      value: controller.filterTahun.label,
                      label: '',
                      warnaBackground: Colors.white,
                      onTap: () async {
                        var a = await controller.pilihTahun(value: controller.filterTahun.value);
                        if(a != null && a.value != controller.filterTahun.value) {
                          controller.filterTahun = a;
                          controller.update(['filter_oncall']);
                          controller.loadOncallCustomers();
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 100),
              IconButton(
                onPressed: () {
                  AFwidget.formHapus(
                    label: 'oncall customer pada bulan ${controller.filterBulan.label} ${controller.filterTahun.label} ',
                    aksi: controller.hapusBanyakData,
                  );
                },
                icon: const Icon(Icons.delete_forever),
                iconSize: 30,
                color: Colors.red,
                padding: const EdgeInsets.all(0),
              ),
          ],
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              image: bgLineBlue,
            ),
            child: Obx(() {
                return PlutoGrid(
                  key: UniqueKey(),
                  columns: columns,
                  rows: _buildRows(controller.listOncallCustomer),
                  onChanged: (PlutoGridOnChangedEvent event) {},
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    event.stateManager.setShowColumnFilter(true);
                    event.stateManager.autoFitColumn(context, columns[1]);
                    event.stateManager.autoFitColumn(context, columns[2]);
                  },
                  configuration: AFplutogridConfig.configDua(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
