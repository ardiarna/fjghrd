import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/utils/af_convert.dart';

class UangPhk {
  String id;
  Karyawan karyawan = Karyawan();
  int tahun;
  int kompensasi;
  int uangPisah;
  int pesangon;
  int masaKerja;
  int penggantianHak;
  DateTime? createdAt;
  DateTime? updatedAt;

  UangPhk({
    this.id = '',
    this.tahun = 0,
    this.kompensasi = 0,
    this.uangPisah = 0,
    this.pesangon = 0,
    this.masaKerja = 0,
    this.penggantianHak = 0,
    this.createdAt,
    this.updatedAt,
  }) ;

  factory UangPhk.fromMap(Map<String, dynamic> data) {
    var a = UangPhk(
      id: AFconvert.keString(data['id']),
      tahun: AFconvert.keInt(data['tahun']),
      kompensasi: AFconvert.keInt(data['kompensasi']),
      uangPisah: AFconvert.keInt(data['uang_pisah']),
      pesangon: AFconvert.keInt(data['pesangon']),
      masaKerja: AFconvert.keInt(data['masa_kerja']),
      penggantianHak: AFconvert.keInt(data['penggantian_hak']),
      createdAt: AFconvert.keTanggal(data['created_at']),
      updatedAt: AFconvert.keTanggal(data['updated_at']),
    );
    if(data['karyawan'] != null) {
      a.karyawan = Karyawan.fromMap(data['karyawan']);
    }
    return a;
  }

  Map<String, String> toMap() {
    Map<String, String> data = {
      'id': id,
      'karyawan_id': karyawan.id,
      'tahun': AFconvert.keString(tahun),
      'kompensasi': AFconvert.keString(kompensasi),
      'uang_pisah': AFconvert.keString(uangPisah),
      'pesangon': AFconvert.keString(pesangon),
      'masa_kerja': AFconvert.keString(masaKerja),
      'penggantian_hak': AFconvert.keString(penggantianHak),
    };
    return data;
  }

}
