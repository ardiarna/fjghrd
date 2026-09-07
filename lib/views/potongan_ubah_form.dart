import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/potongan_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/models/opsi.dart';
import 'package:fjghrd/views/gaji_form.dart';

class PotonganUbahForm extends StatelessWidget {
  const PotonganUbahForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PotonganControl>(
      builder: (controller) => Container(
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
                  label: 'Karyawan',
                  nilai: controller.karyawan.nama,
                  paddingTop: 70,
                ),
                AFwidget.barisInfo(
                  label: 'Jabatan',
                  nilai: controller.karyawan.jabatan.nama,
                ),
                AFwidget.barisInfo(
                  label: 'Masa Kerja',
                  nilai: AFconvert.matDate(controller.karyawan.tanggalMasuk),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Periode'),
                      ),
                      Expanded(
                        child: AFwidget.comboField(
                          value: controller.bulan.label,
                          label: '',
                          onTap: null,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: AFwidget.comboField(
                          value: controller.tahun.label,
                          label: '',
                          onTap: null,
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
                        child: const Text('Jenis Potongan'),
                      ),
                      Expanded(
                        child: AFwidget.comboField(
                          value: controller.jenis.label,
                          label: '',
                          onTap: null,
                        ),
                      ),
                    ],
                  ),
                ),
                GetBuilder<PotonganControl>(
                  id: 'info_upah',
                  builder: (_) {
                                        if(controller.karyawan.id != '' && (controller.jenis.value == 'TB' || controller.jenis.value == 'UL' || controller.jenis.value == 'KJ')) {
                      bool isTB = controller.jenis.value == 'TB';
                      bool isULKJ = controller.jenis.value == 'UL' || controller.jenis.value == 'KJ';
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(170, 15, 25, 10),
                        child: Row(
                          children: [
                            if (isULKJ) const Text('Master Gaji Pokok: '),
                            if (isULKJ) Text(AFconvert.matNumber(controller.upah.gaji),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            if (isTB) const Text('Master Uang Makan: '),
                            if (isTB) Text('${AFconvert.matNumber(controller.upah.uangMakan)}   ${controller.upah.makanHarian ? 'Harian' : 'Tetap'}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 15),
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
                  id: 'form_potongan',
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
                  id: 'form_potongan',
                  builder: (_) {
                    return AFwidget.barisText(
                      label: 'Jumlah IDR',
                      controller: controller.txtJumlah,
                      isNumber: true,
                      onchanged: (_) => controller.update(['form_potongan']),
                    );
                  },
                ),
                AFwidget.barisText(
                  label: 'Keterangan',
                  controller: controller.txtKeterangan,
                  isTextArea: true,
                ),
                GetBuilder<PotonganControl>(
                  id: 'form_potongan',
                  builder: (_) {
                    String msg = controller.pesanValidasi;
                    return Padding(
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
                          const SizedBox(width: 20),
                          if(msg.isNotEmpty)
                            Expanded(
                              child: Text(msg, style: const TextStyle(color: Colors.red, fontStyle: FontStyle.italic)),
                            )
                          else
                            const Spacer(),
                          AFwidget.tombol(
                            label: 'Batal',
                            color: Colors.orange,
                            onPressed: Get.back,
                            minimumSize: const Size(120, 40),
                          ),
                          const SizedBox(width: 20),
                          AFwidget.tombol(
                            label: 'Simpan',
                            color: msg.isEmpty ? Colors.blue : Colors.grey,
                            onPressed: msg.isEmpty ? controller.ubahData : null,
                            minimumSize: const Size(120, 40),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ],
            ),
            AFwidget.formHeader('Form Ubah Potongan'),
          ],
        ),
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
