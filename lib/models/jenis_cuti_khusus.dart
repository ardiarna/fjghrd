import 'package:fjghrd/utils/af_convert.dart';

class JenisCutiKhusus {
  String id;
  String nama;
  String satuan;
  int lamaHari;
  int urutan;

  JenisCutiKhusus({
    this.id = '',
    this.nama = '',
    this.satuan = '',
    this.lamaHari = 0,
    this.urutan = 0,
  });

  factory JenisCutiKhusus.fromMap(Map<String, dynamic> data) {
    return JenisCutiKhusus(
      id: AFconvert.keString(data['id']),
      nama: AFconvert.keString(data['nama']),
      satuan: AFconvert.keString(data['satuan']),
      lamaHari: AFconvert.keInt(data['lama_hari']),
      urutan: AFconvert.keInt(data['urutan']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'satuan': satuan,
      'lama_hari': lamaHari,
      'urutan': urutan,
    };
  }
}
