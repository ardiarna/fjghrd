import 'package:fjghrd/models/customer.dart';
import 'package:fjghrd/utils/af_convert.dart';

class OncallCustomer {
  String id;
  Customer customer = Customer();
  DateTime? tanggal;
  int bulan;
  int tahun;
  int jumlah;
  String keterangan;
  DateTime? createdAt;
  DateTime? updatedAt;

  OncallCustomer({
    this.id = '',
    this.tanggal,
    this.bulan = 0,
    this.tahun = 0,
    this.jumlah = 0,
    this.keterangan = '',
    this.createdAt,
    this.updatedAt,
  }) ;

  factory OncallCustomer.fromMap(Map<String, dynamic> data) {
    var a = OncallCustomer(
      id: AFconvert.keString(data['id']),
      tanggal: AFconvert.keTanggal(data['tanggal']),
      bulan: AFconvert.keInt(data['bulan']),
      tahun: AFconvert.keInt(data['tahun']),
      jumlah: AFconvert.keInt(data['jumlah']),
      keterangan: AFconvert.keString(data['keterangan']),
      createdAt: AFconvert.keTanggal(data['created_at']),
      updatedAt: AFconvert.keTanggal(data['updated_at']),
    );
    if(data['customer'] != null) {
      a.customer = Customer.fromMap(data['customer']);
    }
    return a;
  }

  Map<String, String> toMap() {
    Map<String, String> data = {
      'id': id,
      'customer_id': customer.id,
      'tanggal': AFconvert.matYMDTime(tanggal),
      'tahun': AFconvert.keString(tahun),
      'bulan': AFconvert.keString(bulan),
      'jumlah': AFconvert.keString(jumlah),
      'keterangan': keterangan,
    };
    return data;
  }

}
