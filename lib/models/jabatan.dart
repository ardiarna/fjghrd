import 'package:fjghrd/utils/af_convert.dart';

class Jabatan {
  String id;
  String nama;
  int urutan;
  DateTime? createdAt;
  DateTime? updatedAt;

  Jabatan({
    this.id = '',
    this.nama = '',
    this.urutan = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory Jabatan.fromMap(Map<String, dynamic> data) {
    return Jabatan(
      id: AFconvert.keString(data['id']),
      nama: AFconvert.keString(data['nama']),
      urutan: AFconvert.keInt(data['urutan']),
      createdAt: AFconvert.keTanggal(data['created_at']),
      updatedAt: AFconvert.keTanggal(data['updated_at']),
    );
  }

  Map<String, String> toMap() {
    Map<String, String> data = {
      'id' : id,
      'nama' : nama,
      'urutan': AFconvert.keString(urutan),
    };
    return data;
  }

}
