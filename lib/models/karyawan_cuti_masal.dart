import 'package:fjghrd/utils/af_convert.dart';
import 'package:flutter/material.dart';

class KaryawanCutiMasal {
  String karyawanId;
  String nama;
  String jabatan;
  bool hasJatah;
  int totalHakCuti;
  int sudahDiambil;
  int cutiMasalLama;
  int belumDiambil;
  bool bolehMinus;
  bool pindahKeMinus;
  
  bool isChecked;
  TextEditingController txtLamaHari;
  List<DateTime> inputDates;
  
  KaryawanCutiMasal({
    required this.karyawanId,
    required this.nama,
    required this.jabatan,
    required this.hasJatah,
    required this.totalHakCuti,
    required this.sudahDiambil,
    required this.cutiMasalLama,
    required this.belumDiambil,
    this.bolehMinus = false,
    this.pindahKeMinus = false,
    this.isChecked = true,
  }) : txtLamaHari = TextEditingController(), inputDates = [];

  factory KaryawanCutiMasal.fromMap(Map<String, dynamic> map) {
    return KaryawanCutiMasal(
      karyawanId: map['karyawan_id'].toString(),
      nama: AFconvert.keString(map['nama']),
      jabatan: AFconvert.keString(map['jabatan']),
      hasJatah: map['has_jatah'] == true,
      totalHakCuti: AFconvert.keInt(map['total_hak_cuti']),
      sudahDiambil: AFconvert.keInt(map['sudah_diambil']),
      cutiMasalLama: AFconvert.keInt(map['cuti_masal']),
      belumDiambil: AFconvert.keInt(map['belum_diambil']),
      bolehMinus: map['boleh_minus'] == 'Y',
    );
  }

  int get inputLamaHari => AFconvert.keInt(txtLamaHari.text);

  int get safeBelumDiambil => belumDiambil < 0 ? 0 : belumDiambil;

  int get splitCutiMasal {
    if (!hasJatah) return 0;
    if (pindahKeMinus) return inputLamaHari;
    return inputLamaHari <= safeBelumDiambil ? inputLamaHari : safeBelumDiambil;
  }

  int get splitUnpaid {
    if (!hasJatah) return inputLamaHari;
    if (pindahKeMinus) return 0;
    return inputLamaHari > safeBelumDiambil ? inputLamaHari - safeBelumDiambil : 0;
  }

  int get sisaAkhir {
    return belumDiambil - splitCutiMasal;
  }
}
