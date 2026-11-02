import 'package:fjghrd/utils/af_convert.dart';

class UangPhk2 {
  String id;
  String karyawanId;
  int tahun;
  int kompensasi;
  int uangPisah;
  int pesangon;
  int masaKerja;
  int sisaCutiHari;
  int sisaCutiJumlah;
  int lain;
  int potKas;
  int potCicilan;
  int potCutiHari;
  int potCutiJumlah;
  int potLain;
  String keterangan;
  String ketKompensasi;
  String ketUangPisah;
  String ketPesangon;
  String ketMasaKerja;
  String ketLain;
  String ketPotLain;
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
    this.sisaCutiHari = 0,
    this.sisaCutiJumlah = 0,
    this.lain = 0,
    this.potKas = 0,
    this.potCicilan = 0,
    this.potCutiHari = 0,
    this.potCutiJumlah = 0,
    this.potLain = 0,
    this.keterangan = '',
    this.ketKompensasi = '',
    this.ketUangPisah = '',
    this.ketPesangon = '',
    this.ketMasaKerja = '',
    this.ketLain = '',
    this.ketPotLain = '',
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
      sisaCutiHari: AFconvert.keInt(data['sisa_cuti_hari']),
      sisaCutiJumlah: AFconvert.keInt(data['sisa_cuti_jumlah']),
      lain: AFconvert.keInt(data['lain']),
      potKas: AFconvert.keInt(data['pot_kas']),
      potCicilan: AFconvert.keInt(data['pot_cicilan']),
      potCutiHari: AFconvert.keInt(data['pot_cuti_hari']),
      potCutiJumlah: AFconvert.keInt(data['pot_cuti_jumlah']),
      potLain: AFconvert.keInt(data['pot_lain']),
      keterangan: AFconvert.keString(data['keterangan']),
      ketKompensasi: AFconvert.keString(data['ket_kompensasi']),
      ketUangPisah: AFconvert.keString(data['ket_uang_pisah']),
      ketPesangon: AFconvert.keString(data['ket_pesangon']),
      ketMasaKerja: AFconvert.keString(data['ket_masa_kerja']),
      ketLain: AFconvert.keString(data['ket_lain']),
      ketPotLain: AFconvert.keString(data['ket_pot_lain']),
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
      'sisa_cuti_hari': AFconvert.keString(sisaCutiHari),
      'sisa_cuti_jumlah': AFconvert.keString(sisaCutiJumlah),
      'lain': AFconvert.keString(lain),
      'pot_kas': AFconvert.keString(potKas),
      'pot_cicilan': AFconvert.keString(potCicilan),
      'pot_cuti_hari': AFconvert.keString(potCutiHari),
      'pot_cuti_jumlah': AFconvert.keString(potCutiJumlah),
      'pot_lain': AFconvert.keString(potLain),
      'keterangan': keterangan,
      'ket_kompensasi': ketKompensasi,
      'ket_uang_pisah': ketUangPisah,
      'ket_pesangon': ketPesangon,
      'ket_masa_kerja': ketMasaKerja,
      'ket_lain': ketLain,
      'ket_pot_lain': ketPotLain,
    };
    return data;
  }

}
