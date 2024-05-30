import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/repositories/area_repository.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_convert.dart';
import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:get/get.dart';

class ReportControl extends GetxController {
  final authControl = Get.find<AuthControl>();

  List<Opsi> listArea = [];

  Opsi filterTahun = Opsi(value: '${DateTime.now().year}', label: '${DateTime.now().year}');
  Opsi filterArea = Opsi(value: '', label: '');

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
    await AFdatabase.download(url: 'excel/list-payroll/${filterTahun.value}');
    Get.back();
    AFwidget.snackbar('laporan excel list payroll telah berhasil dibuat. silakan periksa directory Download anda');
  }

  Future<void> dowloadRekapPayroll() async {
    AFwidget.loading();
    await AFdatabase.download(url: 'excel/rekap-payroll/${filterTahun.value}');
    Get.back();
    AFwidget.snackbar('laporan excel rekap payroll telah berhasil dibuat. silakan periksa directory Download anda');
  }

  Future<void> dowloadRekapMedical() async {
    AFwidget.loading();
    await AFdatabase.download(url: 'excel/rekap-medical/${filterTahun.value}');
    Get.back();
    AFwidget.snackbar('laporan excel rekap medikal telah berhasil dibuat. silakan periksa directory Download anda');
  }

  Future<void> dowloadRekapOvertime() async {
    AFwidget.loading();
    await AFdatabase.download(url: 'excel/rekap-overtime/${filterTahun.value}');
    Get.back();
    AFwidget.snackbar('laporan excel rekap overtime telah berhasil dibuat. silakan periksa directory Download anda');
  }

  Future<void> dowloadRekapPayrollPerKaryawanStaf(String jenis) async {
    if(filterArea.value == '') {
      AFwidget.snackbar('Silakan pilih area terlebih dahulu');
      return;
    }
    AFwidget.loading();
    await AFdatabase.download(url: 'excel/rekap-payroll-perkaryawan/$jenis/${filterTahun.value}/${filterArea.value}');
    Get.back();
    AFwidget.snackbar('laporan excel rekap payroll per karyawan divisi ${jenis == '1' ? 'engineering' : jenis == '2' ? 'staf' : ''} ${filterArea.label.toLowerCase()} telah berhasil dibuat. silakan periksa directory Download anda');
  }

  Future<void> dowloadRekapPayrollPerKaryawanNonStaf() async {
    AFwidget.loading();
    await AFdatabase.download(url: 'excel/rekap-payroll-perkaryawan/3/${filterTahun.value}/99');
    Get.back();
    AFwidget.snackbar('laporan excel rekap payroll per karyawan divisi non staf telah berhasil dibuat. silakan periksa directory Download anda');
  }

  Future<Opsi?> pilihTahun({String value = ''}) async {
    int tahunNow = DateTime.now().year;
    var a = await AFcombobox.bottomSheet(
      listOpsi: List.generate(tahunNow-2019, (index) => Opsi(value: '${tahunNow-index}', label: '${tahunNow-index}')),
      valueSelected: value,
      judul: 'Pilih Tahun',
      withCari: false,
    );
    return a;
  }

  Future<Opsi?> pilihArea({String value = ''}) async {
    var a = await AFcombobox.bottomSheet(
      listOpsi: listArea,
      valueSelected: value,
      judul: 'Pilih Area',
    );
    return a;
  }

  @override
  void onInit() {
    loadAreas();
    super.onInit();
  }

}