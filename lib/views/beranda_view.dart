import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/models/opsi.dart';
import 'package:fjghrd/repositories/payroll_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/demografi_view.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            homeControl.tabId = 0;
                            homeControl.kontener = DemografiView();
                            homeControl.update();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Warna latar tombol
                            foregroundColor: Colors.white, // Warna teks
                          ),
                          child: const Text('LIHAT DEMOGRAFI KARYAWAN'),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 25),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
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
                                    ),
                                  );
                                },
                              ),
                              GetBuilder<KaryawanControl>(
                                builder: (_) {
                                  return Visibility(
                                    visible:
                                        karyawanControl.filterArea.value != '',
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        'AREA ${karyawanControl.filterArea.label}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              GetBuilder<KaryawanControl>(
                                builder: (_) {
                                  return Visibility(
                                    visible: karyawanControl
                                            .filterStatusKerja.value !=
                                        '',
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        'STATUS ${karyawanControl.filterStatusKerja.label}',
                                        style: const TextStyle(
                                          fontSize: 13,
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
                            if (karyawanControl.listUlangTahun.isEmpty) {
                              return Container();
                            }
                            return Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.7),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
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
                                    children:
                                        karyawanControl.listUlangTahun.map((e) {
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
                    padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                          child: Text(
                            'OVERTIME ${_now.year}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder<Map<double, double>>(
                            future: getOvertimes(),
                            builder: (_, snap) {
                              if (snap.hasData) {
                                if (snap.data != null) {
                                  if (snap.data!.isNotEmpty) {
                                    var spots = snap.data!.entries.map((e) {
                                      return FlSpot(e.key, e.value);
                                    }).toList();
                                    return LineChart(
                                      LineChartData(
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: spots,
                                            isCurved: false,
                                            color: Colors.green,
                                            barWidth: 5,
                                            isStrokeCapRound: true,
                                            dotData: const FlDotData(
                                              show: true,
                                            ),
                                            belowBarData: BarAreaData(
                                              show: true,
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.green
                                                      .withValues(alpha: 0.3),
                                                  Colors.green
                                                      .withValues(alpha: 0.1),
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
                                            sideTitles:
                                            SideTitles(showTitles: false),
                                          ),
                                          topTitles: const AxisTitles(
                                            sideTitles:
                                            SideTitles(showTitles: false),
                                          ),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              interval: 1,
                                              getTitlesWidget:
                                              bottomTitleWidgetsOvertime,
                                            ),
                                          ),
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 100,
                                              getTitlesWidget:
                                              leftTitleWidgetsOvertime,
                                            ),
                                          ),
                                        ),
                                        borderData: FlBorderData(
                                          show: true,
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                        ),
                                        minX: 1,
                                        maxX: 12,
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
                    padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                          child: Text(
                            'PAYROLL ${_now.year}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder<Map<int, double>>(
                            future: getPayrolls(),
                            builder: (_, snap) {
                              if (snap.hasData) {
                                if (snap.data != null) {
                                  if (snap.data!.isNotEmpty) {
                                    var barGroups = snap.data!.entries.map((e) {
                                      return BarChartGroupData(
                                        x: e.key,
                                        barRods: [
                                          BarChartRodData(
                                            toY: e.value,
                                            color: Colors.blue,
                                            width: 12,
                                            borderRadius: BorderRadius.zero,
                                          )
                                        ],
                                      );
                                    }).toList();
                                    return Column(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                            child: BarChart(
                                              BarChartData(
                                                barGroups: barGroups,
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
                                                      getTitlesWidget: bottomTitleWidgetsPayroll,
                                                    ),
                                                  ),
                                                  leftTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: false,
                                                      reservedSize: 100,
                                                    ),
                                                  ),
                                                ),
                                                borderData: FlBorderData(
                                                  show: true,
                                                  border: const Border(
                                                    bottom: BorderSide(
                                                      color: Colors.lightBlue,
                                                      width: 0.5,
                                                    ),
                                                    left: BorderSide(
                                                      color: Colors.lightBlue,
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Wrap(
                                          alignment: WrapAlignment.start,
                                          spacing: 25,
                                          runSpacing: 5,
                                          children: snap.data!.entries.map((entry) {
                                            return Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 5,
                                                  height: 5,
                                                  margin: const EdgeInsets.only(right: 3),
                                                  decoration: const BoxDecoration(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                Text(
                                                  '${mapBulan[entry.key]} : ${AFconvert.matNumber(entry.value*1000000)}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ],
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
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                          child: Text(
                            'MEDICAL ${_now.year}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder<Map<double, double>>(
                            future: getMedicals(),
                            builder: (_, snap) {
                              if (snap.hasData) {
                                if (snap.data != null) {
                                  if (snap.data!.isNotEmpty) {
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
                                              show: true,
                                            ),
                                            belowBarData: BarAreaData(
                                              show: true,
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.red
                                                      .withValues(alpha: 0.3),
                                                  Colors.orange
                                                      .withValues(alpha: 0.3),
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
                                            sideTitles:
                                                SideTitles(showTitles: false),
                                          ),
                                          topTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false),
                                          ),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              interval: 1,
                                              getTitlesWidget:
                                                  bottomTitleWidgetsMedical,
                                            ),
                                          ),
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 100,
                                              getTitlesWidget:
                                                  leftTitleWidgetsMedical,
                                            ),
                                          ),
                                        ),
                                        borderData: FlBorderData(
                                          show: true,
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                        ),
                                        minX: 1,
                                        maxX: 12,
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
        ],
      ),
    );
  }

  Widget summaryInfo() {
    return GetBuilder<KaryawanControl>(
      builder: (_) {
        List<Widget> widgets = [];
        List<Widget> areaWidgets = [];
        Map<String, int> listTotalPerStatusKerja = {};
        for (var opStatus in karyawanControl.listStatusKerja) {
          int nilaiTotal = 0;
          if (karyawanControl
                  .totalKaryawanPerStatuskerjaPerArea[opStatus.label] !=
              null) {
            nilaiTotal = karyawanControl.totalKaryawanPerStatuskerjaPerArea[
                    opStatus.label]!['TOTAL KARYAWAN'] ??
                0;
          }
          listTotalPerStatusKerja[opStatus.label] = nilaiTotal;
          if (nilaiTotal > 0) {
            areaWidgets.add(
              textButton(
                label: opStatus.label,
                area: Opsi(value: '', label: 'SEMUA'),
                statusKerja: opStatus,
              ),
            );
          }
        }
        if (karyawanControl.filterStatusKerja.value == '') {
          areaWidgets.add(
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: textButton(
                label: 'TOTAL KARYAWAN',
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
        for (var opStatus in karyawanControl.listStatusKerja) {
          int nilaiTotal = listTotalPerStatusKerja[opStatus.label] ?? 0;
          if (nilaiTotal > 0) {
            areaWidgets.add(
              Text(
                '= $nilaiTotal',
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            );
          }
        }
        if (karyawanControl.filterStatusKerja.value == '') {
          areaWidgets.add(
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                '= ${karyawanControl.totalKaryawanPerArea['TOTAL KARYAWAN'] ?? 0}',
                style: const TextStyle(
                  fontSize: 13,
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
          int totalKaryawanPerArea =
              karyawanControl.totalKaryawanPerArea[kodeArea] ?? 0;
          if (totalKaryawanPerArea > 0) {
            for (var opStatus in karyawanControl.listStatusKerja) {
              int nilaiTotal = listTotalPerStatusKerja[opStatus.label] ?? 0;
              if (nilaiTotal > 0) {
                int nilai = 0;
                if (karyawanControl
                        .totalKaryawanPerStatuskerjaPerArea[opStatus.label] !=
                    null) {
                  nilai = karyawanControl.totalKaryawanPerStatuskerjaPerArea[
                          opStatus.label]![kodeArea] ??
                      0;
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
            if (karyawanControl.filterStatusKerja.value == '') {
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
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget bottomTitleWidgetsPayroll(double value, TitleMeta meta) {
    String text = mapBulan[value.toInt()] ?? '';

    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget bottomTitleWidgetsOvertime(double value, TitleMeta meta) {
    String text = mapBulan[value.toInt()] ?? '';

    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget bottomTitleWidgetsMedical(double value, TitleMeta meta) {
    String text = mapBulan[value.toInt()] ?? '';

    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget leftTitleWidgetsOvertime(double value, TitleMeta meta) {
    return SideTitleWidget(
      meta: meta,
      child: Text(
        '${AFconvert.matNumberWithDecimal(value)} juta',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget leftTitleWidgetsMedical(double value, TitleMeta meta) {
    return SideTitleWidget(
      meta: meta,
      child: Text(
        '${AFconvert.matNumberWithDecimal(value)} juta',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.red,
        ),
      ),
    );
  }

  final Map<int, String> mapBulan = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'Mei',
    6: 'Jun',
    7: 'Jul',
    8: 'Agu',
    9: 'Sep',
    10: 'Okt',
    11: 'Nov',
    12: 'Des',
  };

}