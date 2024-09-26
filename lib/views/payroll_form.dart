import 'package:fjghrd/controllers/payroll_control.dart';
import 'package:fjghrd/models/payroll.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_plutogrid_config.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/payroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PayrollForm extends StatelessWidget {
  PayrollForm({this.isEdit = false, super.key});

  final bool isEdit;

  final PayrollControl controller = Get.put(PayrollControl());

  List<PlutoRow> _buildRows(List<Payroll> rowData) {
    return rowData.map((e) {
      return PlutoRow(
        cells: {
          'id': PlutoCell(value: e.id),
          'payroll_header_id': PlutoCell(value: e.headerId),
          'karyawan_id': PlutoCell(value: e.karyawan.id),
          'area': PlutoCell(value: e.karyawan.area.nama),
          'nama': PlutoCell(value: e.karyawan.nama),
          'jabatan': PlutoCell(value: e.karyawan.jabatan.nama),
          'gaji': PlutoCell(value: e.gaji),
          'kenaikan_gaji': PlutoCell(value: e.kenaikanGaji),
          'makan_harian': PlutoCell(value: e.makanHarian ? 'Y' : 'N'),
          'hari_makan': PlutoCell(value: e.hariMakan),
          'uang_makan_harian': PlutoCell(value: e.uangMakanHarian),
          'uang_makan_jumlah': PlutoCell(value: e.uangMakanJumlah),
          'overtime_fjg': PlutoCell(value: e.overtimeFjg),
          'overtime_cus': PlutoCell(value: e.overtimeCus),
          'medical': PlutoCell(value: e.medical),
          'thr': PlutoCell(value: e.thr),
          'bonus': PlutoCell(value: e.bonus),
          'insentif': PlutoCell(value: e.insentif),
          'telkomsel': PlutoCell(value: e.telkomsel),
          'lain': PlutoCell(value: e.lain),
          'pot_25_hari': PlutoCell(value: e.pot25hari),
          'pot_25_jumlah': PlutoCell(value: e.pot25jumlah),
          'pot_telepon': PlutoCell(value: e.potTelepon),
          'pot_bensin': PlutoCell(value: e.potBensin),
          'pot_kas': PlutoCell(value: e.potKas),
          'pot_cicilan': PlutoCell(value: e.potCicilan),
          'pot_bpjs': PlutoCell(value: e.potBpjs),
          'pot_cuti_hari': PlutoCell(value: e.potCutiHari),
          'pot_cuti_jumlah': PlutoCell(value: e.potCutiJumlah),
          'pot_kompensasi_jam': PlutoCell(value: e.potKompensasiJam),
          'pot_kompensasi_jumlah': PlutoCell(value: e.potKompensasiJumlah),
          'pot_lain': PlutoCell(value: e.potLain),
          'total_diterima': PlutoCell(value: e.totalDiterima),
          'keterangan': PlutoCell(value: e.keterangan),
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
          title: 'UNPAID LEAVE',
          fields: ['pot_cuti_hari', 'pot_cuti_jumlah'],
          backgroundColor: Colors.red.shade100,
        ),
        PlutoColumnGroup(
          title: 'KOMPENSASI',
          fields: ['pot_kompensasi_jam', 'pot_kompensasi_jumlah'],
          backgroundColor: Colors.red.shade100,
        ),
        PlutoColumnGroup(
          title: '',
          fields: ['pot_lain'],
          expandedColumn: true,
        ),
      ],
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
        width: 70,
        backgroundColor: Colors.brown.shade100,
        enableFilterMenuItem: false,
        enableContextMenu: false,
        enableDropToResize: false,
        frozen: PlutoColumnFrozen.start,
        renderer: (rdrCtx) {
          if(rdrCtx.row.cells['id']!.value == null) {
            return const Text('');
          }
          if(!isEdit) {
            return Container();
          }
          return IconButton(
            onPressed: () {
              controller.ubahDetilForm(rdrCtx.row.cells['id']!.value, context);
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
        readOnly: true,
        width: 150,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        titleTextAlign: PlutoColumnTextAlign.center,
        suppressedAutoSize: true,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        title: 'KENAIKAN GAJI',
        field: 'kenaikan_gaji',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 150,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        titleTextAlign: PlutoColumnTextAlign.center,
        suppressedAutoSize: true,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        readOnly: true,
        width: 70,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
      ),
      PlutoColumn(
        title: '@HARI IDR',
        field: 'uang_makan_harian',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 120,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
      ),
      PlutoColumn(
        title: 'JUMLAH IDR',
        field: 'uang_makan_jumlah',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 130,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        readOnly: true,
        width: 130,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        readOnly: true,
        width: 130,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        readOnly: true,
        width: 140,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        readOnly: true,
        width: 130,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        readOnly: true,
        width: 130,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        readOnly: true,
        width: 130,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        readOnly: true,
        width: 130,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        readOnly: true,
        width: 130,
        backgroundColor: Colors.brown.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        readOnly: true,
        width: 70,
        backgroundColor: Colors.red.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        readOnly: true,
        width: 130,
        backgroundColor: Colors.red.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        readOnly: true,
        width: 130,
        backgroundColor: Colors.red.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        readOnly: true,
        width: 130,
        backgroundColor: Colors.red.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        readOnly: true,
        width: 130,
        backgroundColor: Colors.red.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        readOnly: true,
        width: 130,
        backgroundColor: Colors.red.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        field: 'pot_cuti_hari',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 70,
        backgroundColor: Colors.red.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        field: 'pot_cuti_jumlah',
        type: PlutoColumnType.number(),
        readOnly: true,
        width: 130,
        backgroundColor: Colors.red.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        title: 'JAM',
        field: 'pot_kompensasi_jam',
        type: PlutoColumnType.number(format: '#,##0.0'),
        readOnly: true,
        width: 70,
        backgroundColor: Colors.red.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumberWithDecimal(value, decimal: 1),
            textAlign: TextAlign.right,
          );
        },
        footerRenderer: (rendererContext) {
          return PlutoAggregateColumnFooter(
            rendererContext: rendererContext,
            type: PlutoAggregateColumnType.sum,
            format: '#,##0.0',
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
        field: 'pot_kompensasi_jumlah',
        type: PlutoColumnType.number(),
        width: 130,
        backgroundColor: Colors.red.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        readOnly: true,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        readOnly: true,
        width: 130,
        backgroundColor: Colors.red.shade100,
        textAlign: PlutoColumnTextAlign.right,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          if(value == 0) {
            return const Text('');
          }
          return Text(
            AFconvert.matNumber(value),
            textAlign: TextAlign.right,
          );
        },
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
        readOnly: true,
        width: 200,
        backgroundColor: Colors.brown.shade100,
        titleTextAlign: PlutoColumnTextAlign.center,
        suppressedAutoSize: true,
        enableContextMenu: false,
        enableSorting: false,
        enableColumnDrag: false,
      ),
    ];
    controller.loadDetilPayrolls();
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
              GetBuilder<PayrollControl>(
                builder: (_) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      color: Colors.brown,
                    ),
                    child: Text('PAYROLL ${mapBulan[controller.currentPayroll.bulan]} ${controller.currentPayroll.tahun}'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 40),
              Visibility(
                visible: isEdit,
                child: IconButton(
                  onPressed: () {
                    controller.ubahForm(context);
                  },
                  icon: const Icon(
                    Icons.edit,
                  ),
                  color: Colors.green,
                  padding: const EdgeInsets.all(0),
                ),
              ),
              const SizedBox(width: 50),
              Flexible(
                child: GetBuilder<PayrollControl>(
                    builder: (_) {
                    return Text('Periode : ${mapBulan[controller.currentPayroll.bulan]} ${controller.currentPayroll.tahun}',
                      style: const TextStyle(
                        color: Colors.black45,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 50),
              Flexible(
                child: GetBuilder<PayrollControl>(
                    builder: (_) {
                    return Text('Periode Batas (Cut-off) : ${AFconvert.matDate(controller.currentPayroll.tanggalAwal)} s/d ${AFconvert.matDate(controller.currentPayroll.tanggalAkhir)}',
                      style: const TextStyle(
                        color: Colors.black45,
                      ),
                    );
                  },
                ),
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
                rows: _buildRows(controller.listDetilPayroll),
                columnGroups: columnGroups,
                onLoaded: (PlutoGridOnLoadedEvent ev) {
                  ev.stateManager.setShowColumnFilter(true);
                },
                configuration: AFplutogridConfig.configSatu(iconSize: 1),
              );
            },
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
