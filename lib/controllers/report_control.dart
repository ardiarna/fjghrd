import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/repositories/area_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_constant.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:get/get.dart';

class ReportControl extends GetxController {
  final authControl = Get.find<AuthControl>();

  final DateTime _now = DateTime.now();

  List<Opsi> listArea = [];
  List<Opsi> listBulan = mapBulan.entries.map((e) => Opsi(value: e.key.toString(), label: e.value)).toList();
  late List<Opsi> listTahun;

  late Opsi filterTahun;
  late Opsi filterBulan;
  Opsi filterArea = Opsi(value: '', label: '');
  String filterJenis = '';

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
      if(listArea.isNotEmpty) {
        filterArea = listArea[0];
      }
      update();
    } else {
      AFwidget.snackbar(hasil.message);
    }
  }

  Future<void> dowloadListpayroll() async {
    AFwidget.loading();
    var hasil = await AFdatabase.download(url: 'excel/list-payroll/${filterTahun.value}');
    Get.back();
    if(hasil.success) {
      AFwidget.snackbar('laporan excel list payroll telah berhasil dibuat. silakan periksa directory Download anda (${hasil.message})');
    } else {
      AFwidget.snackbar('Gagal membuat excel. [${hasil.message}]');
    }
  }

  Future<void> dowloadRekapPayroll() async {
    AFwidget.loading();
    var hasil = await AFdatabase.download(url: 'excel/rekap-gaji/${filterTahun.value}');
    Get.back();
    if(hasil.success) {
      AFwidget.snackbar('laporan excel rekap gaji telah berhasil dibuat. silakan periksa directory Download anda (${hasil.message})');
    } else {
      AFwidget.snackbar('Gagal membuat excel. [${hasil.message}]');
    }
  }

  Future<void> dowloadRekapMedical() async {
    AFwidget.loading();
    var hasil = await AFdatabase.download(url: 'excel/rekap-medical/${filterTahun.value}');
    Get.back();
    if(hasil.success) {
      AFwidget.snackbar('laporan excel rekap medikal telah berhasil dibuat. silakan periksa directory Download anda (${hasil.message})');
    } else {
      AFwidget.snackbar('Gagal membuat excel. [${hasil.message}]');
    }
  }

  Future<void> dowloadRekapOvertime() async {
    AFwidget.loading();
    var hasil = await AFdatabase.download(url: 'excel/rekap-overtime/${filterTahun.value}');
    Get.back();
    if(hasil.success) {
      AFwidget.snackbar('laporan excel rekap overtime telah berhasil dibuat. silakan periksa directory Download anda (${hasil.message})');
    } else {
      AFwidget.snackbar('Gagal membuat excel. [${hasil.message}]');
    }
  }

  Future<void> dowloadRekapPayrollPerKaryawan() async {
    if(filterJenis == '') {
      AFwidget.snackbar('Silakan pilih divisi terlebih dahulu');
      return;
    }
    if(filterArea.value == '') {
      AFwidget.snackbar('Silakan pilih area terlebih dahulu');
      return;
    }
    Get.back();
    AFwidget.loading();
    var hasil = await AFdatabase.download(url: 'excel/rekap-payroll-perkaryawan/$filterJenis/${filterTahun.value}/${filterArea.value}');
    Get.back();
    if(hasil.success) {
      AFwidget.snackbar('laporan excel rekap payroll per karyawan telah berhasil dibuat. silakan periksa directory Download anda (${hasil.message})');
    } else {
      AFwidget.snackbar('Gagal membuat excel. [${hasil.message}]');
    }
  }

  Future<void> downloadSlipGaji() async {
    if(filterBulan.value == '') {
      AFwidget.snackbar('Silakan pilih bulan terlebih dahulu');
      return;
    }
    if(filterJenis == '') {
      AFwidget.snackbar('Silakan pilih divisi terlebih dahulu');
      return;
    }
    if(filterArea.value == '') {
      AFwidget.snackbar('Silakan pilih area terlebih dahulu');
      return;
    }
    Get.back();
    AFwidget.loading();
    var hasil = await AFdatabase.download(url: 'excel/slip-gaji/${filterTahun.value}/${filterBulan.value}/$filterJenis/${filterArea.value}');
    Get.back();
    if(hasil.success) {
      AFwidget.snackbar('excel slip gaji telah berhasil dibuat. silakan periksa directory Download anda (${hasil.message})');
    } else {
      AFwidget.snackbar('Gagal membuat excel. [${hasil.message}]');
    }
  }

  Future<void> dowloadRekapPPh21() async {
    if(filterJenis == '') {
      AFwidget.snackbar('Silakan pilih divisi terlebih dahulu');
      return;
    }
    if(filterArea.value == '') {
      AFwidget.snackbar('Silakan pilih area terlebih dahulu');
      return;
    }
    Get.back();
    AFwidget.loading();
    var hasil = await AFdatabase.download(url: 'excel/rekap-pph21/$filterJenis/${filterTahun.value}/${filterArea.value}');
    Get.back();
    if(hasil.success) {
      AFwidget.snackbar('laporan excel rekap pph 21 telah berhasil dibuat. silakan periksa directory Download anda (${hasil.message})');
    } else {
      AFwidget.snackbar('Gagal membuat excel. [${hasil.message}]');
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

  Future<Opsi?> pilihArea({String value = '', bool withSemua = false}) async {
    List<Opsi> list = [...listArea];
    if(withSemua) {
      list.add(Opsi(value: 'all', label: 'SEMUA'));
    }
    var a = await AFcombobox.bottomSheet(
      listOpsi: list,
      valueSelected: value,
      judul: 'Pilih Area',
    );
    return a;
  }

  @override
  void onInit() {
    loadAreas();
    filterTahun = Opsi(value: '${_now.year}', label: '${_now.year}');
    filterBulan = Opsi(value: '${_now.month}', label: mapBulan[_now.month]!);
    listTahun = List.generate(_now.year-2019, (index) => Opsi(value: '${_now.year-index}', label: '${_now.year-index}'));
    super.onInit();
  }

}