import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class KaryawanRepository {

  Future<Hasil> findAll() async {
    return await AFdatabase.send(
      url: 'karyawan?sort_by=tanggal_masuk&sort_order=asc',
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

}
