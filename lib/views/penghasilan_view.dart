import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/views/payroll_view.dart';
import 'package:fjghrd/controllers/penghasilan_control.dart';
import 'package:fjghrd/views/penghasilan_tambah_form.dart';
import 'package:fjghrd/views/penghasilan_ubah_form.dart';
import 'package:fjghrd/models/penghasilan.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_plutogrid_config.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PenghasilanView extends StatelessWidget {
  PenghasilanView({super.key});

  final PenghasilanControl controller = Get.put(PenghasilanControl());
  final DateTime now = DateTime.now();

  List<PlutoRow> _buildRows(List<Penghasilan> rowData) {
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
              showPenghasilanUbahForm(rdrCtx.row.cells['id']!.value, context);
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
        title: 'JUMLAH',
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
    return Column(
      children: [
        AFwidget.pageHeader(
          onBack: () {
            final hc = Get.find<HomeControl>();
            hc.kontener = PayrollView();
            hc.update();
          },
          title: 'PENGHASILAN',
          icon: Icons.list_alt_outlined,
          children: [
            const Spacer(),
            const SizedBox(width: 40),
              IconButton(
                onPressed: () {
                  showPenghasilanTambahForm(context);
                },
                icon: const Icon(
                  Icons.add_circle,
                ),
                iconSize: 30,
                color: Colors.lightBlueAccent,
                padding: const EdgeInsets.all(0),
              ),
              const Spacer(),
              const Text('Jenis Penghasilan:  ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 300,
                child: GetBuilder<PenghasilanControl>(
                  id: 'filter_penghasilan',
                  builder: (_) {
                    return AFwidget.comboField(
                      value: controller.filterJenis.label,
                      label: '',
                      warnaBackground: Colors.white,
                      onTap: () async {
                        var a = await controller.pilihJenis(value: controller.filterJenis.value, withSemua: true);
                        if(a != null && a.value != controller.filterJenis.value) {
                          controller.filterJenis = a;
                          controller.update(['filter_penghasilan']);
                          controller.loadPenghasilans();
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 20),
              const Text('Periode:  ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 150,
                child: GetBuilder<PenghasilanControl>(
                  id: 'filter_penghasilan',
                  builder: (_) {
                    return AFwidget.comboField(
                      value: controller.filterBulan.label,
                      label: '',
                      warnaBackground: Colors.white,
                      onTap: () async {
                        var a = await controller.pilihBulan(value: controller.filterBulan.value);
                        if(a != null && a.value != controller.filterBulan.value) {
                          controller.filterBulan = a;
                          controller.update(['filter_penghasilan']);
                          controller.loadPenghasilans();
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: GetBuilder<PenghasilanControl>(
                  id: 'filter_penghasilan',
                  builder: (_) {
                    return AFwidget.comboField(
                      value: controller.filterTahun.label,
                      label: '',
                      warnaBackground: Colors.white,
                      onTap: () async {
                        var a = await controller.pilihTahun(value: controller.filterTahun.value);
                        if(a != null && a.value != controller.filterTahun.value) {
                          controller.filterTahun = a;
                          controller.update(['filter_penghasilan']);
                          controller.loadPenghasilans();
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
                    label: '${controller.filterJenis.label} penghasilan pada bulan ${controller.filterBulan.label} ${controller.filterTahun.label} ',
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
                  rows: _buildRows(controller.listPenghasilan),
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
