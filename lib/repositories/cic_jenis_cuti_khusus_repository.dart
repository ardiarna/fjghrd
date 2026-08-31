import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class CicJenisCutiKhususRepository {
  Future<Hasil> findAll() async {
    return await AFdatabase.send(
      url: 'cic/jenis-cuti-khusus',
    );
  }

  Future<Hasil> create(Map<String, dynamic> body) async {
    return await AFdatabase.send(
      url: 'cic/jenis-cuti-khusus',
      methodeRequest: MethodeRequest.post,
      body: body,
      contentIsJson: true,
    );
  }

  Future<Hasil> update(String id, Map<String, dynamic> body) async {
    return await AFdatabase.send(
      url: 'cic/jenis-cuti-khusus/$id',
      methodeRequest: MethodeRequest.put,
      body: body,
      contentIsJson: true,
    );
  }

  Future<Hasil> delete(String id) async {
    return await AFdatabase.send(
      url: 'cic/jenis-cuti-khusus/$id',
      methodeRequest: MethodeRequest.delete,
    );
  }
}
