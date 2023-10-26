import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NotificationModel {
  String? idNotification;
  String title;
  String message;
  String? parameter;
  String? createdBy;
  String? dateTimeCreated;
  NotificationModel({
    this.idNotification,
    required this.title,
    required this.message,
    this.parameter,
    this.createdBy,
    this.dateTimeCreated,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idNotification': idNotification,
      'title': title,
      'message': message,
      'parameter': parameter,
      'createdBy': createdBy,
      'dateTimeCreated': dateTimeCreated,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      idNotification: map['idNotification'] != null
          ? map['idNotification'] as String
          : null,
      title: map['title'] as String,
      message: map['message'] as String,
      parameter: map['parameter'] != null ? map['parameter'] as String : null,
      createdBy: map['createdBy'] != null ? map['createdBy'] as String : null,
      dateTimeCreated: map['dateTimeCreated'] != null
          ? map['dateTimeCreated'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
