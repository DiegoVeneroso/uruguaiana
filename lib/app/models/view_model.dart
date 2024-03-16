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
}
