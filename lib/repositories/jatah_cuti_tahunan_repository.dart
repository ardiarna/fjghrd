import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class JatahCutiTahunanRepository {
  Future<Hasil> findAll({String karyawanId = '', String tahun = ''}) async {
    return await AFdatabase.send(
      url: 'jatah-cuti?karyawan_id=$karyawanId&tahun=$tahun',
    );
  }

  Future<Hasil> create(Map body) async {
    return await AFdatabase.send(
      url: 'jatah-cuti',
      methodeRequest: MethodeRequest.post,
      body: Map<String, dynamic>.from(body),
      contentIsJson: true,
    );
  }

  Future<Hasil> update(String id, Map body) async {
    return await AFdatabase.send(
      url: 'jatah-cuti/$id',
      methodeRequest: MethodeRequest.put,
      body: Map<String, dynamic>.from(body),
      contentIsJson: true,
    );
  }

  Future<Hasil> delete(String id) async {
    return await AFdatabase.send(
      url: 'jatah-cuti/$id',
      methodeRequest: MethodeRequest.delete,
    );
  }
}
