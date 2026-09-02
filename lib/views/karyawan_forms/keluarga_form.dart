import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/models/keluarga_karyawan.dart';

class KeluargaForm extends StatelessWidget {
  final String id;
  const KeluargaForm({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KaryawanControl>();
    KeluargaKaryawan item = KeluargaKaryawan();
    if(id != '') item = controller.listKeluarga.where((element) => element.id == id).first;
    
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
                  label: 'Nama',
                  controller: controller.txtKeluargaNama,
                ),
                AFwidget.barisText(
                  label: 'Nomor KTP',
                  controller: controller.txtKeluargaNomorKtp,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Hubungan'),
                      ),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return RadioGroup<String>(
                              groupValue: controller.keluargaHubungan,
                              onChanged: (a) {
                                if(a != null && a != controller.keluargaHubungan) {
                                  controller.keluargaHubungan = a;
                                  controller.update();
                                }
                              },
                              child: Wrap(
                                spacing: 35,
                                children: controller.mapKeluargaHubungan.entries.map((entry) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio<String>(value: entry.key),
                                      Text(entry.value),
                                    ],
                                  );
                                }).toList(),
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
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Tempat & Tgl Lahir'),
                      ),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: controller.txtKeluargaTempatLahir,
                        ),
                      ),
                      Container(
                        width: 165,
                        margin: const EdgeInsets.only(left: 15),
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: controller.txtKeluargaTanggalLahir,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(controller.txtKeluargaTanggalLahir.text),
                            );
                            if(a != null) {
                              controller.txtKeluargaTanggalLahir.text = AFconvert.matYMD(a);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                AFwidget.barisText(
                  label: 'No. Telepon',
                  controller: controller.txtKeluargaTelepon,
                ),
                AFwidget.barisText(
                  label: 'Email Pribadi',
                  controller: controller.txtKeluargaEmail,
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
                            label: 'keluarga bernama ${item.nama}',
                            aksi: () {
                              controller.hapusKeluargaData(item.id);
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
                        onPressed: controller.simpanKeluargaData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AFwidget.formHeader('Form ${id == '' ? 'Tambah' : 'Ubah'} Anggota Keluarga'),
          ],
        ),
      );
  }
}

void showKeluargaForm(String id, BuildContext context) {
  final controller = Get.find<KaryawanControl>();
  KeluargaKaryawan item = KeluargaKaryawan();
  if(id != '') item = controller.listKeluarga.where((element) => element.id == id).first;
  controller.txtKeluargaId.text = item.id;
  controller.txtKeluargaNama.text = item.nama;
  controller.txtKeluargaNomorKtp.text = item.nomorKtp;
  controller.txtKeluargaTempatLahir.text = item.tempatLahir;
  controller.txtKeluargaTanggalLahir.text = AFconvert.matYMD(item.tanggalLahir ?? DateTime.now());
  controller.txtKeluargaTelepon.text = item.telepon;
  controller.txtKeluargaEmail.text = item.email;
  controller.keluargaHubungan = item.hubungan;

  AFwidget.dialog(
    KeluargaForm(id: id),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
