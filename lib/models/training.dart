import 'package:fjghrd/utils/af_convert.dart';

class Training {
  String id;
  String nama;
  int urutan;
  DateTime? createdAt;
  DateTime? updatedAt;

  Training({
    this.id = '',
    this.nama = '',
    this.urutan = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory Training.fromMap(Map<String, dynamic> data) {
    return Training(
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
