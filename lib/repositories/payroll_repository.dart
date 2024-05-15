import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class PayrollRepository {

  Future<Hasil> findAll({
    String tahun = '',
    String bulan = '',
  }) async {
    return await AFdatabase.send(
      url: 'payroll?tahun=$tahun&bulan=$bulan',
    );
  }

  Future<Hasil> create({
    required String tglAwal,
    required String tglAkhir,
    required String tglMakanAwal,
    required String tglMakanAkhir,
    required List<Map<String, dynamic>> payrolls,
    String keterangan = '',
  }) async {
    var body = {
      'tanggal_awal': tglAwal,
      'tanggal_akhir': tglAkhir,
      'tanggal_makan_awal': tglMakanAwal,
      'tanggal_makan_akhir': tglMakanAkhir,
      'payrolls': payrolls,
    };
    if(keterangan != '') {
      body['keterangan'] = keterangan;
    }
    return await AFdatabase.send(
      url: 'payroll',
      methodeRequest: MethodeRequest.post,
      body: body,
      contentIsJson: true,
    );
  }

  Future<Hasil> kunci(String id) async {
    return await AFdatabase.send(
      url: 'payroll/$id/kunci',
      methodeRequest: MethodeRequest.put,
    );
  }

}
