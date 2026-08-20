import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/utils/af_convert.dart';

class JatahCutiTahunan {
  String id;
  String karyawanId;
  String tahun;
  int jumlahCuti;
  int plusTahunLalu;
  int minTahunLalu;
  int totalCuti;
  Karyawan? karyawan;

  JatahCutiTahunan({
    this.id = '',
    this.karyawanId = '',
    this.tahun = '',
    this.jumlahCuti = 0,
    this.plusTahunLalu = 0,
    this.minTahunLalu = 0,
    this.totalCuti = 0,
    this.karyawan,
  });

  factory JatahCutiTahunan.fromMap(Map<String, dynamic> data) {
    var obj = JatahCutiTahunan(
      id: AFconvert.keString(data['id']),
      karyawanId: AFconvert.keString(data['karyawan_id']),
      tahun: AFconvert.keString(data['tahun']),
      jumlahCuti: AFconvert.keInt(data['jumlah_cuti']),
      plusTahunLalu: AFconvert.keInt(data['plus_tahun_lalu']),
      minTahunLalu: AFconvert.keInt(data['min_tahun_lalu']),
      totalCuti: AFconvert.keInt(data['total_cuti']),
    );
    if (data['karyawan'] != null) {
      obj.karyawan = Karyawan.fromMap(data['karyawan']);
    }
    return obj;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'karyawan_id': karyawanId,
      'tahun': tahun,
      'jumlah_cuti': jumlahCuti,
      'plus_tahun_lalu': plusTahunLalu,
      'min_tahun_lalu': minTahunLalu,
      'total_cuti': totalCuti,
    };
  }
}
