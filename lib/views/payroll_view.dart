import 'package:fjghrd/controllers/payroll_control.dart';
import 'package:fjghrd/views/runpayroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayrollView extends StatelessWidget {
  PayrollView({super.key});

  final PayrollControl controller = Get.put(PayrollControl());

  @override
  Widget build(BuildContext context) {
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
            ],
          ),
        ),
      ],
    );
  }
}
