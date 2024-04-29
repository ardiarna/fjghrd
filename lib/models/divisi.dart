import 'package:fjghrd/utils/af_convert.dart';

class Divisi {
  String id;
  String kode;
  String nama;
  int urutan;
  DateTime? createdAt;
  DateTime? updatedAt;

  Divisi({
    this.id = '',
    this.kode = '',
    this.nama = '',
    this.urutan = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory Divisi.fromMap(Map<String, dynamic> data) {
    return Divisi(
      id: AFconvert.keString(data['id']),
      kode: AFconvert.keString(data['kode']),
      nama: AFconvert.keString(data['nama']),
      urutan: AFconvert.keInt(data['urutan']),
      createdAt: AFconvert.keTanggal(data['created_at']),
      updatedAt: AFconvert.keTanggal(data['updated_at']),
    );
  }

  Map<String, String> toMap() {
    Map<String, String> data = {
      'id' : id,
      'kode': kode,
      'nama' : nama,
      'urutan': AFconvert.keString(urutan),
    };
    return data;
  }

}
