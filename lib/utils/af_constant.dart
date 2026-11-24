import 'package:flutter/material.dart';
import 'package:fjghrd/models/opsi.dart';

abstract class Rute {
  static const home = '/';
  static const login = '/login';
  static const karyawanForm = '/karyawanform';
  static const karyawanPayrollView = '/karyawan-payroll';
  static const phkForm = '/phk-form';
}

final Map<int, String> mapBulan = {
  1: 'Januari',
  2: 'Februari',
  3: 'Maret',
  4: 'April',
  5: 'Mei',
  6: 'Juni',
  7: 'Juli',
  8: 'Agustus',
  9: 'September',
  10: 'Oktober',
  11: 'November',
  12: 'Desember',
};


final Map<int, String> mapBulanSingkat = {
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'Mei',
  6: 'Jun',
  7: 'Jul',
  8: 'Ags',
  9: 'Sep',
  10: 'Okt',
  11: 'Nov',
  12: 'Des',
};

final List<Color> listColor = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.cyan,
  Colors.pink,
  Colors.lime,
  Colors.indigo,
  Colors.amber,
];

const bgLineBlue = DecorationImage(
  image: AssetImage('assets/images/line-blue.png'),
  alignment: Alignment.topRight,
  repeat: ImageRepeat.repeatY,
  fit: BoxFit.fitWidth,
  opacity: 0.1,
);

List<Opsi> getListTahun() {
  int tahunSekarang = DateTime.now().year;
  int startTahun = 2010; // Ubah tahun awal di sini
  int count = (tahunSekarang - startTahun) + 1;
  // Generate list dari tahunSekarang menurun ke startTahun
  if (count <= 0) {
    return [Opsi(value: tahunSekarang.toString(), label: tahunSekarang.toString())];
  }
  return List.generate(count, (index) {
    String thn = (tahunSekarang - index).toString();
    return Opsi(value: thn, label: thn);
  });
}