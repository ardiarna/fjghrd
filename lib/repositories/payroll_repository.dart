import 'package:fjghrd/models/payroll.dart';
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
    required String tahun,
    required String bulan,
    required List<Map<String, dynamic>> payrolls,
    String keterangan = '',
  }) async {
    var body = {
      'tanggal_awal': tglAwal,
      'tanggal_akhir': tglAkhir,
      'tahun': tahun,
      'bulan': bulan,
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

  Future<Hasil> update({
    required String id,
    required String tglAwal,
    required String tglAkhir,
    required String tahun,
    required String bulan,
    String keterangan = '',
  }) async {
    var body = {
      'tanggal_awal': tglAwal,
      'tanggal_akhir': tglAkhir,
      'tahun': tahun,
      'bulan': bulan,
    };
    if(keterangan != '') {
      body['keterangan'] = keterangan;
    }
    return await AFdatabase.send(
      url: 'payroll/$id',
      methodeRequest: MethodeRequest.put,
      body: body,
    );
  }

  Future<Hasil> kunci(String id) async {
    return await AFdatabase.send(
      url: 'payroll/$id/kunci',
      methodeRequest: MethodeRequest.put,
    );
  }

  Future<Hasil> delete(String id) async {
    return await AFdatabase.send(
      url: 'payroll/$id',
      methodeRequest: MethodeRequest.delete,
    );
  }

  Future<Hasil> findDetail(String headerId) async {
    return await AFdatabase.send(
      url: 'payroll/$headerId/detil',
    );
  }

  Future<Hasil> updateDetail(Payroll payroll) async {
    return await AFdatabase.send(
      url: 'payroll/${payroll.headerId}/detil/${payroll.id}',
      methodeRequest: MethodeRequest.put,
      body: payroll.toMap(),
    );
  }

  Future<Hasil> reportRekap({required String tahun}) async {
    return await AFdatabase.send(
      url: 'payroll/report-rekap/$tahun',
    );
  }

}
