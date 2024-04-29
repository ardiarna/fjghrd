import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/agama.dart';
import 'package:fjghrd/models/divisi.dart';
import 'package:fjghrd/models/jabatan.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/keluarga_karyawan.dart';
import 'package:fjghrd/models/keluarga_kontak.dart';
import 'package:fjghrd/models/pendidikan.dart';
import 'package:fjghrd/models/perjanjian_kerja.dart';
import 'package:fjghrd/models/status_kerja.dart';
import 'package:fjghrd/repositories/agama_repository.dart';
import 'package:fjghrd/repositories/divisi_repository.dart';
import 'package:fjghrd/repositories/jabatan_repository.dart';
import 'package:fjghrd/repositories/karyawan_repository.dart';
import 'package:fjghrd/repositories/pendidikan_repository.dart';
import 'package:fjghrd/repositories/status_kerja_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KaryawanControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final KaryawanRepository _repo = KaryawanRepository();

  Karyawan current = Karyawan();
  List<Karyawan> listKaryawan = [];
  List<Opsi> listAgama = [];
  List<Opsi> listDivisi = [];
  List<Opsi> listJabatan = [];
  List<Opsi> listPendidikan = [];
  List<Opsi> listStatusKerja = [];
  List<KeluargaKaryawan> listKeluarga = [];
  List<KeluargaKontak> listKontak = [];
  List<PerjanjianKerja> listPerjanjianKerja = [];

  late TextEditingController txtId, txtNama, txtNik, txtTanggalMasuk, txtNomorKk,
      txtNomorKtp, txtNomorPaspor, txtTempatLahir, txtTanggalLahir, txtAlamatKtp,
      txtAlamatTinggal, txtTelepon, txtEmail, txtPendidikanAlmamater, txtPendidikanJurusan,
      txtKeluargaId, txtKeluargaNama, txtKeluargaNomorKtp, txtKeluargaTempatLahir,
      txtKeluargaTanggalLahir, txtKeluargaTelepon, txtKeluargaEmail,
      txtKontakId, txtKontakNama, txtKontakTelepon, txtKontakEmail,
      txtPerjanjianId, txtPerjanjianNomor, txtPerjanjianTglAwal, txtPerjanjianTglAkhir;

  Agama agama = Agama();
  Divisi divisi = Divisi();
  Jabatan jabatan = Jabatan();
  Pendidikan pendidikan = Pendidikan();
  StatusKerja statusKerja = StatusKerja();
  StatusKerja statusKerjaPerjanjian = StatusKerja();

  bool? kawin = false;
  String keluargaHubungan = '';

  Future<void> loadKaryawans() async {
    var hasil = await _repo.findAll();
    if (hasil.success) {
      listKaryawan.clear();
      for (var data in hasil.daftar) {
        listKaryawan.add(Karyawan.fromMap(data));
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  Future<void> loadKeluargas() async {
    listKeluarga.clear();
    var hasil = await _repo.keluargaFindAll(current.id);
    if (hasil.success) {
      for (var data in hasil.daftar) {
        listKeluarga.add(KeluargaKaryawan.fromMap(data));
      }
    } else {
      AFwidget.snackbar(hasil.message);
    }
    update();
  }

  Future<void> loadKontaks() async {
    listKontak.clear();
    var hasil = await _repo.kontakKeluargaFindAll(current.id);
    if (hasil.success) {
      for (var data in hasil.daftar) {
        listKontak.add(KeluargaKontak.fromMap(data));
      }
    } else {
      AFwidget.snackbar(hasil.message);
    }
    update();
  }

  Future<void> loadPerjanjianKerjas() async {
    listPerjanjianKerja.clear();
    var hasil = await _repo.perjanjianKerjaFindAll(current.id);
    if (hasil.success) {
      for (var data in hasil.daftar) {
        listPerjanjianKerja.add(PerjanjianKerja.fromMap(data));
      }
    } else {
      AFwidget.snackbar(hasil.message);
    }
    update();
  }

  void tambahForm(BuildContext context) {
    txtId.text = '';
    txtNama.text = '';
    txtNik.text = '';
    txtTanggalMasuk.text = AFconvert.matYMD(DateTime.now());
    txtNomorKk.text = '';
    txtNomorKtp.text = '';
    txtNomorPaspor.text = '';
    txtTempatLahir.text = '';
    txtTanggalLahir.text = AFconvert.matYMD(DateTime.now());
    txtAlamatKtp.text = '';
    txtAlamatTinggal.text = '';
    txtTelepon.text = '';
    txtEmail.text = '';
    txtPendidikanAlmamater.text = '';
    txtPendidikanJurusan.text = '';
    agama = Agama();
    divisi = Divisi();
    jabatan = Jabatan();
    pendidikan = Pendidikan();
    statusKerja = StatusKerja();
    kawin = null;
    AFwidget.dialog(
      Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
        width: 700,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Stack(
          children: [
            ListView(
              children: [
                barisForm(
                  label: 'Nama',
                  controller: txtNama,
                  paddingTop: 60,
                ),
                barisForm(
                  label: 'NIK',
                  controller: txtNik,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                          controller: txtTanggalMasuk,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(txtTanggalMasuk.text),
                            );
                            if(a != null) {
                              txtTanggalMasuk.text = AFconvert.matYMD(a);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                              value: agama.nama,
                              label: '',
                              onTap: () async {
                                var a = await pilihAgama(value: agama.id);
                                if(a != null && a.value != agama.id) {
                                  agama = Agama.fromMap(a.data!);
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
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                              value: divisi.nama,
                              label: '',
                              onTap: () async {
                                var a = await pilihDivisi(value: divisi.id);
                                if(a != null && a.value != divisi.id) {
                                  divisi = Divisi.fromMap(a.data!);
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
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                              value: jabatan.nama,
                              label: '',
                              onTap: () async {
                                var a = await pilihJabatan(value: jabatan.id);
                                if(a != null && a.value != jabatan.id) {
                                  jabatan = Jabatan.fromMap(a.data!);
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
                barisForm(
                  label: 'Nomor KK',
                  controller: txtNomorKk,
                ),
                barisForm(
                  label: 'Nomor KTP',
                  controller: txtNomorKtp,
                ),
                barisForm(
                  label: 'Nomor Paspor',
                  controller: txtNomorPaspor,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                          controller: txtTempatLahir,
                        ),
                      ),
                      Container(
                        width: 165,
                        margin: const EdgeInsets.only(left: 15),
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: txtTanggalLahir,
                          readOnly: true,
                          prefixIcon: const Icon(Icons.calendar_month),
                          ontap: () async {
                            var a = await AFwidget.pickDate(
                              context: context,
                              initialDate: AFconvert.keTanggal(txtTanggalLahir.text),
                            );
                            if(a != null) {
                              txtTanggalLahir.text = AFconvert.matYMD(a);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15, top: 15),
                        child: const Text('Alamat KTP'),
                      ),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: txtAlamatKtp,
                          maxLines: 4,
                          minLines: 2,
                          keyboard: TextInputType.multiline,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15, top: 15),
                        child: const Text('Alamat Tinggal Sekarang'),
                      ),
                      Expanded(
                        child: AFwidget.textField(
                          marginTop: 0,
                          controller: txtAlamatTinggal,
                          maxLines: 4,
                          minLines: 2,
                          keyboard: TextInputType.multiline,
                        ),
                      ),
                    ],
                  ),
                ),
                barisForm(
                  label: 'No. Telepon',
                  controller: txtTelepon,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                            return Row(
                              children: [
                                Radio<bool>(
                                  value: true,
                                  groupValue: kawin,
                                  onChanged: (a) {
                                    if(a != null && a != kawin) {
                                      kawin = a;
                                      update();
                                    }
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                  child: Text('Kawin'),
                                ),
                                Radio<bool>(
                                  value: false,
                                  groupValue: kawin,
                                  onChanged: (a) {
                                    if(a != null && a != kawin) {
                                      kawin = a;
                                      update();
                                    }
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text('Single'),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                              value: pendidikan.nama,
                              label: '',
                              onTap: () async {
                                var a = await pilihPendidikan(value: pendidikan.id);
                                if(a != null && a.value != pendidikan.id) {
                                  pendidikan = Pendidikan.fromMap(a.data!);
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
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                          controller: txtPendidikanAlmamater,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                          controller: txtPendidikanJurusan,
                        ),
                      ),
                    ],
                  ),
                ),
                barisForm(
                  label: 'Email Pribadi',
                  controller: txtEmail,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                              value: statusKerja.nama,
                              label: '',
                              onTap: () async {
                                var a = await pilihStatusKerja(value: statusKerja.id);
                                if(a != null && a.value != statusKerja.id) {
                                  statusKerja = StatusKerja.fromMap(a.data!);
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
                  padding: const EdgeInsets.fromLTRB(0, 25, 20, 0),
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
                        onPressed: tambahData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 55,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                ),
              ),
              child: const Text('Form Tambah Karyawan',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void ubahForm(String id) {
    current = listKaryawan.where((element) => element.id == id).first;
    txtId.text = current.id;
    txtNama.text = current.nama;
    txtNik.text = current.nik;
    txtTanggalMasuk.text = AFconvert.matYMD(current.tanggalMasuk);
    txtNomorKk.text = current.nomorKk;
    txtNomorKtp.text = current.nomorKtp;
    txtNomorPaspor.text = current.nomorPaspor;
    txtTempatLahir.text = current.tempatLahir;
    txtTanggalLahir.text = AFconvert.matYMD(current.tanggalLahir);
    txtAlamatKtp.text = current.alamatKtp;
    txtAlamatTinggal.text = current.alamatTinggal;
    txtTelepon.text = current.telepon;
    txtEmail.text = current.email;
    txtPendidikanAlmamater.text = current.pendidikanAlmamater;
    txtPendidikanJurusan.text = current.pendidikanJurusan;
    agama = current.agama;
    divisi = current.divisi;
    jabatan = current.jabatan;
    pendidikan = current.pendidikan;
    statusKerja = current.statusKerja;
    kawin = current.kawin;
    loadKeluargas();
    loadKontaks();
    loadPerjanjianKerjas();
    Get.toNamed(Rute.karyawanForm);
  }

  void hapusForm() {
    AFwidget.formHapus(
      label: 'karyawan ${current.nama}',
      aksi: () {
        hapusData(current.id);
      },
    );
  }

  void tambahKeluargaForm(BuildContext context) {
    txtKeluargaId.text = '';
    txtKeluargaNama.text = '';
    txtKeluargaNomorKtp.text = '';
    txtKeluargaTempatLahir.text = '';
    txtKeluargaTanggalLahir.text = AFconvert.matYMD(DateTime.now());
    txtKeluargaTelepon.text = '';
    txtKeluargaEmail.text = '';
    keluargaHubungan = '';
    AFwidget.dialog(
      Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
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
                  padding: const EdgeInsets.fromLTRB(0, 60, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Nama Karyawan'),
                      ),
                      Expanded(
                        child: Text(': ${current.nama}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                barisForm(
                  label: 'Nama',
                  controller: txtKeluargaNama,
                ),
                barisForm(
                  label: 'Nomor KTP',
                  controller: txtKeluargaNomorKtp,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                            return Row(
                              children: [
                                Radio<String>(
                                  value: 'S',
                                  groupValue: keluargaHubungan,
                                  onChanged: (a) {
                                    if(a != null && a != keluargaHubungan) {
                                      keluargaHubungan = a;
                                      update();
                                    }
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                  child: Text('Suami'),
                                ),
                                Radio<String>(
                                  value: 'I',
                                  groupValue: keluargaHubungan,
                                  onChanged: (a) {
                                    if(a != null && a != keluargaHubungan) {
                                      keluargaHubungan = a;
                                      update();
                                    }
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                  child: Text('Istri'),
                                ),
                                Radio<String>(
                                  value: 'A',
                                  groupValue: keluargaHubungan,
                                  onChanged: (a) {
                                    if(a != null && a != keluargaHubungan) {
                                      keluargaHubungan = a;
                                      update();
                                    }
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text('Anak'),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                barisForm(
                  label: 'No. Telepon',
                  controller: txtKeluargaTelepon,
                ),
                barisForm(
                  label: 'Email Pribadi',
                  controller: txtKeluargaEmail,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
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
                        onPressed: tambahKeluargaData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 55,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                ),
              ),
              child: const Text('Form Tambah Anggota Keluarga',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void ubahKeluargaForm(String id, BuildContext context) {
    var item = listKeluarga.where((element) => element.id == id).first;
    txtKeluargaId.text = item.id;
    txtKeluargaNama.text = item.nama;
    txtKeluargaNomorKtp.text = item.nomorKtp;
    txtKeluargaTempatLahir.text = item.tempatLahir;
    txtKeluargaTanggalLahir.text = AFconvert.matYMD(item.tanggalLahir);
    txtKeluargaTelepon.text = item.telepon;
    txtKeluargaEmail.text = item.email;
    keluargaHubungan = item.hubungan;
    AFwidget.dialog(
      Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
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
                  padding: const EdgeInsets.fromLTRB(0, 60, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Nama Karyawan'),
                      ),
                      Expanded(
                        child: Text(': ${current.nama}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                barisForm(
                  label: 'Nama',
                  controller: txtKeluargaNama,
                ),
                barisForm(
                  label: 'Nomor KTP',
                  controller: txtKeluargaNomorKtp,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                            return Row(
                              children: [
                                Radio<String>(
                                  value: 'S',
                                  groupValue: keluargaHubungan,
                                  onChanged: (a) {
                                    if(a != null && a != keluargaHubungan) {
                                      keluargaHubungan = a;
                                      update();
                                    }
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                  child: Text('Suami'),
                                ),
                                Radio<String>(
                                  value: 'I',
                                  groupValue: keluargaHubungan,
                                  onChanged: (a) {
                                    if(a != null && a != keluargaHubungan) {
                                      keluargaHubungan = a;
                                      update();
                                    }
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                  child: Text('Istri'),
                                ),
                                Radio<String>(
                                  value: 'A',
                                  groupValue: keluargaHubungan,
                                  onChanged: (a) {
                                    if(a != null && a != keluargaHubungan) {
                                      keluargaHubungan = a;
                                      update();
                                    }
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text('Anak'),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                barisForm(
                  label: 'No. Telepon',
                  controller: txtKeluargaTelepon,
                ),
                barisForm(
                  label: 'Email Pribadi',
                  controller: txtKeluargaEmail,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AFwidget.tombol(
                        label: 'Hapus',
                        color: Colors.red,
                        onPressed: () {
                          hapusKeluargaForm(item);
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
                        onPressed: ubahKeluargaData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 55,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                ),
              ),
              child: const Text('Form Ubah Anggota Keluarga',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void hapusKeluargaForm(KeluargaKaryawan item) {
    AFwidget.formHapus(
      label: 'keluarga bernama ${item.nama}',
      aksi: () {
        hapusKeluargaData(item.id);
      },
    );
  }

  void tambahKontakForm(BuildContext context) {
    txtKontakId.text = '';
    txtKontakNama.text = '';
    txtKontakTelepon.text = '';
    txtKontakEmail.text = '';
    AFwidget.dialog(
      Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
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
                  padding: const EdgeInsets.fromLTRB(0, 60, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Nama Karyawan'),
                      ),
                      Expanded(
                        child: Text(': ${current.nama}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                barisForm(
                  label: 'No. Telepon',
                  controller: txtKontakTelepon,
                ),
                barisForm(
                  label: 'Keterangan',
                  controller: txtKontakNama,
                ),
                barisForm(
                  label: 'Email Pribadi',
                  controller: txtKontakEmail,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
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
                        onPressed: tambahKontakData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 55,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                ),
              ),
              child: const Text('Form Tambah Kontak Keluarga',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void ubahKontakForm(String id, BuildContext context) {
    var item = listKontak.where((element) => element.id == id).first;
    txtKontakId.text = item.id;
    txtKontakNama.text = item.nama;
    txtKontakTelepon.text = item.telepon;
    txtKontakEmail.text = item.email;
    AFwidget.dialog(
      Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
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
                  padding: const EdgeInsets.fromLTRB(0, 60, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Nama Karyawan'),
                      ),
                      Expanded(
                        child: Text(': ${current.nama}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                barisForm(
                  label: 'No. Telepon',
                  controller: txtKontakTelepon,
                ),
                barisForm(
                  label: 'Keterangan',
                  controller: txtKontakNama,
                ),
                barisForm(
                  label: 'Email Pribadi',
                  controller: txtKontakEmail,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AFwidget.tombol(
                        label: 'Hapus',
                        color: Colors.red,
                        onPressed: () {
                          hapusKontakForm(item);
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
                        onPressed: ubahKontakData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 55,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                ),
              ),
              child: const Text('Form Ubah Kontak Keluarga',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void hapusKontakForm(KeluargaKontak item) {
    AFwidget.formHapus(
      label: 'kontak keluarga ${item.telepon} (${item.nama})',
      aksi: () {
        hapusKontakData(item.id);
      },
    );
  }

  void tambahPerjanjianForm(BuildContext context) {
    txtPerjanjianId.text = '';
    txtPerjanjianNomor.text = '';
    txtPerjanjianTglAwal.text = AFconvert.matYMD(DateTime.now());
    txtPerjanjianTglAkhir.text = '';
    statusKerjaPerjanjian = StatusKerja();
    AFwidget.dialog(
      Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
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
                  padding: const EdgeInsets.fromLTRB(0, 60, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Nama Karyawan'),
                      ),
                      Expanded(
                        child: Text(': ${current.nama}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                barisForm(
                  label: 'Nomor',
                  controller: txtPerjanjianNomor,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                  padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
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
                        onPressed: tambahPerjanjianData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 55,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                ),
              ),
              child: const Text('Form Tambah Perjanjian Kerja',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void ubahPerjanjianForm(String id, BuildContext context) {
    var item = listPerjanjianKerja.where((element) => element.id == id).first;
    txtPerjanjianId.text = item.id;
    txtPerjanjianNomor.text = item.nomor;
    txtPerjanjianTglAwal.text = AFconvert.matYMD(item.tanggalAwal);
    txtPerjanjianTglAkhir.text = AFconvert.matYMD(item.tanggalAKhir);
    statusKerjaPerjanjian = item.statusKerja;
    AFwidget.dialog(
      Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 15),
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
                  padding: const EdgeInsets.fromLTRB(0, 60, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Nama Karyawan'),
                      ),
                      Expanded(
                        child: Text(': ${current.nama}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                barisForm(
                  label: 'Nomor',
                  controller: txtPerjanjianNomor,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 11, 20, 0),
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
                  padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AFwidget.tombol(
                        label: 'Hapus',
                        color: Colors.red,
                        onPressed: () {
                          hapusPerjanjianForm(item);
                        },
                        minimumSize: const Size(120, 40),
                      ),
                      Spacer(),
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
                        onPressed: ubahPerjanjianData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 55,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                ),
              ),
              child: const Text('Form Ubah Perjanjian Kerja',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void hapusPerjanjianForm(PerjanjianKerja item) {
    AFwidget.formHapus(
      label: 'perjanjian kerja dengan nomor ${item.nomor}',
      aksi: () {
        hapusPerjanjianData(item.id);
      },
    );
  }

  Future<void> tambahData() async {
    try {
      if(txtNama.text.isEmpty) {
        throw 'Nama harus diisi';
      }
      if(txtNomorKtp.text.isEmpty) {
        throw 'Nomor KTP harus diisi';
      }
      if(txtTanggalMasuk.text.isEmpty) {
        throw 'Masa kerja harus diisi';
      }
      if(agama.id == '') {
        throw 'Silakan pilih agama';
      }
      if(divisi.id == '') {
        throw 'Silakan pilih divisi';
      }
      if(jabatan.id == '') {
        throw 'Silakan pilih jabatan';
      }
      if(txtTempatLahir.text.isEmpty || txtTanggalLahir.text.isEmpty) {
        throw 'Tempat & tanggal lahir harus diisi';
      }
      if(txtAlamatKtp.text.isEmpty) {
        throw 'Alamat sesuai KTP harus diisi';
      }
      if(txtTelepon.text.isEmpty) {
        throw 'Nomor telepon harus diisi';
      }
      if(kawin == null) {
        throw 'Silakan isi status kawin';
      }
      if(pendidikan.id == '') {
        throw 'Silakan pilih pendidikan terakhir';
      }
      if(statusKerja.id == '') {
        throw 'Silakan pilih status karyawan';
      }
      var a = Karyawan(
        nama: txtNama.text,
        nik: txtNik.text,
        nomorKtp: txtNomorKtp.text,
        tanggalMasuk: AFconvert.keTanggal('${txtTanggalMasuk.text} 08:00:00'),
        tempatLahir: txtTempatLahir.text,
        tanggalLahir: AFconvert.keTanggal('${txtTanggalLahir.text} 08:00:00'),
        alamatKtp: txtAlamatKtp.text,
        alamatTinggal: txtAlamatTinggal.text,
        telepon: txtTelepon.text,
        email: txtEmail.text,
        kawin: kawin ?? false,
        nomorKk: txtNomorKk.text,
        nomorPaspor: txtNomorPaspor.text,
        pendidikanAlmamater: txtPendidikanAlmamater.text,
        pendidikanJurusan: txtPendidikanJurusan.text,
      );
      a.agama = agama;
      a.jabatan = jabatan;
      a.divisi = divisi;
      a.pendidikan = pendidikan;
      a.statusKerja = statusKerja;

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadKaryawans();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> ubahData() async {
    try {
      if(txtId.text.isEmpty) {
        throw 'ID harus diisi';
      }
      if(txtNama.text.isEmpty) {
        throw 'Nama harus diisi';
      }
      if(txtNomorKtp.text.isEmpty) {
        throw 'Nomor KTP harus diisi';
      }
      if(txtTanggalMasuk.text.isEmpty) {
        throw 'Masa kerja harus diisi';
      }
      if(agama.id == '') {
        throw 'Silakan pilih agama';
      }
      if(divisi.id == '') {
        throw 'Silakan pilih divisi';
      }
      if(jabatan.id == '') {
        throw 'Silakan pilih jabatan';
      }
      if(txtTempatLahir.text.isEmpty || txtTanggalLahir.text.isEmpty) {
        throw 'Tempat & tanggal lahir harus diisi';
      }
      if(txtAlamatKtp.text.isEmpty) {
        throw 'Alamat sesuai KTP harus diisi';
      }
      if(txtTelepon.text.isEmpty) {
        throw 'Nomor telepon harus diisi';
      }
      if(kawin == null) {
        throw 'Silakan isi status kawin';
      }
      if(pendidikan.id == '') {
        throw 'Silakan pilih pendidikan terakhir';
      }
      if(statusKerja.id == '') {
        throw 'Silakan pilih status karyawan';
      }
      var a = Karyawan(
        id: txtId.text,
        nama: txtNama.text,
        nik: txtNik.text,
        nomorKtp: txtNomorKtp.text,
        tanggalMasuk: AFconvert.keTanggal('${txtTanggalMasuk.text} 08:00:00'),
        tempatLahir: txtTempatLahir.text,
        tanggalLahir: AFconvert.keTanggal('${txtTanggalLahir.text} 08:00:00'),
        alamatKtp: txtAlamatKtp.text,
        alamatTinggal: txtAlamatTinggal.text,
        telepon: txtTelepon.text,
        email: txtEmail.text,
        kawin: kawin ?? false,
        nomorKk: txtNomorKk.text,
        nomorPaspor: txtNomorPaspor.text,
        pendidikanAlmamater: txtPendidikanAlmamater.text,
        pendidikanJurusan: txtPendidikanJurusan.text,
      );
      a.agama = agama;
      a.jabatan = jabatan;
      a.divisi = divisi;
      a.pendidikan = pendidikan;
      a.statusKerja = statusKerja;

      AFwidget.loading();
      var hasil = await _repo.update(a.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadKaryawans();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> hapusData(String id) async {
    try {
      if(id == '') {
        throw 'ID Karyawan null';
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadKaryawans();
        Get.back();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> tambahKeluargaData() async {
    try {
      if(current.id.isEmpty) {
        throw 'ID Karyawan tidak ditemukan';
      }
      if(txtKeluargaNama.text.isEmpty) {
        throw 'Nama harus diisi';
      }
      if(keluargaHubungan == '') {
        throw 'Silakan pilih hubungan keluarga dengan karyawan';
      }
      if(txtTempatLahir.text.isEmpty || txtTanggalLahir.text.isEmpty) {
        throw 'Tempat & tanggal lahir harus diisi';
      }
      var a = KeluargaKaryawan(
        nama: txtKeluargaNama.text,
        nomorKtp: txtKeluargaNomorKtp.text,
        tempatLahir: txtKeluargaTempatLahir.text,
        tanggalLahir: AFconvert.keTanggal('${txtKeluargaTanggalLahir.text} 08:00:00'),
        telepon: txtKeluargaTelepon.text,
        email: txtKeluargaEmail.text,
        hubungan: keluargaHubungan,
      );
      a.karyawan = current;

      AFwidget.loading();
      var hasil = await _repo.keluargaCreate(a.karyawan.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadKeluargas();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> ubahKeluargaData() async {
    try {
      if(current.id.isEmpty) {
        throw 'ID Karyawan tidak ditemukan';
      }
      if(txtKeluargaId.text.isEmpty) {
        throw 'ID anggota keluarga tidak ditemukan';
      }
      if(txtKeluargaNama.text.isEmpty) {
        throw 'Nama harus diisi';
      }
      if(keluargaHubungan == '') {
        throw 'Silakan pilih hubungan keluarga dengan karyawan';
      }
      if(txtTempatLahir.text.isEmpty || txtTanggalLahir.text.isEmpty) {
        throw 'Tempat & tanggal lahir harus diisi';
      }
      var a = KeluargaKaryawan(
        id: txtKeluargaId.text,
        nama: txtKeluargaNama.text,
        nomorKtp: txtKeluargaNomorKtp.text,
        tempatLahir: txtKeluargaTempatLahir.text,
        tanggalLahir: AFconvert.keTanggal('${txtKeluargaTanggalLahir.text} 08:00:00'),
        telepon: txtKeluargaTelepon.text,
        email: txtKeluargaEmail.text,
        hubungan: keluargaHubungan,
      );
      a.karyawan = current;

      AFwidget.loading();
      var hasil = await _repo.keluargaUpdate(a.karyawan.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadKeluargas();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> hapusKeluargaData(String keluargaId) async {
    try {
      if(current.id == '') {
        throw 'ID karyawan null';
      }
      if(keluargaId == '') {
        throw 'ID keluarga null';
      }
      AFwidget.loading();
      var hasil = await _repo.keluargaDelete(current.id, keluargaId);
      Get.back();
      if(hasil.success) {
        loadKeluargas();
        Get.back();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> tambahKontakData() async {
    try {
      if(current.id.isEmpty) {
        throw 'ID Karyawan tidak ditemukan';
      }
      if(txtKontakTelepon.text.isEmpty) {
        throw 'Nomor Telepon harus diisi';
      }
      if(txtKontakNama.text.isEmpty) {
        throw 'Keterangan harus diisi';
      }
      var a = KeluargaKontak(
        nama: txtKontakNama.text,
        telepon: txtKontakTelepon.text,
        email: txtKontakEmail.text,
      );
      a.karyawan = current;

      AFwidget.loading();
      var hasil = await _repo.kontakKeluargaCreate(a.karyawan.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadKontaks();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> ubahKontakData() async {
    try {
      if(current.id.isEmpty) {
        throw 'ID Karyawan tidak ditemukan';
      }
      if(txtKontakId.text.isEmpty) {
        throw 'ID kontak keluarga tidak ditemukan';
      }
      if(txtKontakTelepon.text.isEmpty) {
        throw 'Nomor Telepon harus diisi';
      }
      if(txtKontakNama.text.isEmpty) {
        throw 'Keterangan harus diisi';
      }
      var a = KeluargaKontak(
        id: txtKontakId.text,
        nama: txtKontakNama.text,
        telepon: txtKeluargaTelepon.text,
        email: txtKeluargaEmail.text,
      );
      a.karyawan = current;

      AFwidget.loading();
      var hasil = await _repo.kontakKeluargaUpdate(a.karyawan.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadKontaks();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> hapusKontakData(String kontakId) async {
    try {
      if(current.id == '') {
        throw 'ID karyawan null';
      }
      if(kontakId == '') {
        throw 'ID kontak keluarga null';
      }
      AFwidget.loading();
      var hasil = await _repo.kontakKeluargaDelete(current.id, kontakId);
      Get.back();
      if(hasil.success) {
        loadKontaks();
        Get.back();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> tambahPerjanjianData() async {
    try {
      if(current.id.isEmpty) {
        throw 'ID Karyawan tidak ditemukan';
      }
      if(txtPerjanjianNomor.text.isEmpty) {
        throw 'Nomor perjanjian kerja harus diisi';
      }
      if(txtPerjanjianTglAwal.text.isEmpty) {
        throw 'Tanggal awal harus diisi';
      }
      if(statusKerjaPerjanjian.id == '') {
        throw 'Silakan pilih status';
      }

      var a = PerjanjianKerja(
        nomor: txtPerjanjianNomor.text,
        tanggalAwal: AFconvert.keTanggal('${txtPerjanjianTglAwal.text} 08:00:00'),
        tanggalAKhir: txtPerjanjianTglAkhir.text.isNotEmpty ? AFconvert.keTanggal('${txtPerjanjianTglAkhir.text} 08:00:00') : null,
      );
      a.karyawan = current;
      a.statusKerja = statusKerjaPerjanjian;

      AFwidget.loading();
      var hasil = await _repo.perjanjianKerjaCreate(a.karyawan.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadPerjanjianKerjas();
        Get.back();
      }
      print(hasil.message);
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> ubahPerjanjianData() async {
    try {
      if(current.id.isEmpty) {
        throw 'ID Karyawan tidak ditemukan';
      }
      if(txtPerjanjianId.text.isEmpty) {
        throw 'ID perjanjian kerja tidak ditemukan';
      }
      if(txtPerjanjianNomor.text.isEmpty) {
        throw 'Nomor perjanjian kerja harus diisi';
      }
      if(txtPerjanjianTglAwal.text.isEmpty) {
        throw 'Tanggal awal harus diisi';
      }
      if(statusKerjaPerjanjian.id == '') {
        throw 'Silakan pilih status';
      }

      var a = PerjanjianKerja(
        id: txtPerjanjianId.text,
        nomor: txtPerjanjianNomor.text,
        tanggalAwal: AFconvert.keTanggal('${txtPerjanjianTglAwal.text} 08:00:00'),
        tanggalAKhir: txtPerjanjianTglAkhir.text.isNotEmpty ? AFconvert.keTanggal('${txtPerjanjianTglAkhir.text} 08:00:00') : null,
      );
      a.karyawan = current;
      a.statusKerja = statusKerjaPerjanjian;

      AFwidget.loading();
      var hasil = await _repo.perjanjianKerjaUpdate(a.karyawan.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadPerjanjianKerjas();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> hapusPerjanjianData(String perjanjianKerjaid) async {
    try {
      if(current.id == '') {
        throw 'ID karyawan null';
      }
      if(perjanjianKerjaid == '') {
        throw 'ID perjanjian kerja null';
      }
      AFwidget.loading();
      var hasil = await _repo.perjanjianKerjaDelete(current.id, perjanjianKerjaid);
      Get.back();
      if(hasil.success) {
        loadPerjanjianKerjas();
        Get.back();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> loadAgamas() async {
    AgamaRepository repoAgama = AgamaRepository();
    var hasil = await repoAgama.findAll();
    if(hasil.success) {
      listAgama.clear();
      for (var data in hasil.daftar) {
        listAgama.add(
          Opsi(value: AFconvert.keString(data['id']), label: data['nama'], data: data),
        );
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  Future<void> loadDivisis() async {
    DivisiRepository repo = DivisiRepository();
    var hasil = await repo.findAll();
    if(hasil.success) {
      listDivisi.clear();
      for (var data in hasil.daftar) {
        listDivisi.add(
          Opsi(value: AFconvert.keString(data['id']), label: data['nama'], data: data),
        );
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  Future<void> loadJabatans() async {
    JabatanRepository repo = JabatanRepository();
    var hasil = await repo.findAll();
    if(hasil.success) {
      listJabatan.clear();
      for (var data in hasil.daftar) {
        listJabatan.add(
          Opsi(value: AFconvert.keString(data['id']), label: data['nama'], data: data),
        );
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  Future<void> loadPendidikans() async {
    PendidikanRepository repo = PendidikanRepository();
    var hasil = await repo.findAll();
    if(hasil.success) {
      listPendidikan.clear();
      for (var data in hasil.daftar) {
        listPendidikan.add(
          Opsi(value: AFconvert.keString(data['id']), label: data['nama'], data: data),
        );
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  Future<void> loadStatusKerjas() async {
    StatusKerjaRepository repo = StatusKerjaRepository();
    var hasil = await repo.findAll();
    if(hasil.success) {
      listStatusKerja.clear();
      for (var data in hasil.daftar) {
        listStatusKerja.add(
          Opsi(value: AFconvert.keString(data['id']), label: data['nama'], data: data),
        );
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  Future<Opsi?> pilihAgama({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listAgama,
      valueSelected: value,
      judul: 'Pilih Agama',
    );
    return a;
  }

  Future<Opsi?> pilihDivisi({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listDivisi,
      valueSelected: value,
      judul: 'Pilih Divisi',
    );
    return a;
  }

  Future<Opsi?> pilihJabatan({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listJabatan,
      valueSelected: value,
      judul: 'Pilih Jabatan',
    );
    return a;
  }

  Future<Opsi?> pilihPendidikan({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listPendidikan,
      valueSelected: value,
      judul: 'Pilih Pendidikan',
    );
    return a;
  }

  Future<Opsi?> pilihStatusKerja({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listStatusKerja,
      valueSelected: value,
      judul: 'Pilih Status Karyawan',
    );
    return a;
  }

  Widget barisForm({
    String label = '',
    TextEditingController? controller,
    double paddingTop = 11,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, paddingTop, 20, 0),
      child: Row(
        children: [
          Container(
            width: 150,
            padding: const EdgeInsets.only(right: 15),
            child: Text(label),
          ),
          Expanded(
            child: AFwidget.textField(
              marginTop: 0,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onInit() {
    txtId = TextEditingController();
    txtNama = TextEditingController();
    txtNik = TextEditingController();
    txtTanggalMasuk = TextEditingController();
    txtNomorKk = TextEditingController();
    txtNomorKtp = TextEditingController();
    txtNomorPaspor = TextEditingController();
    txtTempatLahir = TextEditingController();
    txtTanggalLahir = TextEditingController();
    txtAlamatKtp = TextEditingController();
    txtAlamatTinggal = TextEditingController();
    txtTelepon = TextEditingController();
    txtEmail = TextEditingController();
    txtPendidikanAlmamater = TextEditingController();
    txtPendidikanJurusan = TextEditingController();
    txtKeluargaId = TextEditingController();
    txtKeluargaNama = TextEditingController();
    txtKeluargaNomorKtp = TextEditingController();
    txtKeluargaTempatLahir = TextEditingController();
    txtKeluargaTanggalLahir = TextEditingController();
    txtKeluargaTelepon = TextEditingController();
    txtKeluargaEmail = TextEditingController();
    txtKontakId = TextEditingController();
    txtKontakNama = TextEditingController();
    txtKontakTelepon = TextEditingController();
    txtKontakEmail = TextEditingController();
    txtPerjanjianId = TextEditingController();
    txtPerjanjianNomor = TextEditingController();
    txtPerjanjianTglAwal = TextEditingController();
    txtPerjanjianTglAkhir = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtNama.dispose();
    txtNik.dispose();
    txtTanggalMasuk.dispose();
    txtNomorKk.dispose();
    txtNomorKtp.dispose();
    txtNomorPaspor.dispose();
    txtTempatLahir.dispose();
    txtTanggalLahir.dispose();
    txtAlamatKtp.dispose();
    txtAlamatTinggal.dispose();
    txtTelepon.dispose();
    txtEmail.dispose();
    txtPendidikanAlmamater.dispose();
    txtPendidikanJurusan.dispose();
    txtKeluargaId.dispose();
    txtKeluargaNama.dispose();
    txtKeluargaNomorKtp.dispose();
    txtKeluargaTempatLahir.dispose();
    txtKeluargaTanggalLahir.dispose();
    txtKeluargaTelepon.dispose();
    txtKeluargaEmail.dispose();
    txtKontakId.dispose();
    txtKontakNama.dispose();
    txtKontakTelepon.dispose();
    txtKontakEmail.dispose();
    txtPerjanjianId.dispose();
    txtPerjanjianNomor.dispose();
    txtPerjanjianTglAwal.dispose();
    txtPerjanjianTglAkhir.dispose();
    super.onClose();
  }
}
