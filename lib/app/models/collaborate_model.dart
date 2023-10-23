import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CollaborateModel {
  String? idCollaborate;
  String name;
  String? phone;
  String description;
  String urlImage;
  String? dateTimeCreated;
  CollaborateModel({
    this.idCollaborate,
    required this.name,
    this.phone,
    required this.description,
    required this.urlImage,
    this.dateTimeCreated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idCollaborate': idCollaborate,
      'name': name,
      'phone': phone,
      'description': description,
      'urlImage': urlImage,
      'dateTimeCreated': dateTimeCreated,
    };
  }

  factory CollaborateModel.fromMap(Map<String, dynamic> map) {
    return CollaborateModel(
      idCollaborate:
          map['idCollaborate'] != null ? map['idCollaborate'] as String : null,
      name: map['name'] as String,
      phone: map['phone'] != null ? map['phone'] as String : null,
      description: map['description'] as String,
      urlImage: map['urlImage'] as String,
      dateTimeCreated: map['dateTimeCreated'] != null
          ? map['dateTimeCreated'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CollaborateModel.fromJson(String source) =>
      CollaborateModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
