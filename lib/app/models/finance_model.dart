import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FinanceModel {
  String? idFinance;
  String description;
  String? date;
  String? type;
  String value;
  String? urlImage;
  FinanceModel({
    this.idFinance,
    required this.description,
    this.date,
    this.type,
    required this.value,
    this.urlImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idFinance': idFinance,
      'description': description,
      'date': date,
      'type': type,
      'value': value,
      'urlImage': urlImage,
    };
  }

  factory FinanceModel.fromMap(Map<String, dynamic> map) {
    return FinanceModel(
      idFinance: map['idFinance'] != null ? map['idFinance'] as String : null,
      description: map['description'] as String,
      date: map['date'] != null ? map['date'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      value: map['value'] as String,
      urlImage: map['urlImage'] != null ? map['urlImage'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FinanceModel.fromJson(String source) =>
      FinanceModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
