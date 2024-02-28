import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/config/api_client.dart';
import '../../core/config/constants.dart' as constants;
import '../../core/mixins/loader_mixin.dart';
import '../../core/mixins/messages_mixin.dart';
import '../../models/event.dart';
import '../../repository/auth_repository.dart';
import '../../repository/calendar_repositories.dart';
import '../../routes/app_pages.dart';
import 'package:http/http.dart' as http;

class CalendarController extends GetxController
    with LoaderMixin, MessagesMixin {
  RealtimeSubscription? subscription;
  CalendarRepository repository;
  AuthRepository authRepository;
  final _loading = false.obs;
  final _message = Rxn<MessageModel>();

  RxMap<DateTime, List<Event>>? selectedEvents = RxMap({});
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  //Conteudo da agenda no dia selecionado
  RxList<String> agenda = <String>[].obs;

  //Formatação inicial do calendário - Visão semana
  CalendarFormat calendarFormat = CalendarFormat.month;

  //Tradução dos Textos do calendário
  String locale = 'pt_BR';

  GetStorage storage = GetStorage();
  RxBool isAdmin = false.obs;

  CalendarController({
    required this.repository,
    required this.authRepository,
  });

  @override
  void onInit() {
    getIsAdmin();
    loaderListener(_loading);
    messageListener(_message);

    super.onInit();
  }

  @override
  void onReady() {
    loadData();
    super.onReady();
  }

  List<Event> getEventsfromDay(DateTime date) {
    return selectedEvents?[date] ?? [];
  }

  void loadData() async {
    try {
      var result = await repository.loadDataRepository();

      String? datetime;
      List<Event> listEvent = [];

      for (var doc in result.documents) {
        datetime = doc.data['datetime'];

        for (var event in doc.data['event']) {
          listEvent.add(Event(title: event));
        }

        selectedEvents?.addEntries({
          DateTime.parse(datetime.toString()): listEvent,
        }.entries);

        listEvent = [];
      }
      // update();
    } catch (e) {
      _loading.toggle();
      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          message: 'Erro carregar dados!',
          type: MessageType.error,
        ),
      );
    }
  }

  void subscribe() {
    final realtime = Realtime(ApiClient.account.client);

    subscription = realtime.subscribe([
      'databases.${constants.DATABASE_ID}.collections.${constants.COLLETION_CALENDAR}.documents'
    ]);

    subscription!.stream.listen((data) {
      for (var ev in data.events) {
        switch (ev) {
          case "databases.*.collections.*.documents.*.create":
            loadData();
            break;
          case "databases.*.collections.*.documents.*.update":
            loadData();
            break;
          case "databases.*.collections.*.documents.*.delete":
            loadData();
            break;
          default:
            break;
        }
      }
    });
  }

  Future<void> eventAdd(Map map) async {
    try {
      _loading.toggle();

      await repository.eventAddRepository(map);

      await sendPushNotificationToAdmin(
          title: 'Novo visita registrada! 💪 👊 ',
          body:
              "${map['name']} para ${DateFormat(DateFormat.MONTH_DAY, 'pt_Br').format(
            DateTime.parse(map['datetime']),
          )}");

      await Future.delayed(const Duration(seconds: 1));
      _loading.toggle();
      Get.toNamed(Routes.calendar);
      _message(
        MessageModel(
          title: 'Parabéns!',
          message:
              'Visita agendada com sucesso!\nEntraremos em contato em breve.',
          type: MessageType.success,
        ),
      );
    } catch (e) {
      log(e.toString());

      _message(
        MessageModel(
          title: 'ATENÇÃO!',
          message: e.toString(),
          type: MessageType.error,
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      _loading.toggle();
      Get.offAndToNamed(Routes.calendar);
    }
  }

  Future<String> getTokenIsAdmin() async {
    try {
      var res = await authRepository.getTokenAdminUserRepository();
      String token = res.documents.first.data['token_push'];

      return token;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<bool> sendPushNotificationToAdmin(
      {required String title, required String body}) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      // "to":
      //     "eTyvEVg8QDuE8ts3_UMNMi:APA91bHVYPFwfEqU4l2qepd4In01F5mROWmZjDV0eEW8mwaVMaUOEOTJuI9h8xQAfGydwmDGPuPSpJiPd69lBE-8JnaDsGrbud6cn8BzdDv5uQk6Om6a6YqBzDH2UJR1IKZ15lUeuT-s",
      "to": await getTokenIsAdmin(),
      "notification": {
        "title": title,
        "body": body,
        "screen": "/calendar",
      },
      "data": {
        "title": title,
        "body": body,
        "screen": "/calendar",
        // "click_action": 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'key=AAAANQf4ge4:APA91bE-LywHQosV6dq1l8cbYjthVP85bTXo5kAokzK8jXOqchENT9VUIoFqFssRpgX5IIDpxiVbPaQLhBltG5EWs3mgbbemOAYpvx4Sk06lidPskgj20-K-B0PlWEnnoBtBnUqSrBCj',
    };

    final response = await http.post(
      Uri.parse(postUrl),
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      log('notificação enviada!');

      return true;
    } else {
      return false;
    }
  }

  Future<void> getIsAdmin() async {
    try {
      var idUser = await storage.read('id_user');

      log('iduser');
      log(idUser);

      if (idUser == '' || idUser == null) {
        isAdmin.value = false;
      } else {
        var user = await authRepository.getUserById(idUser);

        if (user.profile == 'Administrador') {
          isAdmin.value = true;
        } else {
          isAdmin.value = false;
        }
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
