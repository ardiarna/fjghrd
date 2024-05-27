import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/utils/af_convert.dart';

class OvertimeRekap {
  String id;
  Karyawan karyawan = Karyawan();
  String tahun;
  int fjg1;
  int fjg2;
  int fjg3;
  int fjg4;
  int fjg5;
  int fjg6;
  int fjg7;
  int fjg8;
  int fjg9;
  int fjg10;
  int fjg11;
  int fjg12;
  int cus1;
  int cus2;
  int cus3;
  int cus4;
  int cus5;
  int cus6;
  int cus7;
  int cus8;
  int cus9;
  int cus10;
  int cus11;
  int cus12;
  DateTime? createdAt;
  DateTime? updatedAt;

  OvertimeRekap({
    this.id = '',
    this.tahun = '',
    this.fjg1 = 0,
    this.fjg2 = 0,
    this.fjg3 = 0,
    this.fjg4 = 0,
    this.fjg5 = 0,
    this.fjg6 = 0,
    this.fjg7 = 0,
    this.fjg8 = 0,
    this.fjg9 = 0,
    this.fjg10 = 0,
    this.fjg11 = 0,
    this.fjg12 = 0,
    this.cus1 = 0,
    this.cus2 = 0,
    this.cus3 = 0,
    this.cus4 = 0,
    this.cus5 = 0,
    this.cus6 = 0,
    this.cus7 = 0,
    this.cus8 = 0,
    this.cus9 = 0,
    this.cus10 = 0,
    this.cus11 = 0,
    this.cus12 = 0,
    this.createdAt,
    this.updatedAt,
  }) ;

  factory OvertimeRekap.fromMap(Map<String, dynamic> data) {
    var a = OvertimeRekap(
      id: AFconvert.keString(data['id']),
      tahun: AFconvert.keString(data['tahun']),
      fjg1: AFconvert.keInt(data['fjg_1']),
      fjg2: AFconvert.keInt(data['fjg_2']),
      fjg3: AFconvert.keInt(data['fjg_3']),
      fjg4: AFconvert.keInt(data['fjg_4']),
      fjg5: AFconvert.keInt(data['fjg_5']),
      fjg6: AFconvert.keInt(data['fjg_6']),
      fjg7: AFconvert.keInt(data['fjg_7']),
      fjg8: AFconvert.keInt(data['fjg_8']),
      fjg9: AFconvert.keInt(data['fjg_9']),
      fjg10: AFconvert.keInt(data['fjg_10']),
      fjg11: AFconvert.keInt(data['fjg_11']),
      fjg12: AFconvert.keInt(data['fjg_12']),
      cus1: AFconvert.keInt(data['cus_1']),
      cus2: AFconvert.keInt(data['cus_2']),
      cus3: AFconvert.keInt(data['cus_3']),
      cus4: AFconvert.keInt(data['cus_4']),
      cus5: AFconvert.keInt(data['cus_5']),
      cus6: AFconvert.keInt(data['cus_6']),
      cus7: AFconvert.keInt(data['cus_7']),
      cus8: AFconvert.keInt(data['cus_8']),
      cus9: AFconvert.keInt(data['cus_9']),
      cus10: AFconvert.keInt(data['cus_10']),
      cus11: AFconvert.keInt(data['cus_11']),
      cus12: AFconvert.keInt(data['cus_12']),
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
      'fjg_1': AFconvert.keString(fjg1),
      'fjg_2': AFconvert.keString(fjg2),
      'fjg_3': AFconvert.keString(fjg3),
      'fjg_4': AFconvert.keString(fjg4),
      'fjg_5': AFconvert.keString(fjg5),
      'fjg_6': AFconvert.keString(fjg6),
      'fjg_7': AFconvert.keString(fjg7),
      'fjg_8': AFconvert.keString(fjg8),
      'fjg_9': AFconvert.keString(fjg9),
      'fjg_10': AFconvert.keString(fjg10),
      'fjg_11': AFconvert.keString(fjg11),
      'fjg_12': AFconvert.keString(fjg12),
      'cus_1': AFconvert.keString(cus1),
      'cus_2': AFconvert.keString(cus2),
      'cus_3': AFconvert.keString(cus3),
      'cus_4': AFconvert.keString(cus4),
      'cus_5': AFconvert.keString(cus5),
      'cus_6': AFconvert.keString(cus6),
      'cus_7': AFconvert.keString(cus7),
      'cus_8': AFconvert.keString(cus8),
      'cus_9': AFconvert.keString(cus9),
      'cus_10': AFconvert.keString(cus10),
      'cus_11': AFconvert.keString(cus11),
      'cus_12': AFconvert.keString(cus12),
    };
    return data;
  }

}
