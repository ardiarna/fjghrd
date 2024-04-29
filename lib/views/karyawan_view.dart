import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class KaryawanView extends StatelessWidget {
  KaryawanView({super.key});

  final KaryawanControl controller = Get.put(KaryawanControl());

  List<PlutoRow> _buildRows(List<Karyawan> rowData) {
    return List.generate(
      rowData.length,
          (index) => PlutoRow(
        cells: {
          'id': PlutoCell(value: rowData[index].id),
          'nama': PlutoCell(value: rowData[index].nama),
          'nik': PlutoCell(value: rowData[index].nik),
          'tanggal_masuk': PlutoCell(value: AFconvert.matDate(rowData[index].tanggalMasuk)),
          'agama': PlutoCell(value: rowData[index].agama.nama),
          'divisi': PlutoCell(value: rowData[index].divisi.nama),
          'jabatan': PlutoCell(value: rowData[index].jabatan.nama),
          'nomor_kk': PlutoCell(value: rowData[index].nomorKk),
          'nomor_ktp': PlutoCell(value: rowData[index].nomorKtp),
          'nomor_paspor': PlutoCell(value: rowData[index].nomorPaspor),
          'ttl': PlutoCell(value: '${rowData[index].tempatLahir} ${AFconvert.matDate(rowData[index].tanggalLahir)}'),
          'alamat_ktp': PlutoCell(value: rowData[index].alamatKtp),
          'alamat_tinggal': PlutoCell(value: rowData[index].alamatTinggal),
          'telepon': PlutoCell(value: rowData[index].telepon),
          'kawin': PlutoCell(value: rowData[index].kawin ? 'Kawin' : 'Single'),
          'pendidikan': PlutoCell(value: '${rowData[index].pendidikan.nama} ${rowData[index].pendidikanAlmamater} ${rowData[index].pendidikanJurusan != '' ? ', Jurusan: ${rowData[index].pendidikanJurusan}' : ''}'),
          'email': PlutoCell(value: rowData[index].email),
          'status_kerja': PlutoCell(value: rowData[index].statusKerja.nama),
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
        frozen: PlutoColumnFrozen.start,
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
        title: 'NAMA',
        field: 'nama',
        type: PlutoColumnType.text(),
        minWidth: 180,
        backgroundColor: Colors.brown.shade100,
        frozen: PlutoColumnFrozen.start,
      ),
      PlutoColumn(
        title: 'NIK',
        field: 'nik',
        type: PlutoColumnType.text(),
        width: 150,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'MASA KERJA',
        field: 'tanggal_masuk',
        type: PlutoColumnType.text(),
        width: 150,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'AGAMA',
        field: 'agama',
        type: PlutoColumnType.text(),
        width: 150,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'DIVISI',
        field: 'divisi',
        type: PlutoColumnType.text(),
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'JABATAN',
        field: 'jabatan',
        type: PlutoColumnType.text(),
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'NOMOR KK',
        field: 'nomor_kk',
        type: PlutoColumnType.text(),
        minWidth: 170,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'NOMOR KTP',
        field: 'nomor_ktp',
        type: PlutoColumnType.text(),
        minWidth: 170,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'NOMOR PASPOR',
        field: 'nomor_paspor',
        type: PlutoColumnType.text(),
        minWidth: 170,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'TEMPAT & TGL LAHIR',
        field: 'ttl',
        type: PlutoColumnType.text(),
        minWidth: 200,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'SESUAI KTP',
        field: 'alamat_ktp',
        type: PlutoColumnType.text(),
        minWidth: 200,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'TINGGAL SEKARANG',
        field: 'alamat_tinggal',
        type: PlutoColumnType.text(),
        minWidth: 200,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'NO. TLP',
        field: 'telepon',
        type: PlutoColumnType.text(),
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'STATUS',
        field: 'kawin',
        type: PlutoColumnType.text(),
        minWidth: 100,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'PENDIDIKAN TERAKHIR',
        field: 'pendidikan',
        type: PlutoColumnType.text(),
        minWidth: 230,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'EMAIL',
        field: 'email',
        type: PlutoColumnType.text(),
        minWidth: 100,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'STATUS KARYAWAN',
        field: 'status_kerja',
        type: PlutoColumnType.text(),
        minWidth: 180,
        backgroundColor: Colors.brown.shade100,
      ),
    ];
    final List<PlutoColumnGroup> columnGroups = [
      PlutoColumnGroup(
        title: 'DOKUMEN KARYAWAN',
        fields: ['nomor_kk', 'nomor_ktp', 'nomor_paspor', 'ttl'],
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
    controller.loadKaryawans();
    controller.loadAgamas();
    controller.loadDivisis();
    controller.loadJabatans();
    controller.loadPendidikans();
    controller.loadStatusKerjas();
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
                child: Text('Data Karyawan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                onChanged: (PlutoGridOnChangedEvent event) {
                  print('=======onChanged Plutogrid=======: $event');
                },
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  event.stateManager.setShowColumnFilter(true);
                  event.stateManager.autoFitColumn(context, columns[1]);
                  for (int i = 5; i <= 16; i++) {
                    event.stateManager.autoFitColumn(context, columns[i]);
                  }
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
                    sunday: 'Mg',
                    monday: 'Sn',
                    tuesday: 'Sl',
                    wednesday: 'Rb',
                    thursday: 'Km',
                    friday: 'Jm',
                    saturday: 'Sb',

                  ),
                  style: PlutoGridStyleConfig(
                    rowHeight: 35,
                    borderColor: Colors.brown.shade200,
                    gridBorderColor: Colors.transparent,
                    gridBackgroundColor: Colors.transparent,
                    defaultColumnFilterPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
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
