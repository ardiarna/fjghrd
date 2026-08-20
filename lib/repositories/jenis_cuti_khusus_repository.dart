import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class JenisCutiKhususRepository {
  Future<Hasil> findAll() async {
    return await AFdatabase.send(
      url: 'jenis-cuti-khusus',
    );
  }

  Future<Hasil> create(Map body) async {
    return await AFdatabase.send(
      url: 'jenis-cuti-khusus',
      methodeRequest: MethodeRequest.post,
      body: Map<String, dynamic>.from(body),
      contentIsJson: true,
    );
  }

  Future<Hasil> update(String id, Map body) async {
    return await AFdatabase.send(
      url: 'jenis-cuti-khusus/$id',
      methodeRequest: MethodeRequest.put,
      body: Map<String, dynamic>.from(body),
      contentIsJson: true,
    );
  }

  Future<Hasil> delete(String id) async {
    return await AFdatabase.send(
      url: 'jenis-cuti-khusus/$id',
      methodeRequest: MethodeRequest.delete,
    );
  }
}
