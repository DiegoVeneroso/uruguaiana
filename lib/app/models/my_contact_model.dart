import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MyContactModel {
  String name;
  String url;
  MyContactModel({
    required this.name,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'url': url,
    };
  }

  factory MyContactModel.fromMap(Map<String, dynamic> map) {
    return MyContactModel(
      name: map['name'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MyContactModel.fromJson(String source) =>
      MyContactModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
