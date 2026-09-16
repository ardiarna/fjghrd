import 'package:fjghrd/controllers/payroll_control.dart';
import 'package:fjghrd/models/payroll.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/medical_view.dart';
import 'package:fjghrd/views/oncall_customer_view.dart';
import 'package:fjghrd/views/overtime_view.dart';
import 'package:fjghrd/views/payroll_form.dart';
import 'package:fjghrd/views/penghasilan_view.dart';
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
              const Icon(Icons.assignment_outlined, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              const Text('PAYROLL',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20),
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
                label: 'Penghasilan',
                icon: Icons.attach_money,
                onPressed: (){
                  controller.homeControl.kontener = PenghasilanView();
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
              tombol(
                label: 'Overtime & On Call Customer',
                icon: Icons.call_missed_outlined,
                onPressed: (){
                  controller.homeControl.kontener = OncallCustomerView();
                  controller.homeControl.update();
                },
              ),
              tombol(
                label: 'Run Payroll',
                icon: Icons.data_exploration_outlined,
                onPressed: () {
                  controller.homeControl.kontener = RunpayrollView();
                  controller.homeControl.update();
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: 200,
                  child: GetBuilder<PayrollControl>(
                    id: 'filter_payroll',
                    builder: (_) {
                      return AFwidget.comboField(
                        value: controller.filterTahun.label,
                        label: '',
                        warna: Colors.white,
                        warnaBackground: Colors.white.withValues(alpha: 0.1),
                        onTap: () async {
                          var a = await controller.pilihTahun(value: controller.filterTahun.value);
                          if(a != null && a.value != controller.filterTahun.value) {
                            controller.filterTahun = a;
                            controller.update(['filter_payroll']);
                            controller.loadPayrolls();
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: bgLineBlue,
            ),
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
                      child: Obx(() {
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
        ),
      ],
    );
  }

  Widget boxKonten(Payroll item) {
    int totalA = item.gaji + item.kenaikanGaji + item.uangMakanJumlah + item.overtimeFjg + item.overtimeCus + item.medical + item.thr + item.bonus + item.insentif + item.telkomsel + item.lain;
    int totalB = item.pot25jumlah + item.potTelepon + item.potKas + item.potCicilan + item.potBpjs + item.potBensin + item.potCutiJumlah + item.potKompensasiJumlah + item.potLain;
    int totalDiterimaCalc = totalA - totalB;
    return Container(
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
                  AFwidget.formWarning(
                    label: 'Anda akan mengunci data payroll untuk periode ${mapBulan[item.bulan]} ${item.tahun}, pastikan Anda telah memeriksa dan memvalidasi keakuratan data. Lanjutkan untuk mengunci data?',
                    ikon: Icons.lock_outline,
                    warna: Colors.red,
                    isKonfirmasi: true,
                    aksi: () {
                      controller.kunciPayrollData(item.id);
                    },
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
          barisKonten(
            label: 'Lain-lain',
            value: AFconvert.matNumber(item.lain),
          ),
          barisKonten(
            label: 'Total A',
            value: AFconvert.matNumber(totalA),
            withBorder: true,
            color: Colors.grey.shade500,
            textAlign: TextAlign.right,
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
            value: AFconvert.matNumber(totalB),
            withBorder: true,
            color: Colors.grey.shade500,
            textAlign: TextAlign.right,
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
                  AFconvert.matNumber(totalDiterimaCalc),
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          )
        ],
      ),
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

  Widget tombol({
    required String label,
    required IconData? icon,
    required void Function()? onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 45),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.white.withValues(alpha: 0.1),
          elevation: 0,
        ),
      ),
    );
  }
}
