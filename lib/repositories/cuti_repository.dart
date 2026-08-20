import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class CutiRepository {
  Future<Hasil> findAll({String tahun = ''}) async {
    return await AFdatabase.send(
      url: 'cuti?tahun=$tahun',
    );
  }

  Future<Hasil> fetchInfo({required String karyawanId, required String tahun}) async {
    return await AFdatabase.send(
      url: 'cuti/info?karyawan_id=$karyawanId&tahun=$tahun',
    );
  }

  Future<Hasil> submit(Map<String, dynamic> body) async {
    return await AFdatabase.send(
      url: 'cuti/submit',
      methodeRequest: MethodeRequest.post,
      body: body,
      contentIsJson: true,
    );
  }

  Future<Hasil> delete(String id) async {
    return await AFdatabase.send(
      url: 'cuti/$id',
      methodeRequest: MethodeRequest.delete,
    );
  }
}
