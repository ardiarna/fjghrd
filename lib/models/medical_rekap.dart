import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/utils/af_convert.dart';

class MedicalRekap {
  String id;
  Karyawan karyawan = Karyawan();
  String tahun;
  int gaji;
  int bln1;
  int bln2;
  int bln3;
  int bln4;
  int bln5;
  int bln6;
  int bln7;
  int bln8;
  int bln9;
  int bln10;
  int bln11;
  int bln12;
  DateTime? createdAt;
  DateTime? updatedAt;

  MedicalRekap({
    this.id = '',
    this.tahun = '',
    this.gaji = 0,
    this.bln1 = 0,
    this.bln2 = 0,
    this.bln3 = 0,
    this.bln4 = 0,
    this.bln5 = 0,
    this.bln6 = 0,
    this.bln7 = 0,
    this.bln8 = 0,
    this.bln9 = 0,
    this.bln10 = 0,
    this.bln11 = 0,
    this.bln12 = 0,
    this.createdAt,
    this.updatedAt,
  }) ;

  factory MedicalRekap.fromMap(Map<String, dynamic> data) {
    var a = MedicalRekap(
      id: AFconvert.keString(data['id']),
      tahun: AFconvert.keString(data['tahun']),
      gaji: AFconvert.keInt(data['gaji']),
      bln1: AFconvert.keInt(data['bln_1']),
      bln2: AFconvert.keInt(data['bln_2']),
      bln3: AFconvert.keInt(data['bln_3']),
      bln4: AFconvert.keInt(data['bln_4']),
      bln5: AFconvert.keInt(data['bln_5']),
      bln6: AFconvert.keInt(data['bln_6']),
      bln7: AFconvert.keInt(data['bln_7']),
      bln8: AFconvert.keInt(data['bln_8']),
      bln9: AFconvert.keInt(data['bln_9']),
      bln10: AFconvert.keInt(data['bln_10']),
      bln11: AFconvert.keInt(data['bln_11']),
      bln12: AFconvert.keInt(data['bln_12']),
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
      'tahun': tahun,
      'gaji': AFconvert.keString(gaji),
      'bln_1': AFconvert.keString(bln1),
      'bln_2': AFconvert.keString(bln2),
      'bln_3': AFconvert.keString(bln3),
      'bln_4': AFconvert.keString(bln4),
      'bln_5': AFconvert.keString(bln5),
      'bln_6': AFconvert.keString(bln6),
      'bln_7': AFconvert.keString(bln7),
      'bln_8': AFconvert.keString(bln8),
      'bln_9': AFconvert.keString(bln9),
      'bln_10': AFconvert.keString(bln10),
      'bln_11': AFconvert.keString(bln11),
      'bln_12': AFconvert.keString(bln12),
    };
    return data;
  }

}
