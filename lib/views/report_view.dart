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
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(
              color: Colors.brown.shade100, width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                margin: const EdgeInsets.only(right: 40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    color: Colors.green.shade700,
                ),
                child: const Text('REPORT',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/line-green.png'),
                alignment: Alignment.topLeft,
                repeat: ImageRepeat.noRepeat,
                fit: BoxFit.fill,
                opacity: 0.1,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20, width: 20),
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
                    label: 'REKAP PAYROLL PER KARYAWAN',
                    onPressed: dialogRekapPayroll,
                  ),
                  barisBox(
                    label: 'REKAP PPh 21',
                    onPressed: dialogRekapPPh21,
                  ),
                  barisBox(
                    label: 'SLIP GAJI',
                    onPressed: dialogSlipGaji,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void dialogRekapPayroll() {
    controller.filterJenis = '';
    AFwidget.dialog(
      Container(
        width: 500,
        height: 300,
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
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
              child: Text('Excel Rekap Payroll Per Karyawan ${controller.filterTahun.label}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Divisi'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      builder: (_) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: '1',
                                  groupValue: controller.filterJenis,
                                  onChanged: (a) {
                                    if(a != null && a != controller.filterJenis) {
                                      controller.filterJenis = a;
                                      controller.update();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 130,
                                  child: Text('Engineering'),
                                ),
                                Radio<String>(
                                  value: '3',
                                  groupValue: controller.filterJenis,
                                  onChanged: (a) {
                                    if(a != null && a != controller.filterJenis) {
                                      controller.filterJenis = a;
                                      controller.update();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 130,
                                  child: Text('Non Staf'),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: '2',
                                  groupValue: controller.filterJenis,
                                  onChanged: (a) {
                                    if(a != null && a != controller.filterJenis) {
                                      controller.filterJenis = a;
                                      controller.update();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 130,
                                  child: Text('Staf'),
                                ),
                                Radio<String>(
                                  value: '4',
                                  groupValue: controller.filterJenis,
                                  onChanged: (a) {
                                    if(a != null && a != controller.filterJenis) {
                                      controller.filterJenis = a;
                                      controller.update();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 130,
                                  child: Text('Semua'),
                                ),
                              ],
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
              padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Area'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterArea.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihArea(value: controller.filterArea.value, withSemua: true);
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
                    onPressed: controller.dowloadRekapPayrollPerKaryawan,
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

  void dialogRekapPPh21() {
    controller.filterJenis = '';
    AFwidget.dialog(
      Container(
        width: 500,
        height: 300,
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
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
              child: Text('Excel Rekap PPh21 Tahun ${controller.filterTahun.label}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Divisi'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      builder: (_) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: '1',
                                  groupValue: controller.filterJenis,
                                  onChanged: (a) {
                                    if(a != null && a != controller.filterJenis) {
                                      controller.filterJenis = a;
                                      controller.update();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 130,
                                  child: Text('Engineering'),
                                ),
                                Radio<String>(
                                  value: '3',
                                  groupValue: controller.filterJenis,
                                  onChanged: (a) {
                                    if(a != null && a != controller.filterJenis) {
                                      controller.filterJenis = a;
                                      controller.update();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 130,
                                  child: Text('Non Staf'),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: '2',
                                  groupValue: controller.filterJenis,
                                  onChanged: (a) {
                                    if(a != null && a != controller.filterJenis) {
                                      controller.filterJenis = a;
                                      controller.update();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 130,
                                  child: Text('Staf'),
                                ),
                                Radio<String>(
                                  value: '4',
                                  groupValue: controller.filterJenis,
                                  onChanged: (a) {
                                    if(a != null && a != controller.filterJenis) {
                                      controller.filterJenis = a;
                                      controller.update();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 130,
                                  child: Text('Semua'),
                                ),
                              ],
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
              padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Area'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterArea.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihArea(value: controller.filterArea.value, withSemua: true);
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
                    onPressed: controller.dowloadRekapPPh21,
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

  void dialogSlipGaji() {
    controller.filterJenis = '';
    AFwidget.dialog(
      Container(
        width: 500,
        height: 370,
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
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
              child: Text('Excel Slip Gaji ${controller.filterTahun.label}',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Bulan'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterBulan.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihBulan(value: controller.filterBulan.value);
                            if(a != null && a.value != controller.filterBulan.value) {
                              controller.filterBulan = a;
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
              padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Divisi'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      builder: (_) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: '1',
                                  groupValue: controller.filterJenis,
                                  onChanged: (a) {
                                    if(a != null && a != controller.filterJenis) {
                                      controller.filterJenis = a;
                                      controller.update();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 130,
                                  child: Text('Engineering'),
                                ),
                                Radio<String>(
                                  value: '3',
                                  groupValue: controller.filterJenis,
                                  onChanged: (a) {
                                    if(a != null && a != controller.filterJenis) {
                                      controller.filterJenis = a;
                                      controller.update();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 130,
                                  child: Text('Non Staf'),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio<String>(
                                  value: '2',
                                  groupValue: controller.filterJenis,
                                  onChanged: (a) {
                                    if(a != null && a != controller.filterJenis) {
                                      controller.filterJenis = a;
                                      controller.update();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 130,
                                  child: Text('Staf'),
                                ),
                                Radio<String>(
                                  value: '4',
                                  groupValue: controller.filterJenis,
                                  onChanged: (a) {
                                    if(a != null && a != controller.filterJenis) {
                                      controller.filterJenis = a;
                                      controller.update();
                                    }
                                  },
                                ),
                                const SizedBox(
                                  width: 130,
                                  child: Text('Semua'),
                                ),
                              ],
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
              padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    padding: const EdgeInsets.only(right: 15),
                    child: const Text('Area'),
                  ),
                  Expanded(
                    child: GetBuilder<ReportControl>(
                      builder: (_) {
                        return AFwidget.comboField(
                          value: controller.filterArea.label,
                          label: '',
                          onTap: () async {
                            var a = await controller.pilihArea(value: controller.filterArea.value, withSemua: true);
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
                      controller.downloadSlipGaji();
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
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
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
      child: TextButton(
          onPressed: onPressed,
          child: Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
      ),
    );
  }
}
