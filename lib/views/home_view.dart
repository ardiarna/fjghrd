import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/views/agama_view.dart';
import 'package:fjghrd/views/area_view.dart';
import 'package:fjghrd/views/divisi_view.dart';
import 'package:fjghrd/views/jabatan_view.dart';
import 'package:fjghrd/views/pendidikan_view.dart';
import 'package:fjghrd/views/status_kerja_view.dart';
import 'package:fjghrd/views/status_phk_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeControl controller = Get.put(HomeControl());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: Colors.grey[200],
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: GetBuilder<HomeControl>(
            builder: (_) {
              return controller.kontener;
            }
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: GetBuilder<HomeControl>(
            builder: (_) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  barItem(
                    label: 'Beranda',
                    icon: Icons.home_outlined,
                    idx: 0,
                  ),
                  barItem(
                    label: 'Karyawan',
                    icon: Icons.supervisor_account,
                    idx: 1,
                  ),
                  barItem(
                    label: 'Payroll',
                    icon: Icons.assignment_outlined,
                    idx: 2,
                  ),
                  barItem(
                    label: 'Setting',
                    icon: Icons.settings,
                    idx: 3,
                  ),
                  barItem(
                    label: 'Keluar',
                    icon: Icons.logout,
                    idx: 99,
                    warna: Colors.red,
                  ),
                ],
              );
            }
        ),
      ),
      endDrawer: Drawer(
        width: 250,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 20),
            drawItem(
              label: 'Area',
              icon: Icons.maps_home_work_outlined,
              color: Colors.brown,
              onTap: () {
                controller.tabId = 3;
                controller.kontener = AreaView();
                Get.back();
                controller.update();
              },
            ),
            drawItem(
              label: 'Divisi',
              icon: Icons.dataset_linked_outlined,
              color: Colors.brown,
              onTap: () {
                controller.tabId = 3;
                controller.kontener = DivisiView();
                Get.back();
                controller.update();
              },
            ),
            drawItem(
              label: 'Jabatan',
              icon: Icons.chair_alt_outlined,
              color: Colors.brown,
              onTap: () {
                controller.tabId = 3;
                controller.kontener = JabatanView();
                Get.back();
                controller.update();
              },
            ),
            drawItem(
              label: 'Agama',
              icon: Icons.mosque_outlined,
              color: Colors.brown,
              onTap: () {
                controller.tabId = 3;
                controller.kontener = AgamaView();
                Get.back();
                controller.update();
              },
            ),
            drawItem(
              label: 'Pendidikan',
              icon: Icons.school_outlined,
              color: Colors.brown,
              onTap: () {
                controller.tabId = 3;
                controller.kontener = PendidikanView();
                Get.back();
                controller.update();
              },
            ),
            drawItem(
              label: 'Status Karyawan',
              icon: Icons.arrow_drop_down_circle_outlined,
              color: Colors.brown,
              onTap: () {
                controller.tabId = 3;
                controller.kontener = StatusKerjaView();
                Get.back();
                controller.update();
              },
            ),
            drawItem(
              label: 'Status PHK',
              icon: Icons.arrow_drop_down_circle_outlined,
              color: Colors.brown,
              onTap: () {
                controller.tabId = 3;
                controller.kontener = StatusPhkView();
                Get.back();
                controller.update();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget barItem({required String label, required IconData icon, required int idx, Color? warna}) {
    Color color = controller.tabId == idx ? Colors.brown : warna ?? Colors.grey;
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
      height: 50,
      decoration: BoxDecoration(
        color: controller.tabId == idx ? Colors.brown.withOpacity(0.1) : Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: GestureDetector(
        onTap: () {
          controller.pindahTab(idx);
        },
        child: Column(
          children: [
            Icon(icon, color: color),
            Text(label, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }

  Widget drawItem({
    required String label,
    required IconData icon,
    Color? color,
    void Function()? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, size: 21, color: color),
        title: Text(label, style: TextStyle(color: color)),
        trailing: Icon(Icons.keyboard_arrow_right, color: color),
        onTap: onTap,
      ),
    );
  }

}
