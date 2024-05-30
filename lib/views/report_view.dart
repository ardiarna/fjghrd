import 'package:fjghrd/controllers/report_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportView extends StatelessWidget {
  ReportView({super.key});

  final ReportControl controller = Get.put(ReportControl());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: const BoxDecoration(
            color: Colors.green,
          ),
          child: Row(
            children: [
              const Text('REPORT',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 200,
                child: GetBuilder<ReportControl>(
                  builder: (_) {
                    return AFwidget.comboField(
                      value: controller.filterTahun.label,
                      label: '',
                      warna: Colors.white,
                      onTap: () async {
                        var a = await controller.pilihTahun(value: controller.filterTahun.value);
                        if(a != null && a.value != controller.filterTahun.value) {
                          controller.filterTahun = a;
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
        Expanded(
          child: Container(
            color: Colors.white,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                barisBox(
                  label: 'LIST PAYROLL',
                  onPressed: controller.dowloadListpayroll,
                ),
                barisBox(
                  label: 'REKAP GAJI',
                  onPressed: controller.dowloadRekapPayroll,
                ),
                barisBox(
                  label: 'REKAP MEDICAL',
                  onPressed: controller.dowloadRekapMedical,
                ),
                barisBox(
                  label: 'REKAP OVERTIME',
                  onPressed: controller.dowloadRekapOvertime,
                ),
                barisBox(
                  label: 'REKAP PAYROLL PER KARYAWAN DIVISI ENGINEERING',
                  onPressed: () {
                    areaDialog('1');
                  },
                ),
                barisBox(
                  label: 'REKAP PAYROLL PER KARYAWAN DIVISI STAF',
                  onPressed: () {
                    areaDialog('2');
                  },
                ),
                barisBox(
                  label: 'REKAP PAYROLL PER KARYAWAN DIVISI NON STAF',
                  onPressed: controller.dowloadRekapPayrollPerKaryawanNonStaf,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void areaDialog(String jenis) {
    AFwidget.dialog(
      Container(
        width: 500,
        height: 200,
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            Container(
              height: 65,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                ),
              ),
              child: Text(jenis == '1' ? 'DIVISI ENGINEERING' : jenis == '2' ? 'DIVISI STAF' : '',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              children: [
                const Text('Area   :   '),
                Expanded(
                  child: GetBuilder<ReportControl>(
                    builder: (_) {
                      return AFwidget.comboField(
                        value: controller.filterArea.label,
                        label: '',
                        onTap: () async {
                          var a = await controller.pilihArea(value: controller.filterArea.value);
                          if(a != null && a.value != controller.filterArea.value) {
                            controller.filterArea = a;
                            controller.update();
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 25, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AFwidget.tombol(
                    label: 'Batal',
                    color: Colors.orange,
                    onPressed: Get.back,
                    minimumSize: const Size(120, 40),
                  ),
                  const SizedBox(width: 40),
                  AFwidget.tombol(
                    label: 'Download',
                    color: Colors.green,
                    onPressed: () {
                      Get.back();
                      controller.dowloadRekapPayrollPerKaryawanStaf(jenis);
                    },
                    minimumSize: const Size(120, 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  Widget barisBox({
    required String label,
    required Function()? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextButton(
          onPressed: onPressed,
          child: Text(label),
      ),
    );
  }
}
