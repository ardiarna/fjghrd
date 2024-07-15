import 'package:fjghrd/controllers/payroll_control.dart';
import 'package:fjghrd/models/payroll.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/medical_view.dart';
import 'package:fjghrd/views/oncall_customer_view.dart';
import 'package:fjghrd/views/overtime_view.dart';
import 'package:fjghrd/views/payroll_form.dart';
import 'package:fjghrd/views/potongan_view.dart';
import 'package:fjghrd/views/runpayroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayrollView extends StatelessWidget {
  PayrollView({super.key});

  final PayrollControl controller = Get.put(PayrollControl());

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    controller.loadPayrolls();
    controller.loadKaryawans();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.brown.shade100, width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.brown.shade200, width: 3),
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
              const SizedBox(width: 20),
              tombol(
                label: 'Run Payroll',
                icon: Icons.data_exploration_outlined,
                onPressed: () {
                  controller.homeControl.kontener = RunpayrollView();
                  controller.homeControl.update();
                },
              ),
              tombol(
                label: 'Medical',
                icon: Icons.medical_information_outlined,
                onPressed: () {
                  controller.homeControl.kontener = MedicalView();
                  controller.homeControl.update();
                },
              ),
              tombol(
                label: 'Overtime',
                icon: Icons.punch_clock_outlined,
                onPressed: (){
                  controller.homeControl.kontener = OvertimeView();
                  controller.homeControl.update();
                },
              ),
              tombol(
                label: 'Overtime & On Call Customer',
                icon: Icons.call_missed_outlined,
                onPressed: (){
                  controller.homeControl.kontener = OncallCustomerView();
                  controller.homeControl.update();
                },
              ),
              tombol(
                label: 'Potongan',
                icon: Icons.money_off,
                onPressed: (){
                  controller.homeControl.kontener = PotonganView();
                  controller.homeControl.update();
                },
              ),
              const Spacer(),
              SizedBox(
                width: 200,
                child: GetBuilder<PayrollControl>(
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
                    child: GetBuilder<PayrollControl>(
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
                  Visibility(
                    visible: item.dikunci,
                    child: IconButton(
                      onPressed: () {
                        controller.currentPayroll = item;
                        controller.homeControl.kontener = PayrollForm();
                        controller.homeControl.update();
                      },
                      icon: const Icon(
                        Icons.remove_red_eye,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !item.dikunci,
                    child: IconButton(
                      onPressed: () {
                        controller.currentPayroll = item;
                        controller.homeControl.kontener = PayrollForm(isEdit: true);
                        controller.homeControl.update();
                      },
                      icon: const Icon(
                        Icons.edit_square,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: item.dikunci ? null : () {
                      controller.kunciPayrollForm(
                        id: item.id,
                        periode: '${mapBulan[item.bulan]} ${item.tahun}',
                      );
                    },
                    icon: Icon(
                      item.dikunci ? Icons.lock : Icons.lock_open,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const Text(
                'A. PENGHASILAN',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 7),
              barisKonten(
                label: 'Gaji Pokok',
                value: AFconvert.matNumber(item.gaji),
              ),
              item.kenaikanGaji == 0 ? Container() :
              barisKonten(
                label: 'Kenaikan Gaji',
                value: AFconvert.matNumber(item.kenaikanGaji),
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
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget barisKonten({String label = '', String value = ''}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
      child: Row(
        children: [
          SizedBox(
            width: 230,
            child: Text(label),
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
      ),
    );
  }
}
