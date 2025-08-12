import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/potongan.dart';
import 'package:fjghrd/models/upah.dart';
import 'package:fjghrd/repositories/karyawan_repository.dart';
import 'package:fjghrd/repositories/potongan_repository.dart';
import 'package:fjghrd/repositories/upah_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PotonganControl extends GetxController {
  final homeControl = Get.find<HomeControl>();
  final PotonganRepository _repo = PotonganRepository();

  final DateTime _now = DateTime.now();

  List<Potongan> listPotongan = [];
  List<Opsi> listKaryawan = [];
  List<Opsi> listJenis = [
    Opsi(value: 'TB', label: 'Keterlambatan Hadir'),
    Opsi(value: 'KJ', label: 'Kompensasi Hadir (Jam)'),
    Opsi(value: 'TP', label: 'Telepon'),
    Opsi(value: 'BN', label: 'Bensin'),
    Opsi(value: 'KS', label: 'Pinjaman Kas'),
    Opsi(value: 'CC', label: 'Pinjaman cicilan'),
    Opsi(value: 'BP', label: 'BPJS'),
    Opsi(value: 'UL', label: 'Unpaid Leave / Cuti Bersama'),
    Opsi(value: 'LL', label: 'Lain-Lain'),
  ];
  List<Opsi> listBulan = mapBulan.entries.map((e) => Opsi(value: e.key.toString(), label: e.value)).toList();
  late List<Opsi> listTahun;

  Opsi filterJenis = Opsi(value: '', label: 'Semua');
  late Opsi filterTahun;
  late Opsi filterBulan;

  late TextEditingController txtId, txtTanggal, txtHari, txtJumlah, txtKeterangan;
  Karyawan karyawan = Karyawan();
  Opsi jenis = Opsi(value: '', label: '');
  late Opsi tahun;
  late Opsi bulan;
  Upah upah = Upah();

  Future<void> loadPotongans() async {
    var hasil = await _repo.findAll(
      tahun: filterTahun.value,
      bulan: filterBulan.value,
      jenis: filterJenis.value,
    );
    if (hasil.success) {
      listPotongan.clear();
      for (var data in hasil.daftar) {
        listPotongan.add(Potongan.fromMap(data));
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

  Future<void> loadPayroll() async {
    UpahRepository repo = UpahRepository();
    var hasil = await repo.find(karyawan.id);
    if(hasil.success) {
      upah = Upah.fromMap(hasil.data);
    } else {
      upah = Upah();
    }
    update();
  }

  void tambahForm(BuildContext context) {
    txtId.text = '';
    tahun = Opsi(value: filterTahun.value, label: filterTahun.label);
    bulan = Opsi(value: filterBulan.value, label: filterBulan.label);
    txtTanggal.text = AFconvert.matDate(DateTime(AFconvert.keInt(filterTahun.value), AFconvert.keInt(filterBulan.value)));
    txtKeterangan.text = '';
    txtHari.text = '';
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
                        child: const Text('Jenis Potongan'),
                      ),
                      Expanded(
                        child: GetBuilder<PotonganControl>(
                            builder: (_) {
                            return AFwidget.comboField(
                              value: jenis.label,
                              label: '',
                              onTap: () async {
                                var a = await pilihJenis(value: jenis.value);
                                if(a != null && a.value != jenis.value) {
                                  jenis = a;
                                  hitungJumlahIdr(txtHari.text);
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
                        child: const Text('Karyawan'),
                      ),
                      Expanded(
                        child: GetBuilder<PotonganControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: karyawan.nama,
                              label: '',
                              onTap: () async {
                                var a = await pilihKaryawan(value: karyawan.id);
                                if(a != null && a.value != karyawan.id) {
                                  karyawan = Karyawan.fromMap(a.data!);
                                  await loadPayroll();
                                  hitungJumlahIdr(txtHari.text);
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
                    if(karyawan.id != '' && (jenis.value == 'TB' || jenis.value == 'UL' || jenis.value == 'KJ')) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(170, 15, 25, 10),
                        child: Row(
                          children: [
                            const Text('Gaji: '),
                            Text(AFconvert.matNumber(upah.gaji),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 50),
                            const Text('Uang Makan: '),
                            Text('${AFconvert.matNumber(upah.uangMakan)}   ${upah.makanHarian ? 'Harian' : 'Tetap'}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 50),
                            IconButton(
                              onPressed: () {
                                gajiForm(context);
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
                    if(jenis.value == 'TB' || jenis.value == 'UL') {
                      return AFwidget.barisText(
                        label: 'Jumlah Hari',
                        controller: txtHari,
                        isNumber: true,
                        onchanged: hitungJumlahIdr,
                      );
                    } else if(jenis.value == 'KJ') {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 250,
                            child: AFwidget.barisText(
                              label: 'Jumlah Jam',
                              controller: txtHari,
                              onchanged: hitungJumlahIdr,
                              paddingRight: 0,
                            ),
                          ),
                          Expanded(
                            child: const Padding(
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
                    txtHari.text = '';
                    return Container();
                  },
                ),
                AFwidget.barisText(
                  label: 'Jumlah IDR',
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
            AFwidget.formHeader('Form Tambah Potongan - ${bulan.label} ${tahun.label}'),
          ],
        ),
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  Future<void> ubahForm(String id, BuildContext context) async {
    var item = listPotongan.where((element) => element.id == id).first;
    txtId.text = item.id;
    tahun = Opsi(value: '${item.tahun}', label: '${item.tahun}');
    bulan = Opsi(value: '${item.bulan}', label: mapBulan[item.bulan]!);
    txtTanggal.text = AFconvert.matDate(item.tanggal);
    txtKeterangan.text = item.keterangan;
    if(item.jenis == 'KJ') {
      txtHari.text = AFconvert.matNumberWithDecimal(item.hari, decimal: 1);
    } else {
      txtHari.text = AFconvert.matNumber(item.hari);
    }
    txtJumlah.text = AFconvert.matNumber(item.jumlah);
    karyawan = item.karyawan;
    jenis = listJenis.where((element) => element.value == item.jenis).first;
    await loadPayroll();
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
                AFwidget.barisInfo(
                  label: 'Gaji',
                  nilai: AFconvert.matNumber(upah.gaji),
                ),
                item.jenis == 'TB' ?
                AFwidget.barisInfo(
                  label: 'Uang Makan',
                  nilai: '${AFconvert.matNumber(upah.uangMakan)}   ${upah.makanHarian ? 'Harian' : 'Tetap'}',
                ) :
                Container(),
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
                        child: GetBuilder<PotonganControl>(
                          builder: (_) {
                            return AFwidget.comboField(
                              value: jenis.label,
                              label: '',
                              onTap: () async {
                                var a = await pilihJenis(value: jenis.value);
                                if(a != null && a.value != jenis.value) {
                                  jenis = a;
                                  hitungJumlahIdr(txtHari.text);
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
                        child: GetBuilder<PotonganControl>(
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
                        child: GetBuilder<PotonganControl>(
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
                GetBuilder<PotonganControl>(
                  builder: (_) {
                    if(jenis.value == 'TB' || jenis.value == 'UL') {
                      return AFwidget.barisText(
                        label: 'Jumlah Hari',
                        controller: txtHari,
                        isNumber: true,
                        onchanged: hitungJumlahIdr,
                      );
                    } else if(jenis.value == 'KJ') {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 250,
                            child: AFwidget.barisText(
                              label: 'Jumlah Jam',
                              controller: txtHari,
                              onchanged: hitungJumlahIdr,
                              paddingRight: 0,
                            ),
                          ),
                          Expanded(
                            child: const Padding(
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
                    txtHari.text = '';
                    return Container();
                  },
                ),
                AFwidget.barisText(
                  label: 'Jumlah IDR',
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
            AFwidget.formHeader('Form Ubah Potongan'),
          ],
        ),
      ),
      barrierDismissible: false,
      scrollable: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  void hapusForm(Potongan item) {
    AFwidget.formHapus(
      label: 'potongan ${item.karyawan.nama} pada tanggal ${AFconvert.matDate(item.tanggal)} sebesar Rp. ${AFconvert.matNumber(item.jumlah)} ',
      aksi: () {
        hapusData(item.id);
      },
    );
  }

  void hapusBanyakForm() {
    AFwidget.formHapus(
      label: 'potongan ${filterJenis.label} pada bulan ${filterBulan.label} ${filterTahun.label} ',
      aksi: hapusBanyakData,
    );
  }

  void gajiForm(BuildContext context) {
    TextEditingController txtGaji = TextEditingController(text: AFconvert.matNumber(upah.gaji));
    TextEditingController txtUangMakan = TextEditingController(text: AFconvert.matNumber(upah.uangMakan));
    bool makanHarian = upah.makanHarian;
    UpahRepository repo = UpahRepository();
    AFwidget.dialog(
      Container(
        width: 500,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            AFwidget.barisText(
              label: 'Jumlah Gaji',
              controller: txtGaji,
              isNumber: true,
              labelWidth: 200,
            ),
            AFwidget.barisText(
              label: 'Jumlah Uang Makan',
              controller: txtUangMakan,
              isNumber: true,
              labelWidth: 200,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 200,
                    child: Text('Jenis Uang Makan'),
                  ),
                  Expanded(
                    child: GetBuilder<PotonganControl>(
                      builder: (_) {
                        return Row(
                          children: [
                            Radio<bool>(
                              value: true,
                              groupValue: makanHarian,
                              onChanged: (a) {
                                if(a != null && a != makanHarian) {
                                  makanHarian = a;
                                  update();
                                }
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                              child: Text('Harian'),
                            ),
                            Radio<bool>(
                              value: false,
                              groupValue: makanHarian,
                              onChanged: (a) {
                                if(a != null && a != makanHarian) {
                                  makanHarian = a;
                                  update();
                                }
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                              child: Text('Tetap'),
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
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 25),
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
                    onPressed: () async {
                      if(txtGaji.text.isEmpty) {
                        AFwidget.snackbar('Gaji harus diisi');
                        return;
                      }
                      if(txtUangMakan.text.isEmpty) {
                        AFwidget.snackbar('Uang Makan harus diisi');
                        return;
                      }
                      var a = Upah(
                        karyawanId: karyawan.id,
                        gaji: AFconvert.keInt(txtGaji.text),
                        uangMakan: AFconvert.keInt(txtUangMakan.text),
                        makanHarian: makanHarian,
                      );
                      AFwidget.loading();
                      var hasil = await repo.create(a.karyawanId, a.toMap());
                      Get.back();
                      if(hasil.success) {
                        Get.back();
                        AFwidget.snackbar(hasil.message);
                        upah.gaji = a.gaji;
                        upah.uangMakan = a.uangMakan;
                        upah.makanHarian = a.makanHarian;
                        hitungJumlahIdr(txtHari.text);
                        txtGaji.dispose();
                        txtUangMakan.dispose();
                        update();
                      } else {
                        AFwidget.snackbar(hasil.message);
                      }
                    },
                    minimumSize: const Size(120, 40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  Future<void> tambahData() async {
    try {
      if(jenis.value.isEmpty) {
        throw 'Silakan pilih jenis potongan';
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
      if((jenis.value == 'TB' || jenis.value == 'UL') && txtHari.text.isEmpty) {
        throw 'Jumlah hari harus diisi';
      }
      if(txtJumlah.text.isEmpty) {
        throw 'Jumlah IDR harus diisi';
      }

      var a = Potongan(
        jenis: jenis.value,
        tanggal: AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggal.text)} 08:00:00'),
        tahun: AFconvert.keInt(tahun.value),
        bulan: AFconvert.keInt(bulan.value),
        hari: AFconvert.keDouble(txtHari.text),
        jumlah: AFconvert.keInt(txtJumlah.text),
        keterangan: txtKeterangan.text,
      );
      a.karyawan = karyawan;

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadPotongans();
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
        throw 'ID potongan tidak ditemukan';
      }
      if(karyawan.id.isEmpty) {
        throw 'Silakan pilih karyawan';
      }
      if(jenis.value.isEmpty) {
        throw 'Silakan pilih jenis potongan';
      }
      if(bulan.value.isEmpty || tahun.value.isEmpty) {
        throw 'Periode harus diisi';
      }
      if(txtTanggal.text.isEmpty) {
        throw 'Tanggal harus diisi';
      }
      if((jenis.value == 'TB' || jenis.value == 'UL') && txtHari.text.isEmpty) {
        throw 'Jumlah hari harus diisi';
      }
      if(txtJumlah.text.isEmpty) {
        throw 'Jumlah IDR harus diisi';
      }
      var a = Potongan(
        jenis: jenis.value,
        tanggal: AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggal.text)} 08:00:00'),
        tahun: AFconvert.keInt(tahun.value),
        bulan: AFconvert.keInt(bulan.value),
        hari: AFconvert.keDouble(txtHari.text),
        jumlah: AFconvert.keInt(txtJumlah.text),
        keterangan: txtKeterangan.text,
      );
      a.karyawan = karyawan;

      AFwidget.loading();
      var hasil = await _repo.update(txtId.text, a.toMap());
      Get.back();
      if(hasil.success) {
        loadPotongans();
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
        throw 'ID potongan tidak ditemukan';
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadPotongans();
        Get.back();
        Get.back();
      }
      AFwidget.snackbar(hasil.message);
    } catch (er) {
      AFwidget.snackbar('$er');
    }
  }

  Future<void> hapusBanyakData() async {
    try {
      AFwidget.loading();
      var hasil = await _repo.deleteAll(
        tahun: filterTahun.value,
        bulan: filterBulan.value,
        jenis: filterJenis.value,
      );
      Get.back();
      if(hasil.success) {
        loadPotongans();
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
      judul: 'Pilih Jenis Potongan',
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

  void hitungJumlahIdr(String nilai) {
    if(jenis.value == 'TB') {
      int jumlahHari = AFconvert.keInt(nilai);
      double jumlahIdr = (upah.uangMakan/4)*jumlahHari;
      txtJumlah.text = AFconvert.matNumber(jumlahIdr.toInt());
    } else if(jenis.value == 'UL') {
      int jumlahHari = AFconvert.keInt(nilai);
      double jumlahIdr = (upah.gaji/21)*jumlahHari;
      txtJumlah.text = AFconvert.matNumber(jumlahIdr.toInt());
    } else if(jenis.value == 'KJ') {
      double jumlahJam = AFconvert.keDouble(nilai);
      double jumlahIdr = (upah.gaji/168)*jumlahJam;
      txtJumlah.text = AFconvert.matNumber(jumlahIdr.toInt());
    } else {
      txtHari.text = '';
    }
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
    txtHari = TextEditingController();
    txtJumlah = TextEditingController();
    txtKeterangan = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtTanggal.dispose();
    txtHari.dispose();
    txtJumlah.dispose();
    txtKeterangan.dispose();
    super.onClose();
  }
}
