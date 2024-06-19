import 'package:fjghrd/repositories/karyawan_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../repositories/payroll_repository.dart';

class BerandaView extends StatelessWidget {
  BerandaView({super.key});

  final _now = DateTime.now();

  Future<Map<String, dynamic>> getKaryawan() async {
    Map<String, dynamic> rekap = {};
    final KaryawanRepository karyawanRepo = KaryawanRepository();
    var hasil = await karyawanRepo.rekapAreaKelamin();
    if(hasil.success) {
      rekap = hasil.data;
    }
    return rekap;
  }

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
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 30, 30, 10),
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: getKaryawan(),
                    builder: (_, snap) {
                      if(snap.hasData) {
                        if(snap.data != null) {
                          if(snap.data!.isNotEmpty) {
                            var a = snap.data!.entries.map((e) {

                            }).toList();
                            return Container();
                          }
                        }
                      }
                      return AFwidget.circularProgress();
                    }
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