import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/repositories/cuti_repository.dart';
import 'package:fjghrd/repositories/payroll_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/demografi_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BerandaView extends StatelessWidget {
  BerandaView({super.key});

  final KaryawanControl karyawanControl = Get.put(KaryawanControl());
  final HomeControl homeControl = Get.find<HomeControl>();

  final _now = DateTime.now();

  Future<List<Map<String, dynamic>>> getCutiHariIni() async {
    List<Map<String, dynamic>> list = [];
    final CutiRepository cutiRepo = CutiRepository();
    var hasil = await cutiRepo.fetchHariIni(tanggal: AFconvert.matYMD(_now));
    if (hasil.success) {
      var sourceList = hasil.daftar.isNotEmpty
          ? hasil.daftar
          : (hasil.data['data'] is List ? (hasil.data['data'] as List) : []);
      for (var item in sourceList) {
        if (item is Map) {
          list.add(Map<String, dynamic>.from(item));
        }
      }
    }
    return list;
  }

  Future<Map<int, double>> getPayrolls() async {
    Map<int, double> rekap = {};
    final PayrollRepository payrollRepo = PayrollRepository();
    var hasil = await payrollRepo.reportRekap(tahun: _now.year.toString());
    if (hasil.success) {
      var data = hasil.data;
      (data['payrolls'] as Map).forEach((key, value) {
        rekap[AFconvert.keInt(key)] = AFconvert.keDouble(value) / 1000000;
      });
    }
    return rekap;
  }

  Future<Map<double, double>> getOvertimes() async {
    Map<double, double> rekap = {};
    final PayrollRepository payrollRepo = PayrollRepository();
    var hasil = await payrollRepo.reportRekap(tahun: _now.year.toString());
    if (hasil.success) {
      var data = hasil.data;
      (data['overtimes'] as Map).forEach((key, value) {
        rekap[AFconvert.keDouble(key)] = AFconvert.keDouble(value) / 1000000;
      });
    }
    return rekap;
  }

  Future<Map<double, double>> getMedicals() async {
    Map<double, double> rekap = {};
    final PayrollRepository payrollRepo = PayrollRepository();
    var hasil = await payrollRepo.reportRekap(tahun: _now.year.toString());
    if (hasil.success) {
      var data = hasil.data;
      (data['medicals'] as Map).forEach((key, value) {
        rekap[AFconvert.keDouble(key)] = AFconvert.keDouble(value) / 1000000;
      });
    }
    return rekap;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF334155), Color(0xFF475569)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.home_outlined, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              const Text(
                'BERANDA',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Image.asset('assets/images/logo_white.png', height: 40),
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              image: bgLineBlue,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: IntrinsicHeight(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            homeControl.tabId = 0;
                                            homeControl.kontener =
                                                DemografiView();
                                            homeControl.update();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors
                                                .black, // Warna latar tombol
                                            foregroundColor:
                                                Colors.white, // Warna teks
                                          ),
                                          child: const Text(
                                              'LIHAT DEMOGRAFI KARYAWAN'),
                                        ),
                                        FutureBuilder<
                                            List<Map<String, dynamic>>>(
                                          future: getCutiHariIni(),
                                          builder: (_, snap) {
                                            bool isLoading =
                                                snap.connectionState ==
                                                    ConnectionState.waiting;
                                            List<Map<String, dynamic>>
                                                listCuti = snap.data ?? [];

                                            return Container(
                                              width: double.infinity,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                                vertical: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withValues(alpha: 0.7),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(15)),
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'KARYAWAN CUTI HARI INI: ',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors
                                                              .blue.shade300,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      if (!isLoading)
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 2),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: listCuti
                                                                    .isNotEmpty
                                                                ? Colors.blue
                                                                    .shade100
                                                                : Colors.grey
                                                                    .shade200,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Text(
                                                            '${listCuti.length} Karyawan',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: listCuti
                                                                      .isNotEmpty
                                                                  ? Colors.blue
                                                                      .shade800
                                                                  : Colors.grey
                                                                      .shade700,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  if (isLoading)
                                                    const Center(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                                vertical: 4),
                                                        child: SizedBox(
                                                          width: 18,
                                                          height: 18,
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  else if (listCuti.isEmpty)
                                                    Text(
                                                      'Tidak ada yang mengambil cuti hari ini',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    )
                                                  else
                                                    Wrap(
                                                      spacing: 15,
                                                      runSpacing: 4,
                                                      children:
                                                          listCuti.map((e) {
                                                        String label =
                                                            '🏖️ ${e['nama']}';
                                                        String kat =
                                                            e['kategori']
                                                                    ?.toString() ??
                                                                '';
                                                        if (kat.isNotEmpty) {
                                                          label += ' ($kat)';
                                                        }
                                                        return Text(
                                                          label,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .blue.shade600,
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        GetBuilder<KaryawanControl>(
                                          id: 'beranda',
                                          builder: (_) {
                                            return Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                                vertical: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withValues(alpha: 0.7),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(15)),
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'BERULANG TAHUN HARI INI: ',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors
                                                              .green.shade300,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      if (!karyawanControl
                                                          .isLoadingKaryawan)
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 2),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: karyawanControl
                                                                    .listUlangTahun
                                                                    .isNotEmpty
                                                                ? Colors.green
                                                                    .shade100
                                                                : Colors.grey
                                                                    .shade200,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Text(
                                                            '${karyawanControl.listUlangTahun.length} Karyawan',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: karyawanControl
                                                                      .listUlangTahun
                                                                      .isNotEmpty
                                                                  ? Colors.green
                                                                      .shade800
                                                                  : Colors.grey
                                                                      .shade700,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  if (karyawanControl
                                                      .isLoadingKaryawan)
                                                    const Center(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                                vertical: 4),
                                                        child: SizedBox(
                                                          width: 18,
                                                          height: 18,
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  else if (karyawanControl
                                                      .listUlangTahun.isEmpty)
                                                    Text(
                                                      'Tidak ada yang berulang tahun hari ini',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color:
                                                            Colors.grey.shade600,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    )
                                                  else
                                                    Wrap(
                                                      spacing: 15,
                                                      runSpacing: 4,
                                                      children: karyawanControl
                                                          .listUlangTahun
                                                          .map((e) {
                                                        return Text(
                                                          '🎂${e.nama} (${AFconvert.matDate(e.tanggalLahir)})',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors
                                                                .green.shade500,
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
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 30),
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
                                          var spots =
                                              snap.data!.entries.map((e) {
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
                                                        Colors.green.withValues(
                                                            alpha: 0.3),
                                                        Colors.green.withValues(
                                                            alpha: 0.1),
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
                                                  sideTitles: SideTitles(
                                                      showTitles: false),
                                                ),
                                                topTitles: const AxisTitles(
                                                  sideTitles: SideTitles(
                                                      showTitles: false),
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
                                                    color:
                                                        Colors.grey.shade300),
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
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 30),
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
                                          var barGroups =
                                              snap.data!.entries.map((e) {
                                            return BarChartGroupData(
                                              x: e.key,
                                              barRods: [
                                                BarChartRodData(
                                                  toY: e.value,
                                                  color: Colors.blue,
                                                  width: 12,
                                                  borderRadius:
                                                      BorderRadius.zero,
                                                )
                                              ],
                                            );
                                          }).toList();
                                          return Column(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 0, 10, 0),
                                                  child: BarChart(
                                                    BarChartData(
                                                      barGroups: barGroups,
                                                      gridData:
                                                          const FlGridData(
                                                        drawVerticalLine: false,
                                                        // horizontalInterval: 1,
                                                        // verticalInterval: 1,
                                                      ),
                                                      titlesData: FlTitlesData(
                                                        show: true,
                                                        rightTitles:
                                                            const AxisTitles(
                                                          sideTitles:
                                                              SideTitles(
                                                                  showTitles:
                                                                      false),
                                                        ),
                                                        topTitles:
                                                            const AxisTitles(
                                                          sideTitles:
                                                              SideTitles(
                                                                  showTitles:
                                                                      false),
                                                        ),
                                                        bottomTitles:
                                                            AxisTitles(
                                                          sideTitles:
                                                              SideTitles(
                                                            showTitles: true,
                                                            interval: 1,
                                                            getTitlesWidget:
                                                                bottomTitleWidgetsPayroll,
                                                          ),
                                                        ),
                                                        leftTitles: AxisTitles(
                                                          sideTitles:
                                                              SideTitles(
                                                            showTitles: false,
                                                            reservedSize: 100,
                                                          ),
                                                        ),
                                                      ),
                                                      borderData: FlBorderData(
                                                        show: true,
                                                        border: const Border(
                                                          bottom: BorderSide(
                                                            color: Colors
                                                                .lightBlue,
                                                            width: 0.5,
                                                          ),
                                                          left: BorderSide(
                                                            color: Colors
                                                                .lightBlue,
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
                                                children: snap.data!.entries
                                                    .map((entry) {
                                                  return Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: 5,
                                                        height: 5,
                                                        margin: const EdgeInsets
                                                            .only(right: 3),
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${mapBulan[entry.key]} : ${AFconvert.matNumber(entry.value * 1000000)}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 30),
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
                                          var spots =
                                              snap.data!.entries.map((e) {
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
                                                        Colors.red.withValues(
                                                            alpha: 0.3),
                                                        Colors.orange
                                                            .withValues(
                                                                alpha: 0.3),
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
                                                  sideTitles: SideTitles(
                                                      showTitles: false),
                                                ),
                                                topTitles: const AxisTitles(
                                                  sideTitles: SideTitles(
                                                      showTitles: false),
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
                                                    color:
                                                        Colors.grey.shade300),
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
          ),
        ),
      ],
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
