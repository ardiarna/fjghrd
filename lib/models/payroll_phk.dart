
import 'package:fjghrd/models/karyawan.dart';
import 'package:fjghrd/utils/af_convert.dart';

class PayrollPhk {
  String id;
  Karyawan karyawan = Karyawan();
  int tahun;
  int bulan;
  DateTime? tanggalAwal;
  DateTime? tanggalAkhir;
  bool makanHarian;
  int gaji;
  int kenaikanGaji;
  int hariMakan;
  int uangMakanHarian;
  int uangMakanJumlah;
  int overtimeFjg;
  int overtimeCus;
  int medical;
  int thr;
  int bonus;
  int insentif;
  int telkomsel;
  int lain;
  int pot25hari;
  int pot25jumlah;
  int potTelepon;
  int potBensin;
  int potKas;
  int potCicilan;
  int potBpjs;
  int potCutiHari;
  int potCutiJumlah;
  double potKompensasiJam;
  int potKompensasiJumlah;
  int potLain;
  int totalDiterima;
  String keterangan;
  DateTime? createdAt;
  DateTime? updatedAt;

  PayrollPhk({
    this.id = '',
    this.tahun = 0,
    this.bulan = 0,
    this.tanggalAwal,
    this.tanggalAkhir,
    this.makanHarian = true,
    this.gaji = 0,
    this.kenaikanGaji = 0,
    this.hariMakan = 0,
    this.uangMakanHarian = 0,
    this.uangMakanJumlah = 0,
    this.overtimeFjg = 0,
    this.overtimeCus = 0,
    this.medical = 0,
    this.thr = 0,
    this.bonus = 0,
    this.insentif = 0,
    this.telkomsel = 0,
    this.lain = 0,
    this.pot25hari = 0,
    this.pot25jumlah = 0,
    this.potTelepon = 0,
    this.potBensin = 0,
    this.potKas = 0,
    this.potCicilan = 0,
    this.potBpjs = 0,
    this.potCutiHari = 0,
    this.potCutiJumlah = 0,
    this.potKompensasiJam = 0,
    this.potKompensasiJumlah = 0,
    this.potLain = 0,
    this.totalDiterima = 0,
    this.keterangan = '',
    this.createdAt,
    this.updatedAt,
  });

  factory PayrollPhk.fromMap(Map<String, dynamic> data) {
    var a = PayrollPhk(
      id: AFconvert.keString(data['id']),
      tahun: AFconvert.keInt(data['tahun']),
      bulan: AFconvert.keInt(data['bulan']),
      tanggalAwal: AFconvert.keTanggal(data['tanggal_awal']),
      tanggalAkhir: AFconvert.keTanggal(data['tanggal_akhir']),
      makanHarian: AFconvert.keBool(data['makan_harian']),
      gaji: AFconvert.keInt(data['gaji']),
      kenaikanGaji: AFconvert.keInt(data['kenaikan_gaji']),
      hariMakan: AFconvert.keInt(data['hari_makan']),
      uangMakanHarian: AFconvert.keInt(data['uang_makan_harian']),
      uangMakanJumlah: AFconvert.keInt(data['uang_makan_jumlah']),
      overtimeFjg: AFconvert.keInt(data['overtime_fjg']),
      overtimeCus: AFconvert.keInt(data['overtime_cus']),
      medical: AFconvert.keInt(data['medical']),
      thr: AFconvert.keInt(data['thr']),
      bonus: AFconvert.keInt(data['bonus']),
      insentif: AFconvert.keInt(data['insentif']),
      telkomsel: AFconvert.keInt(data['telkomsel']),
      lain: AFconvert.keInt(data['lain']),
      pot25hari: AFconvert.keInt(data['pot_25_hari']),
      pot25jumlah: AFconvert.keInt(data['pot_25_jumlah']),
      potTelepon: AFconvert.keInt(data['pot_telepon']),
      potBensin: AFconvert.keInt(data['pot_bensin']),
      potKas: AFconvert.keInt(data['pot_kas']),
      potCicilan: AFconvert.keInt(data['pot_cicilan']),
      potBpjs: AFconvert.keInt(data['pot_bpjs']),
      potCutiHari: AFconvert.keInt(data['pot_cuti_hari']),
      potCutiJumlah: AFconvert.keInt(data['pot_cuti_jumlah']),
      potKompensasiJam: AFconvert.keDouble(data['pot_kompensasi_jam']),
      potKompensasiJumlah: AFconvert.keInt(data['pot_kompensasi_jumlah']),
      potLain: AFconvert.keInt(data['pot_lain']),
      totalDiterima: AFconvert.keInt(data['total_diterima']),
      keterangan: AFconvert.keString(data['keterangan']),
      createdAt: AFconvert.keTanggal(data['created_at']),
      updatedAt: AFconvert.keTanggal(data['updated_at']),
    );
    if (data['karyawan'] != null) {
      a.karyawan = Karyawan.fromMap(data['karyawan']);
    }
    return a;
  }

  Map<String, String> toMap() {
    return {
      'id': id,
      'karyawan_id': karyawan.id,
      'tahun': AFconvert.keString(tahun),
      'bulan': AFconvert.keString(bulan),
      'tanggal_awal': AFconvert.matYMDTime(tanggalAwal),
      'tanggal_akhir': AFconvert.matYMDTime(tanggalAkhir),
      'makan_harian': makanHarian ? 'Y' : 'N',
      'gaji': AFconvert.keString(gaji),
      'kenaikan_gaji': AFconvert.keString(kenaikanGaji),
      'hari_makan': AFconvert.keString(hariMakan),
      'uang_makan_harian': AFconvert.keString(uangMakanHarian),
      'uang_makan_jumlah': AFconvert.keString(uangMakanJumlah),
      'overtime_fjg': AFconvert.keString(overtimeFjg),
      'overtime_cus': AFconvert.keString(overtimeCus),
      'medical': AFconvert.keString(medical),
      'thr': AFconvert.keString(thr),
      'bonus': AFconvert.keString(bonus),
      'insentif': AFconvert.keString(insentif),
      'telkomsel': AFconvert.keString(telkomsel),
      'lain': AFconvert.keString(lain),
      'pot_25_hari': AFconvert.keString(pot25hari),
      'pot_25_jumlah': AFconvert.keString(pot25jumlah),
      'pot_telepon': AFconvert.keString(potTelepon),
      'pot_bensin': AFconvert.keString(potBensin),
      'pot_kas': AFconvert.keString(potKas),
      'pot_cicilan': AFconvert.keString(potCicilan),
      'pot_bpjs': AFconvert.keString(potBpjs),
      'pot_cuti_hari': AFconvert.keString(potCutiHari),
      'pot_cuti_jumlah': AFconvert.keString(potCutiJumlah),
      'pot_kompensasi_jam': AFconvert.keString(potKompensasiJam),
      'pot_kompensasi_jumlah': AFconvert.keString(potKompensasiJumlah),
      'pot_lain': AFconvert.keString(potLain),
      'total_diterima': AFconvert.keString(totalDiterima),
      'keterangan': keterangan,
    };
  }
}
