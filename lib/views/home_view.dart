import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/agama_view.dart';
import 'package:fjghrd/views/area_view.dart';
import 'package:fjghrd/views/beranda_view.dart';
import 'package:fjghrd/views/customer_view.dart';
import 'package:fjghrd/views/divisi_view.dart';
import 'package:fjghrd/views/hari_libur_view.dart';
import 'package:fjghrd/views/jabatan_view.dart';
import 'package:fjghrd/views/pendidikan_view.dart';
import 'package:fjghrd/views/ptkp_view.dart';
import 'package:fjghrd/views/status_kerja_view.dart';
import 'package:fjghrd/views/status_phk_view.dart';
import 'package:fjghrd/views/tarif_efektif_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeControl controller = Get.put(HomeControl());

  @override
  Widget build(BuildContext context) {
    controller.kontener = BerandaView();
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: Colors.grey.shade50,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: GetBuilder<HomeControl>(
            builder: (_) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutQuad,
                switchOutCurve: Curves.easeInQuad,
                child: KeyedSubtree(
                  key: ValueKey(controller.tabId),
                  child: controller.kontener,
                ),
              );
            }
        ),
      ),
      bottomNavigationBar: GetBuilder<HomeControl>(
        builder: (_) {
          return NavigationBar(
            selectedIndex: controller.tabId > 4 ? 0 : controller.tabId,
            onDestinationSelected: (idx) {
              if (idx == 4) {
                 controller.scaffoldKey.currentState?.openEndDrawer();
              } else {
                 controller.pindahTab(idx);
              }
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Beranda',
              ),
              NavigationDestination(
                icon: Icon(Icons.supervisor_account_outlined),
                selectedIcon: Icon(Icons.supervisor_account),
                label: 'Karyawan',
              ),
              NavigationDestination(
                icon: Icon(Icons.assignment_outlined),
                selectedIcon: Icon(Icons.assignment),
                label: 'Payroll',
              ),
              NavigationDestination(
                icon: Icon(Icons.analytics_outlined),
                selectedIcon: Icon(Icons.analytics),
                label: 'Laporan',
              ),
              NavigationDestination(
                icon: Icon(Icons.dehaze),
                label: 'Menu',
              ),
            ],
          );
        }
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
                    color: Colors.blueGrey,
                    onTap: () {
                      controller.tabId = 4;
                      controller.kontener = AreaView();
                      Get.back();
                      controller.update();
                    },
                  ),
                  drawItem(
                    label: 'Divisi',
                    icon: Icons.dataset_linked_outlined,
                    color: Colors.blueGrey,
                    onTap: () {
                      controller.tabId = 4;
                      controller.kontener = DivisiView();
                      Get.back();
                      controller.update();
                    },
                  ),
                  drawItem(
                    label: 'Jabatan',
                    icon: Icons.chair_alt_outlined,
                    color: Colors.blueGrey,
                    onTap: () {
                      controller.tabId = 4;
                      controller.kontener = JabatanView();
                      Get.back();
                      controller.update();
                    },
                  ),
                  drawItem(
                    label: 'Agama',
                    icon: Icons.mosque_outlined,
                    color: Colors.blueGrey,
                    onTap: () {
                      controller.tabId = 4;
                      controller.kontener = AgamaView();
                      Get.back();
                      controller.update();
                    },
                  ),
                  drawItem(
                    label: 'Pendidikan',
                    icon: Icons.school_outlined,
                    color: Colors.blueGrey,
                    onTap: () {
                      controller.tabId = 4;
                      controller.kontener = PendidikanView();
                      Get.back();
                      controller.update();
                    },
                  ),
                  drawItem(
                    label: 'Status Karyawan',
                    icon: Icons.arrow_drop_down_circle_outlined,
                    color: Colors.blueGrey,
                    onTap: () {
                      controller.tabId = 4;
                      controller.kontener = StatusKerjaView();
                      Get.back();
                      controller.update();
                    },
                  ),
                  drawItem(
                    label: 'Status PHK',
                    icon: Icons.arrow_drop_down_circle_outlined,
                    color: Colors.blueGrey,
                    onTap: () {
                      controller.tabId = 4;
                      controller.kontener = StatusPhkView();
                      Get.back();
                      controller.update();
                    },
                  ),
                  drawItem(
                    label: 'PTKP',
                    icon: Icons.arrow_drop_down_circle_outlined,
                    color: Colors.blueGrey,
                    onTap: () {
                      controller.tabId = 4;
                      controller.kontener = PtkpView();
                      Get.back();
                      controller.update();
                    },
                  ),
                  drawItem(
                    label: 'Tarif EFektif (TER)',
                    icon: Icons.money,
                    color: Colors.blueGrey,
                    onTap: () {
                      controller.tabId = 4;
                      controller.kontener = TarifEfektifView();
                      Get.back();
                      controller.update();
                    },
                  ),
                  drawItem(
                    label: 'Customer',
                    icon: Icons.emoji_people,
                    color: Colors.blueGrey,
                    onTap: () {
                      controller.tabId = 4;
                      controller.kontener = CustomerView();
                      Get.back();
                      controller.update();
                    },
                  ),
                  drawItem(
                    label: 'Hari Libur',
                    icon: Icons.calendar_month,
                    color: Colors.blueGrey,
                    onTap: () {
                      controller.tabId = 4;
                      controller.kontener = HariLiburView();
                      Get.back();
                      controller.update();
                    },
                  ),
                  const Divider(color: Color(0xFFE2E8F0)),
                  drawItem(
                    label: 'Ubah Email',
                    icon: Icons.email_outlined,
                    color: Colors.red,
                    onTap: () {
                      Get.back();
                      controller.tabId = 4;
                      dialogChangeEmail();
                    },
                  ),
                  drawItem(
                    label: 'Ubah Password',
                    icon: Icons.key,
                    color: Colors.red,
                    onTap: () {
                      Get.back();
                      controller.tabId = 4;
                      dialogChangePassword();
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
        color: controller.tabId == idx ? Colors.brown.withValues(alpha: 0.1) : Colors.transparent,
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
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        dense: true,
        leading: Icon(icon, size: 21, color: color),
        title: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.keyboard_arrow_right, color: color?.withValues(alpha: 0.5)),
        onTap: onTap,
        hoverColor: color?.withValues(alpha: 0.1),
      ),
    );
  }

  void dialogChangeEmail() {
    controller.resetEmailForm();
    AFwidget.dialog(
      Container(
        width: 500,
        height: 210,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('UBAH EMAIL'),
            Padding(
              padding: const EdgeInsets.all(20),
              child: AFwidget.textField(
                controller: controller.txtEmail,
                label: 'Email',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 25),
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
                    label: 'Simpan Perubahan',
                    color: Colors.blue,
                    onPressed: controller.changeEmail,
                    minimumSize: const Size(120, 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      scrollable: false,
      barrierDismissible: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void dialogChangePassword() {
    controller.resetPasswordForm();
    AFwidget.dialog(
      Container(
        width: 500,
        height: 350,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            AFwidget.formHeader('UBAH PASSWORD'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              child: GetBuilder<HomeControl>(
                builder: (_) {
                  return AFwidget.textField(
                    controller: controller.txtPassOld,
                    label: 'Password Lama',
                    obscureText: !controller.isTampilPassOld,
                    suffixIcon: GestureDetector(
                      child: Icon(
                        controller.isTampilPassOld
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 20,
                      ),
                      onTap: () {
                        controller.isTampilPassOld = !controller.isTampilPassOld;
                        controller.update();
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
              child: GetBuilder<HomeControl>(
                builder: (_) {
                  return AFwidget.textField(
                    controller: controller.txtPassword,
                    label: 'Password Baru',
                    obscureText: !controller.isTampilPassword,
                    suffixIcon: GestureDetector(
                      child: Icon(
                        controller.isTampilPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 20,
                      ),
                      onTap: () {
                        controller.isTampilPassword = !controller.isTampilPassword;
                        controller.update();
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: GetBuilder<HomeControl>(
                builder: (_) {
                  return AFwidget.textField(
                    controller: controller.txtPassConfirm,
                    label: 'Konfirmasi Password Baru',
                    obscureText: !controller.isTampilPassConfirm,
                    suffixIcon: GestureDetector(
                      child: Icon(
                        controller.isTampilPassConfirm
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 20,
                      ),
                      onTap: () {
                        controller.isTampilPassConfirm = !controller.isTampilPassConfirm;
                        controller.update();
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
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
                    label: 'Simpan Perubahan',
                    color: Colors.blue,
                    onPressed: controller.changePassword,
                    minimumSize: const Size(120, 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      scrollable: false,
      barrierDismissible: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

}
