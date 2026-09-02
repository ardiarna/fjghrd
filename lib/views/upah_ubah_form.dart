import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/upah_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';

class UpahUbahForm extends StatelessWidget {
  const UpahUbahForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UpahControl>();
    return Container(
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Stack(
          children: [
            ListView(
              children: [
                AFwidget.barisInfo(
                  label: 'Nama Karyawan',
                  nilai: controller.current.nama,
                  paddingTop: 70,
                  labelWidth: 200,
                ),
                AFwidget.barisInfo(
                  label: 'Jabatan',
                  nilai: controller.current.jabatan.nama,
                  labelWidth: 200,
                ),
                AFwidget.barisInfo(
                  label: 'Masa Kerja',
                  nilai: AFconvert.matDate(controller.current.tanggalMasuk),
                  labelWidth: 200,
                ),
                AFwidget.barisInfo(
                  label: 'Gaji Pokok Terakhir',
                  nilai: AFconvert.matNumber(controller.current.upah.gaji),
                  labelWidth: 200,
                ),
                AFwidget.barisText(
                  label: 'Jumlah Uang Makan',
                  controller: controller.txtUangMakan,
                  labelWidth: 200,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 200,
                        child: Text('Jenis Uang Makan'),
                      ),
                      Expanded(
                        child: GetBuilder<UpahControl>(
                          builder: (_) {
                            return RadioGroup<bool>(
                              groupValue: controller.makanHarian,
                              onChanged: (bool? a) {
                                if(a != null && a != controller.makanHarian) {
                                  controller.makanHarian = a;
                                  controller.update();
                                }
                              },
                              child: Row(
                                children: const [
                                  Radio<bool>(value: true),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                    child: Text('Harian'),
                                  ),
                                  Radio<bool>(value: false),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                    child: Text('Tetap'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 200,
                        child: Text('Status Overtime'),
                      ),
                      Expanded(
                        child: GetBuilder<UpahControl>(
                          builder: (_) {
                            return RadioGroup<bool>(
                              groupValue: controller.overtime,
                              onChanged: (a) {
                                if(a != null && a != controller.overtime) {
                                  controller.overtime = a;
                                  controller.update();
                                }
                              },
                              child: Row(
                                children: const [
                                  Radio<bool>(value: true),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                    child: Text('OT'),
                                  ),
                                  Radio<bool>(value: false),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                    child: Text('NON OT'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 25),
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
                        label: 'Simpan',
                        color: Colors.blue,
                        onPressed: controller.ubahData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AFwidget.formHeader('Form Salary Karyawan'),
          ],
        ),
      );
  }
}


void showUpahUbahForm(String karyawanId, BuildContext context) {
  final controller = Get.find<UpahControl>();
  controller.current = controller.listKaryawan.where((element) => element.id == karyawanId).first;
  controller.txtUangMakan.text = AFconvert.matNumber(controller.current.upah.uangMakan);
  controller.makanHarian = controller.current.upah.id.isEmpty ? null : controller.current.upah.makanHarian;
  controller.overtime = controller.current.upah.id.isEmpty ? null : controller.current.upah.overtime;
  
  AFwidget.dialog(
    const UpahUbahForm(),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
