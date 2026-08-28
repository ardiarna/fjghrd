import 'package:intl/intl.dart';
import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/models/cuti.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/jatah_cuti_tahunan.dart';
import 'package:fjghrd/repositories/cuti_repository.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/controllers/cuti_masal_control.dart' as cuti_masal;
import 'package:fjghrd/utils/af_combobox.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CutiControl extends GetxController {
  final CutiRepository repo = CutiRepository();
  List<Cuti> listCuti = [];

  List<JatahCutiTahunan> listJatah = [];
  Opsi? selectedKaryawanJatah;
  Opsi? selectedTahunFormJatah;

  late TextEditingController txtJatahId, txtJatahJumlahCuti, txtPlusTahunLalu, txtMinTahunLalu;
  bool cekJatahBolehMinus = false;
  int get totalCutiJatah => AFconvert.keInt(txtJatahJumlahCuti.text) + AFconvert.keInt(txtPlusTahunLalu.text) - AFconvert.keInt(txtMinTahunLalu.text);


  String formType = 'CUTI';
  String currentId = '';
  Opsi filterTahun = Opsi(value: DateTime.now().year.toString(), label: DateTime.now().year.toString());

  
  List<Opsi> listKaryawan = [];
  Karyawan? selectedKaryawan;

    TextEditingController txtTanggalKembali = TextEditingController();

  // Cuti Tahunan
  String idDetailTahunan = '';
  String idDetailKhusus = '';
  String idDetailUnpaid = '';
  String idDetailGantiLibur = '';
  
  bool cekTahunan = false;
  bool hasJatah = false;
  int totalHakCuti = 0;
  int sudahDiambil = 0;
  int cutiMasal = 0;
  int belumDiambil = 0;
  TextEditingController txtAkanDiambil = TextEditingController();
  int sisaHakCuti = 0;
  List<DateTime> tglTahunan = [];
  TextEditingController txtKetTahunan = TextEditingController();

  // Khusus
  bool cekKhusus = false;
  Opsi? jenisKhusus;
  List<Opsi> listJenisKhusus = [];
  TextEditingController txtLamaKhusus = TextEditingController();
  List<DateTime> tglKhusus = [];
  TextEditingController txtKetKhusus = TextEditingController();
  TextEditingController txtTglAwalKhusus = TextEditingController();
  TextEditingController txtTglAkhirKhusus = TextEditingController();
  String satuanKhusus = 'hari';

  // Unpaid
  bool cekUnpaid = false;
  Opsi? jenisUnpaid;
  List<Opsi> listJenisUnpaid = [
    Opsi(value: 'SEBELUM_TIMBUL', label: 'Hak Cuti Sebelum Timbul (Potong Upah)'),
    Opsi(value: 'SUDAH_HABIS', label: 'Hak Cuti Sudah Habis (Potong Upah)'),
  ];
  List<DateTime> tglUnpaid = [];
  TextEditingController txtLamaUnpaid = TextEditingController();
  TextEditingController txtKetUnpaid = TextEditingController();

  // Ganti Hari Libur
  bool cekGantiLibur = false;
  List<DateTime> tglGantiLibur = [];
  TextEditingController txtLamaGantiLibur = TextEditingController();
  TextEditingController txtKetGantiLibur = TextEditingController();
  bool cekMasal = false;
  String idDetailMasal = '';
  TextEditingController txtLamaMasal = TextEditingController();
  TextEditingController txtKetMasal = TextEditingController();
  List<DateTime> tglMasal = [];


  @override
  void onInit() {
    super.onInit();
    txtJatahId = TextEditingController();
    txtJatahJumlahCuti = TextEditingController();
    txtPlusTahunLalu = TextEditingController();
    txtMinTahunLalu = TextEditingController();
    txtJatahJumlahCuti.addListener(update);
    txtPlusTahunLalu.addListener(update);
    txtMinTahunLalu.addListener(update);
    txtAkanDiambil.addListener(hitungSisa);
    txtLamaUnpaid = TextEditingController();
    txtLamaGantiLibur = TextEditingController();
    txtTglAwalKhusus = TextEditingController();
    txtTglAkhirKhusus = TextEditingController();
    loadCutis();
    loadKaryawan();
    loadJenisKhusus();
  }

  
  Future<void> loadJatah() async {
    var hasil = await AFdatabase.send(url: 'jatah-cuti?tahun=${filterTahun.value}');
    if (hasil.success) {
      listJatah.clear();
      for (var data in hasil.daftar) {
        listJatah.add(JatahCutiTahunan.fromMap(data));
      }
      if (selectedKaryawan != null) {
        hasJatah = listJatah.any((e) => e.karyawanId == selectedKaryawan!.id);
        if (formType == 'IJIN' && hasJatah) {
          cekTahunan = true;
        }
        if (!hasJatah) {
          idDetailTahunan = '';
    idDetailKhusus = '';
    idDetailUnpaid = '';
    idDetailGantiLibur = '';
    cekTahunan = false;
        }
        fetchInfoCuti();
      }
      update();
    }
  }

  Future<void> loadCutis() async {
    var hasil = await repo.findAll(tahun: filterTahun.value);
    if(hasil.success) {
      listCuti.clear();
      for (var data in hasil.daftar) {
        listCuti.add(Cuti.fromMap(data));
      }
      update();
    }
    loadJatah();
  }



  Future<void> loadKaryawan() async {
    var hasil = await AFdatabase.send(
      url: 'karyawan?aktif=Y&staf=&area=&status_kerja=&sort_by=nama&sort_order=asc',
    );
    if (hasil.success) {
      listKaryawan.clear();
      for (var data in hasil.daftar) {
        listKaryawan.add(
          Opsi(value: AFconvert.keString(data['id']), label: data['nama'], data: data),
        );
      }
      update();
    }
  }

  Future<void> loadJenisKhusus() async {
    var hasil = await AFdatabase.send(url: 'jenis-cuti-khusus');
    if (hasil.success) {
      listJenisKhusus.clear();
      for (var d in hasil.daftar) {
        listJenisKhusus.add(Opsi(
          value: AFconvert.keString(d['id']),
          label: d['nama'],
          data: d,
        ));
      }
      update();
    }
  }


  Future<Opsi?> pilihJenisKhusus({String value = ''}) async {
    return await AFcombobox.bottomSheet(
      listOpsi: listJenisKhusus,
      valueSelected: value,
      judul: 'Pilih Jenis Cuti Khusus',
    );
  }

  Future<Opsi?> pilihJenisUnpaid({String value = ''}) async {
    return await AFcombobox.bottomSheet(
      listOpsi: listJenisUnpaid,
      valueSelected: value,
      judul: 'Pilih Jenis Unpaid Leave',
    );
  }

Future<Opsi?> pilihTahun({String value = ''}) async {
    List<Opsi> listTahun = [];
    int startTahun = 2024;
    for (int i = 0; i < 10; i++) {
      listTahun.add(Opsi(value: (startTahun + i).toString(), label: (startTahun + i).toString()));
    }
    var a = await AFcombobox.bottomSheet(
      listOpsi: listTahun,
      valueSelected: value,
      judul: 'Pilih Tahun',
    );
    return a;
  }

  Future<Opsi?> pilihKaryawan({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listKaryawan,
      valueSelected: value,
      judul: 'Pilih Karyawan',
    );
    return a;
  }

  void setKaryawan(Karyawan k) {
    selectedKaryawan = k;
    if (formType == 'CUTI' || formType == 'IJIN') {
      hasJatah = listJatah.any((e) => e.karyawanId == k.id);
      if (formType == 'IJIN' && hasJatah) {
        cekTahunan = true;
      }
      if (!hasJatah) {
        idDetailTahunan = '';
    idDetailKhusus = '';
    idDetailUnpaid = '';
    idDetailGantiLibur = '';
    cekTahunan = false;
      }
    }
    fetchInfoCuti();
  }

  bool bolehMinusTahunan = false;
  
  Future<void> fetchInfoCuti({Map<String, dynamic>? snapDet}) async {
    if(selectedKaryawan == null) return;
    var hasil = await repo.fetchInfo(karyawanId: selectedKaryawan!.id, tahun: filterTahun.value);
    if(hasil.success) {
        var data = hasil.data;
        if(data['kuota'] != null) {
            bolehMinusTahunan = (data['kuota']['boleh_minus'] == 'Y');
            
            if (snapDet != null) {
                totalHakCuti   = AFconvert.keInt(snapDet['snap_total_hak_cuti']);
                sudahDiambil   = AFconvert.keInt(snapDet['snap_sudah_diambil']);
                cutiMasal      = AFconvert.keInt(snapDet['snap_cuti_masal']);
                belumDiambil   = totalHakCuti - sudahDiambil - cutiMasal;
            } else {
                totalHakCuti = data['kuota']['total_hak_cuti'] ?? 0;
                sudahDiambil = data['kuota']['sudah_diambil'] ?? 0;
                cutiMasal = data['kuota']['cuti_masal'] ?? 0;
                belumDiambil = data['kuota']['belum_diambil'] ?? 0;
            }
            hitungSisa();
        }
    }
  }

  void hitungSisa() {
    int akanDiambil = AFconvert.keInt(txtAkanDiambil.text);
    sisaHakCuti = belumDiambil - akanDiambil;
    update();
  }

void inputJatahForm(String id, {String? defaultKaryawanId, String? defaultKaryawanNama, String? defaultTahun}) {
    JatahCutiTahunan item = id == ''
        ? JatahCutiTahunan()
        : listJatah.where((e) => e.id == id).first;

    txtJatahId.text = item.id;
    txtJatahJumlahCuti.text = item.jumlahCuti == 0 ? '' : item.jumlahCuti.toString();
    txtPlusTahunLalu.text = (item.id == '' || item.plusTahunLalu == 0) ? '' : item.plusTahunLalu.toString();
    txtMinTahunLalu.text = (item.id == '' || item.minTahunLalu == 0) ? '' : item.minTahunLalu.toString();
    cekJatahBolehMinus = item.bolehMinus == 'Y';

    if (id != '' && item.karyawan != null) {
      selectedKaryawanJatah = Opsi(
        value: item.karyawanId,
        label: item.karyawan!.nama,
      );
    } else if (defaultKaryawanId != null && defaultKaryawanNama != null) {
      selectedKaryawanJatah = Opsi(value: defaultKaryawanId, label: defaultKaryawanNama);
    } else {
      selectedKaryawanJatah = null;
    }

    if (id != '' && item.tahun.isNotEmpty) {
      selectedTahunFormJatah = Opsi(value: item.tahun, label: item.tahun);
    } else if (defaultTahun != null) {
      selectedTahunFormJatah = Opsi(value: defaultTahun, label: defaultTahun);
    } else {
      selectedTahunFormJatah = filterTahun;
    }

    if (id == '' && selectedKaryawanJatah != null && selectedTahunFormJatah != null) {
        hitungSisaJatah();
    }

    update();

    AFwidget.dialog(
      GetBuilder<CutiControl>(
        builder: (ctrl) {
          return Container(
            width: 700,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AFwidget.formHeader('Form Jatah Cuti Tahunan'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Row(
                    children: [
                      SizedBox(width: 150, child: const Text('Karyawan')),
                      Expanded(
                        child: AFwidget.comboField(
                          value: ctrl.selectedKaryawanJatah?.label ?? '',
                          label: '',
                          onTap: () async {
                            var a = await ctrl.pilihKaryawan(value: ctrl.selectedKaryawanJatah?.value ?? '');
                            if (a != null) {
                              ctrl.selectedKaryawanJatah = a;
                              ctrl.update();
                              await ctrl.hitungSisaJatah();
                            }
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
                      SizedBox(width: 150, child: const Text('Tahun')),
                      Expanded(
                        child: AFwidget.comboField(
                          value: ctrl.selectedTahunFormJatah?.label ?? '',
                          label: '',
                          onTap: () async {
                            var a = await ctrl.pilihTahun(value: ctrl.selectedTahunFormJatah?.value ?? '');
                            if (a != null) {
                              ctrl.selectedTahunFormJatah = a;
                              ctrl.update();
                              await ctrl.hitungSisaJatah();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                AFwidget.barisText(label: 'Jumlah Cuti', controller: txtJatahJumlahCuti, isNumber: true),
                AFwidget.barisText(label: '+ Tahun Lalu', controller: txtPlusTahunLalu, isNumber: true),
                AFwidget.barisText(label: '- Tahun Lalu', controller: txtMinTahunLalu, isNumber: true),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Total Cuti', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 20),
                        Text('${ctrl.totalCutiJatah}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.blue)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: ctrl.cekJatahBolehMinus,
                        onChanged: (val) {
                          ctrl.cekJatahBolehMinus = val ?? false;
                          ctrl.update();
                        },
                      ),
                      const Expanded(child: Text('Boleh memakai jatah cuti tahun depan (Boleh Minus) ?', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      item.id == '' ? Container() : AFwidget.tombol(
                        label: 'Hapus Data', color: Colors.red,
                        onPressed: () { hapusJatah(item.id); },
                        minimumSize: const Size(120, 40),
                      ),
                      const Spacer(),
                      AFwidget.tombol(label: 'Batal', color: Colors.orange, onPressed: Get.back, minimumSize: const Size(120, 40)),
                      const SizedBox(width: 40),
                      AFwidget.tombol(label: 'Simpan', color: Colors.blue, onPressed: simpanJatah, minimumSize: const Size(120, 40)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      barrierDismissible: false,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  Future<void> hitungSisaJatah() async {
    if (selectedKaryawanJatah != null && selectedTahunFormJatah != null && txtJatahId.text == '') {
        var hasil = await AFdatabase.send(url: 'jatah-cuti/hitung-sisa?karyawan_id=${selectedKaryawanJatah!.value}&tahun=${selectedTahunFormJatah!.value}');
        if(hasil.success) {
            if (hasil.data['exists'] == true) {
                AFwidget.formWarning(label: 'Jatah cuti untuk karyawan dan tahun tersebut sudah diinput sebelumnya.');
                selectedKaryawanJatah = null;
                txtPlusTahunLalu.text = '';
                txtMinTahunLalu.text = '';
                update();
                return;
            }
            
            var plus = hasil.data['plus_tahun_lalu'] ?? 0;
            var min = hasil.data['min_tahun_lalu'] ?? 0;
            String p = plus == 0 ? '' : plus.toString();
            String m = min == 0 ? '' : min.toString();
            txtPlusTahunLalu.value = TextEditingValue(text: p, selection: TextSelection.collapsed(offset: p.length));
            txtMinTahunLalu.value = TextEditingValue(text: m, selection: TextSelection.collapsed(offset: m.length));
            update();
        }
    }
  }

  Future<void> simpanJatah() async {
    try {
      if (selectedKaryawanJatah == null) throw 'Karyawan harus dipilih';
      if (selectedTahunFormJatah == null) throw 'Tahun harus dipilih';
      if (txtJatahJumlahCuti.text.isEmpty) throw 'Jumlah cuti harus diisi';

      var body = {
        'karyawan_id': selectedKaryawanJatah!.value,
        'tahun': selectedTahunFormJatah!.value,
        'jumlah_cuti': AFconvert.keInt(txtJatahJumlahCuti.text),
        'plus_tahun_lalu': AFconvert.keInt(txtPlusTahunLalu.text),
        'min_tahun_lalu': AFconvert.keInt(txtMinTahunLalu.text),
        'boleh_minus': cekJatahBolehMinus ? 'Y' : 'N',
      };

      AFwidget.loading();
      var hasil = await AFdatabase.send(
        url: txtJatahId.text == '' ? 'jatah-cuti' : 'jatah-cuti/${txtJatahId.text}',
        methodeRequest: txtJatahId.text == '' ? MethodeRequest.post : MethodeRequest.put,
        body: body,
        contentIsJson: true,
      );
      Get.back();
      if (hasil.success) {
        loadJatah();
        if (Get.isRegistered<cuti_masal.CutiMasalControl>()) {
          if (selectedKaryawanJatah != null) {
            Get.find<cuti_masal.CutiMasalControl>().loadSingleInfoMasal(selectedKaryawanJatah!.value);
          }
        }
        Get.back(); // Close the jatah form dialog
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> hapusJatah(String id) async {
    AFwidget.formHapus(
      label: 'Jatah Cuti Tahunan',
      aksi: () async {
        try {
          AFwidget.loading();
          var hasil = await AFdatabase.send(url: 'jatah-cuti/$id', methodeRequest: MethodeRequest.delete);
          Get.back();
          if (hasil.success) {
            loadJatah();
            Get.back();
            Get.back();
            AFwidget.snackbar(hasil.message);
          } else {
            AFwidget.formWarning(label: hasil.message);
          }
        } catch (er) {
          AFwidget.formWarning(label: '$er');
        }
      },
    );
  }

  void editForm(String id) {
    clearForm();
    Cuti? cuti = listCuti.firstWhereOrNull((element) => element.id == id);
    if(cuti != null) {
      currentId = cuti.id;
      formType = cuti.jenisForm;
      selectedKaryawan = cuti.karyawan;

      // Check if TAHUNAN, IJIN, or CUTI_MASAL detail has a snapshot
      var snapDet = cuti.details.firstWhereOrNull(
        (d) => (d['kategori'] == 'TAHUNAN' || d['kategori'] == 'IJIN' || d['kategori'] == 'CUTI_MASAL') && d['snap_total_hak_cuti'] != null
      );
      if (selectedKaryawan != null) {
          hasJatah = listJatah.any((e) => e.karyawanId == selectedKaryawan!.id);
          fetchInfoCuti(snapDet: snapDet);
      }
      if(cuti.tanggalKembali != null) {
          txtTanggalKembali.text = AFconvert.matDate(cuti.tanggalKembali);
      }
      
      for(var det in cuti.details) {
          String kat = det['kategori'] ?? '';
          if(kat == 'TAHUNAN') {
              idDetailTahunan = det['id']?.toString() ?? '';
              cekTahunan = true;
              txtAkanDiambil.text = det['lama_hari']?.toString() ?? '';
              txtKetTahunan.text = det['keterangan'] ?? '';
              if(det['dates'] != null) {
                  for(var dt in det['dates']) {
                      DateTime? t = AFconvert.keTanggal(dt['tanggal']);
                      if(t != null) tglTahunan.add(t);
                  }
              }
              hitungSisa();
          } else if(kat == 'KHUSUS') {
              idDetailKhusus = det['id']?.toString() ?? '';
              cekKhusus = true;
              var dJenis = det['jenis_cuti_khusus_id'];
              if(dJenis != null) {
                  jenisKhusus = listJenisKhusus.firstWhereOrNull((e) => e.value == dJenis.toString());
              }
              txtLamaKhusus.text = det['lama_hari']?.toString() ?? '';
              txtKetKhusus.text = det['keterangan'] ?? '';
              if(det['dates'] != null) {
                  for(var dt in det['dates']) {
                      DateTime? t = AFconvert.keTanggal(dt['tanggal']);
                      if(t != null) tglKhusus.add(t);
                  }
              }
          } else if(kat == 'CUTI_MASAL') {
              idDetailMasal = det['id']?.toString() ?? '';
              cekMasal = true;
              txtLamaMasal.text = det['lama_hari']?.toString() ?? '';
              txtKetMasal.text = det['keterangan'] ?? '';
              if(det['dates'] != null) {
                  for(var dt in det['dates']) {
                      DateTime? t = AFconvert.keTanggal(dt['tanggal']);
                      if(t != null) tglMasal.add(t);
                  }
              }
          } else if(kat == 'UNPAID') {
              idDetailUnpaid = det['id']?.toString() ?? '';
              cekUnpaid = true;
              var dJenis = det['jenis_unpaid'];
              if(dJenis != null) {
                  jenisUnpaid = listJenisUnpaid.firstWhereOrNull((e) => e.value == dJenis);
              }
              txtKetUnpaid.text = det['keterangan'] ?? '';
              if(det['dates'] != null) {
                  for(var dt in det['dates']) {
                      DateTime? t = AFconvert.keTanggal(dt['tanggal']);
                      if(t != null) tglUnpaid.add(t);
                  }
              }
          } else if(kat == 'GANTI_HARI_LIBUR') {
              idDetailGantiLibur = det['id']?.toString() ?? '';
              cekGantiLibur = true;
              txtKetGantiLibur.text = det['keterangan'] ?? '';
              if(det['dates'] != null) {
                  for(var dt in det['dates']) {
                      DateTime? t = AFconvert.keTanggal(dt['tanggal']);
                      if(t != null) tglGantiLibur.add(t);
                  }
              }
          } else if(kat == 'IJIN') {
              // Ijin form uses TAHUNAN variables under the hood in CutiFormView (it checks formType == 'IJIN' and displays Tahunan checklist)
              idDetailTahunan = det['id']?.toString() ?? '';
              cekTahunan = true;
              txtAkanDiambil.text = det['lama_hari']?.toString() ?? '';
              txtKetTahunan.text = det['keterangan'] ?? '';
              if(det['dates'] != null) {
                  for(var dt in det['dates']) {
                      DateTime? t = AFconvert.keTanggal(dt['tanggal']);
                      if(t != null) tglTahunan.add(t);
                  }
              }
              hitungSisa();
          }
      }
      
      var detKhusus = cuti.details.firstWhereOrNull((d) => d['kategori'] == 'KHUSUS');
      if(detKhusus != null) {
          if(tglKhusus.length > 5 || satuanKhusus == 'bulan') {
              tglKhusus.sort();
              if(tglKhusus.isNotEmpty) {
                  txtTglAwalKhusus.text = AFconvert.matDate(tglKhusus.first);
                  txtTglAkhirKhusus.text = AFconvert.matDate(tglKhusus.last);
              }
          }
      }

      var detUnpaid = cuti.details.firstWhereOrNull((d) => d['kategori'] == 'UNPAID');
      if(detUnpaid != null) {
          txtLamaUnpaid.text = detUnpaid['lama_hari']?.toString() ?? '';
      }
      
      var detLibur = cuti.details.firstWhereOrNull((d) => d['kategori'] == 'GANTI_HARI_LIBUR');
      if(detLibur != null) {
          txtLamaGantiLibur.text = detLibur['lama_hari']?.toString() ?? '';
      }
      
      update();
    }
  }

  bool isTanggalDuplicate(DateTime date, {String skipKategori = ''}) {
    String strDate = AFconvert.matYMD(date);
    if (skipKategori != 'TAHUNAN' && tglTahunan.any((d) => AFconvert.matYMD(d) == strDate)) return true;
    if (skipKategori != 'UNPAID' && tglUnpaid.any((d) => AFconvert.matYMD(d) == strDate)) return true;
    if (skipKategori != 'GANTI_LIBUR' && tglGantiLibur.any((d) => AFconvert.matYMD(d) == strDate)) return true;
    
    if (skipKategori != 'KHUSUS') {
        int lm = AFconvert.keInt(txtLamaKhusus.text);
        if (lm > 5 || satuanKhusus == 'bulan') {
            if (txtTglAwalKhusus.text.isNotEmpty && txtTglAkhirKhusus.text.isNotEmpty) {
                DateTime start = DateFormat('dd-MM-yyyy').parse(txtTglAwalKhusus.text);
                DateTime end = DateFormat('dd-MM-yyyy').parse(txtTglAkhirKhusus.text);
                if (date.compareTo(start) >= 0 && date.compareTo(end) <= 0) return true;
            }
        } else {
            if (tglKhusus.any((d) => AFconvert.matYMD(d) == strDate)) return true;
        }
    }
    return false;
  }

  void clearForm() {
    bolehMinusTahunan = false;
    debugCanSubmitReason = '';
    currentId = '';
    selectedKaryawan = null;
    txtTanggalKembali.clear();
    idDetailTahunan = '';
    idDetailKhusus = '';
    idDetailUnpaid = '';
    idDetailGantiLibur = '';
    cekTahunan = false; cekKhusus = false; cekUnpaid = false; cekGantiLibur = false;
    tglTahunan.clear(); tglKhusus.clear(); tglUnpaid.clear(); tglGantiLibur.clear();
    txtKetTahunan.clear(); txtKetKhusus.clear(); txtKetUnpaid.clear(); txtKetGantiLibur.clear();
    cekMasal = false;
    idDetailMasal = '';
    txtLamaMasal.clear();
    txtKetMasal.clear();
    tglMasal.clear();
    txtAkanDiambil.clear();
    txtLamaKhusus.clear();
    txtLamaUnpaid.clear();
    txtLamaGantiLibur.clear();
    txtTglAwalKhusus.clear();
    txtTglAkhirKhusus.clear();
    satuanKhusus = 'hari';
    jenisKhusus = null;
    jenisUnpaid = null;
    update();
  }


  String debugCanSubmitReason = '';
  
  bool get canSubmit {
    if (selectedKaryawan == null) { debugCanSubmitReason = ''; return false; }
    if (txtTanggalKembali.text.isEmpty) { debugCanSubmitReason = 'Tanggal Masuk Kembali belum diisi'; return false; }
    
    bool anyChecked = cekTahunan || cekKhusus || cekUnpaid || cekGantiLibur || cekMasal;
    if (!anyChecked) { debugCanSubmitReason = 'Pilih minimal satu jenis cuti'; return false; }
    
    if (cekTahunan) {
      int lm = AFconvert.keInt(txtAkanDiambil.text);
      if (lm <= 0) { debugCanSubmitReason = 'Lama cuti tahunan belum diisi'; return false; }
      if (!bolehMinusTahunan && sisaHakCuti < 0) { debugCanSubmitReason = 'Lama cuti tidak boleh lebih besar dari sisa cuti yang dapat diambil'; return false; }
      if (tglTahunan.length != lm) { debugCanSubmitReason = 'Jumlah tanggal cuti tahunan tidak sesuai dengan lama cuti'; return false; }
      if (txtKetTahunan.text.isEmpty) { debugCanSubmitReason = 'Keterangan cuti tahunan belum diisi'; return false; }
    }
    
    if (cekKhusus) {
      if (jenisKhusus == null) { debugCanSubmitReason = 'Jenis cuti khusus belum dipilih'; return false; }
      int lm = AFconvert.keInt(txtLamaKhusus.text);
      if (lm <= 0) { debugCanSubmitReason = 'Lama cuti khusus belum diisi'; return false; }
      if (lm > 5 || satuanKhusus == 'bulan') {
        if (txtTglAwalKhusus.text.isEmpty || txtTglAkhirKhusus.text.isEmpty) { debugCanSubmitReason = 'Tanggal mulai/akhir cuti khusus belum dipilih'; return false; }
      } else {
        if (tglKhusus.length != lm) { debugCanSubmitReason = 'Jumlah tanggal cuti khusus tidak sesuai dengan lama cuti'; return false; }
      }
      if (txtKetKhusus.text.isEmpty) { debugCanSubmitReason = 'Keterangan cuti khusus belum diisi'; return false; }
    }
    
    if (cekUnpaid) {
      if (jenisUnpaid == null) { debugCanSubmitReason = 'Jenis unpaid leave belum dipilih'; return false; }
      int lm = AFconvert.keInt(txtLamaUnpaid.text);
      if (lm <= 0) { debugCanSubmitReason = 'Lama unpaid leave belum diisi'; return false; }
      if (tglUnpaid.length != lm) { debugCanSubmitReason = 'Jumlah tanggal unpaid leave tidak sesuai dengan lama cuti'; return false; }
      if (txtKetUnpaid.text.isEmpty) { debugCanSubmitReason = 'Keterangan unpaid leave belum diisi'; return false; }
    }
    
    if (cekMasal) {
      if (txtKetMasal.text.isEmpty) { debugCanSubmitReason = 'Keterangan cuti masal belum diisi'; return false; }
    }
    
    if (cekGantiLibur) {
      int lm = AFconvert.keInt(txtLamaGantiLibur.text);
      if (lm <= 0) { debugCanSubmitReason = 'Lama ganti libur belum diisi'; return false; }
      if (tglGantiLibur.length != lm) { debugCanSubmitReason = 'Jumlah tanggal ganti libur tidak sesuai dengan lama libur'; return false; }
      if (txtKetGantiLibur.text.isEmpty) { debugCanSubmitReason = 'Keterangan ganti libur belum diisi'; return false; }
    }
    
    debugCanSubmitReason = '';
    return true;
  }

  Future<void> submitForm() async {
    if(selectedKaryawan == null) {
        AFwidget.snackbar('Pilih karyawan terlebih dahulu');
        return;
    }
    
    List<Map<String, dynamic>> details = [];
    
    if(cekTahunan) {
        details.add({
            'id': idDetailTahunan,
            'kategori': formType == 'IJIN' ? 'IJIN' : 'TAHUNAN',
            'lama_hari': AFconvert.keInt(txtAkanDiambil.text),
            'keterangan': txtKetTahunan.text,
            'dates': tglTahunan.map((e) => AFconvert.matYMD(e)).toList(),
        });
    }
    if(cekKhusus) {
        List<DateTime> finalTglKhusus = [...tglKhusus];
        int lm = AFconvert.keInt(txtLamaKhusus.text);
        if ((lm > 5 || satuanKhusus == 'bulan') && txtTglAwalKhusus.text.isNotEmpty && txtTglAkhirKhusus.text.isNotEmpty) {
            finalTglKhusus.clear();
            DateTime start = DateFormat('dd-MM-yyyy').parse(txtTglAwalKhusus.text);
            DateTime end = DateFormat('dd-MM-yyyy').parse(txtTglAkhirKhusus.text);
            for (DateTime d = start; d.compareTo(end) <= 0; d = d.add(const Duration(days: 1))) {
                finalTglKhusus.add(d);
            }
        }
        details.add({
            'id': idDetailKhusus,
            'kategori': 'KHUSUS',
            'jenis_cuti_khusus_id': jenisKhusus?.value,
            'lama_hari': lm,
            'keterangan': txtKetKhusus.text,
            'dates': finalTglKhusus.map((e) => AFconvert.matYMD(e)).toList(),
        });
    }
    if(cekMasal) {
        details.add({
            'id': idDetailMasal,
            'kategori': 'CUTI_MASAL',
            'lama_hari': AFconvert.keInt(txtLamaMasal.text),
            'keterangan': txtKetMasal.text,
            'dates': tglMasal.map((e) => AFconvert.matYMD(e)).toList(),
        });
    }
    if(cekUnpaid) {
        details.add({
            'id': idDetailUnpaid,
            'kategori': 'UNPAID',
            'jenis_unpaid': jenisUnpaid?.value,
            'lama_hari': AFconvert.keInt(txtLamaUnpaid.text),
            'keterangan': txtKetUnpaid.text,
            'dates': tglUnpaid.map((e) => AFconvert.matYMD(e)).toList(),
        });
    }
    if(cekGantiLibur) {
        details.add({
            'id': idDetailGantiLibur,
            'kategori': 'GANTI_HARI_LIBUR',
            'lama_hari': AFconvert.keInt(txtLamaGantiLibur.text),
            'keterangan': txtKetGantiLibur.text,
            'dates': tglGantiLibur.map((e) => AFconvert.matYMD(e)).toList(),
        });
    }

    if(details.isEmpty) {
        AFwidget.snackbar('Pilih minimal 1 jenis cuti/ijin');
        return;
    }

    var body = {
        'id': currentId,
        'karyawan_id': selectedKaryawan!.id,
        'jenis_form': formType,
          'tanggal_kembali': txtTanggalKembali.text.isNotEmpty ? AFconvert.matYMD(DateFormat('dd-MM-yyyy').parse(txtTanggalKembali.text)) : null,
        'tahun': AFconvert.keInt(filterTahun.value),
        'details': details,
    };

    AFwidget.loading();
    var hasil = await repo.submit(body);
    Get.back();

    if(hasil.success) {
        clearForm();
        loadCutis();
        Get.back(); // close dialog/form
        AFwidget.snackbar('Form berhasil disimpan');
    } else {
        AFwidget.formWarning(label: 'Gagal menyimpan: ${hasil.message}');
    }
  }

  Future<void> hapusData(String id) async {
    AFwidget.formHapus(
      label: 'Cuti / Ijin',
      aksi: () async {
        AFwidget.loading();
        var hasil = await repo.delete(id);
        Get.back();
        if(hasil.success) {
          loadCutis();
          Get.back();
          Get.back();
          AFwidget.snackbar('Data berhasil dihapus');
        } else {
          AFwidget.formWarning(label: hasil.message);
        }
      },
    );
  }
}
