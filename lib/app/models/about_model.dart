import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AboutModel {
  String? idAbout;
  String title;
  String description;
  String? urlImage;
  AboutModel({
    this.idAbout,
    required this.title,
    required this.description,
    this.urlImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idAbout': idAbout,
      'title': title,
      'description': description,
      'urlImage': urlImage,
    };
  }

  factory AboutModel.fromMap(Map<String, dynamic> map) {
    return AboutModel(
      idAbout: map['idAbout'] != null ? map['idAbout'] as String : null,
      title: map['title'] as String,
      description: map['description'] as String,
      urlImage: map['urlImage'] != null ? map['urlImage'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AboutModel.fromJson(String source) =>
      AboutModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
