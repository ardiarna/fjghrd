import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class DemografiView extends StatelessWidget {
  DemografiView({super.key});

  final KaryawanControl karyawanControl = Get.find<KaryawanControl>();

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      getTooltipColor: (group) => Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 0,
      getTooltipItem: (group, groupIndex, rod, rodIndex) {
        return BarTooltipItem(
          rod.toY.toInt().toString(),
          TextStyle(
            color: rod.color,
            fontWeight: FontWeight.bold,
          ),
        );
      }
    ),
  );

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
          Container(
            padding: const EdgeInsets.all(15),
            child: const Text(
              'DEMOGRAFI KARYAWAN',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: kelaminChart()),
                Expanded(child: agamaChart()),
                Expanded(child: kawinChart()),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: pendidikanChart()),
                Expanded(child: usiaChart()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget kelaminChart() {
    List<Map<String, dynamic>> data = [];
    int index = 0;
    final Map<String, Map<String, int>> renamedMap = {
      for (var entry in karyawanControl.totalKaryawanPerKelamin.entries)
        entry.key == 'L'
            ? 'LAKI-LAKI'
            : entry.key == 'P'
              ? 'PEREMPUAN'
              : entry.key: entry.value
    };
    renamedMap.forEach((key, val) {
      data.add({
        'label': key,
        'value': val['TOTAL KARYAWAN'],
        'color': listColor[index % listColor.length],
      });
      index++;
    });
    return boxKonten(
      title: 'JENIS KELAMIN',
      child: GetBuilder<KaryawanControl>(
        builder: (_) {
          return Column(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: data.map((e) => PieChartSectionData(
                        value: (e['value'] as num).toDouble(),
                        color: e['color'] as Color,
                        title: AFconvert.matNumber(e['value']),
                        titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                        ),
                      ),
                    ).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 30,
                children: data
                    .map(
                      (e) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: e['color'] as Color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text('${e['label']}: ${e['value']}',
                            style: TextStyle(color: e['color'] as Color),
                          ),
                    ],
                  ),
                ).toList(),
              ),
              tombolDetil(
                onPressed: () {
                  dialogDetail(title: 'JENIS KELAMIN', data: renamedMap);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget kawinChart() {
    List<Map<String, dynamic>> data = [];
    int index = 0;
    final Map<String, Map<String, int>> renamedMap = {
      for (var entry in karyawanControl.totalKaryawanPerKawin.entries)
        entry.key == 'Y'
            ? 'KAWIN'
            : entry.key == 'N'
              ? 'SINGLE'
              : entry.key == 'P'
                ? 'SINGLE PARENT'
                : entry.key: entry.value
    };
    renamedMap.forEach((key, val) {
      data.add({
        'label': key,
        'value': val['TOTAL KARYAWAN'],
        'color': listColor[index % listColor.length],
      });
      index++;
    });
    return boxKonten(
      title: 'STATUS MENIKAH',
      child: GetBuilder<KaryawanControl>(
        builder: (_) {
          return Column(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: data.map((e) => PieChartSectionData(
                      value: (e['value'] as num).toDouble(),
                      color: e['color'] as Color,
                      title: AFconvert.matNumber(e['value']),
                      titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                      ),
                    ),
                    ).toList(),
                  ),

                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 30,
                children: data
                    .map(
                      (e) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: e['color'] as Color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text('${e['label']}: ${e['value']}',
                        style: TextStyle(color: e['color'] as Color),
                      ),
                    ],
                  ),
                ).toList(),
              ),
              tombolDetil(
                onPressed: () {
                  dialogDetail(title: 'STATUS MENIKAH', data: renamedMap);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget agamaChart() {
    List<Map<String, dynamic>> data = [];
    int index = 0;
    karyawanControl.totalKaryawanPerAgama.forEach((key, val) {
      data.add({
        'label': key,
        'value': val['TOTAL KARYAWAN'],
        'color': listColor[index % listColor.length],
      });
      index++;
    });
    return boxKonten(
      title: 'AGAMA',
      child: GetBuilder<KaryawanControl>(
        builder: (_) {
          return Column(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: data.map((e) => PieChartSectionData(
                      value: (e['value'] as num).toDouble(),
                      color: e['color'] as Color,
                      title: AFconvert.matNumber(e['value']),
                      titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                      ),
                    ),
                    ).toList(),
                  ),

                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 30,
                children: data
                    .map(
                      (e) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: e['color'] as Color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text('${e['label']}: ${e['value']}',
                            style: TextStyle(color: e['color'] as Color),
                          ),
                        ],
                      ),
                ).toList(),
              ),
              tombolDetil(
                onPressed: () {
                  dialogDetail(title: 'AGAMA', data: karyawanControl.totalKaryawanPerAgama);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget pendidikanChart() {
    List<String> labels = [];
    List<double> values = [];
    karyawanControl.totalKaryawanPerPendidikan.forEach((key, val) {
      labels.add(key);
      values.add((val['TOTAL KARYAWAN'] as num).toDouble());
    });
    var bargroups = values.asMap().entries.map((e) {
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: e.value,
            color: listColor[e.key%listColor.length],
            borderRadius: BorderRadius.zero,
            width: 17,
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
    return boxKonten(
      title: 'PENDIDIKAN',
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                barTouchData: barTouchData,
                titlesData: FlTitlesData(
                  // bottomTitles: AxisTitles(
                  //   sideTitles: SideTitles(
                  //     showTitles: true,
                  //     getTitlesWidget: (v, _) {
                  //       return Text(labels[v.toInt()]);
                  //     },
                  //   ),
                  // ),
                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(),
                    left: BorderSide(),
                  ),
                ),
                gridData: const FlGridData(
                  drawVerticalLine: false,
                ),
                barGroups: bargroups,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
            child: Wrap(
              spacing: 30,
              children: values.asMap().entries.map((e){
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: listColor[e.key%listColor.length],
                      ),
                    ),
                    Text('${labels[e.key]}: ${AFconvert.matNumber(e.value)}',
                      style: TextStyle(color: listColor[e.key%listColor.length]),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          tombolDetil(
            onPressed: () {
              dialogDetail(title: 'PENDIDIKAN', data: karyawanControl.totalKaryawanPerPendidikan);
            },
          ),
        ],
      ),
    );
  }

  Widget usiaChart() {
    List<String> orderedKeys = [
      "< 20",
      "20–25",
      "26–30",
      "31–35",
      "36–40",
      "41–45",
      "46–50",
      "51–55",
      "56+",
    ];
    Map<String, Map<String, int>> sortedMap = {
      for (var key in orderedKeys)
        if (karyawanControl.totalKaryawanPerUsia.containsKey(key)) key: karyawanControl.totalKaryawanPerUsia[key]!
    };
    List<String> labels = [];
    List<double> values = [];
    sortedMap.forEach((key, val) {
      labels.add(key);
      values.add((val['TOTAL KARYAWAN'] as num).toDouble());
    });
    var bargroups = values.asMap().entries.map((e) {
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: e.value,
            color: listColor[e.key%listColor.length],
            borderRadius: BorderRadius.zero,
            width: 17,
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
    return boxKonten(
      title: 'USIA',
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                barTouchData: barTouchData,
                titlesData: FlTitlesData(
                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(),
                    left: BorderSide(),
                  ),
                ),
                gridData: const FlGridData(
                  drawVerticalLine: false,
                ),
                barGroups: bargroups,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
            child: Wrap(
              spacing: 30,
              children: values.asMap().entries.map((e){
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: listColor[e.key%listColor.length],
                      ),
                    ),
                    Text('${labels[e.key]}: ${AFconvert.matNumber(e.value)}',
                      style: TextStyle(color: listColor[e.key%listColor.length]),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          tombolDetil(
            onPressed: () {
              dialogDetail(title: 'USIA', data: sortedMap);
            },
          ),
        ],
      ),
    );
  }

  Widget boxKonten({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius:
          const BorderRadius.all(Radius.circular(12)),
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
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Widget tombolDetil({required void Function()? onPressed}) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onPressed,
        child: Text('Lihat detail'),
      ),
    );
  }

  void dialogDetail({
    required String title,
    required Map<String, Map<String, int>> data,
  }) {
    List<Widget> listKolom = [];
    List<Widget> listBaris = [];
    int index = 0;
    data.forEach((key, val){
      listKolom.add(Text(key,
        style: TextStyle(color: listColor[index%listColor.length]),
      ));
      index++;
    });
    listKolom.add(Text('TOTAL KARYAWAN'));
    listBaris.add(Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: listKolom,
        ),
      )
    );
    index = 0;
    listKolom = [];
    int total = 0;
    data.forEach((key, val){
      var nilai = val['TOTAL KARYAWAN'] ?? 0;
      total += nilai;
      listKolom.add(Text('= $nilai',
        style: TextStyle(color: listColor[index%listColor.length]),
      ));
      index++;
    });
    listKolom.add(Text('= $total'));
    listBaris.add(Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 45, 0),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: listKolom,
        ),
      )
    );
    for (var opArea in karyawanControl.listArea) {
      listKolom = [];
      String kodeArea = opArea.data!['kode'];
      int totalKaryawanPerArea = karyawanControl.totalKaryawanPerArea[kodeArea] ?? 0;
      if (totalKaryawanPerArea > 0) {
        int total = 0;
        index = 0;
        data.forEach((key, val){
          var nilai = val[kodeArea] ?? 0;
          total += nilai;
          listKolom.add(Text('$kodeArea: $nilai',
            style: TextStyle(color: listColor[index%listColor.length]),
          ));
          index++;
        });
        listKolom.add(Text('$kodeArea: $total'));
        listBaris.add(Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: listKolom,
            ),
          )
        );
      }
    }
    AFwidget.dialog(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader(title),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 0, 20),
              child: Row(
                children: listBaris,
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

}