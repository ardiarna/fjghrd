import 'package:fjghrd/models/training.dart';
import 'package:fjghrd/utils/af_convert.dart';

class TrainingKaryawan {
  String id;
  String karyawanId;
  String trainingId;
  String? tanggal;
  String? keterangan;
  Training? training;

  TrainingKaryawan({
    this.id = '',
    this.karyawanId = '',
    this.trainingId = '',
    this.tanggal,
    this.keterangan,
    this.training,
  });

  factory TrainingKaryawan.fromMap(Map<String, dynamic> map) {
    return TrainingKaryawan(
      id: AFconvert.keString(map['id']),
      karyawanId: AFconvert.keString(map['karyawan_id']),
      trainingId: AFconvert.keString(map['training_id']),
      tanggal: map['tanggal'],
      keterangan: map['keterangan'],
      training: map['training'] != null ? Training.fromMap(map['training']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'karyawan_id': karyawanId,
      'training_id': trainingId,
      'tanggal': tanggal,
      'keterangan': keterangan,
    };
  }
}
