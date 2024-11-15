import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/penghasilan.dart';
import 'package:fjghrd/repositories/karyawan_repository.dart';
import 'package:fjghrd/repositories/penghasilan_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PenghasilanControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final homeControl = Get.find<HomeControl>();
  final PenghasilanRepository _repo = PenghasilanRepository();

  final DateTime _now = DateTime.now();

  List<Penghasilan> listPenghasilan = [];
  List<Opsi> listKaryawan = [];
  List<Opsi> listJenis = [
    Opsi(value: 'AB', label: 'Kehadiran'),
    Opsi(value: 'HR', label: 'THR'),
    Opsi(value: 'BN', label: 'Bonus'),
    Opsi(value: 'IN', label: 'Insentif'),
    Opsi(value: 'TK', label: 'Telkomsel'),
    Opsi(value: 'LL', label: 'Lain-Lain'),
  ];
  List<Opsi> listBulan = mapBulan.entries.map((e) => Opsi(value: e.key.toString(), label: e.value)).toList();
  late List<Opsi> listTahun;

  Opsi filterJenis = Opsi(value: '', label: 'Semua');
  late Opsi filterTahun;
  late Opsi filterBulan;

  late TextEditingController txtId, txtTanggal, txtJumlah, txtKeterangan;
  Karyawan karyawan = Karyawan();
  Opsi jenis = Opsi(value: '', label: '');
  late Opsi tahun;
  late Opsi bulan;

  Future<void> loadPenghasilans() async {
    var hasil = await _repo.findAll(
      tahun: filterTahun.value,
      bulan: filterBulan.value,
      jenis: filterJenis.value,
    );
    if (hasil.success) {
      listPenghasilan.clear();
      for (var data in hasil.daftar) {
        listPenghasilan.add(Penghasilan.fromMap(data));
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
    karyawan = Karyawan();
    if(filterJenis.value == '') {
      jenis = Opsi(value: '', label: '');
    } else {
      jenis = Opsi(value: filterJenis.value, label: filterJenis.label);
    }
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
                          builder: (_) {
                            return AFwidget.comboField(
                              value: jenis.label,
                              label: '',
                              onTap: () async {
                                var a = await pilihJenis(value: jenis.value);
                                if(a != null && a.value != jenis.value) {
                                  jenis = a;
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
                          child: const Text('Periode'),
                        ),
                        Expanded(
                          child: GetBuilder<PenghasilanControl>(
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
                          child: GetBuilder<PenghasilanControl>(
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
                GetBuilder<PenghasilanControl>(
                  builder: (_) {
                    return AFwidget.barisText(
                      label: 'Jumlah ${jenis.value == 'AB' ? 'Hari' : 'IDR'}',
                      controller: txtJumlah,
                      isNumber: true,
                    );
                  },
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
            AFwidget.formHeader('Form Tambah Penghasilan - ${bulan.label} ${tahun.label}'),
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
    var item = listPenghasilan.where((element) => element.id == id).first;
    txtId.text = item.id;
    tahun = Opsi(value: '${item.tahun}', label: '${item.tahun}');
    bulan = Opsi(value: '${item.bulan}', label: mapBulan[item.bulan]!);
    txtTanggal.text = AFconvert.matDate(item.tanggal);
    txtKeterangan.text = item.keterangan;
    txtJumlah.text = AFconvert.matNumber(item.jumlah);
    karyawan = item.karyawan;
    jenis = listJenis.where((element) => element.value == item.jenis).first;
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
                        child: const Text('Jenis Penghasilan'),
                      ),
                      Expanded(
                        child: GetBuilder<PenghasilanControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: jenis.label,
                              label: '',
                              onTap: () async {
                                var a = await pilihJenis(value: jenis.value);
                                if(a != null && a.value != jenis.value) {
                                  jenis = a;
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
                        child: const Text('Periode'),
                      ),
                      Expanded(
                        child: GetBuilder<PenghasilanControl>(
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
                        child: GetBuilder<PenghasilanControl>(
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
                GetBuilder<PenghasilanControl>(
                  builder: (_) {
                    return AFwidget.barisText(
                      label: 'Jumlah ${jenis.value == 'AB' ? 'Hari' : 'IDR'}',
                      controller: txtJumlah,
                      isNumber: true,
                    );
                  },
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
            AFwidget.formHeader('Form Ubah Penghasilan'),
          ],
        ),
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void hapusForm(Penghasilan item) {
    AFwidget.formHapus(
      label: 'penghasilan ${item.karyawan.nama} pada tanggal ${AFconvert.matDate(item.tanggal)} sebesar Rp. ${AFconvert.matNumber(item.jumlah)} ',
      aksi: () {
        hapusData(item.id);
      },
    );
  }

  Future<void> tambahData() async {
    try {
      if(jenis.value.isEmpty) {
        throw 'Silakan pilih jenis penghasilan';
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
        throw 'Jumlah ${jenis.value == 'AB' ? 'Hari' : 'IDR'} harus diisi';
      }

      var a = Penghasilan(
        jenis: jenis.value,
        tanggal: AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggal.text)} 08:00:00'),
        tahun: AFconvert.keInt(tahun.value),
        bulan: AFconvert.keInt(bulan.value),
        jumlah: AFconvert.keInt(txtJumlah.text),
        keterangan: txtKeterangan.text,
      );
      a.karyawan = karyawan;

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadPenghasilans();
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
        throw 'ID penghasilan tidak ditemukan';
      }
      if(karyawan.id.isEmpty) {
        throw 'Silakan pilih karyawan';
      }
      if(jenis.value.isEmpty) {
        throw 'Silakan pilih jenis penghasilan';
      }
      if(bulan.value.isEmpty || tahun.value.isEmpty) {
        throw 'Periode harus diisi';
      }
      if(txtTanggal.text.isEmpty) {
        throw 'Tanggal harus diisi';
      }
      if(txtJumlah.text.isEmpty) {
        throw 'Jumlah ${jenis.value == 'AB' ? 'Hari' : 'IDR'} harus diisi';
      }
      var a = Penghasilan(
        jenis: jenis.value,
        tanggal: AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggal.text)} 08:00:00'),
        tahun: AFconvert.keInt(tahun.value),
        bulan: AFconvert.keInt(bulan.value),
        jumlah: AFconvert.keInt(txtJumlah.text),
        keterangan: txtKeterangan.text,
      );
      a.karyawan = karyawan;

      AFwidget.loading();
      var hasil = await _repo.update(txtId.text, a.toMap());
      Get.back();
      if(hasil.success) {
        loadPenghasilans();
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
        throw 'ID penghasilan tidak ditemukan';
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadPenghasilans();
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

  Future<Opsi?> pilihJenis({String value = '', bool withSemua = false}) async {
    List<Opsi> list = [...listJenis];
    if(withSemua) {
      list.insert(0, Opsi(value: '', label: 'Semua'));
    }
    var a = await AFcombobox.bottomSheet(
      listOpsi: list,
      valueSelected: value,
      judul: 'Pilih Jenis Penghasilan',
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
    loadKaryawans();
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
