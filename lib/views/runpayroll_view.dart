import 'package:fjghrd/controllers/payroll_control.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/opsi.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/payroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

//ignore: must_be_immutable
class RunpayrollView extends StatelessWidget {
  RunpayrollView({super.key});

  final PayrollControl controller = Get.put(PayrollControl());
  final ScrollController _scrollController = ScrollController();
  final DateTime now = DateTime.now();

  PlutoGridStateManager? stateManager;

  List<PlutoRow> _buildRows(List<Karyawan> rowData) {
    int hariMakan = controller.countWorkingDays();
    return rowData.map((e) {
      int uangMakanHarian = e.upah.makanHarian ? e.upah.uangMakan : 0;
      int uangMakanJumlah = e.upah.makanHarian ? uangMakanHarian*hariMakan : e.upah.uangMakan;
      int totalDiterima = e.upah.gaji + uangMakanJumlah;
      int medical = controller.listMedical
          .where((element) => element.karyawan.id == e.id)
          .fold(0, (sum, element) => sum + element.jumlah);
      var overtimeFjg = controller.listOvertime
          .where((element) => element.karyawan.id == e.id && element.jenis == 'F')
          .fold(0, (sum, element) => sum + element.jumlah);
      var overtimeCus = controller.listOvertime
          .where((element) => element.karyawan.id == e.id && element.jenis == 'C')
          .fold(0, (sum, element) => sum + element.jumlah);
      return PlutoRow(
        cells: {
          'karyawan_id': PlutoCell(value: e.id),
          'area': PlutoCell(value: e.area.nama),
          'nama': PlutoCell(value: e.nama),
          'jabatan': PlutoCell(value: e.jabatan.nama),
          'gaji': PlutoCell(value: e.upah.gaji),
          'makan_harian': PlutoCell(value: e.upah.makanHarian ? 'Y' : 'N'),
          'hari_makan': PlutoCell(value: hariMakan),
          'uang_makan_harian': PlutoCell(value: uangMakanHarian),
          'uang_makan_jumlah': PlutoCell(value: uangMakanJumlah),
          'overtime_fjg': PlutoCell(value: overtimeFjg),
          'overtime_cus': PlutoCell(value: overtimeCus),
          'medical': PlutoCell(value: medical),
          'thr': PlutoCell(value: 0),
          'bonus': PlutoCell(value: 0),
          'insentif': PlutoCell(value: 0),
          'telkomsel': PlutoCell(value: 0),
          'lain': PlutoCell(value: 0),
          'pot_25_hari': PlutoCell(value: 0),
          'pot_25_jumlah': PlutoCell(value: 0),
          'pot_telepon': PlutoCell(value: 0),
          'pot_bensin': PlutoCell(value: 0),
          'pot_kas': PlutoCell(value: 0),
          'pot_cicilan': PlutoCell(value: 0),
          'pot_bpjs': PlutoCell(value: 0),
          'pot_cuti': PlutoCell(value: 0),
          'pot_lain': PlutoCell(value: 0),
          'total_diterima': PlutoCell(value: totalDiterima),
          'keterangan': PlutoCell(value: ''),
        },
      );
    }).toList();
  }

  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(
      title: 'U/MAKAN & TRANSPORTASI',
      fields: ['hari_makan', 'uang_makan_harian', 'uang_makan_jumlah'],
      backgroundColor: Colors.brown.shade100,
    ),
    PlutoColumnGroup(
      title: 'TUNJANGAN LAINNYA',
      backgroundColor: Colors.brown.shade100,
      children: [
        PlutoColumnGroup(
          title: 'OVERTIME',
          fields: ['overtime_fjg', 'overtime_cus'],
          backgroundColor: Colors.brown.shade100,
        ),
        PlutoColumnGroup(
          title: '',
          fields: ['medical'],
          expandedColumn: true,
          backgroundColor: Colors.brown.shade100,
        ),
        PlutoColumnGroup(
          title: '',
          fields: ['thr'],
          expandedColumn: true,
          backgroundColor: Colors.brown.shade100,
        ),
        PlutoColumnGroup(
          title: '',
          fields: ['bonus'],
          expandedColumn: true,
          backgroundColor: Colors.brown.shade100,
        ),
        PlutoColumnGroup(
          title: '',
          fields: ['insentif'],
          expandedColumn: true,
          backgroundColor: Colors.brown.shade100,
        ),
        PlutoColumnGroup(
          title: '',
          fields: ['telkomsel'],
          expandedColumn: true,
          backgroundColor: Colors.brown.shade100,
        ),
        PlutoColumnGroup(
          title: '',
          fields: ['lain'],
          expandedColumn: true,
          backgroundColor: Colors.brown.shade100,
        ),
      ],
    ),
    PlutoColumnGroup(
      title: 'POTONGAN',
      backgroundColor: Colors.red.shade100,
      children:  [
        PlutoColumnGroup(
          title: 'KETERLAMBATAN 25%',
          fields: ['pot_25_hari', 'pot_25_jumlah'],
          backgroundColor: Colors.red.shade100,
        ),
        PlutoColumnGroup(
          title: '',
          fields: ['pot_telepon'],
          expandedColumn: true,
        ),
        PlutoColumnGroup(
          title: '',
          fields: ['pot_bensin'],
          expandedColumn: true,
        ),
        PlutoColumnGroup(
          title: 'PINJAMAN',
          fields: ['pot_kas', 'pot_cicilan'],
          backgroundColor: Colors.red.shade100,
        ),
        PlutoColumnGroup(
          title: '',
          fields: ['pot_bpjs'],
          expandedColumn: true,
        ),
        PlutoColumnGroup(
          title: '',
          fields: ['pot_cuti'],
          expandedColumn: true,
        ),
        PlutoColumnGroup(
          title: '',
          fields: ['pot_lain'],
          expandedColumn: true,
        ),
      ],
    ),
  ];

  final List<PlutoColumn> columns = [
    PlutoColumn(
      title: 'NAMA',
      field: 'nama',
      type: PlutoColumnType.text(),
      readOnly: true,
      width: 260,
      backgroundColor: Colors.brown.shade100,
      frozen: PlutoColumnFrozen.start,
      titleTextAlign: PlutoColumnTextAlign.center,
      suppressedAutoSize: true,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
    ),
    PlutoColumn(
      title: 'AREA',
      field: 'area',
      type: PlutoColumnType.text(),
      readOnly: true,
      width: 210,
      backgroundColor: Colors.brown.shade100,
      titleTextAlign: PlutoColumnTextAlign.center,
      suppressedAutoSize: true,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
    ),
    PlutoColumn(
      title: 'JABATAN',
      field: 'jabatan',
      type: PlutoColumnType.text(),
      readOnly: true,
      width: 230,
      backgroundColor: Colors.brown.shade100,
      titleTextAlign: PlutoColumnTextAlign.center,
      suppressedAutoSize: true,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
    ),
    PlutoColumn(
      title: 'GAJI / UPAH',
      field: 'gaji',
      type: PlutoColumnType.number(),
      width: 150,
      backgroundColor: Colors.brown.shade100,
      textAlign: PlutoColumnTextAlign.right,
      titleTextAlign: PlutoColumnTextAlign.center,
      suppressedAutoSize: true,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'HR',
      field: 'hari_makan',
      type: PlutoColumnType.number(),
      width: 70,
      backgroundColor: Colors.brown.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
    ),
    PlutoColumn(
      title: '@HARI IDR',
      field: 'uang_makan_harian',
      type: PlutoColumnType.number(),
      width: 120,
      backgroundColor: Colors.brown.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
    ),
    PlutoColumn(
      title: 'JUMLAH IDR',
      field: 'uang_makan_jumlah',
      type: PlutoColumnType.number(),
      width: 130,
      backgroundColor: Colors.brown.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'FRATEKINDO',
      field: 'overtime_fjg',
      type: PlutoColumnType.number(),
      width: 130,
      backgroundColor: Colors.brown.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'CUSTOMER',
      field: 'overtime_cus',
      type: PlutoColumnType.number(),
      width: 130,
      backgroundColor: Colors.brown.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'MEDICAL IDR',
      field: 'medical',
      type: PlutoColumnType.number(),
      width: 140,
      backgroundColor: Colors.brown.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'THR IDR',
      field: 'thr',
      type: PlutoColumnType.number(),
      width: 130,
      backgroundColor: Colors.brown.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'BONUS IDR',
      field: 'bonus',
      type: PlutoColumnType.number(),
      width: 130,
      backgroundColor: Colors.brown.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'INSENTIF IDR',
      field: 'insentif',
      type: PlutoColumnType.number(),
      width: 130,
      backgroundColor: Colors.brown.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'TELKOM IDR',
      field: 'telkomsel',
      type: PlutoColumnType.number(),
      width: 130,
      backgroundColor: Colors.brown.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'LAIN2 IDR',
      field: 'lain',
      type: PlutoColumnType.number(),
      width: 130,
      backgroundColor: Colors.brown.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'HR',
      field: 'pot_25_hari',
      type: PlutoColumnType.number(),
      width: 70,
      backgroundColor: Colors.red.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'JUMLAH IDR',
      field: 'pot_25_jumlah',
      type: PlutoColumnType.number(),
      width: 130,
      backgroundColor: Colors.red.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
      readOnly: true,
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
      title: 'TELP. IDR',
      field: 'pot_telepon',
      type: PlutoColumnType.number(),
      width: 130,
      backgroundColor: Colors.red.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'BENSIN IDR',
      field: 'pot_bensin',
      type: PlutoColumnType.number(),
      width: 130,
      backgroundColor: Colors.red.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'KAS',
      field: 'pot_kas',
      type: PlutoColumnType.number(),
      width: 130,
      backgroundColor: Colors.red.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'CICILAN',
      field: 'pot_cicilan',
      type: PlutoColumnType.number(),
      width: 130,
      backgroundColor: Colors.red.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'BPJS IDR',
      field: 'pot_bpjs',
      type: PlutoColumnType.number(),
      width: 130,
      backgroundColor: Colors.red.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'UNPAID LEAVE',
      field: 'pot_cuti',
      type: PlutoColumnType.number(),
      width: 150,
      backgroundColor: Colors.red.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'LAIN2 IDR',
      field: 'pot_lain',
      type: PlutoColumnType.number(),
      width: 130,
      backgroundColor: Colors.red.shade100,
      textAlign: PlutoColumnTextAlign.right,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
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
      title: 'TOTAL DITERIMA IDR',
      field: 'total_diterima',
      type: PlutoColumnType.number(),
      width: 200,
      backgroundColor: Colors.blue.shade100,
      textAlign: PlutoColumnTextAlign.right,
      titleTextAlign: PlutoColumnTextAlign.center,
      suppressedAutoSize: true,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
      readOnly: true,
      footerRenderer: (rdrCtx) {
        return PlutoAggregateColumnFooter(
          rendererContext: rdrCtx,
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
      width: 200,
      backgroundColor: Colors.brown.shade100,
      titleTextAlign: PlutoColumnTextAlign.center,
      suppressedAutoSize: true,
      enableContextMenu: false,
      enableSorting: false,
      enableColumnDrag: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    controller.txtTanggalAwal.text = AFconvert.matDate(DateTime(now.year, now.month == 1 ? 12 : now.month-1, 19));
    controller.txtTanggalAkhir.text = AFconvert.matDate(DateTime(now.year, now.month, 18));
    controller.tahun = Opsi(value: '${now.year}', label: '${now.year}');
    controller.bulan = Opsi(value: '${now.month}', label: mapBulan[now.month]!);
    controller.homeControl.kontener = wgPeriode();
    return GetBuilder<PayrollControl>(
      builder: (_) {
        return controller.homeControl.kontener;
      }
    );
  }

  Widget wgPeriode() {
    return Row(
      children: [
        const Spacer(),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              const Text('RUN PAYROLL',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Row(
                  children: [
                    Container(
                      width: 240,
                      padding: const EdgeInsets.only(right: 15),
                      child: const Text('Periode Penggajian'),
                    ),
                    SizedBox(
                      width: 170,
                      child: GetBuilder<PayrollControl>(
                        builder: (_) {
                          return AFwidget.comboField(
                            value: controller.bulan.label,
                            label: '',
                            onTap: () async {
                              var a = await controller.pilihBulan(value: controller.bulan.value);
                              if(a != null && a.value != controller.bulan.value) {
                                controller.bulan = a;
                                controller.update();
                              }
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 40),
                    SizedBox(
                      width: 170,
                      child: GetBuilder<PayrollControl>(
                        builder: (_) {
                          return AFwidget.comboField(
                            value: controller.tahun.label,
                            label: '',
                            onTap: () async {
                              var a = await controller.pilihTahun(value: controller.tahun.value);
                              if(a != null && a.value != controller.tahun.value) {
                                controller.tahun = a;
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
                padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                child: Row(
                  children: [
                    Container(
                      width: 240,
                      padding: const EdgeInsets.only(right: 15),
                      child: const Text('Periode Batas (Cut-Off)'),
                    ),
                    SizedBox(
                      width: 170,
                      child: AFwidget.textField(
                        marginTop: 0,
                        controller: controller.txtTanggalAwal,
                        readOnly: true,
                        prefixIcon: const Icon(Icons.calendar_month),
                        ontap: () async {
                          var a = await AFwidget.pickDate(
                            context: controller.homeControl.scaffoldKey.currentContext!,
                            initialDate: AFconvert.keTanggal(AFconvert.matDMYtoYMD(controller.txtTanggalAwal.text)),
                          );
                          if(a != null) {
                            controller.txtTanggalAwal.text = AFconvert.matDate(a);
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                      child: Text('s/d', textAlign: TextAlign.center),
                    ),
                    SizedBox(
                      width: 170,
                      child: AFwidget.textField(
                        marginTop: 0,
                        controller: controller.txtTanggalAkhir,
                        readOnly: true,
                        prefixIcon: const Icon(Icons.calendar_month),
                        ontap: () async {
                          var a = await AFwidget.pickDate(
                            context: controller.homeControl.scaffoldKey.currentContext!,
                            initialDate: AFconvert.keTanggal(AFconvert.matDMYtoYMD(controller.txtTanggalAkhir.text)),
                          );
                          if(a != null) {
                            controller.txtTanggalAkhir.text = AFconvert.matDate(a);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  maxWidth: 625,
                ),
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AFwidget.tombol(
                      label: 'Batal',
                      color: Colors.orange,
                      onPressed: () {
                        controller.homeControl.kontener = PayrollView();
                        controller.homeControl.update();
                      },
                      minimumSize: const Size(120, 40),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        controller.loadOvertimes();
                        controller.loadMedicals();
                        controller.loadHariLiburs();
                        controller.homeControl.kontener = wgKaryawans();
                        controller.homeControl.update();
                      },
                      icon: const Text('Selanjutnya'),
                      label: const Icon(Icons.navigate_next),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
  
  Widget wgKaryawans() {
    return Row(
      children: [
        const Spacer(),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              const Text('RUN PAYROLL',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text('PILIH KARYAWAN',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GetBuilder<PayrollControl>(
                  builder: (_) {
                    List<Widget> children = [];
                    var no = 1;
                    controller.totalKaryawanPerArea.forEach((key, value) {
                      children.add(
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 3),
                            child: Text(key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.blue,
                              ),
                            ),
                          )
                      );
                      for (var i = 0; i < controller.listKaryawan.length; i++) {
                        if(controller.listKaryawan[i].staf && controller.listKaryawan[i].area.nama == key) {
                          children.add(
                            Row(
                              children: [
                                Checkbox(
                                  value: controller.listKaryawan[i].dipilih,
                                  onChanged: (value) {
                                    if(value != null) {
                                      controller.listKaryawan[i].dipilih = value;
                                      controller.update();
                                    }
                                  },
                                ),
                                Text('$no. ${controller.listKaryawan[i].nama}'),
                                const SizedBox(width: 100),
                              ],
                            ),
                          );
                          no++;
                        }
                      }
                      children.add(const SizedBox(height: 20));
                    });
                    for (var i = 0; i < controller.listKaryawan.length; i++) {
                      if(!controller.listKaryawan[i].staf) {
                        children.add(
                          Row(
                            children: [
                              Checkbox(
                                value: controller.listKaryawan[i].dipilih,
                                onChanged: (value) {
                                  if(value != null) {
                                    controller.listKaryawan[i].dipilih = value;
                                    controller.update();
                                  }
                                },
                              ),
                              Text('$no. ${controller.listKaryawan[i].nama}'),
                              const SizedBox(width: 100),
                            ],
                          ),
                        );
                        no++;
                      }
                    }
                    return Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: children,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  maxWidth: 625,
                ),
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AFwidget.tombol(
                      label: 'Batal',
                      color: Colors.orange,
                      onPressed: () {
                        controller.homeControl.kontener = PayrollView();
                        controller.homeControl.update();
                      },
                      minimumSize: const Size(120, 40),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: () {
                        controller.homeControl.kontener = wgPeriode();
                        controller.homeControl.update();
                      },
                      icon: const Icon(Icons.navigate_before),
                      label: const Text('Sebelumnya'),
                    ),
                    const SizedBox(width: 25),
                    FilledButton.icon(
                      onPressed: () {
                        controller.homeControl.kontener = wgGaji();
                        controller.homeControl.update();
                      },
                      icon: const Text('Selanjutnya'),
                      label: const Icon(Icons.navigate_next),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget wgGaji() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: [
              const Text('RUN PAYROLL',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 50),
              Flexible(
                child: Text('Periode : ${controller.bulan.label} ${controller.tahun.label}',
                  style: const TextStyle(
                    color: Colors.black45,
                  ),
                ),
              ),
              const SizedBox(width: 50),
              Flexible(
                child: Text('Periode Batas (Cut-Off) : ${controller.txtTanggalAwal.text} s/d ${controller.txtTanggalAkhir.text}',
                  style: const TextStyle(
                    color: Colors.black45,
                  ),),
              ),
            ],
          ),
        ),
        Expanded(
          child: GetBuilder<PayrollControl>(
            builder: (_) {
              return PlutoGrid(
                key: UniqueKey(),
                columns: columns,
                rows: _buildRows(controller.listKaryawan.where((element) => element.dipilih).toList()),
                columnGroups: columnGroups,
                onChanged: (ev) {
                  if(ev.columnIdx == 4 || ev.columnIdx == 5) {
                    if(ev.row.cells['makan_harian']!.value == 'Y') {
                      ev.row.cells['uang_makan_jumlah']!.value = ev.row.cells['hari_makan']!.value * ev.row.cells['uang_makan_harian']!.value;
                    }
                  } else if(ev.columnIdx == 15 || ev.columnIdx == 5) {
                    if(ev.row.cells['makan_harian']!.value == 'Y') {
                      double a = ev.row.cells['pot_25_hari']!.value * (ev.row.cells['uang_makan_harian']!.value/4);
                      ev.row.cells['pot_25_jumlah']!.value = a.toInt();
                    }
                  }
                  int penghasilan = ev.row.cells['gaji']!.value + ev.row.cells['uang_makan_jumlah']!.value +
                      ev.row.cells['overtime_fjg']!.value + ev.row.cells['overtime_cus']!.value +
                      ev.row.cells['medical']!.value + ev.row.cells['thr']!.value +
                      ev.row.cells['bonus']!.value + ev.row.cells['insentif']!.value +
                      ev.row.cells['telkomsel']!.value + ev.row.cells['lain']!.value;
                  int potongan =  ev.row.cells['pot_25_jumlah']!.value + ev.row.cells['pot_telepon']!.value +
                      ev.row.cells['pot_bensin']!.value + ev.row.cells['pot_kas']!.value +
                      ev.row.cells['pot_cicilan']!.value + ev.row.cells['pot_bpjs']!.value +
                      ev.row.cells['pot_cuti']!.value + ev.row.cells['pot_lain']!.value;
                  ev.row.cells['total_diterima']!.value = penghasilan - potongan;
                },
                onLoaded: (PlutoGridOnLoadedEvent ev) {
                  stateManager = ev.stateManager;
                  ev.stateManager.setShowColumnFilter(true);
                  ev.stateManager.setAutoEditing(true);
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
                    rowHeight: 30,
                    columnHeight: 35,
                    borderColor: Colors.brown.shade200,
                    gridBorderColor: Colors.transparent,
                    gridBackgroundColor: Colors.transparent,
                    defaultColumnFilterPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                    iconSize: 1,
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(30, 10, 50, 5),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: [
              AFwidget.tombol(
                label: 'Batal',
                color: Colors.orange,
                onPressed: () {
                  controller.homeControl.kontener = PayrollView();
                  controller.homeControl.update();
                },
                minimumSize: const Size(120, 40),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () {
                  controller.homeControl.kontener = wgKaryawans();
                  controller.homeControl.update();
                },
                icon: const Icon(Icons.navigate_before),
                label: const Text('Sebelumnya'),
              ),
              const SizedBox(width: 50),
              FilledButton.icon(
                onPressed: () async {
                  if(stateManager != null) {
                    List<Map<String, String>> listData = [];
                    Map<String, String> rowData = {};
                    for(var e in stateManager!.rows) {
                      rowData = {};
                      for(var h in e.cells.entries) {
                        rowData[h.key] = h.value.value.toString();
                      }
                      listData.add(rowData);
                    }
                    var a = await controller.runPayroll(
                      tglAwal: AFconvert.matDMYtoYMD(controller.txtTanggalAwal.text),
                      tglAkhir: AFconvert.matDMYtoYMD(controller.txtTanggalAkhir.text),
                      tahun: controller.tahun.value,
                      bulan: controller.bulan.value,
                      payrolls: listData,
                    );
                    if(a) {
                      controller.homeControl.kontener = PayrollView();
                      controller.homeControl.update();
                    }
                  }
                },
                icon: const Icon(Icons.save, size: 18),
                label: const Text('Simpan Payroll'),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget barisText({
    String label = '',
    TextEditingController? controller,
    double paddingTop = 11,
    bool isTextArea = false
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, paddingTop, 20, 0),
      child: Row(
        crossAxisAlignment: isTextArea ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            width: 150,
            padding: EdgeInsets.only(right: 15, top: isTextArea ? 15 : 0),
            child: Text(label),
          ),
          Expanded(
            child: AFwidget.textField(
              marginTop: 0,
              controller: controller,
              maxLines: isTextArea ? 4 : 1,
              minLines: isTextArea ? 2 : 1,
              keyboard: isTextArea ? TextInputType.multiline : TextInputType.text,
            ),
          ),
        ],
      ),
    );
  }
}
