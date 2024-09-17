import 'package:fjghrd/controllers/potongan_control.dart';
import 'package:fjghrd/models/potongan.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_plutogrid_config.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/payroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PotonganView extends StatelessWidget {
  PotonganView({super.key});

  final PotonganControl controller = Get.put(PotonganControl());
  final DateTime now = DateTime.now();

  List<PlutoRow> _buildRows(List<Potongan> rowData) {
    return List.generate(
      rowData.length,
      (index) {
        var jenis = controller.listJenis.where((element) => element.value == rowData[index].jenis).first;
        return PlutoRow(
          cells: {
            'id': PlutoCell(value: rowData[index].id),
            'karyawan_id': PlutoCell(value: rowData[index].karyawan.id),
            'jenis': PlutoCell(value:  jenis.label),
            'nama': PlutoCell(value: rowData[index].karyawan.nama),
            'area': PlutoCell(value: rowData[index].karyawan.area.nama),
            'jabatan': PlutoCell(value: rowData[index].karyawan.jabatan.nama),
            'tanggal': PlutoCell(value: AFconvert.matDate(rowData[index].tanggal)),
            'tahun': PlutoCell(value: rowData[index].tahun),
            'bulan': PlutoCell(value: rowData[index].bulan),
            'hari': PlutoCell(value: rowData[index].hari),
            'jumlah': PlutoCell(value: rowData[index].jumlah),
            'keterangan': PlutoCell(value: rowData[index].keterangan),
          },
        );
      },
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
              controller.ubahForm(rdrCtx.row.cells['id']!.value, context);
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
      ),
      PlutoColumn(
        title: 'JENIS',
        field: 'jenis',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 220,
        backgroundColor: Colors.brown.shade100,
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
        title: 'JUMLAH IDR',
        field: 'jumlah',
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
        title: 'KETERANGAN',
        field: 'keterangan',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 180,
        backgroundColor: Colors.brown.shade100,
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
    ];
    controller.loadPotongans();
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
              IconButton(
                onPressed: () {
                  controller.homeControl.kontener = PayrollView();
                  controller.homeControl.update();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                ),
                iconSize: 25,
                color: Colors.orange,
                padding: const EdgeInsets.all(0),
              ),
              const SizedBox(width: 50),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    color: Colors.brown
                ),
                child: const Text('POTONGAN',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 40),
              IconButton(
                onPressed: () {
                  controller.tambahForm(context);
                },
                icon: const Icon(
                  Icons.add_circle,
                ),
                iconSize: 30,
                color: Colors.blue,
                padding: const EdgeInsets.all(0),
              ),
              const Spacer(),
              const Text('Jenis Potongan:  '),
              SizedBox(
                width: 300,
                child: GetBuilder<PotonganControl>(
                  builder: (_) {
                    return AFwidget.comboField(
                      value: controller.filterJenis.label,
                      label: '',
                      onTap: () async {
                        var a = await controller.pilihJenis(value: controller.filterJenis.value, withSemua: true);
                        if(a != null && a.value != controller.filterJenis.value) {
                          controller.filterJenis = a;
                          controller.loadPotongans();
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 20),
              const Text('Periode:  '),
              SizedBox(
                width: 150,
                child: GetBuilder<PotonganControl>(
                  builder: (_) {
                    return AFwidget.comboField(
                      value: controller.filterBulan.label,
                      label: '',
                      onTap: () async {
                        var a = await controller.pilihBulan(value: controller.filterBulan.value);
                        if(a != null && a.value != controller.filterBulan.value) {
                          controller.filterBulan = a;
                          controller.loadPotongans();
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: GetBuilder<PotonganControl>(
                  builder: (_) {
                    return AFwidget.comboField(
                      value: controller.filterTahun.label,
                      label: '',
                      onTap: () async {
                        var a = await controller.pilihTahun(value: controller.filterTahun.value);
                        if(a != null && a.value != controller.filterTahun.value) {
                          controller.filterTahun = a;
                          controller.loadPotongans();
                        }
                      },
                    );
                  },
                ),
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
            child: GetBuilder<PotonganControl>(
              builder: (_) {
                return PlutoGrid(
                  key: UniqueKey(),
                  columns: columns,
                  rows: _buildRows(controller.listPotongan),
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
        ),
      ],
    );
  }
}
