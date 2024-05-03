
import 'package:fjghrd/models/status_kerja.dart';
import 'package:fjghrd/models/status_phk.dart';
import 'package:fjghrd/utils/af_convert.dart';

class Phk {
  String id;
  String karyawanId;
  DateTime? tanggalAwal;
  DateTime? tanggalAKhir;
  StatusKerja statusKerja = StatusKerja();
  StatusPhk statusPhk = StatusPhk();
  String keterangan;
  DateTime? createdAt;
  DateTime? updatedAt;

  Phk({
    this.id = '',
    this.karyawanId = '',
    this.tanggalAwal,
    this.tanggalAKhir,
    this.keterangan = '',
    this.createdAt,
    this.updatedAt,
  }) ;

  factory Phk.fromMap(Map<String, dynamic> data) {
    var a = Phk(
      id: AFconvert.keString(data['id']),
      karyawanId: AFconvert.keString(data['karyawan_id']),
      tanggalAwal: AFconvert.keTanggal(data['tanggal_awal']),
      tanggalAKhir: AFconvert.keTanggal(data['tanggal_akhir']),
      keterangan: AFconvert.keString(data['keterangan']),
      createdAt: AFconvert.keTanggal(data['created_at']),
      updatedAt: AFconvert.keTanggal(data['updated_at']),
    );
    if(data['status_kerja'] != null) {
      a.statusKerja = StatusKerja.fromMap(data['status_kerja']);
    }
    if(data['status_phk'] != null) {
      a.statusPhk = StatusPhk.fromMap(data['status_phk']);
    }
    return a;
  }

  Map<String, String> toMap() {
    Map<String, String> data = {
      'id': id,
      'karyawan_id': karyawanId,
      'tanggal_awal': AFconvert.matYMDTime(tanggalAwal),
      'tanggal_akhir': AFconvert.matYMDTime(tanggalAKhir),
      'keterangan': keterangan,
    };
    if(statusKerja.id != '') {
      data['status_kerja_id'] = statusKerja.id;
    }
    if(statusPhk.id != '') {
      data['status_phk_id'] = statusPhk.id;
    }
    return data;
  }

}
