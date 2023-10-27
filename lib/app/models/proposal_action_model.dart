import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProposalActionModel {
  String? idProposalAction;
  String title;
  String description;
  String? urlImage;
  ProposalActionModel({
    this.idProposalAction,
    required this.title,
    required this.description,
    this.urlImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idProposalAction': idProposalAction,
      'title': title,
      'description': description,
      'urlImage': urlImage,
    };
  }

  factory ProposalActionModel.fromMap(Map<String, dynamic> map) {
    return ProposalActionModel(
      idProposalAction: map['idProposalAction'] != null
          ? map['idProposalAction'] as String
          : null,
      title: map['title'] as String,
      description: map['description'] as String,
      urlImage: map['urlImage'] != null ? map['urlImage'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProposalActionModel.fromJson(String source) =>
      ProposalActionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
