import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/utils/af_convert.dart';

class CutiDate {
  String id;
  String cutiDetailId;
  DateTime? tanggal;

  CutiDate({
    this.id = '',
    this.cutiDetailId = '',
    this.tanggal,
  });

  factory CutiDate.fromMap(Map<String, dynamic> map) {
    return CutiDate(
      id: map['id']?.toString() ?? '',
      cutiDetailId: map['cuti_detail_id']?.toString() ?? map['cic_cuti_detail_id']?.toString() ?? '',
      tanggal: AFconvert.keTanggal(map['tanggal']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cuti_detail_id': cutiDetailId,
      'tanggal': tanggal != null ? AFconvert.matYMD(tanggal!) : null,
    };
  }
}

class CutiDetail {
  String id;
  String cutiId;
  String kategori;
  int? snapTotalHakCuti;
  int? snapCutiTerambil;
  int? snapCutiMasal;
  int lamaHari;
  String keterangan;
  String? jenisCutiKhususId;
  String? jenisUnpaid;
  Map<String, dynamic>? jenisKhusus;
  List<CutiDate> dates;

  CutiDetail({
    this.id = '',
    this.cutiId = '',
    this.kategori = '',
    this.snapTotalHakCuti,
    this.snapCutiTerambil,
    this.snapCutiMasal,
    this.lamaHari = 0,
    this.keterangan = '',
    this.jenisCutiKhususId,
    this.jenisUnpaid,
    this.jenisKhusus,
    this.dates = const [],
  });

  factory CutiDetail.fromMap(Map<String, dynamic> map) {
    return CutiDetail(
      id: map['id']?.toString() ?? '',
      cutiId: map['cuti_id']?.toString() ?? map['cic_cuti_id']?.toString() ?? '',
      kategori: map['kategori'] ?? '',
      snapTotalHakCuti: AFconvert.keInt(map['snap_total_hak_cuti']),
      snapCutiTerambil: AFconvert.keInt(map['snap_sudah_diambil'] ?? map['snap_cuti_terambil']),
      snapCutiMasal: AFconvert.keInt(map['snap_cuti_masal']),
      lamaHari: AFconvert.keInt(map['lama_hari']),
      keterangan: map['keterangan'] ?? '',
      jenisCutiKhususId: map['jenis_cuti_khusus_id']?.toString(),
      jenisUnpaid: map['jenis_unpaid']?.toString(),
      jenisKhusus: map['jenis_khusus'],
      dates: map['dates'] != null
          ? List<CutiDate>.from((map['dates'] as List).map((x) => CutiDate.fromMap(x)))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cuti_id': cutiId,
      'kategori': kategori,
      'snap_total_hak_cuti': snapTotalHakCuti,
      'snap_cuti_terambil': snapCutiTerambil,
      'snap_cuti_masal': snapCutiMasal,
      'lama_hari': lamaHari,
      'keterangan': keterangan,
      'jenis_cuti_khusus_id': jenisCutiKhususId,
      'jenis_unpaid': jenisUnpaid,
      'jenis_khusus': jenisKhusus,
      'dates': dates.map((x) => x.toMap()).toList(),
    };
  }
}

class Cuti {
  String id;
  String karyawanId;
  String jenisForm;
  DateTime? tanggalKembali;
  String tahun;
  Karyawan? karyawan;
  List<CutiDetail> details;

  Cuti({
    this.id = '',
    this.karyawanId = '',
    this.jenisForm = '',
    this.tanggalKembali,
    this.tahun = '',
    this.karyawan,
    this.details = const [],
  });

  factory Cuti.fromMap(Map<String, dynamic> map) {
    return Cuti(
      id: map['id']?.toString() ?? '',
      karyawanId: map['karyawan_id']?.toString() ?? map['cic_karyawan_id']?.toString() ?? '',
      jenisForm: map['jenis_form'] ?? '',
      tanggalKembali: AFconvert.keTanggal(map['tanggal_kembali']),
      tahun: map['tahun']?.toString() ?? '',
      karyawan: map['karyawan'] != null ? Karyawan.fromMap(map['karyawan']) : (map['cic_karyawan'] != null ? Karyawan.fromMap(map['cic_karyawan']) : null),
      details: map['details'] != null
          ? List<CutiDetail>.from((map['details'] as List).map((x) => CutiDetail.fromMap(x)))
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'karyawan_id': karyawanId,
      'jenis_form': jenisForm,
      'tanggal_kembali': tanggalKembali != null ? AFconvert.matYMD(tanggalKembali!) : null,
      'tahun': tahun,
      'details': details.map((x) => x.toMap()).toList(),
    };
  }
}
