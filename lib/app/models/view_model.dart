import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ViewModel {
  String? idView;
  String title;
  String description;
  String date;
  String nameUser;
  String phone;
  String bairro;
  String? urlImage;
  String? status;
  ViewModel({
    this.idView,
    required this.title,
    required this.description,
    required this.date,
    required this.nameUser,
    required this.phone,
    required this.bairro,
    this.urlImage,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idView': idView,
      'title': title,
      'description': description,
      'date': date,
      'nameUser': nameUser,
      'phone': phone,
      'bairro': bairro,
      'urlImage': urlImage,
      'status': status,
    };
  }

  factory ViewModel.fromMap(Map<String, dynamic> map) {
    return ViewModel(
      idView: map['idView'] != null ? map['idView'] as String : null,
      title: map['title'] as String,
      description: map['description'] as String,
      date: map['date'] as String,
      nameUser: map['nameUser'] as String,
      phone: map['phone'] as String,
      bairro: map['bairro'] as String,
      urlImage: map['urlImage'] != null ? map['urlImage'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ViewModel.fromJson(String source) =>
      ViewModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
