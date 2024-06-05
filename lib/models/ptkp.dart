import 'package:fjghrd/utils/af_convert.dart';

class Ptkp {
  String id;
  String kode;
  String ter;
  int jumlah;
  DateTime? createdAt;
  DateTime? updatedAt;

  Ptkp({
    this.id = '',
    this.kode = '',
    this.ter = '',
    this.jumlah = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory Ptkp.fromMap(Map<String, dynamic> data) {
    return Ptkp(
      id: AFconvert.keString(data['id']),
      kode: AFconvert.keString(data['kode']),
      ter: AFconvert.keString(data['ter']),
      jumlah: AFconvert.keInt(data['jumlah']),
      createdAt: AFconvert.keTanggal(data['created_at']),
      updatedAt: AFconvert.keTanggal(data['updated_at']),
    );
  }

  Map<String, String> toMap() {
    Map<String, String> data = {
      'id' : id,
      'kode': kode,
      'ter' : ter,
      'jumlah': AFconvert.keString(jumlah),
    };
    return data;
  }

}
