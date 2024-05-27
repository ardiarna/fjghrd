import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class OvertimeRepository {

  Future<Hasil> findAll({
    String tahun = '',
    String bulan = '',
    String jenis = '',
    String karyawanId = '',
  }) async {
    return await AFdatabase.send(
      url: 'overtime?tahun=$tahun&bulan=$bulan&jenis=$jenis&karyawan_id=$karyawanId',
    );
  }

  Future<Hasil> create(Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'overtime',
      methodeRequest: MethodeRequest.post,
      body: body,
    );
  }

  Future<Hasil> update(String id, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'overtime/$id',
      methodeRequest: MethodeRequest.put,
      body: body,
    );
  }

  Future<Hasil> delete(String id) async {
    return await AFdatabase.send(
      url: 'overtime/$id',
      methodeRequest: MethodeRequest.delete,
    );
  }

}