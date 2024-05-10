import 'package:fjghrd/utils/af_convert.dart';
import 'package:flutter/material.dart';

class TimelineMasakerja {
  String id;
  String nama;
  DateTime? tanggalAwal;
  DateTime? tanggalAKhir;
  int masaKerja;
  int tahun;
  int bulan;

  TimelineMasakerja({
    this.id = '',
    this.nama = '',
    this.tanggalAwal,
    this.tanggalAKhir,
    this.masaKerja = 0,
    this.tahun = 0,
    this.bulan = 0,
  }) ;

  factory TimelineMasakerja.fromMap(Map<String, dynamic> data) {
    return TimelineMasakerja(
      id: AFconvert.keString(data['id']),
      nama: AFconvert.keString(data['nama']),
      tanggalAwal: AFconvert.keTanggal(data['tanggal_awal']),
      tanggalAKhir: AFconvert.keTanggal(data['tanggal_akhir']),
      masaKerja: AFconvert.keInt(data['masa_kerja']),
      tahun: AFconvert.keInt(data['tahun']),
      bulan: AFconvert.keInt(data['bulan']),
    );
  }

  Color get warna {
    switch(id) {
      case '1':
        return Colors.green;
      case '2':
        return Colors.blue;
      case '3':
        return Colors.orange;
      case '4':
        return Colors.purpleAccent;
      default:
        return Colors.white;
    }
  }

}
