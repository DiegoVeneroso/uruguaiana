import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import 'package:uruguaiana/app/core/config/api_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uruguaiana/app/models/user_model.dart';
import '../core/config/constants.dart' as constants;

class AuthRepository {
  User? _current;
  User? get current => _current;

  Session? _session;
  Session? get session => _session;

  register(Map map) async {
    try {
      final result = await ApiClient.account.create(
        userId: ID.unique(),
        email: map["email"],
        password: map["password"],
        name: map["name"],
      );
      _current = result;

      var id = result.$id;

      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      var token = await firebaseMessaging.getToken();
      print('token');
      print(token);

      await ApiClient.databases.createDocument(
          databaseId: constants.DATABASE_ID,
          collectionId: constants.COLLETION_USERS_ID,
          documentId: ID.unique(),
          data: {
            'user_id': id,
            'name': map["name"],
            'email': map["email"],
            'phone': map["phone"],
            'profile': map["profile"],
            'url_avatar': map["url_avatar"],
            'token_push': token,
          });

      log('Usuario cadastrado com sucesso!');
    } on AppwriteException catch (e) {
      log(e.response['type']);

      throw (e.response['type']);
    }
  }

  login(Map map) async {
    try {
      _session = await ApiClient.account.createEmailSession(
        email: map["email"],
        password: map["password"],
      );
      return _session;
    } on AppwriteException catch (e) {
      _session = null;
      log(e.response['type']);

      throw (e.response['type']);
    } catch (e) {
      _session = null;
      log(e.toString());
      throw (e.toString());
    }
  }

  logout() async {
    try {
      await ApiClient.account.deleteSession(sessionId: 'current');
    } on AppwriteException {
      print('erro no repo');
      rethrow;
    }
  }

  recoveryPassword(String email) async {
    try {
      await ApiClient.account.createRecovery(
        email: email,
        url: 'http://frontapp.com.br:8080',
        // url: 'https://uruguaiana-91d45.web.app/'
      );
      print('email de recuperação de senha enviado!');
    } on AppwriteException catch (e) {
      print('erro no envio do email de recuperação de senha');
      throw (e.type.toString());
    }
  }

  Future<UserModel> getUserById(String idUser) async {
    try {
      var result = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_USERS_ID,
        queries: [Query.equal("user_id", idUser)],
      );

      var user = result.documents.first.data;

      return UserModel(
        name: user['name'],
        email: user['email'],
        id: user['user_id'],
        urlAvatar: user['url_avatar'],
        profile: user['profile'],
      );
    } on AppwriteException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<DocumentList> getContactFacebookRepository() async {
    try {
      var result = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_CONTACT,
        queries: [Query.equal("name", 'facebook')],
      );

      return result;
    } on AppwriteException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<DocumentList> getContactInstagramRepository() async {
    try {
      var result = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_CONTACT,
        queries: [Query.equal("name", 'instagram')],
      );

      return result;
    } on AppwriteException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<DocumentList> getContactWhatsappRepository() async {
    try {
      var result = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_CONTACT,
        queries: [Query.equal("name", 'whatsapp')],
      );

      return result;
    } on AppwriteException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<String> getProfileRepository(String idUser) async {
    try {
      var result = await ApiClient.databases.listDocuments(
        databaseId: constants.DATABASE_ID,
        collectionId: constants.COLLETION_USERS_ID,
        queries: [Query.equal("user_id", idUser)],
      );

      var profile = result.documents.first.data['profile'];

      return profile;
    } on AppwriteException catch (e) {
      print(e);
      rethrow;
    }
  }
}
