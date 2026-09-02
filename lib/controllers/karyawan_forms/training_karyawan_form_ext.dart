import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/models/training.dart';
import 'package:fjghrd/models/training_karyawan.dart';

extension TrainingKaryawanFormExt on KaryawanControl {
  void trainingKaryawanForm(String id, BuildContext context) {
    TrainingKaryawan item = TrainingKaryawan();
    if(id != '') item = listTrainingKaryawan.where((element) => element.id == id).first;
    txtTrainingKaryawanId.text = item.id;
    txtTrainingKaryawanTanggal.text = AFconvert.matYMD(AFconvert.keTanggal(item.tanggal));
    txtTrainingKaryawanKeterangan.text = item.keterangan ?? '';
    trainingTerpilih = item.training;

    AFwidget.dialog(
      Container(
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
                  nilai: current.nama,
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
                              value: trainingTerpilih?.nama ?? '',
                              label: '',
                              onTap: () async {
                                var a = await pilihTraining(value: trainingTerpilih?.id ?? '');
                                if(a != null && a.value != trainingTerpilih?.id) {
                                  trainingTerpilih = Training.fromMap(a.data!);
                                  update();
                                }
                              },
                            );
                          }
                        ),
                      ),
                      GetBuilder<KaryawanControl>(
                        builder: (_) {
                          if (trainingTerpilih != null) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: IconButton(
                                onPressed: () {
                                  trainingTerpilih = null;
                                  update();
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
                          controller: txtTrainingKaryawanTanggal,
                          readOnly: true,
                          ontap: () async {
                            DateTime? a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(txtTrainingKaryawanTanggal.text) ?? DateTime.now(),
                            );
                            if(a != null) {
                              txtTrainingKaryawanTanggal.text = AFconvert.matYMD(a);
                              update();
                            }
                          },
                        ),
                      ),
                      GetBuilder<KaryawanControl>(
                        builder: (_) {
                          if(txtTrainingKaryawanTanggal.text.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: IconButton(
                                onPressed: () {
                                  txtTrainingKaryawanTanggal.text = '';
                                  update();
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
                  controller: txtTrainingKaryawanKeterangan,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                  child: Row(
                    children: [
                      id != '' ? AFwidget.tombol(
                        label: 'Hapus',
                        color: Colors.red,
                        onPressed: () {
                          hapusTrainingKaryawan(id);
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
                        onPressed: simpanTrainingKaryawanData,
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
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }
}
