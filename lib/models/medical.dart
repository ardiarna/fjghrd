import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/utils/af_convert.dart';

class Medical {
  String id;
  Karyawan karyawan = Karyawan();
  String jenis;
  DateTime? tanggal;
  int bulan;
  int tahun;
  int jumlah;
  String keterangan;
  DateTime? createdAt;
  DateTime? updatedAt;

  Medical({
    this.id = '',
    this.jenis = '',
    this.tanggal,
    this.bulan = 0,
    this.tahun = 0,
    this.jumlah = 0,
    this.keterangan = '',
    this.createdAt,
    this.updatedAt,
  }) ;

  factory Medical.fromMap(Map<String, dynamic> data) {
    var a = Medical(
      id: AFconvert.keString(data['id']),
      jenis: AFconvert.keString(data['jenis']),
      tanggal: AFconvert.keTanggal(data['tanggal']),
      bulan: AFconvert.keInt(data['bulan']),
      tahun: AFconvert.keInt(data['tahun']),
      jumlah: AFconvert.keInt(data['jumlah']),
      keterangan: AFconvert.keString(data['keterangan']),
      createdAt: AFconvert.keTanggal(data['created_at']),
      updatedAt: AFconvert.keTanggal(data['updated_at']),
    );
    if(data['karyawan'] != null) {
      a.karyawan = Karyawan.fromMap(data['karyawan']);
    }
    return a;
  }

  Map<String, String> toMap() {
    Map<String, String> data = {
      'id': id,
      'karyawan_id': karyawan.id,
      'jenis': jenis,
      'tanggal': AFconvert.matYMDTime(tanggal),
      'tahun': AFconvert.keString(tahun),
      'bulan': AFconvert.keString(bulan),
      'jumlah': AFconvert.keString(jumlah),
      'keterangan': keterangan,
    };
    return data;
  }

}
