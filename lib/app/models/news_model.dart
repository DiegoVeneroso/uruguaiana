import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NewsModel {
  String? idNews;
  String title;
  String description;
  String? date;
  String urlImage;
  String? createBy;
  String? DateTimeCreateBy;
  String? updateBy;
  String? DateTimeUpadateBy;
  NewsModel({
    this.idNews,
    required this.title,
    required this.description,
    this.date,
    required this.urlImage,
    this.createBy,
    this.DateTimeCreateBy,
    this.updateBy,
    this.DateTimeUpadateBy,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idNews': idNews,
      'title': title,
      'description': description,
      'date': date,
      'urlImage': urlImage,
      'createBy': createBy,
      'DateTimeCreateBy': DateTimeCreateBy,
      'updateBy': updateBy,
      'DateTimeUpadateBy': DateTimeUpadateBy,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      idNews: map['idNews'] != null ? map['idNews'] as String : null,
      title: map['title'] as String,
      description: map['description'] as String,
      date: map['date'] != null ? map['date'] as String : null,
      urlImage: map['urlImage'] as String,
      createBy: map['createBy'] != null ? map['createBy'] as String : null,
      DateTimeCreateBy: map['DateTimeCreateBy'] != null
          ? map['DateTimeCreateBy'] as String
          : null,
      updateBy: map['updateBy'] != null ? map['updateBy'] as String : null,
      DateTimeUpadateBy: map['DateTimeUpadateBy'] != null
          ? map['DateTimeUpadateBy'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsModel.fromJson(String source) =>
      NewsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
