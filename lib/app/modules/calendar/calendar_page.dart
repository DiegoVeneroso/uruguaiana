import 'package:eu_faco_parte/app/modules/calendar/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_appbar.dart';
import 'package:eu_faco_parte/app/modules/admin/admin_controller.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_drawer.dart';

class CalendarPage extends GetView<CalendarController> {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        body: _buildCalendar(),
      ),
    );
  }

  Widget _buildCalendar() {
    return GetBuilder<CalendarController>(
      id: 'calendario',
      builder: (context) {
        return Container(
          child: TableCalendar(
            firstDay: controller.primeiroDia,
            lastDay: controller.ultimaDia,
            focusedDay: controller.diaAtual,
            selectedDayPredicate: (day) => isSameDay(day, controller.diaAtual),
            onDaySelected: (dayInicio, dayFim) async {
              controller.getProgramacaoDia(dayInicio);
            },
            locale: controller.locale,
          ),
        );
      },
    );
  }
}
