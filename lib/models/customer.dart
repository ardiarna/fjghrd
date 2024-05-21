import 'package:fjghrd/utils/af_convert.dart';

class Customer {
  String id;
  String nama;
  String alamat;
  DateTime? createdAt;
  DateTime? updatedAt;

  Customer({
    this.id = '',
    this.nama = '',
    this.alamat = '',
    this.createdAt,
    this.updatedAt,
  });

  factory Customer.fromMap(Map<String, dynamic> data) {
    return Customer(
      id: AFconvert.keString(data['id']),
      nama: AFconvert.keString(data['nama']),
      alamat: AFconvert.keString(data['alamat']),
      createdAt: AFconvert.keTanggal(data['created_at']),
      updatedAt: AFconvert.keTanggal(data['updated_at']),
    );
  }

  Map<String, String> toMap() {
    Map<String, String> data = {
      'id' : id,
      'nama' : nama,
      'alamat': AFconvert.keString(alamat),
    };
    return data;
  }

}
