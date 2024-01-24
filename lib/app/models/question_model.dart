import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class QuestionModel {
  String? idQuestion;
  String question;
  String option1;
  String option2;
  String? option3;
  String? option4;
  String? option5;
  QuestionModel({
    this.idQuestion,
    required this.question,
    required this.option1,
    required this.option2,
    this.option3,
    this.option4,
    this.option5,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idQuestion': idQuestion,
      'question': question,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
      'option5': option5,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      idQuestion:
          map['idQuestion'] != null ? map['idQuestion'] as String : null,
      question: map['question'] as String,
      option1: map['option1'] as String,
      option2: map['option2'] as String,
      option3: map['option3'] != null ? map['option3'] as String : null,
      option4: map['option4'] != null ? map['option4'] as String : null,
      option5: map['option5'] != null ? map['option5'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionModel.fromJson(String source) =>
      QuestionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
