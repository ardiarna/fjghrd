import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/models/payroll.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KaryawanPayrollView extends StatelessWidget {
  KaryawanPayrollView({super.key});

  final KaryawanControl controller = Get.put(KaryawanControl());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AFwidget.pageHeader(
          onBack: Get.back,
          title: 'PAYROLL',
          icon: Icons.list_alt_outlined,
          children: [
            const Spacer(),
            const SizedBox(width: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.current.nama,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Jabatan : ${controller.current.jabatan.nama}',
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                tombol(
                  label: 'PDF Slip Gaji',
                  icon: Icons.picture_as_pdf,
                  color: Colors.red,
                  onPressed: dialogPdfSlipGaji,
                ),
                tombol(
                  label: 'Excel Slip Gaji',
                  icon: Icons.receipt_long,
                  color: Colors.greenAccent,
                  onPressed: dialogSlipGaji,
                ),
                tombol(
                  label: 'Excel Payroll',
                  icon: Icons.file_open,
                  color: Colors.greenAccent,
                  onPressed: dialogExcelPayroll,
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 200,
                  child: GetBuilder<KaryawanControl>(
                    builder: (_) {
                      return AFwidget.comboField(
                        value: controller.filterTahun.label,
                        label: '',
                        warna: Colors.brown.shade400,
                        onTap: () async {
                          var a = await controller.pilihTahun(value: controller.filterTahun.value);
                          if(a != null && a.value != controller.filterTahun.value) {
                            controller.filterTahun = a;
                            controller.loadPayrolls();
                          }
                        },
                      );
                    },
                  ),
                ),
          ],
        ),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        image: bgLineBlue,
                      ),
                      child: GetBuilder<KaryawanControl>(
                        builder: (_) {
                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: controller.listPayroll.map((e) {
                              return boxKonten(e);
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget boxKonten(Payroll item) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Container(
          width: 430,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
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
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      child: Text(
                        '${mapBulan[item.bulan]} ${item.tahun}'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('A. PENGHASILAN',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 7),
              barisKonten(
                label: 'Gaji Pokok',
                value: AFconvert.matNumber(item.gaji),
              ),
              barisKonten(
                label: 'U/makan & Transport',
                value: AFconvert.matNumber(item.uangMakanJumlah),
              ),
              barisKonten(
                label: 'Lembur/Overtime',
                value: AFconvert.matNumber(item.overtimeFjg+item.overtimeCus),
              ),
              barisKonten(
                label: 'Reimbursement Medical',
                value: AFconvert.matNumber(item.medical),
              ),
              barisKonten(
                label: 'Tunjangan Hari Raya',
                value: AFconvert.matNumber(item.thr),
              ),
              barisKonten(
                label: 'Bonus',
                value: AFconvert.matNumber(item.bonus),
              ),
              barisKonten(
                label: 'Insentif',
                value: AFconvert.matNumber(item.insentif),
              ),
              barisKonten(
                label: 'Telkomsel',
                value: AFconvert.matNumber(item.telkomsel),
              ),
              barisKonten(
                label: 'Lain-lain',
                value: AFconvert.matNumber(item.lain),
              ),
              barisKonten(
                label: 'Total A',
                value: AFconvert.matNumber(item.gaji+item.uangMakanJumlah+item.overtimeFjg+item.overtimeCus+item.medical+item.thr+item.bonus+item.insentif+item.telkomsel+item.lain),
                withBorder: true,
                color: Colors.grey.shade500,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 13),
              const Text('B. POTONGAN',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 7),
              barisKonten(
                label: 'Keterlambatan Kehadiran 25%',
                value: AFconvert.matNumber(item.pot25jumlah),
              ),
              barisKonten(
                label: 'Pemakaian Telepon/Telkomsel',
                value: AFconvert.matNumber(item.potTelepon),
              ),
              barisKonten(
                label: 'Pinjaman Kas',
                value: AFconvert.matNumber(item.potKas),
              ),
              barisKonten(
                label: 'Pinjaman / Cicilan ',
                value: AFconvert.matNumber(item.potCicilan),
              ),
              barisKonten(
                label: 'BPJS Kesehatan',
                value: AFconvert.matNumber(item.potBpjs),
              ),
              barisKonten(
                label: 'Pemakaian Bensin',
                value: AFconvert.matNumber(item.potBensin),
              ),
              barisKonten(
                label: 'Unpaid Leave / Cuti Bersama',
                value: AFconvert.matNumber(item.potCutiJumlah),
              ),
              barisKonten(
                label: 'Kompensasi Kehadiran (Jam)',
                value: AFconvert.matNumber(item.potKompensasiJumlah),
              ),
              barisKonten(
                label: 'Lain-lain',
                value: AFconvert.matNumber(item.potLain),
              ),
              barisKonten(
                label: 'Total B',
                value: AFconvert.matNumber(item.pot25jumlah+item.potTelepon+item.potKas+item.potCicilan+item.potBpjs+item.potBensin+item.potCutiJumlah+item.potKompensasiJumlah+item.potLain),
                withBorder: true,
                color: Colors.grey.shade500,
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  const SizedBox(
                    width: 230,
                    child: Text('TOTAL DITERIMA (A-B)',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Text('='),
                  Expanded(
                    child: Text(AFconvert.matNumber(item.totalDiterima),
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 23),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                      child: Text('BENEFIT LAINNYA',
                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 7),
                    barisKonten(
                      label: 'JP',
                      value: AFconvert.matNumber(item.kantorJp),
                      textAlign: TextAlign.right,
                    ),
                    barisKonten(
                      label: 'JHT',
                      value: AFconvert.matNumber(item.kantorJht),
                      textAlign: TextAlign.right,
                    ),
                    barisKonten(
                      label: 'JKK',
                      value: AFconvert.matNumber(item.kantorJkk),
                      textAlign: TextAlign.right,
                    ),
                    barisKonten(
                      label: 'JKM',
                      value: AFconvert.matNumber(item.kantorJkm),
                      textAlign: TextAlign.right,
                    ),
                    barisKonten(
                      label: 'BPJS Kesehatan',
                      value: AFconvert.matNumber(item.kantorBpjs),
                      textAlign: TextAlign.right,
                    ),
                    barisKonten(
                      label: 'PPh 21',
                      value: AFconvert.matNumber(item.pph21),
                      textAlign: TextAlign.right,
                    ),
                    barisKonten(
                      label: 'Total Benefit',
                      value: AFconvert.matNumber(item.kantorJp+item.kantorJht+item.kantorJkk+item.kantorJkm+item.kantorBpjs+item.pph21),
                      withBorder: true,
                      color: Colors.grey.shade500,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const SizedBox(
                    width: 230,
                    child: Text('TOTAL',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Text('='),
                  Expanded(
                    child: Text(AFconvert.matNumber(item.totalDiterima+item.kantorJp+item.kantorJht+item.kantorJkk+item.kantorJkm+item.kantorBpjs+item.pph21),
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget barisKonten({
    String label = '',
    String value = '',
    TextAlign? textAlign,
    Color? color,
    bool withBorder = false,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      // margin: const EdgeInsets.only(bottom: 7),
      decoration: withBorder ? BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: color ?? const Color(0xFF000000))),
      ) : null,
      child: Row(
        children: [
          Container(
            width: 230,
            padding: const EdgeInsets.only(right: 10),
            child: Text(label,
              textAlign: textAlign,
              style: TextStyle(
                color: color,
              ),
            ),
          ),
          Text('=',
            style: TextStyle(
              color: color,
            ),
          ),
          Expanded(
            child: Text(value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void dialogExcelPayroll() {
    // Default ke pertahun
    String modePilihan = 'tahun'; // 'tahun' atau 'periode'

    AFwidget.dialog(
      StatefulBuilder(
        builder: (ctx, setStateDialog) {
          return Container(
            width: 520,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AFwidget.formHeader('Excel Payroll ${controller.current.nama}'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pilihan mode
                      RadioGroup<String>(
                        groupValue: modePilihan,
                        onChanged: (val) {
                          if (val != null) {
                            setStateDialog(() { modePilihan = val; });
                          }
                        },
                        child: Row(
                          children: const [
                            Radio<String>(
                              value: 'tahun',
                            ),
                            Text('Per Tahun', style: TextStyle(fontWeight: FontWeight.w600)),
                            SizedBox(width: 30),
                            Radio<String>(
                              value: 'periode',
                            ),
                            Text('Per Periode', style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Konten berdasarkan pilihan
                      if(modePilihan == 'tahun') ...[
                        Row(
                          children: [
                            const Text('Tahun : ', style: TextStyle(fontWeight: FontWeight.w500)),
                            const SizedBox(width: 10),
                            GetBuilder<KaryawanControl>(
                              builder: (_) {
                                return SizedBox(
                                  width: 150,
                                  child: AFwidget.comboField(
                                    value: controller.filterTahun.label,
                                    label: '',
                                    warna: Colors.brown.shade400,
                                    onTap: () async {
                                      var a = await controller.pilihTahun(value: controller.filterTahun.value);
                                      if(a != null && a.value != controller.filterTahun.value) {
                                        controller.filterTahun = a;
                                        controller.loadPayrolls();
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ] else ...[
                        // Mode Per Periode - 2 baris: Awal dan Akhir
                        GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return Column(
                              children: [
                                // Baris Awal
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 60,
                                      child: Text('Dari :', style: TextStyle(fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 160,
                                      child: AFwidget.comboField(
                                        value: controller.payrollBulanAwal.label,
                                        label: 'Bulan',
                                        warna: Colors.indigo.shade300,
                                        onTap: () async {
                                          var a = await controller.pilihBulan(value: controller.payrollBulanAwal.value);
                                          if(a != null) {
                                            controller.payrollBulanAwal = a;
                                            controller.update();
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 110,
                                      child: AFwidget.comboField(
                                        value: controller.payrollTahunAwal.label,
                                        label: 'Tahun',
                                        warna: Colors.brown.shade400,
                                        onTap: () async {
                                          var a = await controller.pilihTahun(value: controller.payrollTahunAwal.value);
                                          if(a != null) {
                                            controller.payrollTahunAwal = a;
                                            controller.update();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Baris Akhir
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 60,
                                      child: Text('S/D :', style: TextStyle(fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 160,
                                      child: AFwidget.comboField(
                                        value: controller.payrollBulanAkhir.label,
                                        label: 'Bulan',
                                        warna: Colors.indigo.shade300,
                                        onTap: () async {
                                          var a = await controller.pilihBulan(value: controller.payrollBulanAkhir.value);
                                          if(a != null) {
                                            controller.payrollBulanAkhir = a;
                                            controller.update();
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 110,
                                      child: AFwidget.comboField(
                                        value: controller.payrollTahunAkhir.label,
                                        label: 'Tahun',
                                        warna: Colors.brown.shade400,
                                        onTap: () async {
                                          var a = await controller.pilihTahun(value: controller.payrollTahunAkhir.value);
                                          if(a != null) {
                                            controller.payrollTahunAkhir = a;
                                            controller.update();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],

                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AFwidget.tombol(
                            label: 'Batal',
                            color: Colors.orange,
                            onPressed: Get.back,
                            minimumSize: const Size(120, 40),
                          ),
                          const SizedBox(width: 30),
                          AFwidget.tombol(
                            label: 'Download',
                            color: Colors.green,
                            onPressed: () {
                              Get.back();
                              if(modePilihan == 'tahun') {
                                controller.dowloadPayroll();
                              } else {
                                controller.dowloadPayrollPeriode();
                              }
                            },
                            minimumSize: const Size(120, 40),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void dialogSlipGaji() {
    AFwidget.dialog(
      Container(
        width: 500,
        height: 370,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AFwidget.formHeader('Excel Slip Gaji ${controller.filterTahun.label}'),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 15, 42, 20),
              child: Row(
                children: [
                  Text('Silakan pilih bulan :'),
                  const Spacer(),
                  GetBuilder<KaryawanControl>(
                    builder: (_) {
                      return Checkbox(
                        value: controller.bulanTerpilih.values.every((v) => v),
                        onChanged: (value) {
                          if (value != null) {
                            controller.bulanTerpilih.updateAll((key, val) => value);
                            controller.update();
                          }
                        },
                      );
                    },
                  ),
                  const Text("pilih semua"),
                ],
              ),
            ),
            GetBuilder<KaryawanControl>(
              builder: (_) {
                return SizedBox(
                  height: 150,
                  width: 500,
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 5,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    padding: const EdgeInsets.only(left: 10),
                    children: controller.bulanTerpilih.entries.map((el) {
                      return Row(
                        children: [
                          Checkbox(
                            value: el.value,
                            onChanged: (value) {
                              if(value != null) {
                                controller.bulanTerpilih[el.key] = value;
                                controller.update();
                              }
                            },
                          ),
                          Text(mapBulan[el.key]!),
                        ],
                      );
                    }).toList(),
                  ),
                );
              }
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 25, 30, 0),
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

  void dialogPdfSlipGaji() {
    AFwidget.dialog(
      Container(
        width: 500,
        height: 370,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AFwidget.formHeader('PDF Slip Gaji ${controller.filterTahun.label}'),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 15, 42, 20),
              child: Row(
                children: [
                  Text('Silakan pilih bulan :'),
                  const Spacer(),
                  GetBuilder<KaryawanControl>(
                    builder: (_) {
                      return Checkbox(
                        value: controller.bulanTerpilih.values.every((v) => v),
                        onChanged: (value) {
                          if (value != null) {
                            controller.bulanTerpilih.updateAll((key, val) => value);
                            controller.update();
                          }
                        },
                      );
                    },
                  ),
                  const Text("pilih semua"),
                ],
              ),
            ),
            GetBuilder<KaryawanControl>(
              builder: (_) {
                return SizedBox(
                  height: 150,
                  width: 500,
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 5,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    padding: const EdgeInsets.only(left: 10),
                    children: controller.bulanTerpilih.entries.map((el) {
                      return Row(
                        children: [
                          Checkbox(
                            value: el.value,
                            onChanged: (value) {
                              if(value != null) {
                                controller.bulanTerpilih[el.key] = value;
                                controller.update();
                              }
                            },
                          ),
                          Text(mapBulan[el.key]!),
                        ],
                      );
                    }).toList(),
                  ),
                );
              }
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 25, 30, 0),
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
                    label: 'Download PDF',
                    color: Colors.red,
                    onPressed: () {
                      Get.back();
                      controller.downloadPdfSlipGaji();
                    },
                    minimumSize: const Size(140, 40),
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

  Widget tombol({
    required String label,
    required IconData? icon,
    required void Function()? onPressed,
    Color? color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(100, 70),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        foregroundColor: color,
        backgroundColor: color?.withValues(alpha: 0.1),
      ),
    );
  }
}
