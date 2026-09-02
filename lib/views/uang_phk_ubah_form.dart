import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/uang_phk_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/models/opsi.dart';

class UangPhkUbahForm extends StatelessWidget {
  const UangPhkUbahForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UangPhkControl>();
    return Container(
        width: Get.width,
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
                  nilai: controller.karyawan.nama,
                  paddingTop: 70,
                  labelWidth: 200,
                ),
                AFwidget.barisInfo(
                  label: 'Jabatan',
                  nilai: controller.karyawan.jabatan.nama,
                  labelWidth: 200,
                ),
                AFwidget.barisInfo(
                  label: 'Masa Kerja',
                  nilai: AFconvert.matDate(controller.karyawan.tanggalMasuk),
                  labelWidth: 200,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 200,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Periode'),
                      ),
                      Expanded(
                        child: GetBuilder<UangPhkControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: controller.tahun.label,
                              label: '',
                              onTap: () async {
                                var a = await controller.pilihTahun(value: controller.tahun.value);
                                if(a != null && a.value != controller.tahun.value) {
                                  controller.tahun = a;
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
                AFwidget.barisText(
                  label: 'Uang Kompensasi',
                  controller: controller.txtKompensasi,
                  isNumber: true,
                  labelWidth: 200,
                ),
                AFwidget.barisText(
                  label: 'Uang Pisah',
                  controller: controller.txtUangPisah,
                  isNumber: true,
                  labelWidth: 200,
                ),
                AFwidget.barisText(
                  label: 'Uang Pesangon',
                  controller: controller.txtPesangon,
                  isNumber: true,
                  labelWidth: 200,
                ),
                AFwidget.barisText(
                  label: 'Uang Masa Kerja',
                  controller: controller.txtMasaKerja,
                  isNumber: true,
                  labelWidth: 200,
                ),
                AFwidget.barisText(
                  label: 'Uang Lain-lain',
                  controller: controller.txtLain,
                  isNumber: true,
                  labelWidth: 200,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AFwidget.tombol(
                        label: 'Hapus',
                        color: Colors.red,
                        onPressed: () {
                          AFwidget.formHapus(
                            label: 'data uang PHK ini',
                            aksi: () {
                              controller.hapusData(controller.txtId.text);
                            },
                          );
                        },
                        minimumSize: const Size(120, 40),
                      ),
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
                        onPressed: controller.ubahData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AFwidget.formHeader('Form Ubah Uang Phk'),
          ],
        ),
      );
  }
}


void showUangPhkUbahForm(String id, BuildContext context) {
  final controller = Get.find<UangPhkControl>();
  var item = controller.listUangPhk.where((element) => element.id == id).first;
  controller.txtId.text = item.id;
  controller.tahun = Opsi(value: '${item.tahun}', label: '${item.tahun}');
  controller.txtKompensasi.text = AFconvert.matNumber(item.kompensasi);
  controller.txtUangPisah.text = AFconvert.matNumber(item.uangPisah);
  controller.txtPesangon.text = AFconvert.matNumber(item.pesangon);
  controller.txtMasaKerja.text = AFconvert.matNumber(item.masaKerja);
  controller.txtSisaCutiHari.text = AFconvert.matNumber(item.sisaCutiHari);
  controller.txtSisaCutiJumlah.text = AFconvert.matNumber(item.sisaCutiJumlah);
  controller.txtLain.text = AFconvert.matNumber(item.lain);
  controller.txtPotKas.text = AFconvert.matNumber(item.potKas);
  controller.txtPotCutiHari.text = AFconvert.matNumber(item.potCutiHari);
  controller.txtPotCutiJumlah.text = AFconvert.matNumber(item.potCutiJumlah);
  controller.txtPotLain.text = AFconvert.matNumber(item.potLain);
  controller.karyawan = item.karyawan;
  
  AFwidget.dialog(
    const UangPhkUbahForm(),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
