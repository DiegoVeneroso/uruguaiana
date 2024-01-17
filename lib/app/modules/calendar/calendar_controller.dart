import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends GetxController {
  Rx<DateTime> primeiroDia = DateTime.now().add(const Duration(days: -365)).obs;
  Rx<DateTime> ultimaDia = DateTime.now().add(const Duration(days: 365)).obs;
  Rx<DateTime> diaAtual = DateTime.now().obs;

  //Conteudo da agenda no dia selecionado
  RxList<String> agenda = <String>[].obs;

  //Formatação inicial do calendário - Visão semana
  CalendarFormat calendarFormat = CalendarFormat.month;

  //Tradução dos Textos do calendário
  String locale = 'pt_BR';

  @override
  void onInit() {
    //Parametros iniciais
    // primeiroDia = DateTime.now().add(const Duration(days: -365));
    // ultimaDia = DateTime.now().add(const Duration(days: 365));
    // diaAtual = DateTime.now();

    //Agenda do dia atual
    getProgramacaoDia(diaAtual.value);

    super.onInit();
  }

  //Busca a agendo do dia
  Future getProgramacaoDia(data) async {
    //Seta dia atual
    diaAtual.value = data;

    //busca dados da agenda
    getAgenda(data);

    //refresh ui
    // update(['calendario', 'agenda']);
  }

  //Dados Mock
  void getAgenda(DateTime data) {
    //reseta lista
    agenda.clear();

    //popula lista
    if (data.day == 27) {
      agenda.value = [
        '09:30 : Reunião com o fulano',
        '12:30 : Reunião com o fulano2',
        '20:30 : Reunião com o fulano3',
      ];
    } else if (data.day == 28) {
      agenda.value = [
        '08:45 : Passeio com o cachorro',
        '12:30 : Almoço de trabalho',
        '22:00 : Palestra noturna',
      ];
    }
  }
}
