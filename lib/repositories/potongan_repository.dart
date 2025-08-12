import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class PotonganRepository {

  Future<Hasil> findAll({
    String tahun = '',
    String bulan = '',
    String jenis = '',
    String karyawanId = '',
  }) async {
    return await AFdatabase.send(
      url: 'potongan?tahun=$tahun&bulan=$bulan&jenis=$jenis&karyawan_id=$karyawanId',
    );
  }

  Future<Hasil> create(Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'potongan',
      methodeRequest: MethodeRequest.post,
      body: body,
    );
  }

  Future<Hasil> update(String id, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'potongan/$id',
      methodeRequest: MethodeRequest.put,
      body: body,
    );
  }

  Future<Hasil> delete(String id) async {
    return await AFdatabase.send(
      url: 'potongan/$id',
      methodeRequest: MethodeRequest.delete,
    );
  }

  Future<Hasil> deleteAll({
    required String tahun,
    required String bulan,
    String jenis = '',
  }) async {
    return await AFdatabase.send(
      url: 'potongan/all?tahun=$tahun&bulan=$bulan&jenis=$jenis',
      methodeRequest: MethodeRequest.delete,
    );
  }

}