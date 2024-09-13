import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class UangPhkRepository {

  Future<Hasil> findAll({
    String tahun = '',
    String karyawanId = '',
  }) async {
    return await AFdatabase.send(
      url: 'uang_phk?tahun=$tahun&karyawan_id=$karyawanId',
    );
  }

  Future<Hasil> create(Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'uang_phk',
      methodeRequest: MethodeRequest.post,
      body: body,
    );
  }

  Future<Hasil> update(String id, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'uang_phk/$id',
      methodeRequest: MethodeRequest.put,
      body: body,
    );
  }

  Future<Hasil> delete(String id) async {
    return await AFdatabase.send(
      url: 'uang_phk/$id',
      methodeRequest: MethodeRequest.delete,
    );
  }

}