import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class JobsModel {
  String? idJob;
  String name;
  String phone;
  String address;
  String cpf;
  String rg;
  String old;
  String dateInitJob;
  String urlAvatar;
  String urlDocument;
  String pix;
  String? function;
  JobsModel(
      {this.idJob,
      required this.name,
      required this.phone,
      required this.address,
      required this.cpf,
      required this.rg,
      required this.old,
      required this.dateInitJob,
      required this.urlAvatar,
      required this.urlDocument,
      required this.pix,
      this.function});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idJob': idJob,
      'name': name,
      'phone': phone,
      'address': address,
      'cpf': cpf,
      'rg': rg,
      'old': old,
      'dateInitJob': dateInitJob,
      'urlAvatar': urlAvatar,
      'urlDocument': urlDocument,
      'pix': pix,
      'function': function,
    };
  }

  factory JobsModel.fromMap(Map<String, dynamic> map) {
    return JobsModel(
      idJob: map['idJob'] != null ? map['idJob'] as String : null,
      name: map['name'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
      cpf: map['cpf'] as String,
      rg: map['rg'] as String,
      old: map['old'] as String,
      dateInitJob: map['dateInitJob'] as String,
      urlAvatar: map['urlAvatar'] as String,
      urlDocument: map['urlDocument'] as String,
      pix: map['pix'] as String,
      function: map['function'] != null ? map['function'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory JobsModel.fromJson(String source) =>
      JobsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
