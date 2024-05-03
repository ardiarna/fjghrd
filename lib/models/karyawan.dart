import 'package:fjghrd/models/agama.dart';
import 'package:fjghrd/models/area.dart';
import 'package:fjghrd/models/divisi.dart';
import 'package:fjghrd/models/jabatan.dart';
import 'package:fjghrd/models/pendidikan.dart';
import 'package:fjghrd/models/phk.dart';
import 'package:fjghrd/models/status_kerja.dart';
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
  StatusKerja statusKerja = StatusKerja();
  Pendidikan pendidikan = Pendidikan();
  String pendidikanAlmamater;
  String pendidikanJurusan;
  bool aktif;
  String nomorKk;
  String nomorPaspor;
  Phk phk = Phk();
  DateTime? createdAt;
  DateTime? updatedAt;

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
    this.pendidikanAlmamater = '',
    this.pendidikanJurusan = '',
    this.aktif = false,
    this.nomorKk = '',
    this.nomorPaspor = '',
    this.createdAt,
    this.updatedAt,
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
      pendidikanAlmamater: AFconvert.keString(data['pendidikan_almamater']),
      pendidikanJurusan: AFconvert.keString(data['pendidikan_jurusan']),
      aktif: AFconvert.keBool(data['aktif']),
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
    if(data['pendidikan'] != null) {
      a.pendidikan = Pendidikan.fromMap(data['pendidikan']);
    }
    if(data['phk'] != null) {
      a.phk = Phk.fromMap(data['phk']);
    }
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
      'pendidikan_almamater': pendidikanAlmamater,
      'pendidikan_jurusan': pendidikanJurusan,
      'aktif': aktif ? 'Y' : 'N',
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
    if(pendidikan.id != '') {
      data['pendidikan_id'] = pendidikan.id;
    }
    return data;
  }

}
