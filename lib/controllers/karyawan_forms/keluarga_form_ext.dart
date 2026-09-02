import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/models/keluarga_karyawan.dart';

extension KeluargaFormExt on KaryawanControl {
  void keluargaForm(String id, BuildContext context) {
    KeluargaKaryawan item = KeluargaKaryawan();
    if(id != '') item = listKeluarga.where((element) => element.id == id).first;
    txtKeluargaId.text = item.id;
    txtKeluargaNama.text = item.nama;
    txtKeluargaNomorKtp.text = item.nomorKtp;
    txtKeluargaTempatLahir.text = item.tempatLahir;
    txtKeluargaTanggalLahir.text = AFconvert.matYMD(item.tanggalLahir ?? DateTime.now());
    txtKeluargaTelepon.text = item.telepon;
    txtKeluargaEmail.text = item.email;
    keluargaHubungan = item.hubungan;
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
                  label: 'Nama',
                  controller: txtKeluargaNama,
                ),
                AFwidget.barisText(
                  label: 'Nomor KTP',
                  controller: txtKeluargaNomorKtp,
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
                              groupValue: keluargaHubungan,
                              onChanged: (a) {
                                if(a != null && a != keluargaHubungan) {
                                  keluargaHubungan = a;
                                  update();
                                }
                              },
                              child: Wrap(
                                spacing: 35,
                                children: mapKeluargaHubungan.entries.map((entry) {
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
                          controller: txtKeluargaTempatLahir,
                        ),
                      ),
                      Container(
                        width: 165,
                        margin: const EdgeInsets.only(left: 15),
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: txtKeluargaTanggalLahir,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(txtKeluargaTanggalLahir.text),
                            );
                            if(a != null) {
                              txtKeluargaTanggalLahir.text = AFconvert.matYMD(a);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                AFwidget.barisText(
                  label: 'No. Telepon',
                  controller: txtKeluargaTelepon,
                ),
                AFwidget.barisText(
                  label: 'Email Pribadi',
                  controller: txtKeluargaEmail,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                  child: Row(
                    children: [
                      id != '' ? AFwidget.tombol(
                        label: 'Hapus',
                        color: Colors.red,
                        onPressed: () {
                          hapusKeluargaForm(item);
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
                        onPressed: simpanKeluargaData,
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
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }
}
