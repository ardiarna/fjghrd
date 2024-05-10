import 'package:fjghrd/utils/af_convert.dart';

class HariLibur {
  String id;
  String nama;
  DateTime? tanggal;
  DateTime? createdAt;
  DateTime? updatedAt;

  HariLibur({
    this.id = '',
    this.nama = '',
    this.tanggal,
    this.createdAt,
    this.updatedAt,
  });

  factory HariLibur.fromMap(Map<String, dynamic> data) {
    return HariLibur(
      id: AFconvert.keString(data['id']),
      nama: AFconvert.keString(data['nama']),
      tanggal: AFconvert.keTanggal(data['tanggal']),
      createdAt: AFconvert.keTanggal(data['created_at']),
      updatedAt: AFconvert.keTanggal(data['updated_at']),
    );
  }

  Map<String, String> toMap() {
    Map<String, String> data = {
      'id' : id,
      'nama' : nama,
      'tanggal': AFconvert.matYMDTime(tanggal),
    };
    return data;
  }

}
