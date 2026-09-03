import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/models/agama.dart';
import 'package:fjghrd/models/area.dart';
import 'package:fjghrd/models/divisi.dart';
import 'package:fjghrd/models/jabatan.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/keluarga_karyawan.dart';
import 'package:fjghrd/models/keluarga_kontak.dart';
import 'package:fjghrd/models/payroll.dart';
import 'package:fjghrd/models/pendidikan.dart';
import 'package:fjghrd/models/perjanjian_kerja.dart';
import 'package:fjghrd/models/training.dart';
import 'package:fjghrd/models/training_karyawan.dart';
import 'package:fjghrd/repositories/training_repository.dart';

import 'package:fjghrd/models/phk.dart';
import 'package:fjghrd/models/payroll_phk.dart';
import 'package:fjghrd/models/ptkp.dart';
import 'package:fjghrd/models/status_kerja.dart';
import 'package:fjghrd/models/status_phk.dart';
import 'package:fjghrd/models/timeline_masakerja.dart';
import 'package:fjghrd/models/uang_phk_2.dart';
import 'package:fjghrd/repositories/agama_repository.dart';
import 'package:fjghrd/repositories/area_repository.dart';
import 'package:fjghrd/repositories/divisi_repository.dart';
import 'package:fjghrd/repositories/jabatan_repository.dart';
import 'package:fjghrd/repositories/karyawan_repository.dart';
import 'package:fjghrd/repositories/pendidikan_repository.dart';
import 'package:fjghrd/repositories/ptkp_repository.dart';
import 'package:fjghrd/repositories/status_kerja_repository.dart';
import 'package:fjghrd/repositories/status_phk_repository.dart';
import 'package:fjghrd/repositories/uang_phk_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class KaryawanControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final KaryawanRepository _repo = KaryawanRepository();

  final DateTime _now = DateTime.now();

  Karyawan current = Karyawan();
  RxList<Karyawan> listKaryawan = <Karyawan>[].obs;
  RxList<Karyawan> listCalonKaryawan = <Karyawan>[].obs;
  RxList<Karyawan> listMantanKaryawan = <Karyawan>[].obs;
  List<Karyawan> listUlangTahun = [];
  List<Opsi> listAgama = [];
  List<Opsi> listArea = [];
  List<Opsi> listDivisi = [];
  List<Opsi> listJabatan = [];
  List<Opsi> listPendidikan = [];
  List<Opsi> listStatusKerja = [];
  List<Opsi> listStatusPhk = [];
  List<Opsi> listPtkp = [];
  List<KeluargaKaryawan> listKeluarga = [];
  List<KeluargaKontak> listKontak = [];
  List<PerjanjianKerja> listPerjanjianKerja = [];
  List<TrainingKaryawan> listTrainingKaryawan = [];
  List<TimelineMasakerja> listTimelineMasakerja = [];
  RxList<Payroll> listPayroll = <Payroll>[].obs;
  PayrollPhk payrollPhk = PayrollPhk();
  Opsi filterStaf = Opsi(value: 'Y', label: 'STAF');
  Opsi filterArea = Opsi(value: '', label: 'SEMUA');
  Opsi filterStatusKerja = Opsi(value: '', label: 'SEMUA');
  Map<String, int> totalKaryawanPerArea = {};
  Map<String, int> totalCalonKaryawanPerArea = {};
  Map<String, Map<String, int>> totalKaryawanPerStatuskerjaPerArea = {};
  Map<String, Map<String, int>> totalKaryawanPerKelamin = {};
  Map<String, Map<String, int>> totalKaryawanPerKawin = {};
  Map<String, Map<String, int>> totalKaryawanPerAgama = {};
  Map<String, Map<String, int>> totalKaryawanPerPendidikan = {};
  Map<String, Map<String, int>> totalKaryawanPerUsia = {};

  late TextEditingController txtId, txtNama, txtNik, txtTanggalMasuk, txtTanggalKeluar, txtNomorKk,
      txtNomorKtp, txtNomorPaspor, txtNomorPwp, txtTempatLahir, txtTanggalLahir, txtAlamatKtp,
      txtAlamatTinggal, txtTelepon, txtEmail, txtPendidikanAlmamater, txtPendidikanJurusan;
  late TextEditingController txtKeluargaId, txtKeluargaNama, txtKeluargaNomorKtp, txtKeluargaTempatLahir,
      txtKeluargaTanggalLahir, txtKeluargaTelepon, txtKeluargaEmail;
  late TextEditingController txtKontakId, txtKontakNama, txtKontakTelepon, txtKontakEmail;
  late TextEditingController txtPerjanjianId, txtPerjanjianNomor, txtPerjanjianTglAwal, txtPerjanjianTglAkhir, txtPhkKeterangan;
  late TextEditingController txtTrainingKaryawanId, txtTrainingKaryawanTanggal, txtTrainingKaryawanKeterangan;
  late TextEditingController txtKompensasi, txtPesangon, txtMasaKerja, txtUangPisah, txtSisaCutiHari, txtSisaCutiJumlah, txtLain,
      txtPotKas, txtPotCutiHari, txtPotCutiJumlah, txtPotLain;
  late TextEditingController txtPayrollPhkTglAwal, txtPayrollPhkTglAkhir, txtPayrollPhkGaji, txtPayrollPhkKenaikanGaji, txtPayrollPhkHariMakan, txtPayrollPhkUangMakanHarian,
      txtPayrollPhkUangMakanJumlah, txtPayrollPhkOvertimeFjg, txtPayrollPhkOvertimeCus, txtPayrollPhkMedical, txtPayrollPhkThr,
      txtPayrollPhkBonus, txtPayrollPhkInsentif, txtPayrollPhkTelkomsel, txtPayrollPhkLain, txtPayrollPhkPot25hari,
      txtPayrollPhkPot25jumlah, txtPayrollPhkPotTelepon, txtPayrollPhkPotBensin, txtPayrollPhkPotKas, txtPayrollPhkPotCicilan,
      txtPayrollPhkPotBpjs, txtPayrollPhkPotCutiHari, txtPayrollPhkPotCutiJumlah, txtPayrollPhkPotLain, txtPayrollPhkPotKompensasiJam,
      txtPayrollPhkPotKompensasiJumlah, txtPayrollPhkTotalDiterima, txtPayrollPhkKeterangan;
  Agama agama = Agama();
  Area area = Area();
  Divisi divisi = Divisi();
  Jabatan jabatan = Jabatan();
  Pendidikan pendidikan = Pendidikan();
  StatusKerja statusKerja = StatusKerja();
  StatusKerja statusKerjaPerjanjian = StatusKerja();
  Training? trainingTerpilih;
  StatusPhk statusPhk = StatusPhk();
  Ptkp ptkp = Ptkp();

  String kawin = '';
  String kelamin = '';
  String aktif = '';
  bool? staf = true;
  bool? manajemen = false;
  String keluargaHubungan = '';

  late Opsi filterTahun;
  late Opsi tahunPhk;
  late Opsi bulanPhk;
  late List<Opsi> listTahun;
  List<Opsi> listTraining = [];
  List<Opsi> listBulan = mapBulan.entries.map((e) => Opsi(value: e.key.toString(), label: e.value)).toList();

  // Field untuk dialog download Excel Payroll per periode
  Opsi payrollBulanAwal = Opsi(value: '1', label: 'JANUARI');
  Opsi payrollBulanAkhir = Opsi(value: '12', label: 'DESEMBER');
  late Opsi payrollTahunAwal;
  late Opsi payrollTahunAkhir;


  Map<int, bool> bulanTerpilih = {
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
    6: false,
    7: false,
    8: false,
    9: false,
    10: false,
    11: false,
    12: false,
  };

  Map<String, String> mapKeluargaHubungan = {
    'S' : 'Suami',
    'I' : 'Istri',
    'A' : 'Anak',
    'M' : 'Menantu',
    'C' : 'Cucu',
    'O' : 'Orang Tua',
    'T' : 'Mertua',
    'F' : 'Famili Lain',
  };

  bool payrollPhkMakanHarian = true;

  Future<void> loadKaryawans() async {
    var hasil = await _repo.findAll(
      isStaf: filterStaf.value,
      area: filterArea.value,
      statusKerja: filterStatusKerja.value,
    );
    if (hasil.success) {
      listKaryawan.clear();
      List<Karyawan> tempKaryawans = [];
      listUlangTahun.clear();
      totalKaryawanPerArea.clear();
      totalKaryawanPerStatuskerjaPerArea.clear();
      totalKaryawanPerKelamin.clear();
      totalKaryawanPerKawin.clear();
      totalKaryawanPerAgama.clear();
      totalKaryawanPerPendidikan.clear();
      totalKaryawanPerUsia.clear();
      String hariUltah = AFconvert.matMD(_now);
      for (var data in hasil.daftar) {
        var k = Karyawan.fromMap(data);
        tempKaryawans.add(k);

        if(AFconvert.matMD(k.tanggalLahir) == hariUltah) {
          listUlangTahun.add(k);
        }

        if (totalKaryawanPerArea.containsKey('TOTAL KARYAWAN')) {
          totalKaryawanPerArea['TOTAL KARYAWAN'] = totalKaryawanPerArea['TOTAL KARYAWAN']! + 1;
        } else {
          totalKaryawanPerArea['TOTAL KARYAWAN'] = 1;
        }
        if (totalKaryawanPerArea.containsKey(k.area.kode)) {
          totalKaryawanPerArea[k.area.kode] = totalKaryawanPerArea[k.area.kode]! + 1;
        } else {
          totalKaryawanPerArea[k.area.kode] = 1;
        }

        if (!totalKaryawanPerStatuskerjaPerArea.containsKey(k.statusKerja.nama)) {
          totalKaryawanPerStatuskerjaPerArea[k.statusKerja.nama] = {};
          totalKaryawanPerStatuskerjaPerArea[k.statusKerja.nama]!['TOTAL KARYAWAN'] = 0;
        }
        if (totalKaryawanPerStatuskerjaPerArea[k.statusKerja.nama]!.containsKey(k.area.kode)) {
          totalKaryawanPerStatuskerjaPerArea[k.statusKerja.nama]![k.area.kode] = totalKaryawanPerStatuskerjaPerArea[k.statusKerja.nama]![k.area.kode]! + 1;
        } else {
          totalKaryawanPerStatuskerjaPerArea[k.statusKerja.nama]![k.area.kode] = 1;
        }
        totalKaryawanPerStatuskerjaPerArea[k.statusKerja.nama]!['TOTAL KARYAWAN'] = totalKaryawanPerStatuskerjaPerArea[k.statusKerja.nama]!['TOTAL KARYAWAN']! + 1;

        if (!totalKaryawanPerKelamin.containsKey(k.kelamin)) {
          totalKaryawanPerKelamin[k.kelamin] = {};
          totalKaryawanPerKelamin[k.kelamin]!['TOTAL KARYAWAN'] = 0;
        }
        if (totalKaryawanPerKelamin[k.kelamin]!.containsKey(k.area.kode)) {
          totalKaryawanPerKelamin[k.kelamin]![k.area.kode] = totalKaryawanPerKelamin[k.kelamin]![k.area.kode]! + 1;
        } else {
          totalKaryawanPerKelamin[k.kelamin]![k.area.kode] = 1;
        }
        totalKaryawanPerKelamin[k.kelamin]!['TOTAL KARYAWAN'] = totalKaryawanPerKelamin[k.kelamin]!['TOTAL KARYAWAN']! + 1;

        if (!totalKaryawanPerKawin.containsKey(k.kawin)) {
          totalKaryawanPerKawin[k.kawin] = {};
          totalKaryawanPerKawin[k.kawin]!['TOTAL KARYAWAN'] = 0;
        }
        if (totalKaryawanPerKawin[k.kawin]!.containsKey(k.area.kode)) {
          totalKaryawanPerKawin[k.kawin]![k.area.kode] = totalKaryawanPerKawin[k.kawin]![k.area.kode]! + 1;
        } else {
          totalKaryawanPerKawin[k.kawin]![k.area.kode] = 1;
        }
        totalKaryawanPerKawin[k.kawin]!['TOTAL KARYAWAN'] = totalKaryawanPerKawin[k.kawin]!['TOTAL KARYAWAN']! + 1;

        if (!totalKaryawanPerAgama.containsKey(k.agama.nama)) {
          totalKaryawanPerAgama[k.agama.nama] = {};
          totalKaryawanPerAgama[k.agama.nama]!['TOTAL KARYAWAN'] = 0;
        }
        if (totalKaryawanPerAgama[k.agama.nama]!.containsKey(k.area.kode)) {
          totalKaryawanPerAgama[k.agama.nama]![k.area.kode] = totalKaryawanPerAgama[k.agama.nama]![k.area.kode]! + 1;
        } else {
          totalKaryawanPerAgama[k.agama.nama]![k.area.kode] = 1;
        }
        totalKaryawanPerAgama[k.agama.nama]!['TOTAL KARYAWAN'] = totalKaryawanPerAgama[k.agama.nama]!['TOTAL KARYAWAN']! + 1;

        if (!totalKaryawanPerPendidikan.containsKey(k.pendidikan.nama)) {
          totalKaryawanPerPendidikan[k.pendidikan.nama] = {};
          totalKaryawanPerPendidikan[k.pendidikan.nama]!['TOTAL KARYAWAN'] = 0;
        }
        if (totalKaryawanPerPendidikan[k.pendidikan.nama]!.containsKey(k.area.kode)) {
          totalKaryawanPerPendidikan[k.pendidikan.nama]![k.area.kode] = totalKaryawanPerPendidikan[k.pendidikan.nama]![k.area.kode]! + 1;
        } else {
          totalKaryawanPerPendidikan[k.pendidikan.nama]![k.area.kode] = 1;
        }
        totalKaryawanPerPendidikan[k.pendidikan.nama]!['TOTAL KARYAWAN'] = totalKaryawanPerPendidikan[k.pendidikan.nama]!['TOTAL KARYAWAN']! + 1;

        if (!totalKaryawanPerUsia.containsKey(getKelompokUsia(k.tanggalLahir))) {
          totalKaryawanPerUsia[getKelompokUsia(k.tanggalLahir)] = {};
          totalKaryawanPerUsia[getKelompokUsia(k.tanggalLahir)]!['TOTAL KARYAWAN'] = 0;
        }
        if (totalKaryawanPerUsia[getKelompokUsia(k.tanggalLahir)]!.containsKey(k.area.kode)) {
          totalKaryawanPerUsia[getKelompokUsia(k.tanggalLahir)]![k.area.kode] = totalKaryawanPerUsia[getKelompokUsia(k.tanggalLahir)]![k.area.kode]! + 1;
        } else {
          totalKaryawanPerUsia[getKelompokUsia(k.tanggalLahir)]![k.area.kode] = 1;
        }
        totalKaryawanPerUsia[getKelompokUsia(k.tanggalLahir)]!['TOTAL KARYAWAN'] = totalKaryawanPerUsia[getKelompokUsia(k.tanggalLahir)]!['TOTAL KARYAWAN']! + 1;
      }
      listKaryawan.assignAll(tempKaryawans);
      update(['summary_karyawan', 'ulang_tahun', 'demografi', 'beranda']);
    }
  }

  Future<void> loadCalonKaryawans() async {
    var hasil = await _repo.calonFindAll(isStaf: filterStaf.value, area: filterArea.value);
    if (hasil.success) {
      listCalonKaryawan.clear();
      List<Karyawan> tempCalon = [];
      totalCalonKaryawanPerArea.clear();
      for (var data in hasil.daftar) {
        var k = Karyawan.fromMap(data);
        tempCalon.add(k);
        if(filterArea.value == '') {
          if (totalCalonKaryawanPerArea.containsKey('TOTAL KARYAWAN')) {
            totalCalonKaryawanPerArea['TOTAL KARYAWAN'] = totalCalonKaryawanPerArea['TOTAL KARYAWAN']! + 1;
          } else {
            totalCalonKaryawanPerArea['TOTAL KARYAWAN'] = 1;
          }
        }
        if (totalCalonKaryawanPerArea.containsKey(k.area.kode)) {
          totalCalonKaryawanPerArea[k.area.kode] = totalCalonKaryawanPerArea[k.area.kode]! + 1;
        } else {
          totalCalonKaryawanPerArea[k.area.kode] = 1;
        }
      }
      listCalonKaryawan.assignAll(tempCalon);
      update(['summary_calon']);
    }
  }

  Future<void> loadMantanKaryawans() async {
    var hasil = await _repo.mantanFindAll(isStaf: filterStaf.value);
    if (hasil.success) {
      listMantanKaryawan.assignAll(hasil.daftar.map<Karyawan>((data) => Karyawan.fromMap(data)).toList());
    }
  }

  Future<void> loadKeluargas() async {
    listKeluarga.clear();
    var hasil = await _repo.keluargaFindAll(current.id);
    if (hasil.success) {
      for (var data in hasil.daftar) {
        listKeluarga.add(KeluargaKaryawan.fromMap(data));
      }
    }
    update(['detail_karyawan']);
  }

  Future<void> loadKontaks() async {
    listKontak.clear();
    var hasil = await _repo.kontakKeluargaFindAll(current.id);
    if (hasil.success) {
      for (var data in hasil.daftar) {
        listKontak.add(KeluargaKontak.fromMap(data));
      }
    }
    update(['detail_karyawan']);
  }

  Future<void> loadTrainings() async {
    TrainingRepository repo = TrainingRepository();
    var hasil = await repo.findAll();
    if(hasil.success) {
      listTraining.clear();
      for (var data in hasil.daftar) {
        listTraining.add(
          Opsi(value: AFconvert.keString(data['id']), label: data['nama'], data: data),
        );
      }
    }
  }

  Future<void> loadTrainingKaryawan() async {
    listTrainingKaryawan.clear();
    var hasil = await _repo.trainingKaryawanFindAll(current.id.toString());
    if (hasil.success) {
      for (var data in hasil.daftar) {
        listTrainingKaryawan.add(TrainingKaryawan.fromMap(data));
      }
    }
    update(['detail_karyawan']);
  }

  Future<void> loadPerjanjianKerjas() async {
    listPerjanjianKerja.clear();
    var hasil = await _repo.perjanjianKerjaFindAll(current.id);
    if (hasil.success) {
      for (var data in hasil.daftar) {
        listPerjanjianKerja.add(PerjanjianKerja.fromMap(data));
      }
    }
    update(['detail_karyawan']);
  }

  Future<void> loadTimelineMasakerja() async {
    listTimelineMasakerja.clear();
    var hasil = await _repo.timelineMasakerja(current.id);
    if (hasil.success) {
      for (var data in hasil.daftar) {
        listTimelineMasakerja.add(TimelineMasakerja.fromMap(data));
      }
    }
    update(['detail_karyawan']);
  }

  Future<void> loadPayrolls() async {
    listPayroll.clear();
    var hasil = await _repo.payrollFindAll(id: current.id, tahun: filterTahun.value);
    if (hasil.success) {
      for (var data in hasil.daftar) {
        listPayroll.add(Payroll.fromMap(data));
      }
    }
    update(['detail_karyawan']);
  }

  void ubahForm(String id, String statusAktif) {
    if(statusAktif == 'P') {
      current = listCalonKaryawan.where((element) => element.id == id).first;
    } else if(statusAktif == 'N') {
      current = listMantanKaryawan.where((element) => element.id == id).first;
    } else {
      current = listKaryawan.where((element) => element.id == id).first;
    }
    txtId.text = current.id;
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
    loadKeluargas();
    loadKontaks();
    loadPerjanjianKerjas();
    loadTrainingKaryawan();
    loadTimelineMasakerja();
    Get.toNamed(Rute.karyawanForm);
  }

  void payrollView(String id) {
    current = listKaryawan.where((element) => element.id == id).first;
    loadPayrolls();
    Get.toNamed(Rute.karyawanPayrollView);
  }

  Future<void> tambahData() async {
    try {
      if(area.id == '') {
        throw ValidationException('Silakan pilih area');
      }
      if(staf == null) {
        throw ValidationException('Silakan pilih jenis karyawan (staf atau non staf)');
      }
      if(aktif == '') {
        throw ValidationException('Silakan pilih status aktif');
      }
      if(txtNama.text.isEmpty) {
        throw ValidationException('Nama harus diisi');
      }
      if(txtTanggalMasuk.text.isEmpty) {
        throw ValidationException('Masa kerja harus diisi');
      }
      if(jabatan.id == '') {
        throw ValidationException('Silakan pilih jabatan');
      }
      if(txtNomorKtp.text.isEmpty) {
        throw ValidationException('Nomor KTP harus diisi');
      }
      if(txtTempatLahir.text.isEmpty || txtTanggalLahir.text.isEmpty) {
        throw ValidationException('Tempat & tanggal lahir harus diisi');
      }
      if(txtAlamatKtp.text.isEmpty) {
        throw ValidationException('Alamat sesuai KTP harus diisi');
      }
      if(txtTelepon.text.isEmpty) {
        throw ValidationException('Nomor telepon harus diisi');
      }
      if(kawin == '') {
        throw ValidationException('Silakan isi status kawin');
      }
      if(kelamin == '') {
        throw ValidationException('Silakan pilih jenis kelamin');
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
        kawin: kawin,
        kelamin: kelamin,
        nomorKk: txtNomorKk.text,
        nomorPaspor: txtNomorPaspor.text,
        nomorPwp: txtNomorPwp.text,
        pendidikanAlmamater: txtPendidikanAlmamater.text,
        pendidikanJurusan: txtPendidikanJurusan.text,
        aktif: aktif,
        staf: staf ?? true,
        manajemen: manajemen ?? false,
      );
      a.agama = agama;
      a.area = area;
      a.jabatan = jabatan;
      a.divisi = divisi;
      a.pendidikan = pendidikan;
      a.statusKerja = statusKerja;
      a.ptkp = ptkp;

      AFwidget.loading();
      var hasil = await _repo.create(a.toMap());
      Get.back();
      if(hasil.success) {
        loadKaryawans();
        authControl.karyawanUpdateTrigger.value++;
        loadCalonKaryawans();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> ubahData() async {
    try {
      if(txtId.text.isEmpty) {
        throw ValidationException('ID harus diisi');
      }
      if(txtNama.text.isEmpty) {
        throw ValidationException('Nama harus diisi');
      }
      if(txtTanggalMasuk.text.isEmpty) {
        throw ValidationException('Masa kerja harus diisi');
      }
      if(area.id == '') {
        throw ValidationException('Silakan pilih area');
      }
      if(divisi.id == '') {
        throw ValidationException('Silakan pilih divisi');
      }
      if(jabatan.id == '') {
        throw ValidationException('Silakan pilih jabatan');
      }
      if(txtNomorKtp.text.isEmpty) {
        throw ValidationException('Nomor KTP harus diisi');
      }
      if(txtTempatLahir.text.isEmpty || txtTanggalLahir.text.isEmpty) {
        throw ValidationException('Tempat & tanggal lahir harus diisi');
      }
      if(txtAlamatKtp.text.isEmpty) {
        throw ValidationException('Alamat sesuai KTP harus diisi');
      }
      if(txtTelepon.text.isEmpty) {
        throw ValidationException('Nomor telepon harus diisi');
      }
      if(kawin == '') {
        throw ValidationException('Silakan isi status kawin');
      }
      if(staf == null) {
        throw ValidationException('Silakan pilih jenis karyawan (staf atau non staf)');
      }
      if(aktif == '') {
        throw ValidationException('Silakan pilih status aktif');
      }
      if(kelamin == '') {
        throw ValidationException('Silakan pilih jenis kelamin');
      }
      if(statusKerja.id == '') {
        throw ValidationException('Silakan pilih status karyawan');
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
        kawin: kawin,
        kelamin: kelamin,
        nomorKk: txtNomorKk.text,
        nomorPaspor: txtNomorPaspor.text,
        nomorPwp: txtNomorPwp.text,
        pendidikanAlmamater: txtPendidikanAlmamater.text,
        pendidikanJurusan: txtPendidikanJurusan.text,
        aktif: aktif,
        staf: staf ?? true,
        manajemen: manajemen ?? false,
      );
      a.agama = agama;
      a.area = area;
      a.jabatan = jabatan;
      a.divisi = divisi;
      a.pendidikan = pendidikan;
      a.statusKerja = statusKerja;
      a.ptkp = ptkp;

      AFwidget.loading();
      var hasil = await _repo.update(a.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadKaryawans();
        authControl.karyawanUpdateTrigger.value++;
        loadCalonKaryawans();
        loadMantanKaryawans();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> hapusData(String id) async {
    try {
      if(id == '') {
        throw ValidationException('ID Karyawan null');
      }
      AFwidget.loading();
      var hasil = await _repo.delete(id);
      Get.back();
      if(hasil.success) {
        loadKaryawans();
        authControl.karyawanUpdateTrigger.value++;
        loadCalonKaryawans();
        loadMantanKaryawans();
        Get.back();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> simpanKeluargaData() async {
    try {
      if(current.id.isEmpty) {
        throw ValidationException('ID Karyawan tidak ditemukan');
      }
      if(txtKeluargaNama.text.isEmpty) {
        throw ValidationException('Nama harus diisi');
      }
      if(keluargaHubungan == '') {
        throw ValidationException('Silakan pilih hubungan keluarga dengan karyawan');
      }
      if(txtTempatLahir.text.isEmpty || txtTanggalLahir.text.isEmpty) {
        throw ValidationException('Tempat & tanggal lahir harus diisi');
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
      var hasil = txtKeluargaId.text == ''
          ? await _repo.keluargaCreate(a.karyawan.id, a.toMap())
          : await _repo.keluargaUpdate(a.karyawan.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadKeluargas();
        loadKaryawans();
        authControl.karyawanUpdateTrigger.value++;
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> hapusKeluargaData(String keluargaId) async {
    try {
      if(current.id == '') {
        throw ValidationException('ID karyawan null');
      }
      if(keluargaId == '') {
        throw ValidationException('ID keluarga null');
      }
      AFwidget.loading();
      var hasil = await _repo.keluargaDelete(current.id, keluargaId);
      Get.back();
      if(hasil.success) {
        loadKeluargas();
        loadKaryawans();
        authControl.karyawanUpdateTrigger.value++;
        Get.back();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> simpanKontakData() async {
    try {
      if(current.id.isEmpty) {
        throw ValidationException('ID Karyawan tidak ditemukan');
      }
      if(txtKontakTelepon.text.isEmpty) {
        throw ValidationException('Nomor Telepon harus diisi');
      }
      if(txtKontakNama.text.isEmpty) {
        throw ValidationException('Keterangan harus diisi');
      }
      var a = KeluargaKontak(
        id: txtKontakId.text,
        nama: txtKontakNama.text,
        telepon: txtKontakTelepon.text,
        email: txtKontakEmail.text,
      );
      a.karyawan = current;

      AFwidget.loading();
      var hasil = txtKontakId.text == ''
          ? await _repo.kontakKeluargaCreate(a.karyawan.id, a.toMap())
          : await _repo.kontakKeluargaUpdate(a.karyawan.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadKontaks();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> hapusKontakData(String kontakId) async {
    try {
      if(current.id == '') {
        throw ValidationException('ID karyawan null');
      }
      if(kontakId == '') {
        throw ValidationException('ID kontak keluarga null');
      }
      AFwidget.loading();
      var hasil = await _repo.kontakKeluargaDelete(current.id, kontakId);
      Get.back();
      if(hasil.success) {
        loadKontaks();
        Get.back();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<Opsi?> pilihTraining({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listTraining,
      valueSelected: value,
      judul: 'Pilih Training',
    );
    return a;
  }

  Future<void> simpanTrainingKaryawanData() async {
    try {
      if(current.id.isEmpty) {
        throw ValidationException('ID Karyawan tidak ditemukan');
      }
      if(trainingTerpilih == null) {
        throw ValidationException('Silakan pilih Training');
      }

      Map<String, dynamic> body = {
        'id': txtTrainingKaryawanId.text,
        'karyawan_id': current.id,
        'training_id': trainingTerpilih!.id,
        'tanggal': txtTrainingKaryawanTanggal.text,
        'keterangan': txtTrainingKaryawanKeterangan.text,
      };

      AFwidget.loading();
      var hasil = body['id'] == ''
          ? await _repo.trainingKaryawanCreate(body)
          : await _repo.trainingKaryawanUpdate(body);
      Get.back();

      if(hasil.success) {
        loadTrainingKaryawan();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> hapusTrainingKaryawanData(String id) async {
    AFwidget.loading();
    var hasil = await _repo.trainingKaryawanDelete(id);
    Get.back();
    if(hasil.success) {
      Get.back();
      AFwidget.snackbar(hasil.message);
      loadTrainingKaryawan();
    } else {
      AFwidget.formWarning(label: hasil.message);
    }
  }

  Future<void> simpanPerjanjianData() async {
    try {
      if(current.id.isEmpty) {
        throw ValidationException('ID Karyawan tidak ditemukan');
      }
      if(txtPerjanjianNomor.text.isEmpty) {
        throw ValidationException('Nomor perjanjian kerja harus diisi');
      }
      if(txtPerjanjianTglAwal.text.isEmpty) {
        throw ValidationException('Tanggal awal harus diisi');
      }
      if(statusKerjaPerjanjian.id == '') {
        throw ValidationException('Silakan pilih status');
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
      var hasil = txtPerjanjianId.text == ''
          ? await _repo.perjanjianKerjaCreate(a.karyawan.id, a.toMap())
          : await _repo.perjanjianKerjaUpdate(a.karyawan.id, a.toMap());
      Get.back();
      if(hasil.success) {
        statusKerja = a.statusKerja;
        loadPerjanjianKerjas();
    loadTrainingKaryawan();
        loadTimelineMasakerja();
        loadKaryawans();
        authControl.karyawanUpdateTrigger.value++;
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> hapusPerjanjianData(String perjanjianKerjaid) async {
    try {
      if(current.id == '') {
        throw ValidationException('ID karyawan null');
      }
      if(perjanjianKerjaid == '') {
        throw ValidationException('ID perjanjian kerja null');
      }
      AFwidget.loading();
      var hasil = await _repo.perjanjianKerjaDelete(current.id, perjanjianKerjaid);
      Get.back();
      if(hasil.success) {
        loadPerjanjianKerjas();
    loadTrainingKaryawan();
        loadTimelineMasakerja();
        Get.back();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> simpanPhkData() async {
    try {
      if(current.id.isEmpty) {
        throw ValidationException('ID Karyawan tidak ditemukan');
      }
      if(txtTanggalMasuk.text.isEmpty) {
        throw ValidationException('Tanggal awal masa kerja harus diisi');
      }
      if(txtTanggalKeluar.text.isEmpty) {
        throw ValidationException('Tanggal akhir masa kerja harus diisi');
      }
      if(statusPhk.id == '') {
        throw ValidationException('Silakan pilih status phk');
      }

      var a = Phk(
        id: current.phk.id,
        karyawanId: current.id,
        tanggalAwal: AFconvert.keTanggal('${txtTanggalMasuk.text} 08:00:00'),
        tanggalAKhir: AFconvert.keTanggal('${txtTanggalKeluar.text} 08:00:00'),
        keterangan: txtPhkKeterangan.text,
      );
      a.statusKerja = statusKerja;
      a.statusPhk = statusPhk;

      var b = UangPhk2(
        id: current.uangPhk.id,
        karyawanId: current.id,
        tahun: a.tanggalAKhir!.year,
        kompensasi: AFconvert.keInt(txtKompensasi.text),
        uangPisah: AFconvert.keInt(txtUangPisah.text),
        pesangon: AFconvert.keInt(txtPesangon.text),
        masaKerja: AFconvert.keInt(txtMasaKerja.text),
        sisaCutiHari: AFconvert.keInt(txtSisaCutiHari.text),
        sisaCutiJumlah: AFconvert.keInt(txtSisaCutiJumlah.text),
        lain: AFconvert.keInt(txtLain.text),
        potKas: AFconvert.keInt(txtPotKas.text),
        potCutiHari: AFconvert.keInt(txtPotCutiHari.text),
        potCutiJumlah: AFconvert.keInt(txtPotCutiJumlah.text),
        potLain: AFconvert.keInt(txtPotLain.text),
        keterangan: txtPhkKeterangan.text,
      );
      UangPhkRepository repoUang = UangPhkRepository();

      AFwidget.loading();
      var hasilA = current.phk.id == ''
          ? await _repo.phkCreate(a.karyawanId, a.toMap())
          : await _repo.phkUpdate(a.karyawanId, a.toMap());
      var hasilB = current.uangPhk.id == ''
          ? await repoUang.create(b.toMap())
          : await repoUang.update(b.id, b.toMap());
      Get.back();
      if(hasilA.success && hasilB.success) {
        loadKaryawans();
        authControl.karyawanUpdateTrigger.value++;
        loadMantanKaryawans();
        Get.back();
        Get.back();
        AFwidget.snackbar('${hasilA.message}, ${hasilB.message}.');
      } else {
        AFwidget.formWarning(label: '${hasilA.message}, ${hasilB.message}.');
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> hapusPhkData() async {
    try {
      if(current.id.isEmpty) {
        throw ValidationException('ID Karyawan tidak ditemukan');
      }
      if(current.phk.id.isEmpty) {
        throw ValidationException('ID PHK tidak ditemukan');
      }
      var hasil = await _repo.phkDelete(current.id, current.phk.id);
      if(hasil.success) {
        loadKaryawans();
        authControl.karyawanUpdateTrigger.value++;
        loadMantanKaryawans();
        Get.back();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> loadPayrollPhkData() async {
    payrollPhk = PayrollPhk();
    var hasil = await _repo.payrollPhkFind(current.id);
    if (hasil.success) {
      payrollPhk = PayrollPhk.fromMap(hasil.data);
    }
    update(['payroll_phk_button']);
  }

  void hitungPayrollPhkPenerimaanBersih (String nilai) {
    var a = AFconvert.keInt(txtPayrollPhkGaji.text) + AFconvert.keInt(txtPayrollPhkKenaikanGaji.text) + AFconvert.keInt(txtPayrollPhkUangMakanJumlah.text) +
        AFconvert.keInt(txtPayrollPhkOvertimeFjg.text) + AFconvert.keInt(txtPayrollPhkOvertimeCus.text) +
        AFconvert.keInt(txtPayrollPhkMedical.text) + AFconvert.keInt(txtPayrollPhkThr.text) +
        AFconvert.keInt(txtPayrollPhkBonus.text) + AFconvert.keInt(txtPayrollPhkInsentif.text) +
        AFconvert.keInt(txtPayrollPhkTelkomsel.text) + AFconvert.keInt(txtPayrollPhkLain.text);
    var b = AFconvert.keInt(txtPayrollPhkPot25jumlah.text) + AFconvert.keInt(txtPayrollPhkPotTelepon.text) +
        AFconvert.keInt(txtPayrollPhkPotBensin.text) + AFconvert.keInt(txtPayrollPhkPotKas.text) +
        AFconvert.keInt(txtPayrollPhkPotCicilan.text) + AFconvert.keInt(txtPayrollPhkPotBpjs.text) +
        AFconvert.keInt(txtPayrollPhkPotCutiJumlah.text) + AFconvert.keInt(txtPayrollPhkPotKompensasiJumlah.text) + AFconvert.keInt(txtPayrollPhkPotLain.text);
    var c = a - b;
    txtPayrollPhkTotalDiterima.text = AFconvert.matNumber(c);
  }

  Future<void> simpanPayrollPhkData() async {
    try {
      if(current.id.isEmpty) {
        throw ValidationException('ID Karyawan tidak ditemukan');
      }
      if(tahunPhk.value.isEmpty || bulanPhk.value.isEmpty) {
        throw ValidationException('Periode penggajian harus diisi');
      }
      if(txtPayrollPhkTglAwal.text.isEmpty || txtPayrollPhkTglAkhir.text.isEmpty) {
        throw ValidationException('Periode batas (cut-off) harus diisi');
      }
      if(txtPayrollPhkGaji.text.isEmpty) {
        throw ValidationException('Gaji harus diisi');
      }
      var a = PayrollPhk(
        id: payrollPhk.id,
        tahun: AFconvert.keInt(tahunPhk.value),
        bulan: AFconvert.keInt(bulanPhk.value),
        tanggalAwal: AFconvert.keTanggal('${txtPayrollPhkTglAwal.text} 08:00:00'),
        tanggalAkhir: AFconvert.keTanggal('${txtPayrollPhkTglAkhir.text} 08:00:00'),
        makanHarian: payrollPhkMakanHarian,
        gaji: AFconvert.keInt(txtPayrollPhkGaji.text),
        kenaikanGaji: AFconvert.keInt(txtPayrollPhkKenaikanGaji.text),
        hariMakan: AFconvert.keInt(txtPayrollPhkHariMakan.text),
        uangMakanHarian: AFconvert.keInt(txtPayrollPhkUangMakanHarian.text),
        uangMakanJumlah: AFconvert.keInt(txtPayrollPhkUangMakanJumlah.text),
        overtimeFjg: AFconvert.keInt(txtPayrollPhkOvertimeFjg.text),
        overtimeCus: AFconvert.keInt(txtPayrollPhkOvertimeCus.text),
        medical: AFconvert.keInt(txtPayrollPhkMedical.text),
        thr: AFconvert.keInt(txtPayrollPhkThr.text),
        bonus: AFconvert.keInt(txtPayrollPhkBonus.text),
        insentif: AFconvert.keInt(txtPayrollPhkInsentif.text),
        telkomsel: AFconvert.keInt(txtPayrollPhkTelkomsel.text),
        lain: AFconvert.keInt(txtPayrollPhkLain.text),
        pot25hari: AFconvert.keInt(txtPayrollPhkPot25hari.text),
        pot25jumlah: AFconvert.keInt(txtPayrollPhkPot25jumlah.text),
        potTelepon: AFconvert.keInt(txtPayrollPhkPotTelepon.text),
        potBensin: AFconvert.keInt(txtPayrollPhkPotBensin.text),
        potKas: AFconvert.keInt(txtPayrollPhkPotKas.text),
        potCicilan: AFconvert.keInt(txtPayrollPhkPotCicilan.text),
        potBpjs: AFconvert.keInt(txtPayrollPhkPotBpjs.text),
        potCutiHari: AFconvert.keInt(txtPayrollPhkPotCutiHari.text),
        potCutiJumlah: AFconvert.keInt(txtPayrollPhkPotCutiJumlah.text),
        potKompensasiJam: AFconvert.keDouble(txtPayrollPhkPotKompensasiJam.text),
        potKompensasiJumlah: AFconvert.keInt(txtPayrollPhkPotKompensasiJumlah.text),
        potLain: AFconvert.keInt(txtPayrollPhkPotLain.text),
        totalDiterima: AFconvert.keInt(txtPayrollPhkTotalDiterima.text),
        keterangan: txtPayrollPhkKeterangan.text,
      );
      a.karyawan = current;
      AFwidget.loading();
      var hasil = await _repo.payrollPhkUpdateOrCreate(a.karyawan.id, a.toMap());
      Get.back();
      if(hasil.success) {
        loadPayrollPhkData();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> loadAgamas() async {
    AgamaRepository repo = AgamaRepository();
    var hasil = await repo.findAll();
    if(hasil.success) {
      listAgama.clear();
      for (var data in hasil.daftar) {
        listAgama.add(
          Opsi(value: AFconvert.keString(data['id']), label: data['nama'], data: data),
        );
      }
    }
  }

  Future<void> loadAreas() async {
    AreaRepository repo = AreaRepository();
    var hasil = await repo.findAll();
    if(hasil.success) {
      listArea.clear();
      for (var data in hasil.daftar) {
        listArea.add(
          Opsi(value: AFconvert.keString(data['id']), label: data['nama'], data: data),
        );
      }
    }
  }

  Future<void> loadDivisis() async {
    DivisiRepository repo = DivisiRepository();
    var hasil = await repo.findAll();
    if(hasil.success) {
      listDivisi.clear();
      for (var data in hasil.daftar) {
        listDivisi.add(
          Opsi(value: AFconvert.keString(data['id']), label: '${data['nama']} (${data['kode']})', data: data),
        );
      }
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
    }
  }

  Future<void> loadStatusPhks() async {
    StatusPhkRepository repo = StatusPhkRepository();
    var hasil = await repo.findAll();
    if(hasil.success) {
      listStatusPhk.clear();
      for (var data in hasil.daftar) {
        listStatusPhk.add(
          Opsi(value: AFconvert.keString(data['id']), label: data['nama'], data: data),
        );
      }
    }
  }

  Future<void> loadPtkps() async {
    PtkpRepository repo = PtkpRepository();
    var hasil = await repo.findAll();
    if(hasil.success) {
      listPtkp.clear();
      for (var data in hasil.daftar) {
        listPtkp.add(
          Opsi(value: AFconvert.keString(data['id']), label: data['kode'], data: data),
        );
      }
    }
  }

  Future<void> loadAllData() async {
    await loadAgamas();
    await loadAreas();
    await loadDivisis();
    await loadJabatans();
    await loadPendidikans();
    await loadTrainings();
    await loadStatusKerjas();
    await loadStatusPhks();
    await loadPtkps();
    update(['form_karyawan']);
  }

  Future<Opsi?> pilihAgama({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listAgama,
      valueSelected: value,
      judul: 'Pilih Agama',
    );
    return a;
  }

  Future<Opsi?> pilihArea({String value = '', bool withSemua = false}) async {
    List<Opsi> list = [...listArea];
    if(withSemua) {
      list.add(Opsi(value: '', label: 'SEMUA'));
    }
    var a = await AFcombobox.bottomSheet(
      listOpsi: list,
      valueSelected: value,
      judul: 'Pilih Area',
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

  Future<Opsi?> pilihStatusKerja({String value = '', bool withSemua = false}) async {
    List<Opsi> list = [...listStatusKerja];
    if(withSemua) {
      list.add(Opsi(value: '', label: 'SEMUA'));
    }
    var a = await AFcombobox.bottomSheet(
      listOpsi: list,
      valueSelected: value,
      judul: 'Pilih Status Karyawan',
    );
    return a;
  }

  Future<Opsi?> pilihStatusPhk({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listStatusPhk,
      valueSelected: value,
      judul: 'Pilih Status PHK',
    );
    return a;
  }

  Future<Opsi?> pilihStaf({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: [
        Opsi(value: 'Y', label: 'STAF'),
        Opsi(value: 'N', label: 'NON STAF'),
        Opsi(value: '', label: 'STAF & NON STAF'),
      ],
      valueSelected: value,
      judul: 'Pilih Jenis Karyawan',
      withCari: false,
    );
    return a;
  }

  Future<Opsi?> pilihPtkp({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listPtkp,
      valueSelected: value,
      judul: 'Pilih PTKP',
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

  Future<void> dowloadPayroll() async {
    AFwidget.loading();
    var hasil = await _repo.excelPayroll(id: current.id, tahun: filterTahun.label);
    Get.back();
    if(hasil.success) {
      AFwidget.formWarning(
        label: 'laporan excel payroll ${current.nama} berhasil dibuat. silakan periksa directory Download anda (${hasil.message})',
        warna:  Colors.green,
        ikon: Icons.info,
      );
    } else {
      AFwidget.formWarning(label: 'Gagal membuat excel. [${hasil.message}]');
    }
  }

  Future<void> dowloadPayrollPeriode() async {
    AFwidget.loading();
    var hasil = await _repo.excelPayrollPeriode(
      id: current.id,
      tahunAwal: payrollTahunAwal.value,
      bulanAwal: payrollBulanAwal.value,
      tahunAkhir: payrollTahunAkhir.value,
      bulanAkhir: payrollBulanAkhir.value,
    );
    Get.back();
    if(hasil.success) {
      AFwidget.formWarning(
        label: 'laporan excel payroll ${current.nama} berhasil dibuat. silakan periksa directory Download anda (${hasil.message})',
        warna:  Colors.green,
        ikon: Icons.info,
      );
    } else {
      AFwidget.formWarning(label: 'Gagal membuat excel. [${hasil.message}]');
    }
  }

  Future<void> downloadSlipGaji() async {
    AFwidget.loading();
    List<int> selected = bulanTerpilih.entries
    .where((entry) => entry.value)
    .map((entry) => entry.key)
    .toList();
    var bulans = selected.join('-');
    var hasil = await _repo.excelSlipGaji(id: current.id, tahun: filterTahun.value, bulans: bulans);
    Get.back();
    if(hasil.success) {
      AFwidget.formWarning(
        label: 'slip gaji ${current.nama} berhasil dibuat. silakan periksa directory Download anda (${hasil.message})',
        warna:  Colors.green,
        ikon: Icons.info,
      );
    } else {
      AFwidget.formWarning(label: 'Gagal membuat excel. [${hasil.message}]');
    }
  }

  Future<void> downloadPdfSlipGaji() async {
    AFwidget.loading();
    List<int> selected = bulanTerpilih.entries
    .where((entry) => entry.value)
    .map((entry) => entry.key)
    .toList();
    var bulans = selected.join('-');
    var hasil = await _repo.pdfSlipGaji(id: current.id, tahun: filterTahun.value, bulans: bulans);
    Get.back();
    if(hasil.success) {
      AFwidget.formWarning(
        label: 'PDF slip gaji ${current.nama} berhasil dibuat. silakan periksa directory Download anda (${hasil.message})',
        warna:  Colors.green,
        ikon: Icons.info,
      );
    } else {
      AFwidget.formWarning(label: 'Gagal membuat PDF. [${hasil.message}]');
    }
  }

  String getKelompokUsia(DateTime? birthDate) {
    if (birthDate == null) return "0";

    final now = DateTime.now();
    int age = now.year - birthDate.year;

    // Koreksi jika belum ulang tahun tahun ini
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    if (age < 20) return "< 20";
    if (age <= 25) return "20–25";
    if (age <= 30) return "26–30";
    if (age <= 35) return "31–35";
    if (age <= 40) return "36–40";
    if (age <= 45) return "41–45";
    if (age <= 50) return "46–50";
    if (age <= 55) return "51–55";
    return "56+";
  }

  @override
  void onInit() {
    filterTahun = Opsi(value: '${_now.year}', label: '${_now.year}');
    listTahun = List.generate(_now.year-2019, (index) => Opsi(value: '${_now.year-index}', label: '${_now.year-index}'));
    payrollTahunAwal = Opsi(value: '${_now.year}', label: '${_now.year}');
    payrollTahunAkhir = Opsi(value: '${_now.year}', label: '${_now.year}');
    txtId = TextEditingController();
    txtNama = TextEditingController();
    txtNik = TextEditingController();
    txtTanggalMasuk = TextEditingController();
    txtTanggalKeluar = TextEditingController();
    txtNomorKk = TextEditingController();
    txtNomorKtp = TextEditingController();
    txtNomorPaspor = TextEditingController();
    txtNomorPwp = TextEditingController();
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
    txtTrainingKaryawanId = TextEditingController();
    txtTrainingKaryawanTanggal = TextEditingController();
    txtTrainingKaryawanKeterangan = TextEditingController();
    txtPhkKeterangan = TextEditingController();
    txtKompensasi = TextEditingController();
    txtPesangon = TextEditingController();
    txtMasaKerja = TextEditingController();
    txtUangPisah = TextEditingController();
    txtSisaCutiHari = TextEditingController();
    txtSisaCutiJumlah = TextEditingController();
    txtLain = TextEditingController();
    txtPotKas = TextEditingController();
    txtPotCutiHari = TextEditingController();
    txtPotCutiJumlah = TextEditingController();
    txtPotLain = TextEditingController();
    txtPayrollPhkGaji = TextEditingController();
    txtPayrollPhkKenaikanGaji = TextEditingController();
    txtPayrollPhkHariMakan = TextEditingController();
    txtPayrollPhkUangMakanHarian = TextEditingController();
    txtPayrollPhkUangMakanJumlah = TextEditingController();
    txtPayrollPhkOvertimeFjg = TextEditingController();
    txtPayrollPhkOvertimeCus = TextEditingController();
    txtPayrollPhkMedical = TextEditingController();
    txtPayrollPhkThr = TextEditingController();
    txtPayrollPhkBonus = TextEditingController();
    txtPayrollPhkInsentif = TextEditingController();
    txtPayrollPhkTelkomsel = TextEditingController();
    txtPayrollPhkLain = TextEditingController();
    txtPayrollPhkPot25hari = TextEditingController();
    txtPayrollPhkPot25jumlah = TextEditingController();
    txtPayrollPhkPotTelepon = TextEditingController();
    txtPayrollPhkPotBensin = TextEditingController();
    txtPayrollPhkPotKas = TextEditingController();
    txtPayrollPhkPotCicilan = TextEditingController();
    txtPayrollPhkPotBpjs = TextEditingController();
    txtPayrollPhkPotCutiHari = TextEditingController();
    txtPayrollPhkPotCutiJumlah = TextEditingController();
    txtPayrollPhkPotLain = TextEditingController();
    txtPayrollPhkPotKompensasiJam = TextEditingController();
    txtPayrollPhkPotKompensasiJumlah = TextEditingController();
    txtPayrollPhkTotalDiterima = TextEditingController();
    txtPayrollPhkKeterangan = TextEditingController();
    txtPayrollPhkTglAwal = TextEditingController();
    txtPayrollPhkTglAkhir = TextEditingController();
    tahunPhk = Opsi(value: '${_now.year}', label: '${_now.year}');
    bulanPhk = Opsi(value: '${_now.month}', label: mapBulan[_now.month]!);
    loadKaryawans();
    loadCalonKaryawans();
    loadMantanKaryawans();
    loadAllData();
    super.onInit();
  }

  @override
  void onClose() {
    txtId.dispose();
    txtNama.dispose();
    txtNik.dispose();
    txtTanggalMasuk.dispose();
    txtTanggalKeluar.dispose();
    txtNomorKk.dispose();
    txtNomorKtp.dispose();
    txtNomorPaspor.dispose();
    txtNomorPwp.dispose();
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
    txtTrainingKaryawanId.dispose();
    txtTrainingKaryawanTanggal.dispose();
    txtTrainingKaryawanKeterangan.dispose();
    txtPhkKeterangan.dispose();
    txtKompensasi.dispose();
    txtPesangon.dispose();
    txtMasaKerja.dispose();
    txtUangPisah.dispose();
    txtSisaCutiHari.dispose();
    txtSisaCutiJumlah.dispose();
    txtLain.dispose();
    txtPotKas.dispose();
    txtPotCutiHari.dispose();
    txtPotCutiJumlah.dispose();
    txtPotLain.dispose();
    txtPayrollPhkGaji.dispose();
    txtPayrollPhkKenaikanGaji.dispose();
    txtPayrollPhkHariMakan.dispose();
    txtPayrollPhkUangMakanHarian.dispose();
    txtPayrollPhkUangMakanJumlah.dispose();
    txtPayrollPhkOvertimeFjg.dispose();
    txtPayrollPhkOvertimeCus.dispose();
    txtPayrollPhkMedical.dispose();
    txtPayrollPhkThr.dispose();
    txtPayrollPhkBonus.dispose();
    txtPayrollPhkInsentif.dispose();
    txtPayrollPhkTelkomsel.dispose();
    txtPayrollPhkLain.dispose();
    txtPayrollPhkPot25hari.dispose();
    txtPayrollPhkPot25jumlah.dispose();
    txtPayrollPhkPotTelepon.dispose();
    txtPayrollPhkPotBensin.dispose();
    txtPayrollPhkPotKas.dispose();
    txtPayrollPhkPotCicilan.dispose();
    txtPayrollPhkPotBpjs.dispose();
    txtPayrollPhkPotCutiHari.dispose();
    txtPayrollPhkPotCutiJumlah.dispose();
    txtPayrollPhkPotLain.dispose();
    txtPayrollPhkPotKompensasiJam.dispose();
    txtPayrollPhkPotKompensasiJumlah.dispose();
    txtPayrollPhkTotalDiterima.dispose();
    txtPayrollPhkKeterangan.dispose();
    txtPayrollPhkTglAwal.dispose();
    txtPayrollPhkTglAkhir.dispose();
    super.onClose();
  }
}
