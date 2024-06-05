import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class PtkpRepository {

  Future<Hasil> findAll({
    String ter = '',
    String sortBy = '',
    String sortOrder = '',
  }) async {
    return await AFdatabase.send(
      url: 'ptkp',
      body: {
        'ter': ter,
        'sort_by': sortBy,
        'sort_order': sortOrder,
      },
    );
  }

  Future<Hasil> findById(String id) async {
    return await AFdatabase.send(
      url: 'ptkp/id/$id',
    );
  }

  Future<Hasil> findByKode(String kode) async {
    return await AFdatabase.send(
      url: 'ptkp/cari?kode=$kode',
    );
  }

  Future<Hasil> create(Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'ptkp',
      methodeRequest: MethodeRequest.post,
      body: body,
    );
  }

  Future<Hasil> update(String id, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'ptkp/$id',
      methodeRequest: MethodeRequest.put,
      body: body,
    );
  }

  Future<Hasil> delete(String id) async {
    return await AFdatabase.send(
      url: 'ptkp/$id',
      methodeRequest: MethodeRequest.delete,
    );
  }

}
