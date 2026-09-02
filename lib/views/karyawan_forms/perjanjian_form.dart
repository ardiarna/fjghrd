import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/models/perjanjian_kerja.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/models/status_kerja.dart';

class PerjanjianForm extends StatelessWidget {
  final String id;
  const PerjanjianForm({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KaryawanControl>();
    PerjanjianKerja item = PerjanjianKerja();
    if(id != '') item = controller.listPerjanjianKerja.where((element) => element.id == id).first;
    
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
                AFwidget.barisText(
                  label: 'Nomor',
                  controller: controller.txtPerjanjianNomor,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Tanggal Awal'),
                      ),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: controller.txtPerjanjianTglAwal,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(controller.txtPerjanjianTglAwal.text),
                            );
                            if(a != null) {
                              controller.txtPerjanjianTglAwal.text = AFconvert.matYMD(a);
                            }
                          },
                        ),
                      )
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
                        child: const Text('Tanggal Akhir'),
                      ),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: controller.txtPerjanjianTglAkhir,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(controller.txtPerjanjianTglAkhir.text),
                            );
                            if(a != null) {
                              controller.txtPerjanjianTglAkhir.text = AFconvert.matYMD(a);
                              controller.update();
                            }
                          },
                        ),
                      ),
                      GetBuilder<KaryawanControl>(
                        builder: (_) {
                          if(controller.txtPerjanjianTglAkhir.text.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: IconButton(
                                onPressed: () {
                                  controller.txtPerjanjianTglAkhir.text = '';
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
                        child: const Text('Status Karyawan'),
                      ),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: controller.statusKerjaPerjanjian.nama,
                              label: '',
                              onTap: () async {
                                var a = await controller.pilihStatusKerja(value: controller.statusKerjaPerjanjian.id);
                                if(a != null && a.value != controller.statusKerjaPerjanjian.id) {
                                  controller.statusKerjaPerjanjian = StatusKerja.fromMap(a.data!);
                                  controller.update();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
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
                            label: 'perjanjian kerja dengan nomor ${item.nomor}',
                            aksi: () {
                              controller.hapusPerjanjianData(item.id);
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
                        onPressed: controller.simpanPerjanjianData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AFwidget.formHeader('Form ${id == '' ? 'Tambah' : 'Ubah'} Perjanjian Kerja'),
          ],
        ),
      );
  }
}

void showPerjanjianForm(String id, BuildContext context) {
  final controller = Get.find<KaryawanControl>();
  PerjanjianKerja item = PerjanjianKerja();
  if(id != '') item = controller.listPerjanjianKerja.where((element) => element.id == id).first;
  controller.txtPerjanjianId.text = item.id;
  controller.txtPerjanjianNomor.text = item.nomor;
  controller.txtPerjanjianTglAwal.text = AFconvert.matYMD(item.tanggalAwal ?? DateTime.now());
  controller.txtPerjanjianTglAkhir.text = AFconvert.matYMD(item.tanggalAKhir);
  controller.statusKerjaPerjanjian = item.statusKerja;

  AFwidget.dialog(
    PerjanjianForm(id: id),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
