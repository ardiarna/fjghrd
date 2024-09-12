import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/utils/af_plutogrid_config.dart';
import 'package:fjghrd/views/mantan_karyawan_view.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class KaryawanView extends StatelessWidget {
  KaryawanView({super.key});

  final KaryawanControl controller = Get.put(KaryawanControl());

  List<PlutoRow> _buildRows(List<Karyawan> rowData) {
    var now = DateTime.now();
    return List.generate(
      rowData.length,
      (index) {
        Duration d = now.difference(rowData[index].tanggalMasuk ?? now); // dalama hari
        int tahun = d.inDays ~/ 365; // Membagi dengan 365 untuk tahun
        int bulan = (d.inDays % 365) ~/ 30; // Menggunakan modulo 365, lalu dibagi dengan 30 untuk bulan
        return PlutoRow(
          cells: {
            'urutan': PlutoCell(value: index+1),
            'area': PlutoCell(value: rowData[index].area.nama),
            'id': PlutoCell(value: rowData[index].id),
            'nama': PlutoCell(value: rowData[index].nama),
            'nik': PlutoCell(value: rowData[index].nik),
            'tanggal_masuk': PlutoCell(value: AFconvert.matDate(rowData[index].tanggalMasuk)),
            'masa_kerja': PlutoCell(value: '${tahun>0 ? '$tahun tahun' : ''} ${bulan>0 ? '$bulan bulan' : ''}'),
            'agama': PlutoCell(value: rowData[index].agama.nama),
            'divisi': PlutoCell(value: rowData[index].divisi.nama),
            'jabatan': PlutoCell(value: rowData[index].jabatan.nama),
            'nomor_kk': PlutoCell(value: rowData[index].nomorKk),
            'nomor_ktp': PlutoCell(value: rowData[index].nomorKtp),
            'nomor_paspor': PlutoCell(value: rowData[index].nomorPaspor),
            'nomor_pwp': PlutoCell(value: rowData[index].nomorPwp),
            'ttl': PlutoCell(value: '${rowData[index].tempatLahir} ${AFconvert.matDate(rowData[index].tanggalLahir)}'),
            'alamat_ktp': PlutoCell(value: rowData[index].alamatKtp),
            'alamat_tinggal': PlutoCell(value: rowData[index].alamatTinggal),
            'telepon': PlutoCell(value: rowData[index].telepon),
            'kawin': PlutoCell(value: rowData[index].kawin ? 'Kawin' : 'Single'),
            'pendidikan': PlutoCell(value: '${rowData[index].pendidikan.nama} ${rowData[index].pendidikanAlmamater} ${rowData[index].pendidikanJurusan != '' ? ', Jurusan: ${rowData[index].pendidikanJurusan}' : ''}'),
            'email': PlutoCell(value: rowData[index].email),
            'status_kerja': PlutoCell(value: rowData[index].statusKerja.nama),
            'status_kerja_id': PlutoCell(value: rowData[index].statusKerja.id),
            'ptkp': PlutoCell(value: rowData[index].ptkp.kode),
          },
        );
      },
    );
  }

  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(
      title: 'MASA KERJA',
      fields: ['tanggal_masuk', 'masa_kerja'],
      expandedColumn: false,
      backgroundColor: Colors.brown.shade100,
    ),
    PlutoColumnGroup(
      title: 'DOKUMEN KARYAWAN',
      fields: ['nomor_kk', 'nomor_ktp', 'nomor_paspor', 'nomor_pwp', 'ttl'],
      expandedColumn: false,
      backgroundColor: Colors.brown.shade100,
    ),
    PlutoColumnGroup(
      title: 'ALAMAT',
      fields: ['alamat_ktp', 'alamat_tinggal'],
      expandedColumn: false,
      backgroundColor: Colors.brown.shade100,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<PlutoColumn> columns = [
      PlutoColumn(
        title: '',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 100,
        backgroundColor: Colors.brown.shade100,
        enableFilterMenuItem: false,
        enableContextMenu: false,
        enableDropToResize: false,
        frozen: PlutoColumnFrozen.start,
        renderer: (rdrCtx) {
          if(rdrCtx.row.cells['id']!.value == null) {
            return const Text('');
          }
          return Row(
            children: [
              IconButton(
                onPressed: () {
                  controller.ubahForm(rdrCtx.row.cells['id']!.value, true);
                },
                icon: const Icon(
                  Icons.edit_square,
                ),
                iconSize: 18,
                color: Colors.green,
                padding: const EdgeInsets.all(0),
              ),
              IconButton(
                onPressed: () {
                  controller.payrollView(rdrCtx.row.cells['id']!.value);
                },
                icon: const Icon(
                  Icons.assignment_outlined,
                ),
                iconSize: 18,
                color: Colors.lightBlueAccent,
                padding: const EdgeInsets.all(0),
              ),
            ],
          );
        },
      ),
      PlutoColumn(
        title: 'NO',
        field: 'urutan',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 70,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.center,
        frozen: PlutoColumnFrozen.start,
      ),
      PlutoColumn(
        title: 'NAMA',
        field: 'nama',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 200,
        backgroundColor: Colors.brown.shade100,
        frozen: PlutoColumnFrozen.start,
      ),
      PlutoColumn(
        title: 'AREA',
        field: 'area',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 230,
        backgroundColor: Colors.brown.shade100,
        enableFilterMenuItem: false,
      ),
      PlutoColumn(
        title: 'NIK',
        field: 'nik',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 120,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'TANGGAL',
        field: 'tanggal_masuk',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 150,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'DURASI',
        field: 'masa_kerja',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 150,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
      ),
      PlutoColumn(
        title: 'AGAMA',
        field: 'agama',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 120,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'DIVISI',
        field: 'divisi',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 150,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'JABATAN',
        field: 'jabatan',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 150,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'NOMOR KK',
        field: 'nomor_kk',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 170,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'NOMOR KTP',
        field: 'nomor_ktp',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 170,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'NOMOR PASPOR',
        field: 'nomor_paspor',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 170,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'NPWP',
        field: 'nomor_pwp',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 170,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'TEMPAT & TGL LAHIR',
        field: 'ttl',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 200,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'SESUAI KTP',
        field: 'alamat_ktp',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 200,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'TINGGAL SEKARANG',
        field: 'alamat_tinggal',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 200,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'NO. TLP',
        field: 'telepon',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 150,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'STATUS',
        field: 'kawin',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 100,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'PENDIDIKAN TERAKHIR',
        field: 'pendidikan',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 230,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'EMAIL',
        field: 'email',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 100,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'STATUS KARYAWAN',
        field: 'status_kerja',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 180,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: '',
        field: 'status_kerja_id',
        type: PlutoColumnType.text(),
        readOnly: true,
        backgroundColor: Colors.brown.shade100,
        hide: true,
      ),
      PlutoColumn(
        title: 'PTKP',
        field: 'ptkp',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 100,
        backgroundColor: Colors.brown.shade100,
      ),
    ];
    controller.loadKaryawans();
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
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    color: Colors.brown
                ),
                child: const Text('DATA KARYAWAN',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 200,
                child: GetBuilder<KaryawanControl>(
                  builder: (_) {
                    return AFwidget.comboField(
                      value: controller.cariStaf.label,
                      label: '',
                      onTap: () async {
                        var a = await controller.pilihStaf(value: controller.cariStaf.value);
                        if(a != null && a.value != controller.cariStaf.value) {
                          controller.cariStaf = a;
                          controller.loadKaryawans();
                        }
                      },
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                child: Text('Area: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 300,
                child: GetBuilder<KaryawanControl>(
                  builder: (_) {
                    return AFwidget.comboField(
                      value: controller.cariArea.label,
                      label: '',
                      onTap: () async {
                        var a = await controller.pilihArea(value: controller.cariArea.value, withSemua: true);
                        if(a != null && a.value != controller.cariArea.value) {
                          controller.cariArea = a;
                          controller.loadKaryawans();
                        }
                      },
                    );
                  },
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
              OutlinedButton(
                style: ButtonStyle(
                  side: WidgetStateProperty.all<BorderSide>(const BorderSide(color: Colors.red)),
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () {
                  controller.homeControl.kontener = MantanKaryawanView();
                  controller.homeControl.update();
                },
                child: const Text('DATA EX KARYAWAN'),
              ),
            ],
          ),
        ),
        Expanded(
          child: GetBuilder<KaryawanControl>(
            builder: (_) {
              return PlutoGrid(
                key: UniqueKey(),
                columns: columns,
                rows: _buildRows(controller.listKaryawan),
                columnGroups: columnGroups,
                onChanged: (PlutoGridOnChangedEvent event) {},
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  event.stateManager.setShowColumnFilter(true);
                  for (int i = 2; i <= 21; i++) {
                    event.stateManager.autoFitColumn(context, columns[i]);
                  }
                  // event.stateManager.setRowGroup(
                  //   PlutoRowGroupByColumnDelegate(
                  //     columns: [
                  //       columns[0],
                  //     ],
                  //   ),
                  // );
                },
                rowColorCallback: (rtx) {
                  switch(rtx.row.cells['status_kerja_id']!.value) {
                    case '2':
                      return Colors.blue.shade100;
                    case '3':
                      return Colors.orange.shade200;
                    case '4':
                      return Colors.purpleAccent.shade100;
                    default:
                      return Colors.white;
                  }
                },
                configuration: AFplutogridConfig.configSatu(),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: GetBuilder<KaryawanControl>(
            builder: (_) {
              return Wrap(
                spacing: 15,
                runSpacing: 5,
                alignment: WrapAlignment.end,
                children: controller.totalKaryawanPerArea.entries.map((e) {
                  return Text(
                    '💫${e.key}: ${e.value}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: e.key == 'TOTAL KARYAWAN' ? FontWeight.bold : FontWeight.normal,
                      color: e.key == 'TOTAL KARYAWAN' ? Colors.blue : Colors.black54,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        )
      ],
    );
  }
}
