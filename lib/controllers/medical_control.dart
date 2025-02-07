import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/medical.dart';
import 'package:fjghrd/models/medical_rekap.dart';
import 'package:fjghrd/repositories/karyawan_repository.dart';
import 'package:fjghrd/repositories/medical_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicalControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final homeControl = Get.find<HomeControl>();
  final MedicalRepository _repo = MedicalRepository();

  final DateTime _now = DateTime.now();

  List<Medical> listMedical = [];
  List<Opsi> listKaryawan = [];
  List<Opsi> listJenis = [
    Opsi(value: 'R', label: 'Rawat Jalan'),
    Opsi(value: 'K', label: 'Kacamata'),
    Opsi(value: 'I', label: 'Melahirkan'),
  ];
  List<Opsi> listBulan = mapBulan.entries.map((e) => Opsi(value: e.key.toString(), label: e.value)).toList();
  late List<Opsi> listTahun;

  Opsi filterJenis = Opsi(value: 'R', label: 'Rawat Jalan');
  late Opsi filterTahun;
  late Opsi filterBulan;

  late TextEditingController txtId, txtTanggal, txtJumlah, txtKeterangan;
  Karyawan karyawan = Karyawan();
  Opsi jenis = Opsi(value: 'R', label: 'Rawat Jalan');
  late Opsi tahun;
  late Opsi bulan;

  MedicalRekap medicalRekap = MedicalRekap();
  int tunjangan = 0, jumlahKlaim = 0, sisaTunjangan = 0;
  List<Medical> medicalHistory = [];

  Future<void> loadMedicals() async {
    var hasil = await _repo.findAll(
      tahun: filterTahun.value,
      bulan: filterBulan.value,
      jenis: filterJenis.value,
    );
    if (hasil.success) {
      listMedical.clear();
      for (var data in hasil.daftar) {
        listMedical.add(Medical.fromMap(data));
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  Future<void> loadKaryawans() async {
    KaryawanRepository repo = KaryawanRepository();
    var hasil = await repo.findAll();
    if(hasil.success) {
      listKaryawan.clear();
      for (var data in hasil.daftar) {
        listKaryawan.add(
          Opsi(value: AFconvert.keString(data['id']), label: data['nama'], data: data),
        );
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  Future<void> loadInfoMedical() async {
    try {
      medicalRekap = MedicalRekap();
      medicalHistory.clear();
      if(karyawan.id != '') {
        if(jenis.value == 'R') {
          KaryawanRepository repo = KaryawanRepository();
          var hasil = await repo.medicalRekap(karyawan.id, tahun.value);
          if(!hasil.success) throw hasil.message;
          medicalRekap = MedicalRekap.fromMap(hasil.data);
        } else {
          var hasil = await _repo.findAll(
            jenis: jenis.value,
            karyawanId: karyawan.id,
          );
          if(!hasil.success) throw hasil.message;
          for (var data in hasil.daftar) {
            medicalHistory.add(Medical.fromMap(data));
          }
        }
      }
      update();
    } catch (er) {
      update();
      AFwidget.snackbar('$er');
    }
  }

  void tambahForm(BuildContext context) {
    txtId.text = '';
    tahun = Opsi(value: filterTahun.value, label: filterTahun.label);
    bulan = Opsi(value: filterBulan.value, label: filterBulan.label);
    txtTanggal.text = AFconvert.matDate(DateTime(AFconvert.keInt(filterTahun.value), AFconvert.keInt(filterBulan.value)));
    txtKeterangan.text = '';
    txtJumlah.text = '';
    karyawan = Karyawan();
    jenis = Opsi(value: filterJenis.value, label: filterJenis.label);
    medicalRekap = MedicalRekap();
    medicalHistory = [];
    AFwidget.dialog(
      Container(
        width: Get.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
          children: [
            Expanded(
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
                              child: const Text('Jenis Medical'),
                            ),
                            Expanded(
                              child: GetBuilder<MedicalControl>(
                                builder: (_) {
                                  return AFwidget.comboField(
                                    value: jenis.label,
                                    label: '',
                                    onTap: () async {
                                      var a = await pilihJenis(value: jenis.value);
                                      if(a != null && a.value != jenis.value) {
                                        jenis = a;
                                        loadInfoMedical();
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
                                child: const Text('Periode'),
                              ),
                              Expanded(
                                child: GetBuilder<MedicalControl>(
                                  builder: (_) {
                                    return AFwidget.comboField(
                                      value: bulan.label,
                                      label: '',
                                      onTap: () async {
                                        var a = await pilihBulan(value: bulan.value);
                                        if(a != null && a.value != bulan.value) {
                                          bulan = a;
                                          update();
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 40),
                              Expanded(
                                child: GetBuilder<MedicalControl>(
                                  builder: (_) {
                                    return AFwidget.comboField(
                                      value: tahun.label,
                                      label: '',
                                      onTap: () async {
                                        var a = await pilihTahun(value: tahun.value);
                                        if(a != null && a.value != tahun.value) {
                                          tahun = a;
                                          if(jenis.value == 'R') {
                                            loadInfoMedical();
                                          } else {
                                            update();
                                          }
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
                      Visibility(
                        visible: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                          child: Row(
                            children: [
                              Container(
                                width: 150,
                                padding: const EdgeInsets.only(right: 15),
                                child: const Text('Tanggal'),
                              ),
                              Expanded(
                                child: AFwidget.textField(
                                  marginTop: 0,
                                  controller: txtTanggal,
                                  readOnly: true,
                                  prefixIcon: const Icon(Icons.calendar_month),
                                  ontap: () async {
                                    var a = await AFwidget.pickDate(
                                      context: context,
                                      initialDate: AFconvert.keTanggal(AFconvert.matDMYtoYMD(txtTanggal.text)),
                                    );
                                    if(a != null) {
                                      txtTanggal.text = AFconvert.matDate(a);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
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
                              child: GetBuilder<MedicalControl>(
                                builder: (_) {
                                  return AFwidget.comboField(
                                    value: karyawan.nama,
                                    label: '',
                                    onTap: () async {
                                      var a = await pilihKaryawan(value: karyawan.id);
                                      if(a != null && a.value != karyawan.id) {
                                        karyawan = Karyawan.fromMap(a.data!);
                                        loadInfoMedical();
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
                        label: 'Jumlah',
                        controller: txtJumlah,
                        isNumber: true,
                      ),
                      AFwidget.barisText(
                        label: 'Keterangan',
                        controller: txtKeterangan,
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
                              onPressed: tambahData,
                              minimumSize: const Size(120, 40),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AFwidget.formHeader(
                    'Form Tambah Medical - ${bulan.label} ${tahun.label}',
                    radiusRight: false,
                  ),
                ],
              ),
            ),
            Container(
              width: 200,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: GetBuilder<MedicalControl>(
                builder: (_) {
                  if(jenis.value == 'R') {
                    tunjangan = karyawan.kelamin == 'L' ? medicalRekap.gaji*2 : medicalRekap.gaji;
                    jumlahKlaim = medicalRekap.bln1 + medicalRekap.bln2 + medicalRekap.bln3 +
                        medicalRekap.bln4 + medicalRekap.bln5 + medicalRekap.bln6 +
                        medicalRekap.bln7 + medicalRekap.bln8 + medicalRekap.bln9 +
                        medicalRekap.bln10 + medicalRekap.bln11 + medicalRekap.bln12;
                    sisaTunjangan = tunjangan - jumlahKlaim;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Nama karyawan:'),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 5, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(karyawan.nama),
                        ),
                        const Text('Gaji:'),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 5, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(AFconvert.matNumber(medicalRekap.gaji)),
                        ),
                        const Text('Tunjangan:'),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 5, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(AFconvert.matNumber(tunjangan)),
                        ),
                        const Text('Jumlah Klaim:'),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 5, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(AFconvert.matNumber(jumlahKlaim)),
                        ),
                        const Text('Sisa IDR:'),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 5, bottom: 15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(AFconvert.matNumber(sisaTunjangan)),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('History:'),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: medicalHistory.length,
                            itemBuilder: (_, i) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(left: 5, bottom: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AFconvert.matDate(medicalHistory[i].tanggal)),
                                    Text('Rp. ${AFconvert.matNumber(medicalHistory[i].jumlah)}'),
                                    Text(medicalHistory[i].keterangan),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
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

  void ubahForm(String id, BuildContext context) {
    var item = listMedical.where((element) => element.id == id).first;
    txtId.text = item.id;
    tahun = Opsi(value: '${item.tahun}', label: '${item.tahun}');
    bulan = Opsi(value: '${item.bulan}', label: mapBulan[item.bulan]!);
    txtTanggal.text = AFconvert.matDate(item.tanggal);
    txtKeterangan.text = item.keterangan;
    txtJumlah.text = AFconvert.matNumber(item.jumlah);
    karyawan = item.karyawan;
    jenis = listJenis.where((element) => element.value == item.jenis).first;
    loadInfoMedical();
    AFwidget.dialog(
      Container(
        width: Get.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ListView(
                    children: [
                      AFwidget.barisInfo(
                        label: 'Nama Karyawan',
                        nilai: karyawan.nama,
                        paddingTop: 70,
                      ),
                      AFwidget.barisInfo(
                        label: 'Jabatan',
                        nilai: karyawan.jabatan.nama,
                      ),
                      AFwidget.barisInfo(
                        label: 'Masa Kerja',
                        nilai: AFconvert.matDate(karyawan.tanggalMasuk),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                        child: Row(
                          children: [
                            Container(
                              width: 150,
                              padding: const EdgeInsets.only(right: 15),
                              child: const Text('Jenis Medical'),
                            ),
                            Expanded(
                              child: GetBuilder<MedicalControl>(
                                builder: (_) {
                                  return AFwidget.comboField(
                                    value: jenis.label,
                                    label: '',
                                    onTap: () async {
                                      var a = await pilihJenis(value: jenis.value);
                                      if(a != null && a.value != jenis.value) {
                                        jenis = a;
                                        loadInfoMedical();
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
                              child: const Text('Periode'),
                            ),
                            Expanded(
                              child: GetBuilder<MedicalControl>(
                                builder: (_) {
                                  return AFwidget.comboField(
                                    value: bulan.label,
                                    label: '',
                                    onTap: () async {
                                      var a = await pilihBulan(value: bulan.value);
                                      if(a != null && a.value != bulan.value) {
                                        bulan = a;
                                        update();
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 40),
                            Expanded(
                              child: GetBuilder<MedicalControl>(
                                builder: (_) {
                                  return AFwidget.comboField(
                                    value: tahun.label,
                                    label: '',
                                    onTap: () async {
                                      var a = await pilihTahun(value: tahun.value);
                                      if(a != null && a.value != tahun.value) {
                                        tahun = a;
                                        if(jenis.value == 'R') {
                                          loadInfoMedical();
                                        } else {
                                          update();
                                        }
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
                                child: const Text('Tanggal'),
                              ),
                              Expanded(
                                child: AFwidget.textField(
                                  marginTop: 0,
                                  controller: txtTanggal,
                                  readOnly: true,
                                  prefixIcon: const Icon(Icons.calendar_month),
                                  ontap: () async {
                                    var a = await AFwidget.pickDate(
                                      context: context,
                                      initialDate: AFconvert.keTanggal(AFconvert.matDMYtoYMD(txtTanggal.text)),
                                    );
                                    if(a != null) {
                                      txtTanggal.text = AFconvert.matDate(a);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      AFwidget.barisText(
                        label: 'Jumlah',
                        controller: txtJumlah,
                        isNumber: true,
                      ),
                      AFwidget.barisText(
                        label: 'Keterangan',
                        controller: txtKeterangan,
                        isTextArea: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AFwidget.tombol(
                              label: 'Hapus',
                              color: Colors.red,
                              onPressed: () {
                                hapusForm(item);
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
                              onPressed: ubahData,
                              minimumSize: const Size(120, 40),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AFwidget.formHeader(
                    'Form Ubah Medical',
                    radiusRight: false,
                  ),
                ],
              ),
            ),
            Container(
              width: 200,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: GetBuilder<MedicalControl>(
                builder: (_) {
                  if(jenis.value == 'R') {
                    tunjangan = karyawan.kelamin == 'L' ? medicalRekap.gaji*2 : medicalRekap.gaji;
                    jumlahKlaim = medicalRekap.bln1 + medicalRekap.bln2 + medicalRekap.bln3 +
                        medicalRekap.bln4 + medicalRekap.bln5 + medicalRekap.bln6 +
                        medicalRekap.bln7 + medicalRekap.bln8 + medicalRekap.bln9 +
                        medicalRekap.bln10 + medicalRekap.bln11 + medicalRekap.bln12;
                    sisaTunjangan = tunjangan - jumlahKlaim;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Gaji:'),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 5, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(AFconvert.matNumber(medicalRekap.gaji)),
                        ),
                        const Text('Tunjangan:'),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 5, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(AFconvert.matNumber(tunjangan)),
                        ),
                        const Text('Jumlah Klaim:'),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 5, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(AFconvert.matNumber(jumlahKlaim)),
                        ),
                        const Text('Sisa IDR:'),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(left: 5, bottom: 15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(AFconvert.matNumber(sisaTunjangan)),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('History:'),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: medicalHistory.length,
                            itemBuilder: (_, i) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(left: 5, bottom: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(AFconvert.matDate(medicalHistory[i].tanggal)),
                                    Text('Rp. ${AFconvert.matNumber(medicalHistory[i].jumlah)}'),
                                    Text(medicalHistory[i].keterangan),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
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

  void hapusForm(Medical item) {
    AFwidget.formHapus(
      label: 'medical ${item.karyawan.nama} pada tanggal ${AFconvert.matDate(item.tanggal)} sebesar Rp. ${AFconvert.matNumber(item.jumlah)} ',
      aksi: () {
        hapusData(item.id);
      },
    );
  }

  Future<void> tambahData() async {
    try {
      if(jenis.value.isEmpty) {
        throw 'Silakan pilih jenis medical';
      }
      if(bulan.value.isEmpty || tahun.value.isEmpty) {
        throw 'Periode harus diisi';
      }
      if(txtTanggal.text.isEmpty) {
        throw 'Tanggal harus diisi';
      }
      if(karyawan.id.isEmpty) {
        throw 'Silakan pilih karyawan';
      }
      if(txtJumlah.text.isEmpty) {
        throw 'Jumlah harus diisi';
      }

      var a = Medical(
        jenis: jenis.value,
        tanggal: AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggal.text)} 08:00:00'),
        bulan: AFconvert.keInt(bulan.value),
        tahun: AFconvert.keInt(tahun.value),
        jumlah: AFconvert.keInt(txtJumlah.text),
        keterangan: txtKeterangan.text,
      );
      a.karyawan = karyawan;

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadMedicals();
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
        throw 'ID medical tidak ditemukan';
      }
      if(karyawan.id.isEmpty) {
        throw 'Silakan pilih karyawan';
      }
      if(jenis.value.isEmpty) {
        throw 'Silakan pilih jenis medical';
      }
      if(bulan.value.isEmpty || tahun.value.isEmpty) {
        throw 'Periode harus diisi';
      }
      if(txtTanggal.text.isEmpty) {
        throw 'Tanggal harus diisi';
      }
      if(txtJumlah.text.isEmpty) {
        throw 'Jumlah harus diisi';
      }
      var a = Medical(
        jenis: jenis.value,
        tanggal: AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggal.text)} 08:00:00'),
        bulan: AFconvert.keInt(bulan.value),
        tahun: AFconvert.keInt(tahun.value),
        jumlah: AFconvert.keInt(txtJumlah.text),
        keterangan: txtKeterangan.text,
      );
      a.karyawan = karyawan;

      AFwidget.loading();
      var hasil = await _repo.update(txtId.text, a.toMap());
      Get.back();
      if(hasil.success) {
        loadMedicals();
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
        throw 'ID medical tidak ditemukan';
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadMedicals();
        Get.back();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<Opsi?> pilihKaryawan({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listKaryawan,
      valueSelected: value,
      judul: 'Pilih Karyawan',
    );
    return a;
  }

  Future<Opsi?> pilihJenis({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listJenis,
      valueSelected: value,
      judul: 'Pilih Jenis Medical',
    );
    return a;
  }

  Future<Opsi?> pilihTahun({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listTahun,
      valueSelected: value,
      judul: 'Pilih Tahun',
      withCari: false,
    );
    return a;
  }

  Future<Opsi?> pilihBulan({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listBulan,
      valueSelected: value,
      judul: 'Pilih Bulan',
      withCari: false,
    );
    return a;
  }

  @override
  void onInit() {
    filterTahun = Opsi(value: '${_now.year}', label: '${_now.year}');
    filterBulan = Opsi(value: '${_now.month}', label: mapBulan[_now.month]!);
    tahun = Opsi(value: '${_now.year}', label: '${_now.year}');
    bulan = Opsi(value: '${_now.month}', label: mapBulan[_now.month]!);
    listTahun = List.generate(_now.year-2019, (index) => Opsi(value: '${_now.year-index}', label: '${_now.year-index}'));
    txtId = TextEditingController();
    txtTanggal = TextEditingController();
    txtJumlah = TextEditingController();
    txtKeterangan = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtTanggal.dispose();
    txtJumlah.dispose();
    txtKeterangan.dispose();
    super.onClose();
  }
}
