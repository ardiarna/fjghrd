import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/potongan_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/models/opsi.dart';
import 'package:fjghrd/models/karyawan.dart';

import 'package:fjghrd/views/gaji_form.dart';

class PotonganUbahForm extends StatelessWidget {
  const PotonganUbahForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PotonganControl>();
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
                      child: const Text('Jenis Potongan'),
                    ),
                    Expanded(
                      child: GetBuilder<PotonganControl>(
                        builder: (_) {
                          return AFwidget.comboField(
                            value: controller.jenis.label,
                            label: '',
                            onTap: () async {
                              var a = await controller.pilihJenis(value: controller.jenis.value);
                              if(a != null && a.value != controller.jenis.value) {
                                controller.jenis = a;
                                controller.hitungJumlahIdr(controller.txtHari.text);
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
                padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                child: Row(
                  children: [
                    Container(
                      width: 150,
                      padding: const EdgeInsets.only(right: 15),
                      child: const Text('Karyawan'),
                    ),
                    Expanded(
                      child: GetBuilder<PotonganControl>(
                        builder: (_) {
                          return AFwidget.comboField(
                            value: controller.karyawan.nama,
                            label: '',
                            onTap: () async {
                              var a = await controller.pilihKaryawan(value: controller.karyawan.id);
                              if(a != null && a.value != controller.karyawan.id) {
                                controller.karyawan = Karyawan.fromMap(a.data!);
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
              GetBuilder<PotonganControl>(
                builder: (_) {
                  if(controller.karyawan.id != '' && (controller.jenis.value == 'TB' || controller.jenis.value == 'UL' || controller.jenis.value == 'KJ')) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(170, 15, 25, 10),
                      child: Row(
                        children: [
                          const Text('Gaji: '),
                          Text(AFconvert.matNumber(controller.upah.gaji),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 50),
                          const Text('Uang Makan: '),
                          Text('${AFconvert.matNumber(controller.upah.uangMakan)}   ${controller.upah.makanHarian ? 'Harian' : 'Tetap'}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 50),
                          IconButton(
                            onPressed: () {
                              showGajiForm(context);
                            },
                            icon: const Icon(Icons.edit, color: Colors.green),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
              GetBuilder<PotonganControl>(
                builder: (_) {
                  if(controller.jenis.value == 'TB' || controller.jenis.value == 'UL') {
                    return AFwidget.barisText(
                      label: 'Jumlah Hari',
                      controller: controller.txtHari,
                      isNumber: true,
                      onchanged: controller.hitungJumlahIdr,
                    );
                  } else if(controller.jenis.value == 'KJ') {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 250,
                          child: AFwidget.barisText(
                            label: 'Jumlah Jam',
                            controller: controller.txtHari,
                            onchanged: controller.hitungJumlahIdr,
                            paddingRight: 0,
                          ),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 11, 25, 5),
                            child: Text('*Desimal menggunakan titik, contoh: 3.5',
                              style: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  controller.txtHari.text = '';
                  return Container();
                },
              ),
              GetBuilder<PotonganControl>(
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
                  children: [
                    AFwidget.tombol(
                      label: 'Hapus',
                      color: Colors.red,
                      onPressed: () {
                        AFwidget.formHapus(
                          label: 'data potongan ini',
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
          AFwidget.formHeader('Form Ubah Potongan'),
        ],
      ),
    );
  }
}

Future<void> showPotonganUbahForm(String id, BuildContext context) async {
  final controller = Get.find<PotonganControl>();
  var item = controller.listPotongan.where((element) => element.id == id).first;
  controller.txtId.text = item.id;
  controller.tahun = Opsi(value: '${item.tahun}', label: '${item.tahun}');
  controller.bulan = Opsi(value: '${item.bulan}', label: mapBulan[item.bulan]!);
  controller.txtTanggal.text = AFconvert.matDate(item.tanggal);
  controller.txtKeterangan.text = item.keterangan;
  controller.txtHari.text = AFconvert.matNumber(item.hari);
  controller.txtJumlah.text = AFconvert.matNumber(item.jumlah);
  controller.karyawan = item.karyawan;
  controller.jenis = controller.listJenis.where((element) => element.value == item.jenis).first;
  if (controller.jenis.value == 'TB' || controller.jenis.value == 'UL' || controller.jenis.value == 'KJ') {
    await controller.loadPayroll();
  }
  AFwidget.dialog(
    const PotonganUbahForm(),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
