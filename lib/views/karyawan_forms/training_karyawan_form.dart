import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/models/training.dart';
import 'package:fjghrd/models/training_karyawan.dart';

class TrainingKaryawanForm extends StatelessWidget {
  final String id;
  const TrainingKaryawanForm({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KaryawanControl>();
    
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
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
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Training'),
                      ),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: controller.trainingTerpilih?.nama ?? '',
                              label: '',
                              onTap: () async {
                                var a = await controller.pilihTraining(value: controller.trainingTerpilih?.id ?? '');
                                if(a != null && a.value != controller.trainingTerpilih?.id) {
                                  controller.trainingTerpilih = Training.fromMap(a.data!);
                                  controller.update();
                                }
                              },
                            );
                          }
                        ),
                      ),
                      GetBuilder<KaryawanControl>(
                        builder: (_) {
                          if (controller.trainingTerpilih != null) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: IconButton(
                                onPressed: () {
                                  controller.trainingTerpilih = null;
                                  controller.update();
                                },
                                icon: const Icon(Icons.highlight_off),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Tanggal'),
                      ),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: controller.txtTrainingKaryawanTanggal,
                          readOnly: true,
                          ontap: () async {
                            DateTime? a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(controller.txtTrainingKaryawanTanggal.text) ?? DateTime.now(),
                            );
                            if(a != null) {
                              controller.txtTrainingKaryawanTanggal.text = AFconvert.matYMD(a);
                              controller.update();
                            }
                          },
                        ),
                      ),
                      GetBuilder<KaryawanControl>(
                        builder: (_) {
                          if(controller.txtTrainingKaryawanTanggal.text.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: IconButton(
                                onPressed: () {
                                  controller.txtTrainingKaryawanTanggal.text = '';
                                  controller.update();
                                },
                                icon: const Icon(Icons.highlight_off),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
                AFwidget.barisText(
                  label: 'Keterangan',
                  controller: controller.txtTrainingKaryawanKeterangan,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                  child: Row(
                    children: [
                      id != '' ? AFwidget.tombol(
                        label: 'Hapus',
                        color: Colors.red,
                        onPressed: () {
                          AFwidget.formHapus(
                            label: 'riwayat training ini',
                            aksi: () {
                              controller.hapusTrainingKaryawanData(id);
                            },
                          );
                        },
                        minimumSize: const Size(120, 40),
                      ) : Container(),
                      const Spacer(),
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
                        onPressed: controller.simpanTrainingKaryawanData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AFwidget.formHeader('Form ${id == '' ? 'Tambah' : 'Ubah'} Riwayat Training'),
          ],
        ),
      );
  }
}

void showTrainingKaryawanForm(String id, BuildContext context) {
  final controller = Get.find<KaryawanControl>();
  TrainingKaryawan item = TrainingKaryawan();
  if(id != '') item = controller.listTrainingKaryawan.where((element) => element.id == id).first;
  controller.txtTrainingKaryawanId.text = item.id;
  controller.txtTrainingKaryawanTanggal.text = AFconvert.matYMD(AFconvert.keTanggal(item.tanggal));
  controller.txtTrainingKaryawanKeterangan.text = item.keterangan ?? '';
  controller.trainingTerpilih = item.training;

  AFwidget.dialog(
    TrainingKaryawanForm(id: id),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
