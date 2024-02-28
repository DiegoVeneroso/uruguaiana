// import 'package:calendar/event.dart';
// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_appbar.dart';
import 'package:eu_faco_parte/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/config/api_client.dart';
import '../../models/event.dart';
import '../../repository/auth_repository.dart';
import '../../repository/calendar_repositories.dart';
import 'calendar_controller.dart';
import '../../core/config/constants.dart' as constants;

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  RxMap<DateTime, List<Event>>? selectedEvents = RxMap({});
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  final TextEditingController _eventController = TextEditingController();

  RealtimeSubscription? subscription;

  GetStorage storage = GetStorage();
  RxBool isAdmin = false.obs;

  AuthRepository authRepository = AuthRepository();

  @override
  void initState() {
    getIsAdmin();
    loadEvents();
    subscribe();
    super.initState();
  }

  loadEvents() async {
    var response = await ApiClient.databases.listDocuments(
      databaseId: constants.DATABASE_ID,
      collectionId: constants.COLLETION_CALENDAR,
    );
    String? datetime;
    List<Event> listEvent = [];

    for (var doc in response.documents) {
      datetime = doc.data['datetime'];

      for (var event in doc.data['event']) {
        listEvent.add(Event(title: event));
      }

      selectedEvents?.addEntries({
        DateTime.parse(datetime.toString()): listEvent,
      }.entries);

      listEvent = [];
    }
    setState(() {});
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents?[date] ?? [];
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
            loadEvents();
            // setState(() {});
            break;
          case "databases.*.collections.*.documents.*.update":
            loadEvents();
            // setState(() {});
            break;
          case "databases.*.collections.*.documents.*.delete":
            loadEvents();
            // setState(() {});
            break;
          default:
            break;
        }
      }
    });
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
          setState(() {});
        } else {
          isAdmin.value = false;
          setState(() {});
        }
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CalendarController controller = CalendarController(
      repository: CalendarRepository(),
      authRepository: AuthRepository(),
    );
    return Scaffold(
      appBar: CustomAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 5),
              child: Center(
                child: AutoSizeText(
                  minFontSize: 10,
                  'AGENDAR VISITA',
                  style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.surface,
                      fontSize: 22),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Get.theme.colorScheme.primary,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Get.theme.colorScheme.shadow,
                      offset: const Offset(3.0, 8.0),
                      blurRadius: 10.0,
                    )
                  ],
                  color: Get.theme.colorScheme.background,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    focusedDay: selectedDay,
                    firstDay: DateTime(1990),
                    lastDay: DateTime(2050),
                    locale: controller.locale,
                    rowHeight: 43,
                    availableGestures: AvailableGestures.all,
                    calendarFormat: format,
                    onFormatChanged: (CalendarFormat format) {
                      setState(() {
                        format = format;
                      });
                    },
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    daysOfWeekVisible: true,

                    //Day Changed
                    onDaySelected: (DateTime selectDay, DateTime focusDay) {
                      setState(() {
                        selectedDay = selectDay;
                        focusedDay = focusDay;
                      });
                    },
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(selectedDay, date);
                    },

                    eventLoader: _getEventsfromDay,

                    calendarStyle: CalendarStyle(
                      markerDecoration: BoxDecoration(
                        color: Get.theme.colorScheme.tertiary,
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: TextStyle(
                        color: Get.theme.colorScheme.primary,
                      ),
                      weekendTextStyle: TextStyle(
                          color: Get.theme.colorScheme.primary,
                          fontWeight: FontWeight.bold),
                      isTodayHighlighted: true,
                      selectedDecoration: BoxDecoration(
                        color: Get.theme.colorScheme.primary,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      selectedTextStyle: const TextStyle(color: Colors.white),
                      todayDecoration: BoxDecoration(
                        color: const Color.fromARGB(255, 246, 212, 161),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      defaultDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      weekendDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.primary,
                      ),
                      // titleTextFormatter: (day, locale) =>
                      //     DateFormat('MMMM yyyy', locale).format(day).capitalize!,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 5.0),
              child: Center(
                child: AutoSizeText(
                  minFontSize: 10,
                  'Visitas de ${DateFormat(DateFormat.MONTH_DAY, 'pt_Br').format(
                    DateTime.parse(selectedDay.toString()),
                  )}',
                  style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.surface,
                      fontSize: 20),
                ),
              ),
            ),
            _getEventsfromDay(selectedDay).isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Nenhuma vista agendada para este dia",
                          style: TextStyle(
                              fontSize: 16,
                              color: Get.theme.colorScheme.primary),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            ..._getEventsfromDay(selectedDay).map((Event event) {
              List<String> eventPart = event.title.split('|');

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Get.theme.colorScheme.primary,
                              style: BorderStyle.solid,
                              width: 1.0,
                            ),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 8.0),
                                child: Text(
                                  eventPart[0],
                                  style: TextStyle(
                                    color: Get.theme.colorScheme.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: SingleChildScrollView(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            eventPart[1],
                                            style: TextStyle(
                                                color: Get
                                                    .theme.colorScheme.primary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            eventPart[3],
                                            style: TextStyle(
                                              color:
                                                  Get.theme.colorScheme.primary,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            eventPart[2],
                                            style: TextStyle(
                                              color:
                                                  Get.theme.colorScheme.primary,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Obx(
                                () => isAdmin()
                                    ? Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Uri url = Uri.parse(
                                                'https://wa.me/55${eventPart[2]}');
                                            launchUrl(url);
                                          },
                                          child: Icon(
                                            FontAwesomeIcons.whatsapp,
                                            color:
                                                Get.theme.colorScheme.tertiary,
                                            size: 30,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(Routes.calendar_add, parameters: {
            'date': selectedDay.toString(),
          });
        },
        label: Row(
          children: [
            const Icon(Icons.calendar_today_sharp),
            const SizedBox(
              width: 10,
            ),
            Column(children: [
              const Text('Agendar para'),
              Text(DateFormat(DateFormat.MONTH_DAY, 'pt_Br').format(
                DateTime.parse(selectedDay.toString()),
              )),
            ]),
          ],
        ),
      ),
    );
  }
}
