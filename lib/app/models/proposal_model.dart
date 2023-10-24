import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProposalModel {
  String? idProposal;
  String title;
  String url_image;

  ProposalModel({
    this.idProposal,
    required this.title,
    required this.url_image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idProposal': idProposal,
      'title': title,
      'url_image': url_image,
    };
  }

  factory ProposalModel.fromMap(Map<String, dynamic> map) {
    return ProposalModel(
      idProposal:
          map['idProposal'] != null ? map['idProposal'] as String : null,
      title: map['title'] as String,
      url_image: map['url_image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProposalModel.fromJson(String source) =>
      ProposalModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
