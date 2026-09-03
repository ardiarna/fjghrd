
import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/controllers/home_control.dart';
import 'package:fjghrd/models/potongan.dart';
import 'package:fjghrd/models/hari_libur.dart';
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/medical.dart';
import 'package:fjghrd/models/overtime.dart';
import 'package:fjghrd/models/payroll.dart';
import 'package:fjghrd/models/penghasilan.dart';
import 'package:fjghrd/repositories/hari_libur_repository.dart';
import 'package:fjghrd/repositories/medical_repository.dart';
import 'package:fjghrd/repositories/overtime_repository.dart';
import 'package:fjghrd/repositories/payroll_repository.dart';
import 'package:fjghrd/repositories/penghasilan_repository.dart';
import 'package:fjghrd/repositories/potongan_repository.dart';
import 'package:fjghrd/repositories/upah_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:fjghrd/views/payroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fjghrd/utils/validation_exception.dart';

class PayrollControl extends GetxController {
  final authControl = Get.find<AuthControl>();
  final homeControl = Get.find<HomeControl>();
  final PayrollRepository _payrollRepo = PayrollRepository();
  final UpahRepository _upahRepo = UpahRepository();

  final DateTime _now = DateTime.now();

  RxList<Payroll> listPayroll = <Payroll>[].obs;
  RxList<Payroll> listDetilPayroll = <Payroll>[].obs;
  List<Karyawan> listKaryawan = [];
  Map<String, int> totalKaryawanPerArea = {};
  List<Overtime> listOvertime = [];
  List<Medical> listMedical = [];
  List<Penghasilan> listPenghasilan = [];
  List<Potongan> listPotongan = [];
  List<HariLibur> listHariLibur = [];
  List<Opsi> listBulan = mapBulan.entries.map((e) => Opsi(value: e.key.toString(), label: e.value)).toList();
  late List<Opsi> listTahun;
  Payroll currentPayroll = Payroll();
  Payroll currentDetilPayroll = Payroll();

  late TextEditingController txtTanggalAwal, txtTanggalAkhir,
      txtGaji, txtKenaikanGaji, txtHariMakan, txtUangMakanHarian, txtUangMakanJumlah, txtOvertimeFjg, txtOvertimeCus,
      txtMedical, txtThr, txtBonus, txtInsentif, txtTelkomsel, txtLain, txtPot25hari, txtPot25jumlah,
      txtPotTelepon, txtPotBensin, txtPotKas, txtPotCicilan, txtPotBpjs, txtPotCutiHari, txtPotCutiJumlah, txtPotLain,
      txtPotKompensasiJam, txtPotKompensasiJumlah, txtTotalDiterima, txtKeterangan;
  late Opsi filterTahun;
  late Opsi tahun;
  late Opsi bulan;

  Future<void> loadPayrolls() async {
    var hasil = await _payrollRepo.findAll(tahun: filterTahun.value);
    if (hasil.success) {
      List<Payroll> tempList = [];
      for (var data in hasil.daftar) {
        tempList.add(Payroll.fromMap(data));
      }
      listPayroll.assignAll(tempList);
    }
  }

  Future<bool> payrollPeriodeIsExist(String tahun, String bulan) async {
    var hasil = await _payrollRepo.findAll(tahun: tahun, bulan: bulan);
    if(hasil.success) {
      if(hasil.daftar.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  Future<void> loadDetilPayrolls() async {
    var hasil = await _payrollRepo.findDetail(currentPayroll.id);
    if (hasil.success) {
      List<Payroll> tempList = [];
      for (var data in hasil.daftar) {
        tempList.add(Payroll.fromMap(data));
      }
      listDetilPayroll.assignAll(tempList);
    }
  }

  Future<void> loadKaryawans() async {
    var hasil = await _upahRepo.findAll();
    if (hasil.success) {
      listKaryawan.clear();
      totalKaryawanPerArea.clear();
      for (var data in hasil.daftar) {
        var k = Karyawan.fromMap(data);
        listKaryawan.add(k);
        if(k.staf) {
          if (totalKaryawanPerArea.containsKey(k.area.nama)) {
            totalKaryawanPerArea[k.area.nama] = totalKaryawanPerArea[k.area.nama]! + 1;
          } else {
            totalKaryawanPerArea[k.area.nama] = 1;
          }
        }
      }
      for (var k in listKaryawan) {
        if(k.staf == false) {
          if (totalKaryawanPerArea.containsKey('NON STAF')) {
            totalKaryawanPerArea['NON STAF'] = totalKaryawanPerArea['NON STAF']! + 1;
          } else {
            totalKaryawanPerArea['NON STAF'] = 1;
          }
        }
      }
      update(['payroll_karyawan']);
    }
  }

  Future<void> loadOvertimes() async {
    final OvertimeRepository repo = OvertimeRepository();
    var hasil = await repo.findAll(
      tahun: tahun.value,
      bulan: bulan.value,
    );
    if (hasil.success) {
      listOvertime.clear();
      for (var data in hasil.daftar) {
        listOvertime.add(Overtime.fromMap(data));
      }
    }
  }

  Future<void> loadMedicals() async {
    final MedicalRepository repo = MedicalRepository();
    var hasil = await repo.findAll(
      tahun: tahun.value,
      bulan: bulan.value,
      jenis: '',
    );
    if (hasil.success) {
      listMedical.clear();
      for (var data in hasil.daftar) {
        listMedical.add(Medical.fromMap(data));
      }
    }
  }

  Future<void> loadPenghasilans() async {
    final PenghasilanRepository repo = PenghasilanRepository();
    var hasil = await repo.findAll(
      tahun: tahun.value,
      bulan: bulan.value,
    );
    if (hasil.success) {
      listPenghasilan.clear();
      for (var data in hasil.daftar) {
        listPenghasilan.add(Penghasilan.fromMap(data));
      }
    }
  }

  Future<void> loadPotongans() async {
    final PotonganRepository repo = PotonganRepository();
    var hasil = await repo.findAll(
      tahun: tahun.value,
      bulan: bulan.value,
    );
    if (hasil.success) {
      listPotongan.clear();
      for (var data in hasil.daftar) {
        listPotongan.add(Potongan.fromMap(data));
      }
    }
  }

  Future<void> loadHariLiburs() async {
    final HariLiburRepository repo = HariLiburRepository();
    var hasil = await repo.findAll(tahun: tahun.value);
    if (hasil.success) {
      listHariLibur.clear();
      for (var data in hasil.daftar) {
        listHariLibur.add(HariLibur.fromMap(data));
      }
    }
  }

  int countWorkingDays() {
    DateTime startDate = AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggalAwal.text)} 00:00:00') ?? _now;
    DateTime endDate = AFconvert.keTanggal('${AFconvert.matDMYtoYMD(txtTanggalAkhir.text)} 00:00:00') ?? _now;
    int workingDays = 0;
    for (DateTime date = startDate; date.isBefore(endDate.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
      if (date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday &&
          !listHariLibur.any((liburan) => liburan.tanggal != null && liburan.tanggal!.year == date.year && liburan.tanggal!.month == date.month && liburan.tanggal!.day == date.day)) {
        workingDays++;
      }
    }
    return workingDays;
  }

  void hitungPenerimaanBersih (String nilai) {
    var a = AFconvert.keInt(txtGaji.text) + AFconvert.keInt(txtKenaikanGaji.text) + AFconvert.keInt(txtUangMakanJumlah.text) +
        AFconvert.keInt(txtOvertimeFjg.text) + AFconvert.keInt(txtOvertimeCus.text) +
        AFconvert.keInt(txtMedical.text) + AFconvert.keInt(txtThr.text) +
        AFconvert.keInt(txtBonus.text) + AFconvert.keInt(txtInsentif.text) +
        AFconvert.keInt(txtTelkomsel.text) + AFconvert.keInt(txtLain.text);
    var b = AFconvert.keInt(txtPot25jumlah.text) + AFconvert.keInt(txtPotTelepon.text) +
        AFconvert.keInt(txtPotBensin.text) + AFconvert.keInt(txtPotKas.text) +
        AFconvert.keInt(txtPotCicilan.text) + AFconvert.keInt(txtPotBpjs.text) +
        AFconvert.keInt(txtPotCutiJumlah.text) + AFconvert.keInt(txtPotKompensasiJumlah.text) + AFconvert.keInt(txtPotLain.text);
    var c = a - b;
    txtTotalDiterima.text = AFconvert.matNumber(c);
  }

  Future<bool> runPayroll({
    required String tglAwal,
    required String tglAkhir,
    required String tahun,
    required String bulan,
    required List<Map<String, dynamic>> payrolls,
    String keterangan = '',
  }) async {
    try {
      AFwidget.loading();
      var hasil = await _payrollRepo.create(
        tglAwal: tglAwal,
        tglAkhir: tglAkhir,
        tahun: tahun,
        bulan: bulan,
        payrolls: payrolls,
        keterangan: keterangan,
      );
      Get.back();
      if(hasil.success) {
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
      return hasil.success;
    } catch (er) {
      AFwidget.formWarning(label: '$er');
      return false;
    }
  }

  Future<void> kunciPayrollData(String id) async {
    try {
      AFwidget.loading();
      var hasil = await _payrollRepo.kunci(id);
      Get.back();
      if(hasil.success) {
        loadPayrolls();
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
      if(currentPayroll.id.isEmpty) {
        throw ValidationException('ID Payroll tidak ditemukan');
      }
      if(tahun.value.isEmpty || bulan.value.isEmpty) {
        throw ValidationException('Periode penggajian harus diisi');
      }
      if(txtTanggalAwal.text.isEmpty || txtTanggalAkhir.text.isEmpty) {
        throw ValidationException('Periode batas (cut-off) harus diisi');
      }
      AFwidget.loading();
      var id = currentPayroll.id;
      var hasil = await _payrollRepo.update(
        id: id,
        tglAwal: txtTanggalAwal.text,
        tglAkhir: txtTanggalAkhir.text,
        bulan: bulan.value,
        tahun: tahun.value,
        keterangan: txtKeterangan.text,
      );
      Get.back();
      if(hasil.success) {
        Get.back();
        await loadPayrolls();
        currentPayroll = listPayroll.where((element) => element.id == id).first;
        update();
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
        throw ValidationException('ID Payroll null');
      }
      AFwidget.loading();
      var hasil = await _payrollRepo.delete(id);
      Get.back();
      if(hasil.success) {
        loadPayrolls();
        Get.back();
        Get.back();
        homeControl.kontener = PayrollView();
        homeControl.update();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
  }

  Future<void> ubahDetilData() async {
    try {
      if(currentDetilPayroll.id.isEmpty) {
        throw ValidationException('ID Payroll tidak ditemukan');
      }
      if(txtGaji.text.isEmpty) {
        throw ValidationException('Gaji harus diisi');
      }
      var a = Payroll(
        id: currentDetilPayroll.id,
        headerId: currentDetilPayroll.headerId,
        makanHarian: currentDetilPayroll.makanHarian,
        gaji: AFconvert.keInt(txtGaji.text),
        kenaikanGaji: AFconvert.keInt(txtKenaikanGaji.text),
        hariMakan: AFconvert.keInt(txtHariMakan.text),
        uangMakanHarian: AFconvert.keInt(txtUangMakanHarian.text),
        uangMakanJumlah: AFconvert.keInt(txtUangMakanJumlah.text),
        overtimeFjg: AFconvert.keInt(txtOvertimeFjg.text),
        overtimeCus: AFconvert.keInt(txtOvertimeCus.text),
        medical: AFconvert.keInt(txtMedical.text),
        thr: AFconvert.keInt(txtThr.text),
        bonus: AFconvert.keInt(txtBonus.text),
        insentif: AFconvert.keInt(txtInsentif.text),
        telkomsel: AFconvert.keInt(txtTelkomsel.text),
        lain: AFconvert.keInt(txtLain.text),
        pot25hari: AFconvert.keInt(txtPot25hari.text),
        pot25jumlah: AFconvert.keInt(txtPot25jumlah.text),
        potTelepon: AFconvert.keInt(txtPotTelepon.text),
        potBensin: AFconvert.keInt(txtPotBensin.text),
        potKas: AFconvert.keInt(txtPotKas.text),
        potCicilan: AFconvert.keInt(txtPotCicilan.text),
        potBpjs: AFconvert.keInt(txtPotBpjs.text),
        potCutiHari: AFconvert.keInt(txtPotCutiHari.text),
        potCutiJumlah: AFconvert.keInt(txtPotCutiJumlah.text),
        potKompensasiJam: AFconvert.keDouble(txtPotKompensasiJam.text),
        potKompensasiJumlah: AFconvert.keInt(txtPotKompensasiJumlah.text),
        potLain: AFconvert.keInt(txtPotLain.text),
        totalDiterima: AFconvert.keInt(txtTotalDiterima.text),
        keterangan: txtKeterangan.text,
      );
      a.karyawan = currentDetilPayroll.karyawan;
      AFwidget.loading();
      var hasil = await _payrollRepo.updateDetail(a);
      Get.back();
      if(hasil.success) {
        loadDetilPayrolls();
        Get.back();
        AFwidget.snackbar(hasil.message);
      } else {
        AFwidget.formWarning(label: hasil.message);
      }
    } catch (er) {
      AFwidget.formWarning(label: '$er');
    }
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
    ever(authControl.karyawanUpdateTrigger, (_) => loadKaryawans());
    filterTahun = Opsi(value: '${_now.year}', label: '${_now.year}');
    tahun = Opsi(value: '${_now.year}', label: '${_now.year}');
    bulan = Opsi(value: '${_now.month}', label: mapBulan[_now.month]!);
    listTahun = List.generate(_now.year-2019, (index) => Opsi(value: '${_now.year-index}', label: '${_now.year-index}'));
    txtTanggalAwal = TextEditingController();
    txtTanggalAkhir = TextEditingController();
    txtGaji = TextEditingController();
    txtKenaikanGaji = TextEditingController();
    txtHariMakan = TextEditingController();
    txtUangMakanHarian = TextEditingController();
    txtUangMakanJumlah = TextEditingController();
    txtOvertimeFjg = TextEditingController();
    txtOvertimeCus = TextEditingController();
    txtMedical = TextEditingController();
    txtThr = TextEditingController();
    txtBonus = TextEditingController();
    txtInsentif = TextEditingController();
    txtTelkomsel = TextEditingController();
    txtLain = TextEditingController();
    txtPot25hari = TextEditingController();
    txtPot25jumlah = TextEditingController();
    txtPotTelepon = TextEditingController();
    txtPotBensin = TextEditingController();
    txtPotKas = TextEditingController();
    txtPotCicilan = TextEditingController();
    txtPotBpjs = TextEditingController();
    txtPotCutiHari = TextEditingController();
    txtPotCutiJumlah = TextEditingController();
    txtPotKompensasiJam = TextEditingController();
    txtPotKompensasiJumlah = TextEditingController();
    txtPotLain = TextEditingController();
    txtTotalDiterima = TextEditingController();
    txtKeterangan = TextEditingController();
    loadPayrolls();
    super.onInit();
  }

  @override
  void onClose() {
    txtTanggalAwal.dispose();
    txtTanggalAkhir.dispose();
    txtGaji.dispose();
    txtKenaikanGaji.dispose();
    txtHariMakan.dispose();
    txtUangMakanHarian.dispose();
    txtUangMakanJumlah.dispose();
    txtOvertimeFjg.dispose();
    txtOvertimeCus.dispose();
    txtMedical.dispose();
    txtThr.dispose();
    txtBonus.dispose();
    txtInsentif.dispose();
    txtTelkomsel.dispose();
    txtLain.dispose();
    txtPot25hari.dispose();
    txtPot25jumlah.dispose();
    txtPotTelepon.dispose();
    txtPotBensin.dispose();
    txtPotKas.dispose();
    txtPotCicilan.dispose();
    txtPotBpjs.dispose();
    txtPotCutiHari.dispose();
    txtPotCutiJumlah.dispose();
    txtPotKompensasiJam.dispose();
    txtPotKompensasiJumlah.dispose();
    txtPotLain.dispose();
    txtTotalDiterima.dispose();
    txtKeterangan.dispose();
    super.onClose();
  }
}
