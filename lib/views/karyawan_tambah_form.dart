import 'package:fjghrd/controllers/karyawan_control.dart';
import 'package:fjghrd/models/agama.dart';
import 'package:fjghrd/models/area.dart';
import 'package:fjghrd/models/divisi.dart';
import 'package:fjghrd/models/jabatan.dart';
import 'package:fjghrd/models/pendidikan.dart';
import 'package:fjghrd/models/status_kerja.dart';
import 'package:fjghrd/models/ptkp.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KaryawanTambahForm extends StatelessWidget {
  const KaryawanTambahForm({super.key});

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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Area'),
                      ),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: controller.area.nama,
                              label: '',
                              onTap: () async {
                                var a = await controller.pilihArea(value: controller.area.id);
                                if(a != null && a.value != controller.area.id) {
                                  controller.area = Area.fromMap(a.data!);
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
                        child: const Text('Jenis Karyawan'),
                      ),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return RadioGroup<bool>(
                              groupValue: controller.staf,
                              onChanged: (a) {
                                if(a != null && a != controller.staf) {
                                  controller.staf = a;
                                  controller.update();
                                }
                              },
                              child: Row(
                                children: const [
                                  Radio<bool>(value: true),
                                  SizedBox(
                                    width: 90,
                                    child: Text('Staf'),
                                  ),
                                  Radio<bool>(value: false),
                                  SizedBox(
                                    width: 110,
                                    child: Text('Non Staf'),
                                  ),
                                ],
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
                        child: const Text('Manajemen'),
                      ),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return RadioGroup<bool>(
                              groupValue: controller.manajemen,
                              onChanged: (a) {
                                if(a != null && a != controller.manajemen) {
                                  controller.manajemen = a;
                                  controller.update();
                                }
                              },
                              child: Row(
                                children: const [
                                  Radio<bool>(value: true),
                                  SizedBox(
                                    width: 90,
                                    child: Text('Ya'),
                                  ),
                                  Radio<bool>(value: false),
                                  SizedBox(
                                    width: 110,
                                    child: Text('Tidak'),
                                  ),
                                ],
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
                        child: const Text('Status Aktif'),
                      ),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return RadioGroup<String>(
                              groupValue: controller.aktif,
                              onChanged: (a) {
                                if(a != null && a != controller.aktif) {
                                  controller.aktif = a;
                                  controller.update();
                                }
                              },
                              child: Row(
                                children: const [
                                  Radio<String>(value: 'Y'),
                                  SizedBox(
                                    width: 90,
                                    child: Text('Sudah'),
                                  ),
                                  Radio<String>(value: 'P'),
                                  SizedBox(
                                    width: 110,
                                    child: Text('Belum'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                AFwidget.barisText(
                  label: 'Nama',
                  controller: controller.txtNama,
                ),
                AFwidget.barisText(
                  label: 'NIK',
                  controller: controller.txtNik,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Masa Kerja'),
                      ),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: controller.txtTanggalMasuk,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(controller.txtTanggalMasuk.text),
                            );
                            if(a != null) {
                              controller.txtTanggalMasuk.text = AFconvert.matYMD(a);
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
                        child: const Text('Agama'),
                      ),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: controller.agama.nama,
                              label: '',
                              onTap: () async {
                                var a = await controller.pilihAgama(value: controller.agama.id);
                                if(a != null && a.value != controller.agama.id) {
                                  controller.agama = Agama.fromMap(a.data!);
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
                        child: const Text('Divisi'),
                      ),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: controller.divisi.nama,
                              label: '',
                              onTap: () async {
                                var a = await controller.pilihDivisi(value: controller.divisi.id);
                                if(a != null && a.value != controller.divisi.id) {
                                  controller.divisi = Divisi.fromMap(a.data!);
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
                        child: const Text('Jabatan'),
                      ),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: controller.jabatan.nama,
                              label: '',
                              onTap: () async {
                                var a = await controller.pilihJabatan(value: controller.jabatan.id);
                                if(a != null && a.value != controller.jabatan.id) {
                                  controller.jabatan = Jabatan.fromMap(a.data!);
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
                  label: 'Nomor KK',
                  controller: controller.txtNomorKk,
                ),
                AFwidget.barisText(
                  label: 'Nomor KTP',
                  controller: controller.txtNomorKtp,
                ),
                AFwidget.barisText(
                  label: 'Nomor Paspor',
                  controller: controller.txtNomorPaspor,
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
                          controller: controller.txtTempatLahir,
                        ),
                      ),
                      Container(
                        width: 165,
                        margin: const EdgeInsets.only(left: 15),
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: controller.txtTanggalLahir,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(controller.txtTanggalLahir.text),
                            );
                            if(a != null) {
                              controller.txtTanggalLahir.text = AFconvert.matYMD(a);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                AFwidget.barisText(
                  label: 'Alamat KTP',
                  controller: controller.txtAlamatKtp,
                  isTextArea: true,
                ),
                AFwidget.barisText(
                  label: 'Alamat Tinggal Sekarang',
                  controller: controller.txtAlamatTinggal,
                  isTextArea: true,
                ),
                AFwidget.barisText(
                  label: 'No. Telepon',
                  controller: controller.txtTelepon,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Jenis Kelamin'),
                      ),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return RadioGroup(
                              groupValue: controller.kelamin,
                              onChanged: (a) {
                                if(a != null && a != controller.kelamin) {
                                  controller.kelamin = a;
                                  controller.update();
                                }
                              },
                              child: Row(
                                children: const [
                                  Radio<String>(value: 'L'),
                                  SizedBox(
                                    width: 90,
                                    child: Text('Laki-Laki'),
                                  ),
                                  Radio<String>(value: 'P'),
                                  SizedBox(
                                    width: 110,
                                    child: Text('Perempuan'),
                                  ),
                                ],
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
                        child: const Text('Status'),
                      ),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return RadioGroup<String>(
                              groupValue: controller.kawin,
                              onChanged: (a) {
                                if(a != null && a != controller.kawin) {
                                  controller.kawin = a;
                                  controller.update();
                                }
                              },
                              child: Row(
                                children: const [
                                  Radio<String>(value: 'Y'),
                                  SizedBox(
                                    width: 90,
                                    child: Text('Kawin'),
                                  ),
                                  Radio<String>(value: 'N'),
                                  SizedBox(
                                    width: 110,
                                    child: Text('Single'),
                                  ),
                                  Radio<String>(value: 'P',
                                  ),
                                  SizedBox(
                                    width: 110,
                                    child: Text('Single Parent'),
                                  ),
                                ],
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
                        child: const Text('Pendidikan Terakhir'),
                      ),
                      Expanded(
                        child: GetBuilder<KaryawanControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: controller.pendidikan.nama,
                              label: '',
                              onTap: () async {
                                var a = await controller.pilihPendidikan(value: controller.pendidikan.id);
                                if(a != null && a.value != controller.pendidikan.id) {
                                  controller.pendidikan = Pendidikan.fromMap(a.data!);
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
                      const SizedBox(width: 150),
                      Container(
                        width: 100,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Almamater'),
                      ),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: controller.txtPendidikanAlmamater,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      const SizedBox(width: 150),
                      Container(
                        width: 100,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Jurusan'),
                      ),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: controller.txtPendidikanJurusan,
                        ),
                      ),
                    ],
                  ),
                ),
                AFwidget.barisText(
                  label: 'Email Pribadi',
                  controller: controller.txtEmail,
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
                              value: controller.statusKerja.nama,
                              label: '',
                              onTap: () async {
                                var a = await controller.pilihStatusKerja(value: controller.statusKerja.id);
                                if(a != null && a.value != controller.statusKerja.id) {
                                  controller.statusKerja = StatusKerja.fromMap(a.data!);
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
                  label: 'NPWP',
                  controller: controller.txtNomorPwp,
                ),
                Visibility(
                  visible: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          padding: const EdgeInsets.only(right: 15),
                          child: const Text('PTKP'),
                        ),
                        Expanded(
                          child: GetBuilder<KaryawanControl>(
                            builder: (_) {
                              return AFwidget.comboField(
                                value: controller.ptkp.kode,
                                label: '',
                                onTap: () async {
                                  var a = await controller.pilihPtkp(value: controller.ptkp.id);
                                  if(a != null && a.value != controller.ptkp.id) {
                                    controller.ptkp = Ptkp.fromMap(a.data!);
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
            AFwidget.formHeader(
              'Form Tambah Karyawan',
              actions: [
                IconButton(
                  onPressed: () async {
                    AFwidget.loading();
                    await controller.loadAllData();
                    Get.back();
                  },
                  icon: const Icon(Icons.refresh),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
      );
  
  }
}

void showKaryawanTambahForm(BuildContext context) {
  final controller = Get.find<KaryawanControl>();

    controller.txtId.text = '';
    controller.txtNama.text = '';
    controller.txtNik.text = '';
    controller.txtTanggalMasuk.text = AFconvert.matYMD(DateTime.now());
    controller.txtNomorKk.text = '';
    controller.txtNomorKtp.text = '';
    controller.txtNomorPaspor.text = '';
    controller.txtNomorPwp.text = '';
    controller.txtTempatLahir.text = '';
    controller.txtTanggalLahir.text = AFconvert.matYMD(DateTime.now());
    controller.txtAlamatKtp.text = '';
    controller.txtAlamatTinggal.text = '';
    controller.txtTelepon.text = '';
    controller.txtEmail.text = '';
    controller.txtPendidikanAlmamater.text = '';
    controller.txtPendidikanJurusan.text = '';
    controller.agama = Agama();
    controller.area = Area();
    controller.divisi = Divisi();
    controller.jabatan = Jabatan();
    controller.pendidikan = Pendidikan();
    controller.statusKerja = StatusKerja();
    controller.ptkp = Ptkp();
    controller.kawin = '';
    controller.kelamin = '';
    controller.aktif = '';
    controller.staf = null;
    controller.manajemen = false;
  AFwidget.dialog(
    const KaryawanTambahForm(),
    barrierDismissible: false,
    scrollable: false,
    backgroundColor: Colors.white,
    contentPadding: const EdgeInsets.all(0),
  );
}
