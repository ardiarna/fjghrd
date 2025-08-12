import 'package:fjghrd/controllers/medical_control.dart';
import 'package:fjghrd/models/medical.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_plutogrid_config.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/payroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class MedicalView extends StatelessWidget {
  MedicalView({super.key});

  final MedicalControl controller = Get.put(MedicalControl());
  final DateTime now = DateTime.now();

  List<Medical> gabungkanMedicalPerKaryawan(List<Medical> daftar) {
    final Map<String, Medical> gabungan = {};

    // Peta jenis ke label
    final jenisMap = {
      'R': 'Rawat Jalan',
      'K': 'Kacamata',
      'I': 'Melahirkan',
    };

    for (var m in daftar) {
      final key = m.karyawan.id;

      // Jika belum ada, buat baru
      if (!gabungan.containsKey(key)) {
        var newMedical = Medical(
          id: m.id,
          jenis: m.jenis,
          tanggal: m.tanggal,
          bulan: m.bulan,
          tahun: m.tahun,
          jumlah: m.jumlah,
          keterangan: '',
        );
        newMedical.karyawan = m.karyawan;
        gabungan[key] = newMedical;
      } else {
        // Gabungkan data
        gabungan[key]!.id += ',${m.id}';
        gabungan[key]!.jumlah += m.jumlah;
      }

      final existing = gabungan[key]!;

      // Peta sementara jenis -> list keterangan
      Map<String, List<String>> perJenis = {};

      // Parse existing.keterangan dulu jika ada
      if (existing.keterangan.isNotEmpty) {
        for (var bagian in existing.keterangan.split(',')) {
          var part = bagian.trim();
          if (part.contains(':')) {
            final split = part.split(':');
            final jenis = split[0].trim();
            final isis = split[1].split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
            perJenis[jenis] = [...?perJenis[jenis], ...isis];
          } else {
            // Label saja tanpa keterangan
            perJenis[part] = [...?perJenis[part]];
          }
        }
      }

      // Tambahkan data dari m
      final jenisLabel = jenisMap[m.jenis] ?? m.jenis;
      final isiBaru = m.keterangan.trim();

      if (isiBaru.isEmpty) {
        perJenis[jenisLabel] = [...?perJenis[jenisLabel]];
      } else {
        perJenis[jenisLabel] = [...?perJenis[jenisLabel], isiBaru];
      }

      // Buang duplikat
      for (var key in perJenis.keys) {
        perJenis[key] = perJenis[key]!.toSet().toList();
      }

      // Susun kembali jadi string
      existing.keterangan = perJenis.entries.map((e) {
        if (e.value.isEmpty) {
          return e.key; // hanya label
        } else {
          return '${e.key}: ${e.value.join(', ')}';
        }
      }).join(', ');
    }

    return gabungan.values.toList();
  }

  List<PlutoRow> _buildRows(List<Medical> rowData) {
    final groupedData = gabungkanMedicalPerKaryawan(rowData);
    return List.generate(
      groupedData.length,
          (index) {
        final ids = groupedData[index].id.split(',').map((e) => e.trim()).toList();
        return PlutoRow(
          cells: {
            'id': PlutoCell(value: ids),
            'karyawan_id': PlutoCell(value: groupedData[index].karyawan.id),
            'jenis': PlutoCell(value: groupedData[index].jenis),
            'nama': PlutoCell(value: groupedData[index].karyawan.nama),
            'area': PlutoCell(value: groupedData[index].karyawan.area.nama),
            'jabatan': PlutoCell(value: groupedData[index].karyawan.jabatan.nama),
            'tanggal': PlutoCell(value: AFconvert.matDate(groupedData[index].tanggal)),
            'bulan': PlutoCell(value: groupedData[index].bulan),
            'tahun': PlutoCell(value: groupedData[index].tahun),
            'jumlah': PlutoCell(value: groupedData[index].jumlah),
            'keterangan': PlutoCell(value: groupedData[index].keterangan),
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
        width: 140,
        backgroundColor: Colors.brown.shade100,
        enableFilterMenuItem: false,
        enableContextMenu: false,
        enableDropToResize: false,
        suppressedAutoSize: true,
        frozen: PlutoColumnFrozen.start,
        renderer: (rdrCtx) {
          final List<dynamic> ids = rdrCtx.cell.value ?? [];
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ids.map((id) {
              return IconButton(
                onPressed: () {
                  controller.ubahForm(id, context);
                },
                icon: const Icon(Icons.edit_square),
                iconSize: 18,
                color: Colors.green,
                padding: const EdgeInsets.all(0),
              );
            }).toList(),
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
              return [TextSpan(text: text)];
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
    controller.loadMedicals();
    controller.loadKaryawans();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          decoration: BoxDecoration(
            color: const Color(0xFFf2fbfe),
            border: Border.all(color: Colors.brown.shade100, width: 1.5),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  controller.homeControl.kontener = PayrollView();
                  controller.homeControl.update();
                },
                icon: const Icon(Icons.arrow_back_ios),
                iconSize: 25,
                color: Colors.orange,
                padding: const EdgeInsets.all(0),
              ),
              const SizedBox(width: 50),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.brown,
                ),
                child: const Text(
                  'MEDICAL',
                  style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 40),
              IconButton(
                onPressed: () {
                  controller.tambahForm(context);
                },
                icon: const Icon(Icons.add_circle),
                iconSize: 30,
                color: Colors.blue,
                padding: const EdgeInsets.all(0),
              ),
              const Spacer(),
              const Text('Jenis Medical:  '),
              SizedBox(
                width: 150,
                child: GetBuilder<MedicalControl>(
                  builder: (_) {
                    return AFwidget.comboField(
                      value: controller.filterJenis.label,
                      label: '',
                      warnaBackground: Colors.white,
                      onTap: () async {
                        var a = await controller.pilihJenis(value: controller.filterJenis.value, withSemua: true);
                        if(a != null && a.value != controller.filterJenis.value) {
                          controller.filterJenis = a;
                          controller.loadMedicals();
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
                child: GetBuilder<MedicalControl>(
                  builder: (_) {
                    return AFwidget.comboField(
                      value: controller.filterBulan.label,
                      label: '',
                      warnaBackground: Colors.white,
                      onTap: () async {
                        var a = await controller.pilihBulan(value: controller.filterBulan.value);
                        if(a != null && a.value != controller.filterBulan.value) {
                          controller.filterBulan = a;
                          controller.loadMedicals();
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: GetBuilder<MedicalControl>(
                  builder: (_) {
                    return AFwidget.comboField(
                      value: controller.filterTahun.label,
                      label: '',
                      warnaBackground: Colors.white,
                      onTap: () async {
                        var a = await controller.pilihTahun(value: controller.filterTahun.value);
                        if(a != null && a.value != controller.filterTahun.value) {
                          controller.filterTahun = a;
                          controller.loadMedicals();
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 100),
              IconButton(
                onPressed: controller.hapusBanyakForm,
                icon: const Icon(Icons.delete_forever),
                iconSize: 30,
                color: Colors.red,
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
            child: GetBuilder<MedicalControl>(
              builder: (_) {
                return PlutoGrid(
                  key: UniqueKey(),
                  columns: columns,
                  rows: _buildRows(controller.listMedical),
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
