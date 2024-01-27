import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class QuestionModel {
  String? idQuestion;
  String question;
  String listOptions;
  QuestionModel({
    this.idQuestion,
    required this.question,
    required this.listOptions,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idQuestion': idQuestion,
      'question': question,
      'listOptions': listOptions,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      idQuestion:
          map['idQuestion'] != null ? map['idQuestion'] as String : null,
      question: map['question'] as String,
      listOptions: map['listOptions'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionModel.fromJson(String source) =>
      QuestionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
