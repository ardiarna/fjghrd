
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/utils/af_convert.dart';

class KeluargaKontak {
  String id;
  Karyawan karyawan = Karyawan();
  String nama;
  String telepon;
  String email;
  DateTime? createdAt;
  DateTime? updatedAt;

  KeluargaKontak({
    this.id = '',
    this.nama = '',
    this.telepon = '',
    this.email = '',
    this.createdAt,
    this.updatedAt,
  }) ;

  factory KeluargaKontak.fromMap(Map<String, dynamic> data) {
    var a = KeluargaKontak(
      id: AFconvert.keString(data['id']),
      nama: AFconvert.keString(data['nama']),
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
      'telepon': telepon,
      'email': email,
      'karyawan_id': karyawan.id,
    };
    return data;
  }

}
