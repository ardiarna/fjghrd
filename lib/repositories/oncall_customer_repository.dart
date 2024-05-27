import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class OncallCustomerRepository {

  Future<Hasil> findAll({
    String tahun = '',
    String bulan = '',
    String customerId = '',
  }) async {
    return await AFdatabase.send(
      url: 'oncall_customer?tahun=$tahun&bulan=$bulan&customer_id=$customerId',
    );
  }

  Future<Hasil> create(Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'oncall_customer',
      methodeRequest: MethodeRequest.post,
      body: body,
    );
  }

  Future<Hasil> update(String id, Map<String, String> body) async {
    return await AFdatabase.send(
      url: 'oncall_customer/$id',
      methodeRequest: MethodeRequest.put,
      body: body,
    );
  }

  Future<Hasil> delete(String id) async {
    return await AFdatabase.send(
      url: 'oncall_customer/$id',
      methodeRequest: MethodeRequest.delete,
    );
  }

}