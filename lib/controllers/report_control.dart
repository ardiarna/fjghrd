import 'package:fjghrd/controllers/auth_control.dart';
import 'package:fjghrd/utils/af_combobox.dart';
import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/af_widget.dart';
import 'package:get/get.dart';

class ReportControl extends GetxController {
  final authControl = Get.find<AuthControl>();

  Opsi filterTahun = Opsi(value: '${DateTime.now().year}', label: '${DateTime.now().year}');

  Future<void> dowloadListpayroll() async {
    AFwidget.loading();
    await AFdatabase.download(url: 'excel/listpayroll/${filterTahun.value}');
    Get.back();
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

}