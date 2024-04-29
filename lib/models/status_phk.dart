import 'package:fjghrd/utils/af_convert.dart';

class StatusPhk {
  String id;
  String nama;
  int urutan;
  DateTime? createdAt;
  DateTime? updatedAt;

  StatusPhk({
    this.id = '',
    this.nama = '',
    this.urutan = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory StatusPhk.fromMap(Map<String, dynamic> data) {
    return StatusPhk(
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
