import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class TarifEfektifRepository {

  Future<Hasil> findAll({
    String ter = '',
    String sortBy = '',
    String sortOrder = '',
  }) async {
    return await AFdatabase.send(
      url: 'tarif_efektif',
      body: {
        'ter': ter,
        'sort_by': sortBy,
        'sort_order': sortOrder,
      },
    );
  }

  Future<Hasil> findById(String id) async {
    return await AFdatabase.send(
      url: 'tarif_efektif/id/$id',
    );
  }

  Future<Hasil> findByTerAndPenghasilan({
    required String ter,
    required int penghasilan,
  }) async {
    return await AFdatabase.send(
      url: 'tarif_efektif/cari?ter=$ter&penghasilan=$penghasilan',
    );
  }

  Future<Hasil> create(Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'tarif_efektif',
      methodeRequest: MethodeRequest.post,
      body: body,
    );
  }

  Future<Hasil> update(String id, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'tarif_efektif/$id',
      methodeRequest: MethodeRequest.put,
      body: body,
    );
  }

  Future<Hasil> delete(String id) async {
    return await AFdatabase.send(
      url: 'tarif_efektif/$id',
      methodeRequest: MethodeRequest.delete,
    );
  }

}
