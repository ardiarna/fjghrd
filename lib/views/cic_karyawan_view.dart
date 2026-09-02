import 'package:fjghrd/controllers/cic_karyawan_control.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/cic_cuti_view.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/models/durasi_tanggal.dart';
import 'package:fjghrd/utils/af_plutogrid_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class CicKaryawanView extends StatelessWidget {
  CicKaryawanView({super.key});

  final CicKaryawanControl controller = Get.put(CicKaryawanControl());

  List<PlutoRow> _buildRows(List<Karyawan> rowData) {
    var now = DateTime.now();
    return List.generate(
      rowData.length,
      (index) {
        var a = rowData[index].tanggalMasuk ?? now;
        var b = rowData[index].tanggalKeluar ?? now;
        DurasiTanggal durasi = DurasiTanggal.diff(a, b);
        return PlutoRow(
          cells: {
            'urutan': PlutoCell(value: index+1),
            'area': PlutoCell(value: rowData[index].area.nama),
            'id': PlutoCell(value: rowData[index].id),
            'nama': PlutoCell(value: rowData[index].nama),
            'nik': PlutoCell(value: rowData[index].nik),
            'tanggal_masuk': PlutoCell(value: AFconvert.matDate(rowData[index].tanggalMasuk)),
            'masa_kerja': PlutoCell(value: durasi.cetakSingkat()),
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
            'kawin': PlutoCell(value: '${rowData[index].kawin == 'Y' ? 'Kawin' : (rowData[index].kawin == 'N' ? 'Single' : 'Single Parent')} ${ rowData[index].jumlahAnak > 0 ? '/ ${rowData[index].jumlahAnak}' : ''}'),
            'pendidikan': PlutoCell(value: '${rowData[index].pendidikan.nama} ${rowData[index].pendidikanAlmamater} ${rowData[index].pendidikanJurusan != '' ? ', Jurusan: ${rowData[index].pendidikanJurusan}' : ''}'),
            'email': PlutoCell(value: rowData[index].email),
            'status_kerja': PlutoCell(value: rowData[index].statusKerja.nama),
            'status_kerja_id': PlutoCell(value: rowData[index].statusKerja.id),
          },
        );
      },
    );
  }

  Color _getStatusColor(String id) {
    switch (id) {
      case '1':
        return Colors.transparent;
      case '2':
        return Colors.blue.shade100;
      case '3':
        return Colors.orange.shade200;
      case '4':
        return Colors.purpleAccent.shade100;
      case '5':
        return Colors.green.shade200;
      case '6':
        return Colors.yellow.shade200;
      default:
        return Colors.transparent;
    }
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
                  controller.formCicKaryawan(rdrCtx.row.cells['id']!.value, context);
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
        title: 'NO',
        field: 'urutan',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 70,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.center,
        frozen: PlutoColumnFrozen.start,
        enableFilterMenuItem: false,
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
        enableFilterMenuItem: false,
      ),
      PlutoColumn(
        title: '',
        field: 'status_kerja_id',
        type: PlutoColumnType.text(),
        readOnly: true,
        backgroundColor: Colors.brown.shade100,
        hide: true,
      ),
    ];

    return Column(
      children: [
        AFwidget.pageHeader(
          title: 'DATA KARYAWAN CIC',
          icon: Icons.people_alt,
          onBack: () {
            Get.find<HomeControl>().kontener = CicCutiView();
            Get.find<HomeControl>().update();
          },
          children: [
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => controller.formCicKaryawan('', context),
              icon: const Icon(Icons.add_circle, size: 18),
              label: const Text('Tambah'),
            ),
          ],
        ),
        Expanded(
          child: GetBuilder<CicKaryawanControl>(
              initState: (_) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Get.find<CicKaryawanControl>().loadData();
                });
              },
              builder: (ctrl) {
                if (ctrl.listData.isEmpty) {
                  return const Center(child: Text('Belum ada data'));
                }
                return PlutoGrid(
                  key: UniqueKey(),
                  columns: columns,
                  rows: _buildRows(ctrl.listData),
                  columnGroups: columnGroups,
                  onChanged: (PlutoGridOnChangedEvent event) {},
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    event.stateManager.setShowColumnFilter(true);
                    for (int i = 2; i <= 20; i++) {
                      try {
                        event.stateManager.autoFitColumn(context, columns[i]);
                      } catch (e) { /* ignore */ }
                    }
                  },
                  rowColorCallback: (rtx) {
                    return _getStatusColor(rtx.row.cells['status_kerja_id']!.value);
                  },
                  configuration: AFplutogridConfig.configSatu(),
                );
              },
            ),
        ),
      ],
    );
  }
}
