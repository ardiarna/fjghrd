import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/penghasilan_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/opsi.dart';
import 'package:fjghrd/views/uang_makan_form.dart';

class PenghasilanTambahForm extends StatelessWidget {
  const PenghasilanTambahForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PenghasilanControl>();
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Jenis Penghasilan'),
                      ),
                      Expanded(
                        child: GetBuilder<PenghasilanControl>(
                          id: 'form_penghasilan',
                          builder: (_) {
                            return AFwidget.comboField(
                              value: controller.jenis.label,
                              label: '',
                              onTap: () async {
                                var a = await controller.pilihJenis(value: controller.jenis.value);
                                if(a != null && a.value != controller.jenis.value) {
                                  controller.jenis = a;
                                  controller.hitungJumlahIdr(controller.txtHari.text);
                                  controller.update(['form_penghasilan']);
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
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Karyawan'),
                      ),
                      Expanded(
                        child: GetBuilder<PenghasilanControl>(
                          id: 'form_penghasilan',
                          builder: (_) {
                            return AFwidget.comboField(
                              value: controller.karyawan.nama,
                              label: '',
                              onTap: () async {
                                var a = await controller.pilihKaryawan(value: controller.karyawan.id);
                                if(a != null && a.value != controller.karyawan.id) {
                                  controller.karyawan = Karyawan.fromMap(a.data!);
                                  controller.update(['form_penghasilan']);
                                  await controller.loadPayroll();
                                  controller.hitungJumlahIdr(controller.txtHari.text);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                GetBuilder<PenghasilanControl>(
                  id: 'info_upah',
                  builder: (_) {
                    if(controller.karyawan.id != '' && (controller.jenis.value == 'AB')) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(170, 15, 25, 10),
                        child: Row(
                          children: [
                            const Text('Uang Makan: '),
                            Text('${AFconvert.matNumber(controller.upah.uangMakan)}   ${controller.upah.makanHarian ? 'Harian' : 'Tetap'}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 50),
                            IconButton(
                              onPressed: () {
                                showUangMakanForm(context);
                              },
                              icon: const Icon(Icons.edit, color: Colors.green),
                            ),
                          ],
                        ),
                      );
                    } else if(controller.karyawan.id != '' && (controller.jenis.value == 'GP')) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(170, 15, 25, 10),
                        child: Row(
                          children: [
                            const Text('Gaji Pokok Sebelumnya: '),
                            Text(AFconvert.matNumber(controller.upah.gaji),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                ),
                GetBuilder<PenghasilanControl>(
                  id: 'form_penghasilan',
                  builder: (_) {
                    if(controller.jenis.value == 'AB') {
                      return AFwidget.barisText(
                        label: 'Jumlah Hari',
                        controller: controller.txtHari,
                        isNumber: true,
                        onchanged:controller.hitungJumlahIdr,
                      );
                    }
                    controller.txtHari.text = '';
                    return Container();
                  },
                ),
                GetBuilder<PenghasilanControl>(
                  id: 'form_penghasilan',
                  builder: (_) {
                    return AFwidget.barisText(
                      label: 'Jumlah IDR',
                      controller: controller.txtJumlah,
                      isNumber: true,
                    );
                  },
                ),
                AFwidget.barisText(
                  label: 'Keterangan',
                  controller: controller.txtKeterangan,
                  isTextArea: true,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
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
                        onPressed: controller.tambahData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AFwidget.formHeader('Form Tambah Penghasilan - ${controller.bulan.label} ${controller.tahun.label}'),
          ],
        ),
      );
  }
}

void showPenghasilanTambahForm(BuildContext context) {
  final controller = Get.find<PenghasilanControl>();
  controller.txtId.text = '';
  controller.tahun = Opsi(value: controller.filterTahun.value, label: controller.filterTahun.label);
  controller.bulan = Opsi(value: controller.filterBulan.value, label: controller.filterBulan.label);
  controller.txtTanggal.text = AFconvert.matDate(DateTime(AFconvert.keInt(controller.filterTahun.value), AFconvert.keInt(controller.filterBulan.value)));
  controller.txtKeterangan.text = '';
  controller.txtHari.text = '';
  controller.txtJumlah.text = '';
  controller.karyawan = Karyawan();
  if(controller.filterJenis.value == '') {
    controller.jenis = Opsi(value: '', label: '');
  } else {
    controller.jenis = Opsi(value: controller.filterJenis.value, label: controller.filterJenis.label);
  }
  AFwidget.dialog(
    const PenghasilanTambahForm(),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
