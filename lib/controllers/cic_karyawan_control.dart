import 'package:fjghrd/models/agama.dart';
import 'package:fjghrd/models/area.dart';
import 'package:fjghrd/models/divisi.dart';
import 'package:fjghrd/models/jabatan.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/pendidikan.dart';
import 'package:fjghrd/models/status_kerja.dart';
import 'package:fjghrd/models/ptkp.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class CicKaryawanControl extends GetxController {
  List<Karyawan> listData = [];
  String filterNama = '';
  final DateTime _now = DateTime.now();

  late TextEditingController txtId, txtNama, txtNik, txtNomorKtp, txtTempatLahir, txtTanggalLahir;
  late TextEditingController txtTanggalMasuk, txtTanggalKeluar, txtAlamatKtp, txtAlamatTinggal;
  late TextEditingController txtTelepon, txtEmail, txtPendidikanAlmamater, txtPendidikanJurusan;
  late TextEditingController txtNomorKk, txtNomorPaspor, txtNomorPwp;
  
  Agama agama = Agama();
  Area area = Area();
  Divisi divisi = Divisi();
  Jabatan jabatan = Jabatan();
  Pendidikan pendidikan = Pendidikan();
  StatusKerja statusKerja = StatusKerja();
  Ptkp ptkp = Ptkp();
  
  String kawin = '';
  String kelamin = '';
  String aktif = '';
  bool? staf;
  bool manajemen = false;

  Future<void> loadData() async {
    var hasil = await AFdatabase.send(url: 'cic/karyawan', methodeRequest: MethodeRequest.get);
    if(hasil.success) {
      listData = hasil.daftar.map((e) => Karyawan.fromMap(e)).toList();
      update();
    } else {
      AFwidget.formWarning(label: hasil.message);
    }
  }

  void formCicKaryawan(String id, BuildContext context) {
    txtId.text = id;
    if(id.isEmpty) {
      txtNama.text = ''; txtNik.text = ''; txtNomorKtp.text = ''; txtTempatLahir.text = '';
      txtTanggalLahir.text = AFconvert.matYMD(_now); txtTanggalMasuk.text = AFconvert.matYMD(_now);
      txtTanggalKeluar.text = ''; txtAlamatKtp.text = ''; txtAlamatTinggal.text = '';
      txtTelepon.text = ''; txtEmail.text = ''; txtPendidikanAlmamater.text = ''; txtPendidikanJurusan.text = '';
      txtNomorKk.text = ''; txtNomorPaspor.text = ''; txtNomorPwp.text = '';
      agama = Agama(); area = Area(); divisi = Divisi(); jabatan = Jabatan();
      pendidikan = Pendidikan(); statusKerja = StatusKerja(); ptkp = Ptkp();
      kawin = ''; kelamin = ''; aktif = ''; staf = null; manajemen = false;
    } else {
      var current = listData.firstWhere((e) => e.id == id);
      txtNama.text = current.nama;
      txtNik.text = current.nik;
      txtTanggalMasuk.text = AFconvert.matYMD(current.tanggalMasuk);
      txtTanggalKeluar.text = AFconvert.matYMD(current.tanggalKeluar);
      txtNomorKk.text = current.nomorKk;
      txtNomorKtp.text = current.nomorKtp;
      txtNomorPaspor.text = current.nomorPaspor;
      txtNomorPwp.text = current.nomorPwp;
      txtTempatLahir.text = current.tempatLahir;
      txtTanggalLahir.text = AFconvert.matYMD(current.tanggalLahir);
      txtAlamatKtp.text = current.alamatKtp;
      txtAlamatTinggal.text = current.alamatTinggal;
      txtTelepon.text = current.telepon;
      txtEmail.text = current.email;
      txtPendidikanAlmamater.text = current.pendidikanAlmamater;
      txtPendidikanJurusan.text = current.pendidikanJurusan;
      agama = current.agama;
      area = current.area;
      divisi = current.divisi;
      jabatan = current.jabatan;
      pendidikan = current.pendidikan;
      statusKerja = current.statusKerja;
      ptkp = current.ptkp;
      kawin = current.kawin;
      kelamin = current.kelamin;
      aktif = current.aktif;
      staf = current.staf;
      manajemen = current.manajemen;
    }
    
    

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
                        child: GetBuilder<CicKaryawanControl>(init: this, 
                          builder: (_) {
                            return AFwidget.comboField(
                              value: area.nama,
                              label: '',
                              onTap: () async {
                                var a = await pilihArea(value: area.id);
                                if(a != null && a.value != area.id) {
                                  area = Area.fromMap(a.data!);
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
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Jenis Karyawan'),
                      ),
                      Expanded(
                        child: GetBuilder<CicKaryawanControl>(init: this, 
                          builder: (_) {
                            return RadioGroup<bool>(
                              groupValue: staf,
                              onChanged: (a) {
                                if(a != null && a != staf) {
                                  staf = a;
                                  update();
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
                        child: GetBuilder<CicKaryawanControl>(init: this, 
                          builder: (_) {
                            return RadioGroup<bool>(
                              groupValue: manajemen,
                              onChanged: (a) {
                                if(a != null && a != manajemen) {
                                  manajemen = a;
                                  update();
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
                        child: GetBuilder<CicKaryawanControl>(init: this, 
                          builder: (_) {
                            return RadioGroup<String>(
                              groupValue: aktif,
                              onChanged: (a) {
                                if(a != null && a != aktif) {
                                  aktif = a;
                                  update();
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
                  controller: txtNama,
                ),
                AFwidget.barisText(
                  label: 'NIK',
                  controller: txtNik,
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
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Agama'),
                      ),
                      Expanded(
                        child: GetBuilder<CicKaryawanControl>(init: this, 
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
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Divisi'),
                      ),
                      Expanded(
                        child: GetBuilder<CicKaryawanControl>(init: this, 
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
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Jabatan'),
                      ),
                      Expanded(
                        child: GetBuilder<CicKaryawanControl>(init: this, 
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
                AFwidget.barisText(
                  label: 'Nomor KK',
                  controller: txtNomorKk,
                ),
                AFwidget.barisText(
                  label: 'Nomor KTP',
                  controller: txtNomorKtp,
                ),
                AFwidget.barisText(
                  label: 'Nomor Paspor',
                  controller: txtNomorPaspor,
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
                AFwidget.barisText(
                  label: 'Alamat KTP',
                  controller: txtAlamatKtp,
                  isTextArea: true,
                ),
                AFwidget.barisText(
                  label: 'Alamat Tinggal Sekarang',
                  controller: txtAlamatTinggal,
                  isTextArea: true,
                ),
                AFwidget.barisText(
                  label: 'No. Telepon',
                  controller: txtTelepon,
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
                        child: GetBuilder<CicKaryawanControl>(init: this, 
                          builder: (_) {
                            return RadioGroup(
                              groupValue: kelamin,
                              onChanged: (a) {
                                if(a != null && a != kelamin) {
                                  kelamin = a;
                                  update();
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
                        child: GetBuilder<CicKaryawanControl>(init: this, 
                          builder: (_) {
                            return RadioGroup<String>(
                              groupValue: kawin,
                              onChanged: (a) {
                                if(a != null && a != kawin) {
                                  kawin = a;
                                  update();
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
                        child: GetBuilder<CicKaryawanControl>(init: this, 
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
                          controller: txtPendidikanAlmamater,
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
                          controller: txtPendidikanJurusan,
                        ),
                      ),
                    ],
                  ),
                ),
                AFwidget.barisText(
                  label: 'Email Pribadi',
                  controller: txtEmail,
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
                        child: GetBuilder<CicKaryawanControl>(init: this, 
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
                AFwidget.barisText(
                  label: 'NPWP',
                  controller: txtNomorPwp,
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
                          child: GetBuilder<CicKaryawanControl>(init: this, 
                            builder: (_) {
                              return AFwidget.comboField(
                                value: ptkp.kode,
                                label: '',
                                onTap: () async {
                                  var a = await pilihPtkp(value: ptkp.id);
                                  if(a != null && a.value != ptkp.id) {
                                    ptkp = Ptkp.fromMap(a.data!);
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
                        onPressed: simpanData,
                        minimumSize: const Size(120, 40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AFwidget.formHeader(
              txtId.text.isEmpty ? 'Form Tambah Data Karyawan CIC' : 'Form Ubah Data Karyawan CIC',
              actions: [
                IconButton(
                  onPressed: () async {
                    await loadData();
                  },
                  icon: const Icon(Icons.refresh),
                  padding: EdgeInsets.zero,
                ),
              ],
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

  Future<void> simpanData() async {
    try {
      if(area.id == '') throw ValidationException('Silakan pilih area');
      if(jabatan.id == '') throw ValidationException('Silakan pilih jabatan');
      if(txtNama.text.isEmpty) throw ValidationException('Nama tidak boleh kosong');
      if(txtTanggalMasuk.text.isEmpty) throw ValidationException('Masa kerja harus diisi');
      if(txtNomorKtp.text.isEmpty) throw ValidationException('No KTP tidak boleh kosong');
      if(txtTempatLahir.text.isEmpty || txtTanggalLahir.text.isEmpty) throw ValidationException('Tempat & tanggal lahir harus diisi');
      if(txtAlamatKtp.text.isEmpty) throw ValidationException('Alamat sesuai KTP harus diisi');
      if(txtTelepon.text.isEmpty) throw ValidationException('Nomor telepon harus diisi');
      if(kawin == '') throw ValidationException('Silakan isi status kawin');
      if(kelamin == '') throw ValidationException('Silakan isi jenis kelamin');
      if(aktif == '') throw ValidationException('Silakan isi status aktif');
      if(staf == null) throw ValidationException('Silakan isi jenis karyawan (Staf/Non)');
      
      Map<String, dynamic> body = {
        'nama': txtNama.text,
        'nik': txtNik.text,
        'nomor_ktp': txtNomorKtp.text,
        'nomor_kk': txtNomorKk.text,
        'nomor_paspor': txtNomorPaspor.text,
        
        'tempat_lahir': txtTempatLahir.text,
        'tanggal_lahir': txtTanggalLahir.text,
        'tanggal_masuk': txtTanggalMasuk.text,
        'tanggal_keluar': txtTanggalKeluar.text,
        'alamat_ktp': txtAlamatKtp.text,
        'alamat_tinggal': txtAlamatTinggal.text,
        'telepon': txtTelepon.text,
        'email': txtEmail.text,
        'pendidikan_almamater': txtPendidikanAlmamater.text,
        'pendidikan_jurusan': txtPendidikanJurusan.text,
        'kawin': kawin,
        'kelamin': kelamin,
        'aktif': aktif,
        'staf': staf! ? 'Y' : 'N',
        
        'agama_id': agama.id,
        'area_id': area.id,
        'jabatan_id': jabatan.id,
        'divisi_id': divisi.id,
        'pendidikan_id': pendidikan.id,
        'status_kerja_id': statusKerja.id,
        
      };

      if(body['tanggal_keluar'] == '') body['tanggal_keluar'] = null;
      if(body['agama_id'] == '') body['agama_id'] = null;
      if(body['area_id'] == '') body['area_id'] = null;
      if(body['jabatan_id'] == '') body['jabatan_id'] = null;
      if(body['divisi_id'] == '') body['divisi_id'] = null;
      if(body['pendidikan_id'] == '') body['pendidikan_id'] = null;
      if(body['status_kerja_id'] == '') body['status_kerja_id'] = null;
      AFwidget.loading();
      var hasil = await AFdatabase.send(
        url: txtId.text.isEmpty ? 'cic/karyawan' : 'cic/karyawan/${txtId.text}',
        methodeRequest: txtId.text.isEmpty ? MethodeRequest.post : MethodeRequest.put,
        body: body,
        contentIsJson: true,
      );
      Get.back();
      if(hasil.success) {
        Get.back();
        AFwidget.snackbar(hasil.message);
        loadData();
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch(err) {
      AFwidget.formWarning(label: '$err');
    }
  }

  Future<void> hapusData(String id) async {
    AFwidget.loading();
    var hasil = await AFdatabase.send(url: 'cic/karyawan/$id', methodeRequest: MethodeRequest.delete);
    Get.back();
    if(hasil.success) {
      Get.back();
      AFwidget.snackbar(hasil.message);
      loadData();
    } else {
      AFwidget.formWarning(label: hasil.message);
    }
  }
  Future<Opsi?> _fetchAndPick(String url, String title, String value) async {
    AFwidget.loading();
    var hasil = await AFdatabase.send(url: url, methodeRequest: MethodeRequest.get);
    Get.back();
    if(hasil.success) {
      List<Opsi> list = hasil.daftar.map((e) => Opsi(value: e['id'].toString(), label: e['nama'] ?? e['kode'] ?? '', data: e)).toList();
      return await AFcombobox.bottomSheet(
        listOpsi: list,
        valueSelected: value,
        judul: title,
      );
    }
    return null;
  }

  Future<Opsi?> pilihAgama({String value = ''}) async => await _fetchAndPick('agama', 'Pilih Agama', value);
  Future<Opsi?> pilihArea({String value = '', bool withSemua = false}) async => await _fetchAndPick('area', 'Pilih Area', value);
  Future<Opsi?> pilihDivisi({String value = ''}) async => await _fetchAndPick('divisi', 'Pilih Divisi', value);
  Future<Opsi?> pilihJabatan({String value = ''}) async => await _fetchAndPick('jabatan', 'Pilih Jabatan', value);
  Future<Opsi?> pilihPendidikan({String value = ''}) async => await _fetchAndPick('pendidikan', 'Pilih Pendidikan', value);
  Future<Opsi?> pilihStatusKerja({String value = '', bool withSemua = false}) async => await _fetchAndPick('status_kerja', 'Pilih Status Kerja', value);
  Future<Opsi?> pilihPtkp({String value = ''}) async => await _fetchAndPick('ptkp', 'Pilih PTKP', value);

  @override
  void onInit() {
    txtId = TextEditingController();
    txtNama = TextEditingController();
    txtNik = TextEditingController();
    txtNomorKtp = TextEditingController();
    txtTempatLahir = TextEditingController();
    txtTanggalLahir = TextEditingController();
    txtTanggalMasuk = TextEditingController();
    txtTanggalKeluar = TextEditingController();
    txtAlamatKtp = TextEditingController();
    txtAlamatTinggal = TextEditingController();
    txtTelepon = TextEditingController();
    txtEmail = TextEditingController();
    txtPendidikanAlmamater = TextEditingController();
    txtPendidikanJurusan = TextEditingController();
    txtNomorKk = TextEditingController();
    txtNomorPaspor = TextEditingController();
    txtNomorPwp = TextEditingController();
    loadData();
    super.onInit();
  }
}
