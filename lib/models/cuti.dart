import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/utils/af_convert.dart';

class Cuti {
  String id;
  String karyawanId;
  String jenisForm;
  String keperluan;
  DateTime? tanggalKembali;
  String tahun;
  Karyawan? karyawan;
  List<dynamic> details;

  Cuti({
    this.id = '',
    this.karyawanId = '',
    this.jenisForm = '',
    this.keperluan = '',
    this.tanggalKembali,
    this.tahun = '',
    this.karyawan,
    this.details = const [],
  });

  factory Cuti.fromMap(Map<String, dynamic> map) {
    return Cuti(
      id: map['id']?.toString() ?? '',
      karyawanId: map['karyawan_id']?.toString() ?? '',
      jenisForm: map['jenis_form'] ?? '',
      keperluan: map['keperluan'] ?? '',
      tanggalKembali: AFconvert.keTanggal(map['tanggal_kembali']),
      tahun: map['tahun']?.toString() ?? '',
      karyawan: map['karyawan'] != null ? Karyawan.fromMap(map['karyawan']) : null,
      details: map['details'] ?? [],
    );
  }
}
