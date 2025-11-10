import 'package:fjghrd/utils/af_convert.dart';

class UangPhk2 {
  String id;
  String karyawanId;
  int tahun;
  int kompensasi;
  int uangPisah;
  int pesangon;
  int masaKerja;
  int penggantianHak;
  int sisaCutiHari;
  int sisaCutiJumlah;
  int lain;
  int potKas;
  int potCutiHari;
  int potCutiJumlah;
  int potLain;
  String keterangan;
  DateTime? createdAt;
  DateTime? updatedAt;

  UangPhk2({
    this.id = '',
    this.karyawanId = '',
    this.tahun = 0,
    this.kompensasi = 0,
    this.uangPisah = 0,
    this.pesangon = 0,
    this.masaKerja = 0,
    this.penggantianHak = 0,
    this.sisaCutiHari = 0,
    this.sisaCutiJumlah = 0,
    this.lain = 0,
    this.potKas = 0,
    this.potCutiHari = 0,
    this.potCutiJumlah = 0,
    this.potLain = 0,
    this.keterangan = '',
    this.createdAt,
    this.updatedAt,
  }) ;

  factory UangPhk2.fromMap(Map<String, dynamic> data) {
    return UangPhk2(
      id: AFconvert.keString(data['id']),
      karyawanId: AFconvert.keString(data['karyawan_id']),
      tahun: AFconvert.keInt(data['tahun']),
      kompensasi: AFconvert.keInt(data['kompensasi']),
      uangPisah: AFconvert.keInt(data['uang_pisah']),
      pesangon: AFconvert.keInt(data['pesangon']),
      masaKerja: AFconvert.keInt(data['masa_kerja']),
      penggantianHak: AFconvert.keInt(data['penggantian_hak']),
      sisaCutiHari: AFconvert.keInt(data['sisa_cuti_hari']),
      sisaCutiJumlah: AFconvert.keInt(data['sisa_cuti_jumlah']),
      lain: AFconvert.keInt(data['lain']),
      potKas: AFconvert.keInt(data['pot_kas']),
      potCutiHari: AFconvert.keInt(data['pot_cuti_hari']),
      potCutiJumlah: AFconvert.keInt(data['pot_cuti_jumlah']),
      potLain: AFconvert.keInt(data['pot_lain']),
      keterangan: AFconvert.keString(data['keterangan']),
      createdAt: AFconvert.keTanggal(data['created_at']),
      updatedAt: AFconvert.keTanggal(data['updated_at']),
    );
  }

  Map<String, String> toMap() {
    Map<String, String> data = {
      'id': id,
      'karyawan_id': karyawanId,
      'tahun': AFconvert.keString(tahun),
      'kompensasi': AFconvert.keString(kompensasi),
      'uang_pisah': AFconvert.keString(uangPisah),
      'pesangon': AFconvert.keString(pesangon),
      'masa_kerja': AFconvert.keString(masaKerja),
      'penggantian_hak': AFconvert.keString(penggantianHak),
      'sisa_cuti_hari': AFconvert.keString(sisaCutiHari),
      'sisa_cuti_jumlah': AFconvert.keString(sisaCutiJumlah),
      'lain': AFconvert.keString(lain),
      'pot_kas': AFconvert.keString(potKas),
      'pot_cuti_hari': AFconvert.keString(potCutiHari),
      'pot_cuti_jumlah': AFconvert.keString(potCutiJumlah),
      'pot_lain': AFconvert.keString(potLain),
      'keterangan': keterangan,
    };
    return data;
  }

}
