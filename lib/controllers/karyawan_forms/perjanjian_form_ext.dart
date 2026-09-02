import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/models/perjanjian_kerja.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/models/status_kerja.dart';

extension PerjanjianFormExt on KaryawanControl {
  void perjanjianForm(String id, BuildContext context) {
    PerjanjianKerja item = PerjanjianKerja();
    if(id != '') item = listPerjanjianKerja.where((element) => element.id == id).first;
    txtPerjanjianId.text = item.id;
    txtPerjanjianNomor.text = item.nomor;
    txtPerjanjianTglAwal.text = AFconvert.matYMD(item.tanggalAwal ?? DateTime.now());
    txtPerjanjianTglAkhir.text = AFconvert.matYMD(item.tanggalAKhir);
    statusKerjaPerjanjian = item.statusKerja;
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
                AFwidget.barisText(
                  label: 'Nomor',
                  controller: txtPerjanjianNomor,
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
                          controller: txtPerjanjianTglAwal,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(txtPerjanjianTglAwal.text),
                            );
                            if(a != null) {
                              txtPerjanjianTglAwal.text = AFconvert.matYMD(a);
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
                          controller: txtPerjanjianTglAkhir,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(txtPerjanjianTglAkhir.text),
                            );
                            if(a != null) {
                              txtPerjanjianTglAkhir.text = AFconvert.matYMD(a);
                              update();
                            }
                          },
                        ),
                      ),
                      GetBuilder<KaryawanControl>(
                        builder: (_) {
                          if(txtPerjanjianTglAkhir.text.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: IconButton(
                                onPressed: () {
                                  txtPerjanjianTglAkhir.text = '';
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
                        child: const Text('Status Karyawan'),
                      ),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: statusKerjaPerjanjian.nama,
                              label: '',
                              onTap: () async {
                                var a = await pilihStatusKerja(value: statusKerjaPerjanjian.id);
                                if(a != null && a.value != statusKerjaPerjanjian.id) {
                                  statusKerjaPerjanjian = StatusKerja.fromMap(a.data!);
                                  update();
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
                          hapusPerjanjianForm(item);
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
                        onPressed: simpanPerjanjianData,
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
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }
}
