import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class DivisiRepository {

  Future<Hasil> findAll({
    String searchBy = '',
    String value = '',
    String sortBy = '',
    String sortOrder = '',
  }) async {
    return await AFdatabase.send(
      url: 'divisi',
      body: {
        'search_by': searchBy,
        'value': value,
        'sort_by': sortBy,
        'sort_order': sortOrder,
      },
    );
  }

  Future<Hasil> findById(String id) async {
    return await AFdatabase.send(
      url: 'divisi/$id',
    );
  }

  Future<Hasil> create(Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'divisi',
      methodeRequest: MethodeRequest.post,
      body: body,
    );
  }

  Future<Hasil> update(String id, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'divisi/$id',
      methodeRequest: MethodeRequest.put,
      body: body,
    );
  }

  Future<Hasil> delete(String id) async {
    return await AFdatabase.send(
      url: 'divisi/$id',
      methodeRequest: MethodeRequest.delete,
    );
  }

}
