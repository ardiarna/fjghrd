import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/agama_view.dart';
import 'package:fjghrd/views/area_view.dart';
import 'package:fjghrd/views/divisi_view.dart';
import 'package:fjghrd/views/hari_libur_view.dart';
import 'package:fjghrd/views/jabatan_view.dart';
import 'package:fjghrd/views/pendidikan_view.dart';
import 'package:fjghrd/views/status_kerja_view.dart';
import 'package:fjghrd/views/status_phk_view.dart';
import 'package:fjghrd/views/upah_view.dart';
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
                    label: 'Laporan',
                    icon: Icons.analytics_outlined,
                    idx: 3,
                  ),
                  barItem(
                    label: 'Menu',
                    icon: Icons.dehaze,
                    idx: 4,
                  ),
                ],
              );
            }
        ),
      ),
      endDrawer: Drawer(
        width: 250,
        child: Column(
          children: [
            Expanded(
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
                  drawItem(
                    label: 'Hari Libur',
                    icon: Icons.calendar_month,
                    color: Colors.brown,
                    onTap: () {
                      controller.tabId = 3;
                      controller.kontener = HariLiburView();
                      Get.back();
                      controller.update();
                    },
                  ),
                  drawItem(
                    label: 'Salary',
                    icon: Icons.attach_money,
                    color: Colors.brown,
                    onTap: () {
                      controller.tabId = 3;
                      controller.kontener = UpahView();
                      Get.back();
                      controller.update();
                    },
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.red,
              child: drawItem(
                label: 'Keluar',
                icon: Icons.logout_outlined,
                color: Colors.white,
                onTap: () {
                  AFwidget.dialog(
                    Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Apakah Kamu Yakin?',
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              const Padding(
                                padding: EdgeInsets.only(top: 15, bottom: 20),
                                child: Text(
                                    'Ingin keluar dari aplikasi HRD Fratekindo?'),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: AFwidget.tombol(
                                      label: 'BATAL',
                                      color: Colors.orangeAccent,
                                      onPressed: () {
                                        Get.back();
                                      },
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.only(right: 10)),
                                  Expanded(
                                    child: AFwidget.tombol(
                                      label: 'YA',
                                      color: Colors.red,
                                      onPressed: () {
                                        Get.back();
                                        controller.authControl.sessionEnd();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          height: 5,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(7),
                              topLeft: Radius.circular(7),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child: const Icon(Icons.logout_rounded,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.all(0),
                    backgroundColor: Colors.transparent,
                  );
                },
              ),
            )
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
