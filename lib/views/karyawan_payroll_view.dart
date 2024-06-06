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
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.brown.shade100, width: 0.5),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: Get.back,
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ),
                  iconSize: 25,
                  color: Colors.orange,
                  padding: const EdgeInsets.all(0),
                ),
                const SizedBox(width: 50),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.brown.shade200, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: const Text('PAYROLL',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ),
                const SizedBox(width: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.current.nama,
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    Text('Jabatan : ${controller.current.jabatan.nama}',
                      style: const TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),


                const Spacer(),
                tombol(
                  label: 'Export Excel',
                  icon: Icons.file_open,
                  color: Colors.green,
                  onPressed: () {

                  },
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
                      color: Colors.grey.shade50,
                      child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: controller.listPayroll.map((e) {
                                return boxKonten(e);
                              }).toList(),
                            );
                          }
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
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
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
              const Text(
                'A. PENGHASILAN',
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
              item.thr == 0 ? Container() :
              barisKonten(
                label: 'Tunjangan Hari Raya',
                value: AFconvert.matNumber(item.thr),
              ),
              item.bonus == 0 ? Container() :
              barisKonten(
                label: 'Bonus',
                value: AFconvert.matNumber(item.bonus),
              ),
              item.insentif == 0 ? Container() :
              barisKonten(
                label: 'Insentif',
                value: AFconvert.matNumber(item.insentif),
              ),
              item.telkomsel == 0 ? Container() :
              barisKonten(
                label: 'Telkomsel',
                value: AFconvert.matNumber(item.telkomsel),
              ),
              item.lain == 0 ? Container() :
              barisKonten(
                label: 'Lain-lain',
                value: AFconvert.matNumber(item.lain),
              ),
              const SizedBox(height: 13),
              const Text(
                'B. POTONGAN',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 7),
              barisKonten(
                label: 'Keterlambatan Kehadiran 25%',
                value: AFconvert.matNumber(item.pot25jumlah),
              ),
              item.potTelepon == 0 ? Container() :
              barisKonten(
                label: 'Pemakaian Telepon/Telkomsel',
                value: AFconvert.matNumber(item.potTelepon),
              ),
              item.potKas == 0 ? Container() :
              barisKonten(
                label: 'Pinjaman Kas',
                value: AFconvert.matNumber(item.potKas),
              ),
              item.potCicilan == 0 ? Container() :
              barisKonten(
                label: 'Pinjaman / Cicilan ',
                value: AFconvert.matNumber(item.potCicilan),
              ),
              item.potBpjs == 0 ? Container() :
              barisKonten(
                label: 'BPJS Kesehatan',
                value: AFconvert.matNumber(item.potBpjs),
              ),
              item.potBensin == 0 ? Container() :
              barisKonten(
                label: 'Pemakaian Bensin',
                value: AFconvert.matNumber(item.potBensin),
              ),
              barisKonten(
                label: 'Unpaid Leave / Cuti Bersama',
                value: AFconvert.matNumber(item.potCuti),
              ),
              item.potLain == 0 ? Container() :
              barisKonten(
                label: 'Lain-lain',
                value: AFconvert.matNumber(item.potLain),
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  const SizedBox(
                    width: 230,
                    child: Text(
                      'TOTAL DITERIMA (A-B)',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Text('='),
                  Expanded(
                    child: Text(
                      AFconvert.matNumber(item.totalDiterima),
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
                      child: Text(
                        'BENEFIT LAINNYA',
                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
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
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const SizedBox(
                    width: 230,
                    child: Text(
                      'TOTAL',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Text('='),
                  Expanded(
                    child: Text(
                      AFconvert.matNumber(item.totalDiterima+item.kantorJp+item.kantorJht+item.kantorJkk+item.kantorJkm+item.kantorBpjs+item.pph21),
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

  Widget barisKonten({String label = '', String value = '', TextAlign? textAlign}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
      child: Row(
        children: [
          Container(
            width: 230,
            padding: const EdgeInsets.only(right: 10),
            child: Text(label, textAlign: textAlign),
          ),
          const Text('='),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
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
        backgroundColor: color != null ? (color as MaterialColor).shade50 : null,
      ),
    );
  }
}
