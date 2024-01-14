import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TokenDonateModel {
  String? idTokenDonate;
  String? parameter;
  String value;
  TokenDonateModel({
    this.idTokenDonate,
    this.parameter,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idTokenDonate': idTokenDonate,
      'parameter': parameter,
      'value': value,
    };
  }

  factory TokenDonateModel.fromMap(Map<String, dynamic> map) {
    return TokenDonateModel(
      idTokenDonate:
          map['idTokenDonate'] != null ? map['idTokenDonate'] as String : null,
      parameter: map['parameter'] != null ? map['parameter'] as String : null,
      value: map['value'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TokenDonateModel.fromJson(String source) =>
      TokenDonateModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
