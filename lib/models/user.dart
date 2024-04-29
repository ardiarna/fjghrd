import 'package:fjghrd/utils/af_convert.dart';

class User {
  String id;
  String email;
  String password;
  String nama;
  String foto;
  String status;
  String tokenPush;
  String tokenJWT;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id = '',
    this.email = '',
    this.password = '',
    this.nama = '',
    this.foto = '',
    this.status = '',
    this.tokenPush = '',
    this.tokenJWT = '',
    this.createdAt,
    this.updatedAt,
  }) ;

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: AFconvert.keString(data['id']),
      email: AFconvert.keString(data['email']),
      nama: AFconvert.keString(data['nama']),
      foto: AFconvert.keString(data['foto']),
      status: AFconvert.keString(data['status']),
      tokenPush: AFconvert.keString(data['token_push']),
      createdAt: AFconvert.keTanggal(data['created_at']),
      updatedAt: AFconvert.keTanggal(data['updated_at']),
    );
  }

  Map<String, String> toMap(String passwordConfirmation) {
    Map<String, String> data = {
      'id': id,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'nama': nama,
      'status': status,
      'token_push': tokenPush,
    };
    return data;
  }

}
