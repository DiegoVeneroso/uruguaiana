import 'package:eu_faco_parte/app/modules/calendar/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_appbar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_drawer.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    CalendarController controller = CalendarController();

    return SafeArea(
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        drawer: CustomDrawer(),
        appBar: CustomAppbar(
          actionsList: [
            IconButton(
              onPressed: ThemeService().switchTheme,
              icon: const Icon(Icons.contrast),
              color: Get.theme.colorScheme.background,
            ),
          ],
        ),
        body: Obx(
          () => Column(
            children: [
              TableCalendar(
                firstDay: controller.primeiroDia.value,
                lastDay: controller.ultimaDia.value,
                focusedDay: controller.diaAtual.value,
                selectedDayPredicate: (day) =>
                    isSameDay(day, controller.diaAtual.value),
                onDaySelected: (dayInicio, dayFim) async {
                  controller.getProgramacaoDia(dayInicio);
                },
                locale: controller.locale,

                calendarBuilders:
                    CalendarBuilders(markerBuilder: ((context, day, int) {
                  return getWidgeCellmarker(day);
                })),

                //formatação do header mes e ano
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Get.theme.colorScheme.primary,
                  ),
                  titleTextFormatter: (day, locale) =>
                      DateFormat('MMMM yyyy', locale).format(day).capitalize!,
                ),

                //formatação do dia e mes
                calendarStyle: CalendarStyle(
                  defaultTextStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  weekendTextStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  todayDecoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.blue),
                  selectedTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        isSameDay(DateTime.now(), controller.diaAtual.value)
                            ? FontWeight.normal
                            : FontWeight.bold,
                    fontSize:
                        isSameDay(DateTime.now(), controller.diaAtual.value)
                            ? 16
                            : 14,
                  ),
                  selectedDecoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                ),
              ),
              Obx(() => controller.agenda.isEmpty
                  ? Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: const Column(
                        children: [Text('Nenhum agendamento')],
                      ),
                    )
                  : Flexible(
                      flex: 2,
                      child: ListView.builder(
                        itemCount: controller.agenda.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              title: Text(
                                controller.agenda[index],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  //marker dos eventos nos dias
  Widget getWidgeCellmarker(DateTime day) {
    var qtde = day.day % 2 == 0 ? 2 : 1;

    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.only(bottom: 4, left: 4),
      height: 18,
      width: 14,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (qtde == 1) ? Colors.deepOrangeAccent : Colors.green),
      child: Text(
        qtde.toString(),
        style: const TextStyle(color: Colors.white, fontSize: 8),
      ),
    );
  }
}
