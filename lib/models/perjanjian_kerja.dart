
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/models/status_kerja.dart';
import 'package:fjghrd/utils/af_convert.dart';

class PerjanjianKerja {
  String id;
  Karyawan karyawan = Karyawan();
  String nomor;
  DateTime? tanggalAwal;
  DateTime? tanggalAKhir;
  StatusKerja statusKerja = StatusKerja();
  DateTime? createdAt;
  DateTime? updatedAt;

  PerjanjianKerja({
    this.id = '',
    this.nomor = '',
    this.tanggalAwal,
    this.tanggalAKhir,
    this.createdAt,
    this.updatedAt,
  }) ;

  factory PerjanjianKerja.fromMap(Map<String, dynamic> data) {
    var a = PerjanjianKerja(
      id: AFconvert.keString(data['id']),
      nomor: AFconvert.keString(data['nomor']),
      tanggalAwal: AFconvert.keTanggal(data['tanggal_awal']),
      tanggalAKhir: AFconvert.keTanggal(data['tanggal_akhir']),
      createdAt: AFconvert.keTanggal(data['created_at']),
      updatedAt: AFconvert.keTanggal(data['updated_at']),
    );
    if(data['karyawan'] != null) {
      a.karyawan = Karyawan.fromMap(data['karyawan']);
    }
    if(data['status_kerja'] != null) {
      a.statusKerja = StatusKerja.fromMap(data['status_kerja']);
    }
    return a;
  }

  Map<String, String> toMap() {
    Map<String, String> data = {
      'id': id,
      'nomor': nomor,
      'tanggal_awal': AFconvert.matYMDTime(tanggalAwal),
      'karyawan_id': karyawan.id,
      'status_kerja_id': statusKerja.id,
    };
    if(tanggalAKhir != null) {
      data['tanggal_akhir'] = AFconvert.matYMDTime(tanggalAKhir);
    }
    return data;
  }

}
