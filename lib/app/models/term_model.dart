import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TermModel {
  String? idTerm;
  String descripton;
  TermModel({
    this.idTerm,
    required this.descripton,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idTerm': idTerm,
      'descripton': descripton,
    };
  }

  factory TermModel.fromMap(Map<String, dynamic> map) {
    return TermModel(
      idTerm: map['idTerm'] != null ? map['idTerm'] as String : null,
      descripton: map['descripton'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TermModel.fromJson(String source) =>
      TermModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
