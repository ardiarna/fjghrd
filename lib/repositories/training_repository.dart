import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class TrainingRepository {
  Future<Hasil> findAll({
    String searchBy = '',
    String value = '',
    String sortBy = '',
    String sortOrder = '',
  }) async {
    return await AFdatabase.send(
      url: 'training',
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
      url: 'training/$id',
    );
  }

  Future<Hasil> create(Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'training',
      methodeRequest: MethodeRequest.post,
      body: body,
    );
  }

  Future<Hasil> update(String id, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'training/$id',
      methodeRequest: MethodeRequest.put,
      body: body,
    );
  }

  Future<Hasil> delete(String id) async {
    return await AFdatabase.send(
      url: 'training/$id',
      methodeRequest: MethodeRequest.delete,
    );
  }
}
