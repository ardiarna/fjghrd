import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/models/agama.dart';
import 'package:fjghrd/models/area.dart';
import 'package:fjghrd/models/divisi.dart';
import 'package:fjghrd/models/jabatan.dart';
import 'package:fjghrd/models/keluarga_karyawan.dart';
import 'package:fjghrd/models/keluarga_kontak.dart';
import 'package:fjghrd/models/pendidikan.dart';
import 'package:fjghrd/models/perjanjian_kerja.dart';
import 'package:fjghrd/models/ptkp.dart';
import 'package:fjghrd/models/status_kerja.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';


class KaryawanForm extends StatelessWidget {
  KaryawanForm({super.key});

  final KaryawanControl controller = Get.put(KaryawanControl());

  final ScrollController _scrollControllerLeft = ScrollController();
  final ScrollController _scrollControllerRight = ScrollController();

  List<PlutoRow> _buildRowsKeluarga(List<KeluargaKaryawan> rowData) {
    return List.generate(
      rowData.length,
          (index) => PlutoRow(
        cells: {
          'id': PlutoCell(value: rowData[index].id),
          'nama': PlutoCell(value: rowData[index].nama),
          'nomor_ktp': PlutoCell(value: rowData[index].nomorKtp),
          'hubungan': PlutoCell(value: rowData[index].hubungan == 'S' ? 'Suami' : rowData[index].hubungan == 'I' ? 'Istri' : 'Anak'),
          'ttl': PlutoCell(value: '${rowData[index].tempatLahir} ${AFconvert.matDate(rowData[index].tanggalLahir)}'),
          'telepon': PlutoCell(value: rowData[index].telepon),
          'email': PlutoCell(value: rowData[index].email),
        },
      ),
    );
  }

  List<PlutoRow> _buildRowsKontak(List<KeluargaKontak> rowData) {
    return List.generate(
      rowData.length,
          (index) => PlutoRow(
        cells: {
          'id': PlutoCell(value: rowData[index].id),
          'nama': PlutoCell(value: rowData[index].nama),
          'telepon': PlutoCell(value: rowData[index].telepon),
          'email': PlutoCell(value: rowData[index].email),
        },
      ),
    );
  }

  List<PlutoRow> _buildRowsPerjanjian(List<PerjanjianKerja> rowData) {
    return List.generate(
      rowData.length,
          (index) => PlutoRow(
        cells: {
          'id': PlutoCell(value: rowData[index].id),
          'nomor': PlutoCell(value: rowData[index].nomor),
          'tanggal_awal': PlutoCell(value: AFconvert.matDate(rowData[index].tanggalAwal)),
          'tanggal_akhir': PlutoCell(value: AFconvert.matDate(rowData[index].tanggalAKhir)),
          'status_kerja': PlutoCell(value: rowData[index].statusKerja.nama),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<PlutoColumn> columnsKeluarga = [
      PlutoColumn(
        title: '',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 63,
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
                  controller.ubahKeluargaForm(rdrCtx.row.cells['id']!.value, context);
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
        readOnly: true,
        width: 300,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'NOMOR KTP',
        field: 'nomor_ktp',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 170,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'HUBUNGAN',
        field: 'hubungan',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 130,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'TEMPAT & TGL LAHIR',
        field: 'ttl',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 300,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'NO. TLP',
        field: 'telepon',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 140,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'EMAIL',
        field: 'email',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 150,
        backgroundColor: Colors.brown.shade100,
      ),
    ];
    final List<PlutoColumn> columnsKontak = [
      PlutoColumn(
        title: '',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 63,
        suppressedAutoSize: true,
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
                  controller.ubahKontakForm(rdrCtx.row.cells['id']!.value, context);
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
        title: 'NO. TLP',
        field: 'telepon',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 140,
        suppressedAutoSize: true,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'KETERANGAN',
        field: 'nama',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 300,
        suppressedAutoSize: true,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'EMAIL',
        field: 'email',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 150,
        backgroundColor: Colors.brown.shade100,
      ),
    ];
    final List<PlutoColumn> columnsPerjanjian = [
      PlutoColumn(
        title: '',
        field: 'id',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 63,
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
                  controller.ubahPerjanjianForm(rdrCtx.row.cells['id']!.value, context);
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
        title: 'NOMOR',
        field: 'nomor',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 250,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'TGL AWAL',
        field: 'tanggal_awal',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 150,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'TGL AKHIR',
        field: 'tanggal_akhir',
        type: PlutoColumnType.text(),
        readOnly: true,
        width: 150,
        backgroundColor: Colors.brown.shade100,
      ),
      PlutoColumn(
        title: 'STATUS',
        field: 'status_kerja',
        type: PlutoColumnType.text(),
        readOnly: true,
        minWidth: 180,
        backgroundColor: Colors.brown.shade100,
      ),
    ];
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(50, 15, 15, 0),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: Get.back,
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ),
                  iconSize: 25,
                  color: Colors.orange,
                  padding: const EdgeInsets.all(0),
                ),
                const SizedBox(width: 50),
                const Text('Data Karyawan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        Expanded(
                          child: Scrollbar(
                            controller: _scrollControllerLeft,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _scrollControllerLeft,
                              child: Column(
                                children: [
                                  barisForm(
                                    label: 'Nama',
                                    controller: controller.txtNama,
                                  ),
                                  barisForm(
                                    label: 'NIK',
                                    controller: controller.txtNik,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          padding: const EdgeInsets.only(right: 15),
                                          child: const Text('Masa Kerja'),
                                        ),
                                        Expanded(
                                          child: AFwidget.textField(
                                            marginTop: 0,
                                            controller: controller.txtTanggalMasuk,
                                            readOnly: true,
                                            prefixIcon: const Icon(Icons.calendar_month),
                                            ontap: () async {
                                              var a = await AFwidget.pickDate(
                                                context: context,
                                                initialDate: AFconvert.keTanggal(controller.txtTanggalMasuk.text),
                                              );
                                              if(a != null) {
                                                controller.txtTanggalMasuk.text = AFconvert.matYMD(a);
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          padding: const EdgeInsets.only(right: 15),
                                          child: const Text('Agama'),
                                        ),
                                        Expanded(
                                          child: GetBuilder<KaryawanControl>(
                                            builder: (_) {
                                              return AFwidget.comboField(
                                                value: controller.agama.nama,
                                                label: '',
                                                onTap: () async {
                                                  var a = await controller.pilihAgama(value: controller.agama.id);
                                                  if(a != null && a.value != controller.agama.id) {
                                                    controller.agama = Agama.fromMap(a.data!);
                                                    controller.update();
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          padding: const EdgeInsets.only(right: 15),
                                          child: const Text('Area'),
                                        ),
                                        Expanded(
                                          child: GetBuilder<KaryawanControl>(
                                            builder: (_) {
                                              return AFwidget.comboField(
                                                value: controller.area.nama,
                                                label: '',
                                                onTap: () async {
                                                  var a = await controller.pilihArea(value: controller.area.id);
                                                  if(a != null && a.value != controller.area.id) {
                                                    controller.area = Area.fromMap(a.data!);
                                                    controller.update();
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          padding: const EdgeInsets.only(right: 15),
                                          child: const Text('Jenis Karyawan'),
                                        ),
                                        Expanded(
                                          child: GetBuilder<KaryawanControl>(
                                            builder: (_) {
                                              return Row(
                                                children: [
                                                  Radio<bool>(
                                                    value: true,
                                                    groupValue: controller.staf,
                                                    onChanged: (a) {
                                                      if(a != null && a != controller.staf) {
                                                        controller.staf = a;
                                                        controller.update();
                                                      }
                                                    },
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                                    child: Text('Staf'),
                                                  ),
                                                  Radio<bool>(
                                                    value: false,
                                                    groupValue: controller.staf,
                                                    onChanged: (a) {
                                                      if(a != null && a != controller.staf) {
                                                        controller.staf = a;
                                                        controller.update();
                                                      }
                                                    },
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                    child: Text('Non Staf'),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          padding: const EdgeInsets.only(right: 15),
                                          child: const Text('Divisi'),
                                        ),
                                        Expanded(
                                          child: GetBuilder<KaryawanControl>(
                                            builder: (_) {
                                              return AFwidget.comboField(
                                                value: controller.divisi.nama,
                                                label: '',
                                                onTap: () async {
                                                  var a = await controller.pilihDivisi(value: controller.divisi.id);
                                                  if(a != null && a.value != controller.divisi.id) {
                                                    controller.divisi = Divisi.fromMap(a.data!);
                                                    controller.update();
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          padding: const EdgeInsets.only(right: 15),
                                          child: const Text('Jabatan'),
                                        ),
                                        Expanded(
                                          child: GetBuilder<KaryawanControl>(
                                            builder: (_) {
                                              return AFwidget.comboField(
                                                value: controller.jabatan.nama,
                                                label: '',
                                                onTap: () async {
                                                  var a = await controller.pilihJabatan(value: controller.jabatan.id);
                                                  if(a != null && a.value != controller.jabatan.id) {
                                                    controller.jabatan = Jabatan.fromMap(a.data!);
                                                    controller.update();
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  barisForm(
                                    label: 'Nomor KK',
                                    controller: controller.txtNomorKk,
                                  ),
                                  barisForm(
                                    label: 'Nomor KTP',
                                    controller: controller.txtNomorKtp,
                                  ),
                                  barisForm(
                                    label: 'Nomor Paspor',
                                    controller: controller.txtNomorPaspor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          padding: const EdgeInsets.only(right: 15),
                                          child: const Text('Tempat & Tgl Lahir'),
                                        ),
                                        Expanded(
                                          child: AFwidget.textField(
                                            marginTop: 0,
                                            controller: controller.txtTempatLahir,
                                          ),
                                        ),
                                        Container(
                                          width: 165,
                                          margin: const EdgeInsets.only(left: 15),
                                          child: AFwidget.textField(
                                            marginTop: 0,
                                            controller: controller.txtTanggalLahir,
                                            readOnly: true,
                                            prefixIcon: const Icon(Icons.calendar_month),
                                            ontap: () async {
                                              var a = await AFwidget.pickDate(
                                                context: context,
                                                initialDate: AFconvert.keTanggal(controller.txtTanggalLahir.text),
                                              );
                                              if(a != null) {
                                                controller.txtTanggalLahir.text = AFconvert.matYMD(a);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 150,
                                          padding: const EdgeInsets.only(right: 15, top: 15),
                                          child: const Text('Alamat KTP'),
                                        ),
                                        Expanded(
                                          child: AFwidget.textField(
                                            marginTop: 0,
                                            controller: controller.txtAlamatKtp,
                                            maxLines: 4,
                                            minLines: 2,
                                            keyboard: TextInputType.multiline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        Container(
                                          width: 150,
                                          padding: const EdgeInsets.only(right: 15, top: 15),
                                          child: const Text('Alamat Tinggal Sekarang'),
                                        ),
                                        Expanded(
                                          child: AFwidget.textField(
                                            marginTop: 0,
                                            controller: controller.txtAlamatTinggal,
                                            maxLines: 4,
                                            minLines: 2,
                                            keyboard: TextInputType.multiline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  barisForm(
                                    label: 'No. Telepon',
                                    controller: controller.txtTelepon,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          padding: const EdgeInsets.only(right: 15),
                                          child: const Text('Jenis Kelamin'),
                                        ),
                                        Expanded(
                                          child: GetBuilder<KaryawanControl>(
                                            builder: (_) {
                                              return Row(
                                                children: [
                                                  Radio<String>(
                                                    value: 'L',
                                                    groupValue: controller.kelamin,
                                                    onChanged: (a) {
                                                      if(a != null && a != controller.kelamin) {
                                                        controller.kelamin = a;
                                                        controller.update();
                                                      }
                                                    },
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                                    child: Text('Laki-laki'),
                                                  ),
                                                  Radio<String>(
                                                    value: 'P',
                                                    groupValue: controller.kelamin,
                                                    onChanged: (a) {
                                                      if(a != null && a != controller.kelamin) {
                                                        controller.kelamin = a;
                                                        controller.update();
                                                      }
                                                    },
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                    child: Text('Perempuan'),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          padding: const EdgeInsets.only(right: 15),
                                          child: const Text('Status'),
                                        ),
                                        Expanded(
                                          child: GetBuilder<KaryawanControl>(
                                            builder: (_) {
                                              return Row(
                                                children: [
                                                  Radio<bool>(
                                                    value: true,
                                                    groupValue: controller.kawin,
                                                    onChanged: (a) {
                                                      if(a != null && a != controller.kawin) {
                                                        controller.kawin = a;
                                                        controller.update();
                                                      }
                                                    },
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                                    child: Text('Kawin'),
                                                  ),
                                                  Radio<bool>(
                                                    value: false,
                                                    groupValue: controller.kawin,
                                                    onChanged: (a) {
                                                      if(a != null && a != controller.kawin) {
                                                        controller.kawin = a;
                                                        controller.update();
                                                      }
                                                    },
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                    child: Text('Single'),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          padding: const EdgeInsets.only(right: 15),
                                          child: const Text('Pendidikan Terakhir'),
                                        ),
                                        Expanded(
                                          child: GetBuilder<KaryawanControl>(
                                            builder: (_) {
                                              return AFwidget.comboField(
                                                value: controller.pendidikan.nama,
                                                label: '',
                                                onTap: () async {
                                                  var a = await controller.pilihPendidikan(value: controller.pendidikan.id);
                                                  if(a != null && a.value != controller.pendidikan.id) {
                                                    controller.pendidikan = Pendidikan.fromMap(a.data!);
                                                    controller.update();
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 150),
                                        Container(
                                          width: 100,
                                          padding: const EdgeInsets.only(right: 15),
                                          child: const Text('Almamater'),
                                        ),
                                        Expanded(
                                          child: AFwidget.textField(
                                            marginTop: 0,
                                            controller: controller.txtPendidikanAlmamater,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 150),
                                        Container(
                                          width: 100,
                                          padding: const EdgeInsets.only(right: 15),
                                          child: const Text('Jurusan'),
                                        ),
                                        Expanded(
                                          child: AFwidget.textField(
                                            marginTop: 0,
                                            controller: controller.txtPendidikanJurusan,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  barisForm(
                                    label: 'Email Pribadi',
                                    controller: controller.txtEmail,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          padding: const EdgeInsets.only(right: 15),
                                          child: const Text('Status Karyawan'),
                                        ),
                                        Expanded(
                                          child: GetBuilder<KaryawanControl>(
                                            builder: (_) {
                                              return AFwidget.comboField(
                                                value: controller.statusKerja.nama,
                                                label: '',
                                                onTap: () async {
                                                  var a = await controller.pilihStatusKerja(value: controller.statusKerja.id);
                                                  if(a != null && a.value != controller.statusKerja.id) {
                                                    controller.statusKerja = StatusKerja.fromMap(a.data!);
                                                    controller.update();
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  barisForm(
                                    label: 'NPWP',
                                    controller: controller.txtNomorPwp,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 150,
                                          padding: const EdgeInsets.only(right: 15),
                                          child: const Text('PTKP'),
                                        ),
                                        Expanded(
                                          child: GetBuilder<KaryawanControl>(
                                            builder: (_) {
                                              return AFwidget.comboField(
                                                value: controller.ptkp.kode,
                                                label: '',
                                                onTap: () async {
                                                  var a = await controller.pilihPtkp(value: controller.ptkp.id);
                                                  if(a != null && a.value != controller.ptkp.id) {
                                                    controller.ptkp = Ptkp.fromMap(a.data!);
                                                    controller.update();
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.fromLTRB(0, 15, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AFwidget.tombol(
                                label: 'Hapus Data',
                                color: Colors.red,
                                onPressed: () {
                                  controller.hapusForm();
                                },
                                minimumSize: const Size(120, 40),
                              ),
                              const SizedBox(width: 25),
                              AFwidget.tombol(
                                label: 'PHK',
                                color: Colors.orange,
                                onPressed: () {
                                  controller.tambahPhkForm(context);
                                },
                                minimumSize: const Size(120, 40),
                              ),
                              const Spacer(),
                              AFwidget.tombol(
                                label: 'Simpan Perubahan',
                                color: Colors.blue,
                                onPressed: controller.ubahData,
                                minimumSize: const Size(120, 40),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Scrollbar(
                      controller: _scrollControllerRight,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _scrollControllerRight,
                        child: Column(
                          children: [
                            GetBuilder<KaryawanControl>(
                              builder: (_) {
                                if(controller.listTimelineMasakerja.isEmpty) {
                                  return Container();
                                }
                                var a = controller.listTimelineMasakerja[0].tanggalAwal;
                                // var b = controller.listTimelineMasakerja[controller.listTimelineMasakerja.length-1].tanggalAKhir ?? DateTime.now();
                                var b = DateTime.now();
                                Duration d = b.difference(a ?? b); // dalam hari
                                int tahun = d.inDays ~/ 365; // Membagi dengan 365 untuk tahun
                                int bulan = (d.inDays % 365) ~/ 30; // Menggunakan modulo 365, lalu dibagi dengan 30 untuk bulan
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 15, 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                                        child: Text(
                                          'Masa Kerja : ${tahun>0 ? '$tahun tahun' : ''} ${bulan>0 ? '$bulan bulan' : ''} ',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: controller.listTimelineMasakerja.map((e) {
                                          return Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Stack(
                                                  alignment: AlignmentDirectional.center,
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                                      padding: const EdgeInsets.all(1),
                                                      decoration: BoxDecoration(
                                                        color: e.warna,
                                                      ),
                                                      child: Text(
                                                        '${e.tahun>0 ? '${e.tahun} tahun' : ''} ${e.bulan>0 ? '${e.bulan} bulan' : ''} ',
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      left: -3,
                                                      child: Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: e.warna,
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 3,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: -27,
                                                      child: Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration: const BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 30),
                                                  child: Text(
                                                    '${AFconvert.matDate(e.tanggalAwal)} : ${e.nama}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: e.warna,
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 30, 10),
                                  child: Text('Anggota Keluarga',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    controller.tambahKeluargaForm(context);
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                  ),
                                  iconSize: 30,
                                  color: Colors.blue,
                                  padding: const EdgeInsets.all(0),
                                ),
                              ],
                            ),
                            GetBuilder<KaryawanControl>(
                              builder: (_) {
                                if(controller.listKeluarga.isEmpty) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    padding: const EdgeInsets.all(7),
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.brown.shade200),
                                    ),
                                    child: const Text('Tidak ada data'),
                                  );
                                }
                                int jumlah = controller.listKeluarga.length;
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  height: jumlah > 4 ? 230 : jumlah == 4 ? 193 : jumlah == 3 ? 157 : jumlah == 2 ? 121 : 85,
                                  child: PlutoGrid(
                                    key: UniqueKey(),
                                    columns: columnsKeluarga,
                                    rows: _buildRowsKeluarga(controller.listKeluarga),
                                    onLoaded: (PlutoGridOnLoadedEvent event) {},
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
                                        gridBorderColor: Colors.brown.shade200,
                                        gridBackgroundColor: Colors.transparent,
                                        defaultColumnFilterPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(20, 10, 30, 10),
                                    child: Text('Kontak Keluarga',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      controller.tambahKontakForm(context);
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                    ),
                                    iconSize: 30,
                                    color: Colors.blue,
                                    padding: const EdgeInsets.all(0),
                                  ),
                                ],
                              ),
                            ),
                            GetBuilder<KaryawanControl>(
                              builder: (_) {
                                if(controller.listKontak.isEmpty) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    padding: const EdgeInsets.all(7),
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.brown.shade200),
                                    ),
                                    child: const Text('Tidak ada data'),
                                  );
                                }
                                int jumlah = controller.listKontak.length;
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  height: jumlah > 4 ? 230 : jumlah == 4 ? 193 : jumlah == 3 ? 157 : jumlah == 2 ? 121 : 85,
                                  child: PlutoGrid(
                                    key: UniqueKey(),
                                    columns: columnsKontak,
                                    rows: _buildRowsKontak(controller.listKontak),
                                    onLoaded: (PlutoGridOnLoadedEvent event) {},
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
                                        gridBorderColor: Colors.brown.shade200,
                                        gridBackgroundColor: Colors.transparent,
                                        defaultColumnFilterPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                      ),
                                      columnSize: const PlutoGridColumnSizeConfig(
                                        autoSizeMode: PlutoAutoSizeMode.scale,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(20, 10, 30, 10),
                                    child: Text('Perjanjian Kerja',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      controller.tambahPerjanjianForm(context);
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                    ),
                                    iconSize: 30,
                                    color: Colors.blue,
                                    padding: const EdgeInsets.all(0),
                                  ),
                                ],
                              ),
                            ),
                            GetBuilder<KaryawanControl>(
                              builder: (_) {
                                if(controller.listPerjanjianKerja.isEmpty) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    padding: const EdgeInsets.all(7),
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.brown.shade200),
                                    ),
                                    child: const Text('Tidak ada data'),
                                  );
                                }
                                int jumlah = controller.listPerjanjianKerja.length;
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  height: jumlah > 4 ? 230 : jumlah == 4 ? 193 : jumlah == 3 ? 157 : jumlah == 2 ? 121 : 85,
                                  child: PlutoGrid(
                                    key: UniqueKey(),
                                    columns: columnsPerjanjian,
                                    rows: _buildRowsPerjanjian(controller.listPerjanjianKerja),
                                    onLoaded: (PlutoGridOnLoadedEvent event) {},
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
                                        gridBorderColor: Colors.brown.shade200,
                                        gridBackgroundColor: Colors.transparent,
                                        defaultColumnFilterPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget barisForm({
    String label = '',
    TextEditingController? controller,
    double paddingTop = 11,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, paddingTop, 20, 0),
      child: Row(
        children: [
          Container(
            width: 150,
            padding: const EdgeInsets.only(right: 15),
            child: Text(label),
          ),
          Expanded(
            child: AFwidget.textField(
              marginTop: 0,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}
