import 'package:fjghrd/utils/af_convert.dart';

class TarifEfektif {
  String id;
  String ter;
  int penghasilan;
  double persen;
  DateTime? createdAt;
  DateTime? updatedAt;

  TarifEfektif({
    this.id = '',
    this.ter = '',
    this.penghasilan = 0,
    this.persen = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory TarifEfektif.fromMap(Map<String, dynamic> data) {
    return TarifEfektif(
      id: AFconvert.keString(data['id']),
      ter: AFconvert.keString(data['ter']),
      penghasilan: AFconvert.keInt(data['penghasilan']),
      persen: AFconvert.keDouble(data['persen']),
      createdAt: AFconvert.keTanggal(data['created_at']),
      updatedAt: AFconvert.keTanggal(data['updated_at']),
    );
  }

  Map<String, String> toMap() {
    Map<String, String> data = {
      'id' : id,
      'ter' : ter,
      'penghasilan': AFconvert.keString(penghasilan),
      'persen': AFconvert.keString(persen),
    };
    return data;
  }

}
