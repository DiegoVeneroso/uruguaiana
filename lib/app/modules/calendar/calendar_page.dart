import 'package:eu_faco_parte/app/core/ui/widgets/custom_textformfield.dart';
import 'package:eu_faco_parte/app/modules/calendar/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_appbar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_button.dart';
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
          () => SingleChildScrollView(
            child: Column(
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
                    defaultTextStyle: TextStyle(
                        color: Get.theme.colorScheme.primary,
                        fontWeight: FontWeight.bold),
                    weekendTextStyle: TextStyle(
                        color: Get.theme.colorScheme.primary,
                        fontWeight: FontWeight.bold),
                    todayDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Get.theme.colorScheme.primary),
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
                    selectedDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Get.theme.colorScheme.primary,
                    ),
                  ),
                ),
                //lista de envetos
                Obx(() => controller.agenda.isEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: Get.theme.colorScheme.primary,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(controller.diaAtual.value),
                                style: TextStyle(
                                  color: Get.theme.colorScheme.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Get.defaultDialog(
                                  titlePadding: const EdgeInsets.only(top: 10),
                                  contentPadding: const EdgeInsets.only(
                                      top: 10, bottom: 20),
                                  title: 'AGENDAR VISITA!',
                                  titleStyle: TextStyle(
                                    color: Get.theme.colorScheme.onSurface,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(children: [
                                      Text(
                                        DateFormat('dd/MM/yyyy')
                                            .format(controller.diaAtual.value),
                                        style: TextStyle(
                                          color: Get.theme.colorScheme.primary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '09:00 às 11:00',
                                        style: TextStyle(
                                          color: Get.theme.colorScheme.primary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CustomTextformfield(
                                            label: 'Nome completo'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CustomTextformfield(
                                            label: 'Telefone'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CustomTextformfield(
                                          label: 'Endereço',
                                          maxlines: 2,
                                          cellMask: true,
                                        ),
                                      ),
                                    ]),
                                  ),
                                  radius: 30,
                                  confirm: CustomButton(
                                    color: Get.theme.colorScheme.onError,
                                    height: 40,
                                    width: Get.width * .4,
                                    label: 'VOLTAR',
                                    onPressed: () async {
                                      Get.back();
                                    },
                                  ),
                                  cancel: CustomButton(
                                    color: Get.theme.colorScheme.primary,
                                    height: 40,
                                    width: Get.width * .4,
                                    label: 'CADASTRAR',
                                    onPressed: () async {},
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Get.theme.colorScheme.surface),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    '09:00 às 11:00',
                                    style: TextStyle(
                                      color: Get
                                          .theme.colorScheme.onPrimaryContainer,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Get.theme.colorScheme.surface),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  '15:00 às 17:00',
                                  style: TextStyle(
                                    color: Get.theme.colorScheme.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Get.theme.colorScheme.surface),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  '18:00 às 20:00',
                                  style: TextStyle(
                                    color: Get.theme.colorScheme.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Get.theme.colorScheme.surface),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  '18:00 às 20:00',
                                  style: TextStyle(
                                    color: Get.theme.colorScheme.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Flexible(
                        flex: 2,
                        child: ListView.builder(
                          itemCount: controller.agenda.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Divider(
                                    color: Get.theme.colorScheme.primary,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    child: Text(
                                      DateFormat('dd/MM/yyyy')
                                          .format(controller.diaAtual.value),
                                      style: TextStyle(
                                        color: Get.theme.colorScheme.primary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Card(
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
                                  ),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                Card(
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
                                ),
                              ],
                            );
                          },
                        ),
                      )),
              ],
            ),
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
        border: Border.all(color: Get.theme.colorScheme.surface),
        shape: BoxShape.circle,
      ),
      child: Text(
        qtde.toString(),
        style: const TextStyle(
            color: Colors.green, fontSize: 8, fontWeight: FontWeight.bold),
      ),
    );
  }
}
