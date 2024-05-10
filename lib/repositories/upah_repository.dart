import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class UpahRepository {

  Future<Hasil> findAll({String isStaf = ''}) async {
    return await AFdatabase.send(
      url: 'upah?aktif=Y&staf=$isStaf&sort_by=tanggal_masuk&sort_order=asc',
    );
  }

  Future<Hasil> create(String karyawanId, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'karyawan/$karyawanId/upah',
      methodeRequest: MethodeRequest.post,
      body: body,
    );
  }

  Future<Hasil> updateByKaryawanId(String karyawanId, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'karyawan/$karyawanId/upah',
      methodeRequest: MethodeRequest.put,
      body: body,
    );
  }

  Future<Hasil> deleteByKaryawanId(String karyawanId) async {
    return await AFdatabase.send(
      url: 'karyawan/$karyawanId/upah',
      methodeRequest: MethodeRequest.delete,
    );
  }

}
