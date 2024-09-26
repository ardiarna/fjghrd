import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/models/opsi.dart';
import 'package:fjghrd/repositories/payroll_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/karyawan_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BerandaView extends StatelessWidget {
  BerandaView({super.key});

  final KaryawanControl karyawanControl = Get.put(KaryawanControl());
  final HomeControl homeControl = Get.find<HomeControl>();

  final _now = DateTime.now();

  Future<Map<int, double>> getPayrolls() async {
    Map<int, double> rekap = {};
    final PayrollRepository payrollRepo = PayrollRepository();
    var hasil = await payrollRepo.reportRekap(tahun: _now.year.toString());
    if(hasil.success) {
      var data = hasil.data;
      (data['payrolls'] as Map).forEach((key, value){
        rekap[AFconvert.keInt(key)] = AFconvert.keDouble(value)/1000000;
      });
    }
    return rekap;
  }

  Future<Map<double, double>> getOvertimes() async {
    Map<double, double> rekap = {};
    final PayrollRepository payrollRepo = PayrollRepository();
    var hasil = await payrollRepo.reportRekap(tahun: _now.year.toString());
    if(hasil.success) {
      var data = hasil.data;
      (data['overtimes'] as Map).forEach((key, value){
        rekap[AFconvert.keDouble(key)] = AFconvert.keDouble(value)/1000000;
      });
    }
    return rekap;
  }

  Future<Map<double, double>> getMedicals() async {
    Map<double, double> rekap = {};
    final PayrollRepository payrollRepo = PayrollRepository();
    var hasil = await payrollRepo.reportRekap(tahun: _now.year.toString());
    if(hasil.success) {
      var data = hasil.data;
      (data['medicals'] as Map).forEach((key, value){
        rekap[AFconvert.keDouble(key)] = AFconvert.keDouble(value)/1000000;
      });
    }
    return rekap;
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      getTooltipColor: (group) => Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 0,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.toY.toString(),
          TextStyle(
            color: Colors.green.shade200,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    karyawanControl.loadKaryawans();
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/line-blue.png'),
                      alignment: Alignment.topRight,
                      repeat: ImageRepeat.repeatY,
                      fit: BoxFit.fitWidth,
                      opacity: 0.1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 25),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.blue,
                              blurRadius: 1,
                              blurStyle: BlurStyle.outer,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            GetBuilder<KaryawanControl>(
                              builder: (_) {
                                return Text(
                                  'KETERANGAN STATUS KARYAWAN ${karyawanControl.filterStaf.label} :',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.red,
                                  ),
                                );
                              },
                            ),
                            GetBuilder<KaryawanControl>(
                              builder: (_) {
                                return Visibility(
                                  visible: karyawanControl.filterArea.value != '',
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      'AREA ${karyawanControl.filterArea.label}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            GetBuilder<KaryawanControl>(
                              builder: (_) {
                                return Visibility(
                                  visible: karyawanControl.filterStatusKerja.value != '',
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      'STATUS ${karyawanControl.filterStatusKerja.label}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 15),
                            summaryInfo(),
                          ],
                        ),
                      ),
                      GetBuilder<KaryawanControl>(
                        builder: (_) {
                          if(karyawanControl.listUlangTahun.isEmpty) {
                            return Container();
                          }
                          return Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.green,
                                  blurRadius: 1,
                                  blurStyle: BlurStyle.outer,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BERULANG TAHUN HARI INI: ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.green.shade300,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Wrap(
                                  spacing: 15,
                                  children: karyawanControl.listUlangTahun.map((e) {
                                    return Text(
                                      '🎂${e.nama} (${AFconvert.matDate(e.tanggalLahir)})',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.green.shade500,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                        child: Text('PAYROLL ${_now.year}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<Map<int, double>>(
                          future: getPayrolls(),
                          builder: (_, snap) {
                            if(snap.hasData) {
                              if(snap.data != null) {
                                if(snap.data!.isNotEmpty) {
                                  var barGroups = snap.data!.entries.map((e) {
                                    return BarChartGroupData(
                                      x: e.key,
                                      barRods: [
                                        BarChartRodData(
                                          toY: e.value,
                                          color: Colors.green,
                                        )
                                      ],
                                      showingTooltipIndicators: [0],
                                    );
                                  }).toList();
                                  return BarChart(
                                    BarChartData(
                                      barGroups: barGroups,
                                      barTouchData: barTouchData,
                                      gridData: const FlGridData(
                                        drawVerticalLine: false,
                                        // horizontalInterval: 1,
                                        // verticalInterval: 1,
                                      ),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        rightTitles: const AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        topTitles: const AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            interval: 1,
                                            getTitlesWidget: bottomTitleWidgets,
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 100,
                                            getTitlesWidget: leftTitleWidgets,
                                          ),
                                        ),
                                      ),
                                      borderData: FlBorderData(
                                        show: true,
                                        border: const Border(
                                          bottom: BorderSide(
                                            color: Color(0xff37434d),
                                            width: 0.5,
                                          ),
                                          left: BorderSide(
                                            color: Color(0xff37434d),
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                            return AFwidget.circularProgress();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                        child: Text('OVERTIME ${_now.year}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<Map<double, double>>(
                          future: getOvertimes(),
                          builder: (_, snap) {
                            if(snap.hasData) {
                              if(snap.data != null) {
                                if(snap.data!.isNotEmpty) {
                                  var spots = snap.data!.entries.map((e) {
                                    return FlSpot(e.key, e.value);
                                  }).toList();
                                  return LineChart(
                                    LineChartData(
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: spots,
                                          isCurved: false,
                                          gradient: const LinearGradient(
                                            colors: [
                                              Colors.green,
                                              Colors.blue,
                                            ],
                                          ),
                                          barWidth: 5,
                                          isStrokeCapRound: true,
                                          dotData: const FlDotData(
                                            show: true,
                                          ),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.green.withOpacity(0.3),
                                                Colors.blue.withOpacity(0.3),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                      gridData: const FlGridData(
                                        show: true,
                                      ),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        rightTitles: const AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        topTitles: const AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            interval: 1,
                                            getTitlesWidget: bottomTitleWidgets,
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 100,
                                            getTitlesWidget: leftTitleWithDecimalWidgets,
                                          ),
                                        ),
                                      ),
                                      borderData: FlBorderData(
                                        show: true,
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      minX: 1,
                                      maxX: 12,
                                    ),
                                  );
                                }
                              }
                            }
                            return AFwidget.circularProgress();
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                        child: Text('MEDICAL ${_now.year}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<Map<double, double>>(
                          future: getMedicals(),
                          builder: (_, snap) {
                            if(snap.hasData) {
                              if(snap.data != null) {
                                if(snap.data!.isNotEmpty) {
                                  var spots = snap.data!.entries.map((e) {
                                    return FlSpot(e.key, e.value);
                                  }).toList();
                                  return LineChart(
                                    LineChartData(
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: spots,
                                          color: Colors.red,
                                          isCurved: false,
                                          barWidth: 5,
                                          isStrokeCapRound: true,
                                          dotData: const FlDotData(
                                            show: false,
                                          ),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.red.withOpacity(0.3),
                                                Colors.red.withOpacity(0.3),
                                                Colors.orange.withOpacity(0.3),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                      gridData: const FlGridData(
                                        show: true,
                                      ),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        rightTitles: const AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        topTitles: const AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            interval: 1,
                                            getTitlesWidget: bottomTitleWidgets,
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 100,
                                            getTitlesWidget: leftTitleWithDecimalWidgets,
                                          ),
                                        ),
                                      ),
                                      borderData: FlBorderData(
                                        show: true,
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      minX: 1,
                                      maxX: 12,
                                    ),
                                  );
                                }
                              }
                            }
                            return AFwidget.circularProgress();
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget summaryInfo() {
    return GetBuilder<KaryawanControl>(
      builder: (_) {
        List<Widget> widgets = [];
        List<Widget> areaWidgets = [];
        Map<String, int> listTotalPerStatusKerja = {};
        for(var opStatus in karyawanControl.listStatusKerja) {
          int nilaiTotal = 0;
          if(karyawanControl.totalKaryawanPerStatuskerjaPerArea[opStatus.label] != null) {
            nilaiTotal = karyawanControl.totalKaryawanPerStatuskerjaPerArea[opStatus.label]!['TOTAL KARYAWAN'] ?? 0;
          }
          listTotalPerStatusKerja[opStatus.label] = nilaiTotal;
          if(nilaiTotal > 0) {
            areaWidgets.add(
              textButton(
                label: '🟥${opStatus.label}',
                area: Opsi(value: '', label: 'SEMUA'),
                statusKerja: opStatus,
              ),
            );
          }
        }
        if(karyawanControl.filterStatusKerja.value == '') {
          areaWidgets.add(
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: textButton(
                label: '🟥TOTAL KARYAWAN',
                area: Opsi(value: '', label: 'SEMUA'),
                statusKerja: Opsi(value: '', label: 'SEMUA'),
              ),
            ),
          );
        }
        widgets.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: areaWidgets,
            ),
          ),
        );
        areaWidgets = [];
        for(var opStatus in karyawanControl.listStatusKerja) {
          int nilaiTotal = listTotalPerStatusKerja[opStatus.label] ?? 0;
          if (nilaiTotal > 0) {
            areaWidgets.add(
              Text('= $nilaiTotal',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.red,
                ),
              ),
            );
          }
        }
        if(karyawanControl.filterStatusKerja.value == '') {
          areaWidgets.add(
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text('= ${karyawanControl.totalKaryawanPerArea['TOTAL KARYAWAN'] ?? 0}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }
        widgets.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 35, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: areaWidgets,
            ),
          ),
        );

        for (var opArea in karyawanControl.listArea) {
          areaWidgets = [];
          String kodeArea = opArea.data!['kode'];
          int totalKaryawanPerArea = karyawanControl.totalKaryawanPerArea[kodeArea] ?? 0;
          if(totalKaryawanPerArea > 0 ) {
            for(var opStatus in karyawanControl.listStatusKerja) {
              int nilaiTotal = listTotalPerStatusKerja[opStatus.label] ?? 0;
              if(nilaiTotal > 0) {
                int nilai = 0;
                if(karyawanControl.totalKaryawanPerStatuskerjaPerArea[opStatus.label] != null) {
                  nilai = karyawanControl.totalKaryawanPerStatuskerjaPerArea[opStatus.label]![kodeArea] ?? 0;
                }
                areaWidgets.add(
                  textButton(
                    label: '$kodeArea: $nilai',
                    area: opArea,
                    statusKerja: opStatus,
                  ),
                );
              }
            }
            if(karyawanControl.filterStatusKerja.value == '') {
              areaWidgets.add(
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: textButton(
                    label: '$kodeArea: $totalKaryawanPerArea',
                    area: opArea,
                    statusKerja: Opsi(value: '', label: 'SEMUA'),
                  ),
                ),
              );
            }
            widgets.add(
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: areaWidgets,
                ),
              ),
            );
          }
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgets,
        );
      },
    );
  }

  Widget textButton({
    required String label,
    required Opsi area,
    required Opsi statusKerja,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      onPressed: () {
        karyawanControl.filterArea = area;
        karyawanControl.filterStatusKerja = statusKerja;
        karyawanControl.loadKaryawans();
        homeControl.tabId = 1;
        homeControl.kontener = KaryawanView();
        homeControl.update();
      },
      child: Text(label,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 1:
        text = 'Jan';
        break;
      case 2:
        text = 'Feb';
        break;
      case 3:
        text = 'Mar';
        break;
      case 4:
        text = 'Apr';
        break;
      case 5:
        text = 'Mei';
        break;
      case 6:
        text = 'Jun';
        break;
      case 7:
        text = 'Jul';
        break;
      case 8:
        text = 'Agu';
        break;
      case 9:
        text = 'Sep';
        break;
      case 10:
        text = 'Okt';
        break;
      case 11:
        text = 'Nov';
        break;
      case 12:
        text = 'Des';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '${AFconvert.matNumber(value)} juta',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget leftTitleWithDecimalWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '${AFconvert.matNumberWithDecimal(value)} juta',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

}