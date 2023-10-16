import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String? id;
  final String name;
  final String email;
  final String? phone;
  final String? urlAvatar;
  final String? tokenPush;
  final String? profile;
  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.urlAvatar,
    this.tokenPush,
    this.profile,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'urlAvatar': urlAvatar,
      'tokenPush': tokenPush,
      'profile': profile,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] != null ? map['phone'] as String : null,
      urlAvatar: map['urlAvatar'] != null ? map['urlAvatar'] as String : null,
      tokenPush: map['tokenPush'] != null ? map['tokenPush'] as String : null,
      profile: map['profile'] != null ? map['profile'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
