import 'package:fjghrd/controllers/payroll_control.dart';
import 'package:fjghrd/models/payroll.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/payroll_form.dart';
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
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: [
              const Text('PAYROLL',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: (){
                  controller.homeControl.kontener = RunpayrollView();
                  controller.homeControl.update();
                },
                icon: const Icon(Icons.data_exploration_outlined),
                label: const Text('Run Payroll'),
              ),
              const Spacer(),
              SizedBox(
                width: 200,
                child: GetBuilder<PayrollControl>(
                  builder: (_) {
                    return AFwidget.comboField(
                      value: controller.filterTahun.label,
                      label: '',
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
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !item.dikunci,
                    child: IconButton(
                      onPressed: () {
                        controller.currentPayroll = item;
                        controller.homeControl.kontener = PayrollForm();
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
}
