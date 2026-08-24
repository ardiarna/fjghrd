import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/views/cuti_form_view.dart';

class CutiMenuView extends StatelessWidget {
  CutiMenuView({super.key});

  final HomeControl homeControl = Get.find<HomeControl>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
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
              const Icon(Icons.beach_access_outlined, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              const Text('Menu Cuti',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildMenuItem(context, 'Form Cuti', Icons.flight_takeoff, 'CUTI'),
                _buildMenuItem(context, 'Form Ijin', Icons.assignment_late, 'IJIN'),
                _buildMenuItem(context, 'Form Cuti Masal', Icons.groups, 'CUTI_MASAL'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, String type) {
    return InkWell(
      onTap: () {
        if(type == 'CUTI_MASAL') {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Belum tersedia.')));
            return;
        }
        homeControl.kontener = CutiFormView(formType: type);
        homeControl.update();
      },
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 50, color: Colors.blueGrey),
            const SizedBox(height: 15),
            Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
