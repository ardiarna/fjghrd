import 'package:fjghrd/utils/af_convert.dart';

class Upah {
  String id;
  String karyawanId;
  int gaji;
  int uangMakan;
  bool makanHarian;
  bool overtime;
  DateTime? createdAt;
  DateTime? updatedAt;

  Upah({
    this.id = '',
    this.karyawanId = '',
    this.gaji = 0,
    this.uangMakan = 0,
    this.makanHarian = true,
    this.overtime = false,
    this.createdAt,
    this.updatedAt,
  }) ;

  factory Upah.fromMap(Map<String, dynamic> data) {
    return Upah(
      id: AFconvert.keString(data['id']),
      karyawanId: AFconvert.keString(data['karyawan_id']),
      gaji: AFconvert.keInt(data['gaji']),
      uangMakan: AFconvert.keInt(data['uang_makan']),
      makanHarian: AFconvert.keBool(data['makan_harian']),
      overtime: AFconvert.keBool(data['overtime']),
      createdAt: AFconvert.keTanggal(data['created_at']),
      updatedAt: AFconvert.keTanggal(data['updated_at']),
    );
  }

  Map<String, String> toMap() {
    Map<String, String> data = {
      'id': id,
      'karyawan_id': karyawanId,
      'gaji': AFconvert.keString(gaji),
      'uang_makan': AFconvert.keString(uangMakan),
      'makan_harian': makanHarian ? 'Y' : 'N',
      'overtime': overtime ? 'Y' : 'N',
    };
    return data;
  }

}
