import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class KaryawanRepository {

  Future<Hasil> findAll({String isStaf = '', String area = ''}) async {
    return await AFdatabase.send(
      url: 'karyawan?aktif=Y&staf=$isStaf&area=$area&sort_by=tanggal_masuk&sort_order=asc',
    );
  }

  Future<Hasil> create(Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'karyawan',
      methodeRequest: MethodeRequest.post,
      body: body,
    );
  }

  Future<Hasil> update(String id, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'karyawan/$id',
      methodeRequest: MethodeRequest.put,
      body: body,
    );
  }

  Future<Hasil> delete(String id) async {
    return await AFdatabase.send(
      url: 'karyawan/$id',
      methodeRequest: MethodeRequest.delete,
    );
  }

  Future<Hasil> keluargaFindAll(String id) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/keluarga?sort_by=tanggal_lahir&sort_order=asc',
    );
  }

  Future<Hasil> keluargaCreate(String id, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/keluarga',
      methodeRequest: MethodeRequest.post,
      body: body,
    );
  }

  Future<Hasil> keluargaUpdate(String id, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/keluarga/${body['id']}',
      methodeRequest: MethodeRequest.put,
      body: body,
    );
  }

  Future<Hasil> keluargaDelete(String id, String keluargaId) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/keluarga/$keluargaId',
      methodeRequest: MethodeRequest.delete,
    );
  }

  Future<Hasil> kontakKeluargaFindAll(String id) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/kontak-keluarga',
    );
  }

  Future<Hasil> kontakKeluargaCreate(String id, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/kontak-keluarga',
      methodeRequest: MethodeRequest.post,
      body: body,
    );
  }

  Future<Hasil> kontakKeluargaUpdate(String id, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/kontak-keluarga/${body['id']}',
      methodeRequest: MethodeRequest.put,
      body: body,
    );
  }

  Future<Hasil> kontakKeluargaDelete(String id, String kontakId) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/kontak-keluarga/$kontakId',
      methodeRequest: MethodeRequest.delete,
    );
  }

  Future<Hasil> perjanjianKerjaFindAll(String id) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/perjanjian-kerja',
    );
  }

  Future<Hasil> perjanjianKerjaCreate(String id, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/perjanjian-kerja',
      methodeRequest: MethodeRequest.post,
      body: body,
    );
  }

  Future<Hasil> perjanjianKerjaUpdate(String id, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/perjanjian-kerja/${body['id']}',
      methodeRequest: MethodeRequest.put,
      body: body,
    );
  }

  Future<Hasil> perjanjianKerjaDelete(String id, String perjanjianKerjaId) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/perjanjian-kerja/$perjanjianKerjaId',
      methodeRequest: MethodeRequest.delete,
    );
  }

  Future<Hasil> mantanFindAll({String isStaf = ''}) async {
    return await AFdatabase.send(
      url: 'karyawan?aktif=N&staf=$isStaf&sort_by=tanggal_keluar&sort_order=desc',
    );
  }

  Future<Hasil> phkFindAll(String id) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/phk?sort_by=tanggal_akhir&sort_order=asc',
    );
  }

  Future<Hasil> phkCreate(String id, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/phk',
      methodeRequest: MethodeRequest.post,
      body: body,
    );
  }

  Future<Hasil> timelineMasakerja(String id) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/timeline-masakerja',
    );
  }

  Future<Hasil> medicalRekap(String id, String tahun) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/medical-rekap/$tahun',
    );
  }

  Future<Hasil> overtimeRekap(String id, String tahun) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/overtime-rekap/$tahun',
    );
  }

  Future<Hasil> payrollFindAll({
    required String id,
    required String tahun,
  }) async {
    return await AFdatabase.send(
      url: 'karyawan/$id/payroll?tahun=$tahun&pph21=Y',
    );
  }

  Future<Hasil> excelPayroll({
    required String id,
    required String tahun,
  }) async {
    return await AFdatabase.download(url: 'excel/payroll/$id/$tahun');
  }
  
  Future<Hasil> excelSlipGaji({
    required String id,
    required String tahun,
    required String bulans,
  }) async {
    return await AFdatabase.download(url: 'excel/slip-karyawan/$id/$tahun/$bulans');
  }

  Future<Hasil> rekapAreaKelamin() async {
    return await AFdatabase.send(
      url: 'karyawan/rekap/area-kelamin',
    );
  }


}
