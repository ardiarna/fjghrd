import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/overtime.dart';
import 'package:fjghrd/repositories/karyawan_repository.dart';
import 'package:fjghrd/repositories/overtime_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/utils/hasil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OvertimeControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final homeControl = Get.find<HomeControl>();
  final OvertimeRepository _repo = OvertimeRepository();

  final DateTime _now = DateTime.now();

  List<Overtime> listOvertime = [];
  List<Opsi> listKaryawan = [];
  List<Opsi> listJenis = [
    Opsi(value: '', label: 'Semua'),
    Opsi(value: 'F', label: 'Fratekindo'),
    Opsi(value: 'C', label: 'Customer'),
  ];
  List<Opsi> listBulan = mapBulan.entries.map((e) => Opsi(value: e.key.toString(), label: e.value)).toList();
  late List<Opsi> listTahun;

  Opsi filterJenis = Opsi(value: '', label: 'Semua');
  late Opsi filterTahun;
  late Opsi filterBulan;

  late TextEditingController txtId, txtTanggal, txtJumlah, txtJum2, txtKeterangan;
  Karyawan karyawan = Karyawan();
  String jenis = '';
  late Opsi tahun;
  late Opsi bulan;

  Future<void> loadOvertimes() async {
    var hasil = await _repo.findAll(
      tahun: filterTahun.value,
      bulan: filterBulan.value,
      jenis: filterJenis.value,
    );
    if (hasil.success) {
      listOvertime.clear();
      for (var data in hasil.daftar) {
        listOvertime.add(Overtime.fromMap(data));
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

  void tambahForm(BuildContext context) {
    txtId.text = '';
    tahun = Opsi(value: filterTahun.value, label: filterTahun.label);
    bulan = Opsi(value: filterBulan.value, label: filterBulan.label);
    txtTanggal.text = AFconvert.matDate(DateTime(AFconvert.keInt(filterTahun.value), AFconvert.keInt(filterBulan.value)));
    txtKeterangan.text = '';
    txtJumlah.text = '';
    txtJum2.text = '';
    karyawan = Karyawan();
    jenis = '';
    AFwidget.dialog(
      Container(
        width: Get.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Stack(
          children: [
            ListView(
              children: [
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
                          child: GetBuilder<OvertimeControl>(
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
                          child: GetBuilder<OvertimeControl>(
                            builder: (_) {
                              return AFwidget.comboField(
                                value: tahun.label,
                                label: '',
                                onTap: () async {
                                  var a = await pilihTahun(value: tahun.value);
                                  if(a != null && a.value != tahun.value) {
                                    tahun = a;
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
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Karyawan'),
                      ),
                      Expanded(
                        child: GetBuilder<OvertimeControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: karyawan.nama,
                              label: '',
                              onTap: () async {
                                var a = await pilihKaryawan(value: karyawan.id);
                                if(a != null && a.value != karyawan.id) {
                                  karyawan = Karyawan.fromMap(a.data!);
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
                  label: 'Fratekindo IDR',
                  controller: txtJumlah,
                  isNumber: true,
                ),
                AFwidget.barisText(
                  label: 'Customer IDR',
                  controller: txtJum2,
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
            AFwidget.formHeader('Form Tambah Overtime - ${bulan.label} ${tahun.label}'),
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
    var item = listOvertime.where((element) => element.id == id).first;
    txtId.text = item.id;
    tahun = Opsi(value: '${item.tahun}', label: '${item.tahun}');
    bulan = Opsi(value: '${item.bulan}', label: mapBulan[item.bulan]!);
    txtTanggal.text = AFconvert.matDate(item.tanggal);
    txtKeterangan.text = item.keterangan;
    txtJumlah.text = AFconvert.matNumber(item.jumlah);
    karyawan = item.karyawan;
    jenis = item.jenis;
    AFwidget.dialog(
      Container(
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
                        child: const Text('Jenis Overtime'),
                      ),
                      Expanded(
                        child: GetBuilder<OvertimeControl>(
                          builder: (_) {
                            return Row(
                              children: [
                                Radio<String>(
                                  value: 'F',
                                  groupValue: jenis,
                                  onChanged: (a) {
                                    if(a != null && a != jenis) {
                                      jenis = a;
                                      update();
                                    }
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                  child: Text('Fratekindo'),
                                ),
                                Radio<String>(
                                  value: 'C',
                                  groupValue: jenis,
                                  onChanged: (a) {
                                    if(a != null && a != jenis) {
                                      jenis = a;
                                      update();
                                    }
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text('Customer'),
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
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(right: 15),
                        child: const Text('Periode'),
                      ),
                      Expanded(
                        child: GetBuilder<OvertimeControl>(
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
                        child: GetBuilder<OvertimeControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: tahun.label,
                              label: '',
                              onTap: () async {
                                var a = await pilihTahun(value: tahun.value);
                                if(a != null && a.value != tahun.value) {
                                  tahun = a;
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
            AFwidget.formHeader('Form Ubah Overtime'),
          ],
        ),
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void hapusForm(Overtime item) {
    AFwidget.formHapus(
      label: 'overtime ${item.karyawan.nama} pada tanggal ${AFconvert.matDate(item.tanggal)} sebesar Rp. ${AFconvert.matNumber(item.jumlah)} ',
      aksi: () {
        hapusData(item.id);
      },
    );
  }

  Future<void> tambahData() async {
    try {
      if(bulan.value.isEmpty || tahun.value.isEmpty) {
        throw 'Periode harus diisi';
      }
      if(txtTanggal.text.isEmpty) {
        throw 'Tanggal harus diisi';
      }
      if(karyawan.id.isEmpty) {
        throw 'Silakan pilih karyawan';
      }
      if(txtJumlah.text.isEmpty && txtJum2.text.isEmpty) {
        throw 'Jumlah Overtime Fratekindo atau Customer, salah satu harus diisi';
      }

      Hasil hasil = Hasil();
      Hasil hasil2 = Hasil();
      AFwidget.loading();

      if(AFconvert.keInt(txtJumlah.text) > 0) {
        var a = Overtime(
          jenis: 'F',
          tanggal: AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggal.text)} 08:00:00'),
          bulan: AFconvert.keInt(bulan.value),
          tahun: AFconvert.keInt(tahun.value),
          jumlah: AFconvert.keInt(txtJumlah.text),
          keterangan: txtKeterangan.text,
        );
        a.karyawan = karyawan;
        hasil = await _repo.create(a.toMap());
      } else {
        hasil.success = true;
      }

      if(AFconvert.keInt(txtJum2.text) > 0) {
        var b = Overtime(
          jenis: 'C',
          tanggal: AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggal.text)} 08:00:00'),
          bulan: AFconvert.keInt(bulan.value),
          tahun: AFconvert.keInt(tahun.value),
          jumlah: AFconvert.keInt(txtJum2.text),
          keterangan: txtKeterangan.text,
        );
        b.karyawan = karyawan;
        hasil2 = await _repo.create(b.toMap());
      } else {
        hasil2.success = true;
      }

      Get.back();
      if(hasil.success && hasil2.success) {
        loadOvertimes();
        Get.back();
      }
      List<String> vMessages = [];
      if(hasil.message != '') vMessages.add(hasil.message);
      if(hasil2.message != '') vMessages.add(hasil2.message);
      AFwidget.snackbar(vMessages.join(', '));
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> ubahData() async {
    try {
      if(txtId.text.isEmpty) {
        throw 'ID overtime tidak ditemukan';
      }
      if(karyawan.id.isEmpty) {
        throw 'Silakan pilih karyawan';
      }
      if(jenis.isEmpty) {
        throw 'Silakan pilih jenis overtime';
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
      var a = Overtime(
        jenis: jenis,
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
        loadOvertimes();
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
        throw 'ID overtime tidak ditemukan';
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadOvertimes();
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
      judul: 'Pilih Jenis Overtime',
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
    txtJum2 = TextEditingController();
    txtKeterangan = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtTanggal.dispose();
    txtJumlah.dispose();
    txtJum2.dispose();
    txtKeterangan.dispose();
    super.onClose();
  }
}
