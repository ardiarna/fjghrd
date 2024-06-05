import 'package:fjghrd/models/agama.dart';
import 'package:fjghrd/models/area.dart';
import 'package:fjghrd/models/divisi.dart';
import 'package:fjghrd/models/jabatan.dart';
import 'package:fjghrd/models/pendidikan.dart';
import 'package:fjghrd/models/phk.dart';
import 'package:fjghrd/models/ptkp.dart';
import 'package:fjghrd/models/status_kerja.dart';
import 'package:fjghrd/models/upah.dart';
import 'package:fjghrd/utils/af_convert.dart';

class Karyawan {
  String id;
  String nama;
  String nik;
  String nomorKtp;
  DateTime? tanggalMasuk;
  DateTime? tanggalKeluar;
  Agama agama = Agama();
  Area area = Area();
  Jabatan jabatan = Jabatan();
  Divisi divisi = Divisi();
  String tempatLahir;
  DateTime? tanggalLahir;
  String alamatKtp;
  String alamatTinggal;
  String telepon;
  String email;
  bool kawin;
  String kelamin;
  StatusKerja statusKerja = StatusKerja();
  Ptkp ptkp = Ptkp();
  Pendidikan pendidikan = Pendidikan();
  String pendidikanAlmamater;
  String pendidikanJurusan;
  bool aktif;
  bool staf;
  String nomorKk;
  String nomorPaspor;
  Phk phk = Phk();
  Upah upah = Upah();
  DateTime? createdAt;
  DateTime? updatedAt;
  bool dipilih;

  Karyawan({
    this.id = '',
    this.nama = '',
    this.nik = '',
    this.nomorKtp = '',
    this.tanggalMasuk,
    this.tanggalKeluar,
    this.tempatLahir = '',
    this.tanggalLahir,
    this.alamatKtp = '',
    this.alamatTinggal = '',
    this.telepon = '',
    this.email = '',
    this.kawin = false,
    this.kelamin = '',
    this.pendidikanAlmamater = '',
    this.pendidikanJurusan = '',
    this.aktif = false,
    this.staf = true,
    this.nomorKk = '',
    this.nomorPaspor = '',
    this.createdAt,
    this.updatedAt,
    this.dipilih = true,
  }) ;

  factory Karyawan.fromMap(Map<String, dynamic> data) {
    var a = Karyawan(
      id: AFconvert.keString(data['id']),
      nama: AFconvert.keString(data['nama']),
      nik: AFconvert.keString(data['nik']),
      nomorKtp: AFconvert.keString(data['nomor_ktp']),
      tanggalMasuk: AFconvert.keTanggal(data['tanggal_masuk']),
      tanggalKeluar: AFconvert.keTanggal(data['tanggal_keluar']),
      tempatLahir: AFconvert.keString(data['tempat_lahir']),
      tanggalLahir: AFconvert.keTanggal(data['tanggal_lahir']),
      alamatKtp: AFconvert.keString(data['alamat_ktp']),
      alamatTinggal: AFconvert.keString(data['alamat_tinggal']),
      telepon: AFconvert.keString(data['telepon']),
      email: AFconvert.keString(data['email']),
      kawin: AFconvert.keBool(data['kawin']),
      kelamin: AFconvert.keString(data['kelamin']),
      pendidikanAlmamater: AFconvert.keString(data['pendidikan_almamater']),
      pendidikanJurusan: AFconvert.keString(data['pendidikan_jurusan']),
      aktif: AFconvert.keBool(data['aktif']),
      staf: AFconvert.keBool(data['staf']),
      nomorKk: AFconvert.keString(data['nomor_kk']),
      nomorPaspor: AFconvert.keString(data['nomor_paspor']),
      createdAt: AFconvert.keTanggal(data['created_at']),
      updatedAt: AFconvert.keTanggal(data['updated_at']),
    );
    if(data['agama'] != null) {
      a.agama = Agama.fromMap(data['agama']);
    }
    if(data['area'] != null) {
      a.area = Area.fromMap(data['area']);
    }
    if(data['jabatan'] != null) {
      a.jabatan = Jabatan.fromMap(data['jabatan']);
    }
    if(data['divisi'] != null) {
      a.divisi = Divisi.fromMap(data['divisi']);
    }
    if(data['status_kerja'] != null) {
      a.statusKerja = StatusKerja.fromMap(data['status_kerja']);
    }
    if(data['ptkp'] != null) {
      a.ptkp = Ptkp.fromMap(data['ptkp']);
    }
    if(data['pendidikan'] != null) {
      a.pendidikan = Pendidikan.fromMap(data['pendidikan']);
    }
    if(data['phk'] != null) {
      a.phk = Phk.fromMap(data['phk']);
    }
    a.upah = Upah(
      id: AFconvert.keString(data['upah_id']),
      karyawanId: a.id,
      gaji: AFconvert.keInt(data['gaji']),
      uangMakan: AFconvert.keInt(data['uang_makan']),
      makanHarian: AFconvert.keBool(data['makan_harian']),
      overtime: AFconvert.keBool(data['overtime']),
    );
    return a;
  }

  Map<String, String> toMap() {
    Map<String, String> data = {
      'id': id,
      'nama': nama,
      'nik': nik,
      'nomor_ktp': nomorKtp,
      'tanggal_masuk': AFconvert.matYMDTime(tanggalMasuk),
      'tempat_lahir': tempatLahir,
      'tanggal_lahir': AFconvert.matYMDTime(tanggalLahir),
      'alamat_ktp': alamatKtp,
      'alamat_tinggal': alamatTinggal,
      'telepon': telepon,
      'email': email,
      'kawin': kawin ? 'Y' : 'N',
      'kelamin': kelamin,
      'pendidikan_almamater': pendidikanAlmamater,
      'pendidikan_jurusan': pendidikanJurusan,
      'aktif': aktif ? 'Y' : 'N',
      'staf': staf ? 'Y' : 'N',
      'nomor_kk': nomorKk,
      'nomor_paspor': nomorPaspor,
    };
    if(tanggalKeluar != null) {
      data['tanggal_keluar'] = AFconvert.matYMDTime(tanggalKeluar);
    }
    if(agama.id != '') {
      data['agama_id'] = agama.id;
    }
    if(area.id != '') {
      data['area_id'] = area.id;
    }
    if(jabatan.id != '') {
      data['jabatan_id'] = jabatan.id;
    }
    if(divisi.id != '') {
      data['divisi_id'] = divisi.id;
    }
    if(statusKerja.id != '') {
      data['status_kerja_id'] = statusKerja.id;
    }
    if(ptkp.id != '') {
      data['ptkp_id'] = ptkp.id;
    }
    if(pendidikan.id != '') {
      data['pendidikan_id'] = pendidikan.id;
    }
    return data;
  }

}
