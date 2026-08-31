import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class CicCutiRepository {
  Future<Hasil> findAll({String tahun = ''}) async {
    return await AFdatabase.send(
      url: 'cic/cuti?tahun=$tahun',
    );
  }

  Future<Hasil> fetchInfo({required String karyawanId, required String tahun}) async {
    return await AFdatabase.send(
      url: 'cic/cuti/info?cic_karyawan_id=$karyawanId&tahun=$tahun',
    );
  }

  Future<Hasil> submit(Map<String, dynamic> body) async {
    return await AFdatabase.send(
      url: 'cic/cuti/submit',
      methodeRequest: MethodeRequest.post,
      body: body,
      contentIsJson: true,
    );
  }

  Future<Hasil> delete(String id) async {
    return await AFdatabase.send(
      url: 'cic/cuti/$id',
      methodeRequest: MethodeRequest.delete,
    );
  }
}