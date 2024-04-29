
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/utils/af_convert.dart';

class KeluargaKaryawan {
  String id;
  Karyawan karyawan = Karyawan();
  String nama;
  String nomorKtp;
  String hubungan;
  String tempatLahir;
  DateTime? tanggalLahir;
  String telepon;
  String email;
  DateTime? createdAt;
  DateTime? updatedAt;

  KeluargaKaryawan({
    this.id = '',
    this.nama = '',
    this.nomorKtp = '',
    this.hubungan = '',
    this.tempatLahir = '',
    this.tanggalLahir,
    this.telepon = '',
    this.email = '',
    this.createdAt,
    this.updatedAt,
  }) ;

  factory KeluargaKaryawan.fromMap(Map<String, dynamic> data) {
    var a = KeluargaKaryawan(
      id: AFconvert.keString(data['id']),
      nama: AFconvert.keString(data['nama']),
      nomorKtp: AFconvert.keString(data['nomor_ktp']),
      hubungan: AFconvert.keString(data['hubungan']),
      tempatLahir: AFconvert.keString(data['tempat_lahir']),
      tanggalLahir: AFconvert.keTanggal(data['tanggal_lahir']),
      telepon: AFconvert.keString(data['telepon']),
      email: AFconvert.keString(data['email']),
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
      'nama': nama,
      'nomor_ktp': nomorKtp,
      'hubungan': hubungan,
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': AFconvert.matYMDTime(tanggalLahir),
      'telepon': telepon,
      'email': email,
      'karyawan_id': karyawan.id,
    };
    return data;
  }

}
