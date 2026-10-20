import 'package:fjghrd/utils/af_convert.dart';

class Note {
  String id;
  String kode;
  String nama;
  String teks;
  DateTime? createdAt;
  DateTime? updatedAt;

  Note({
    this.id = '',
    this.kode = '',
    this.nama = '',
    this.teks = '',
    this.createdAt,
    this.updatedAt,
  });

  factory Note.fromMap(Map<String, dynamic> data) {
    return Note(
      id: AFconvert.keString(data['id']),
      kode: AFconvert.keString(data['kode']),
      nama: AFconvert.keString(data['nama']),
      teks: AFconvert.keString(data['teks']),
      createdAt: AFconvert.keTanggal(data['created_at']),
      updatedAt: AFconvert.keTanggal(data['updated_at']),
    );
  }

  Map<String, String> toMap() {
    Map<String, String> data = {
      'id': id,
      'kode': kode,
      'nama': nama,
      'teks': teks,
    };
    return data;
  }
}
