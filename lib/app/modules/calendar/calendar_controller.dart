import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../repository/auth_repository.dart';

class CalendarController extends GetxController {
  late DateTime primeiroDia;
  late DateTime ultimaDia;
  late DateTime diaAtual;

  //Conteudo da agenda no dia selecionado
  List<String> agenda = [];

  //Formatação inicial do calendário - Visão semana
  CalendarFormat calendarFormat = CalendarFormat.month;

  //Tradução dos Textos do calendário
  String locale = 'pt_BR';

  @override
  void onInit() {
    //Parametros iniciais
    primeiroDia = DateTime.now().add(const Duration(days: -365));
    ultimaDia = DateTime.now().add(const Duration(days: 365));
    diaAtual = DateTime.now();

    //Agenda do dia atual
    getProgramacaoDia(diaAtual);

    super.onInit();
  }

  //Busca a agendo do dia
  Future getProgramacaoDia(data) async {
    //Seta dia atual
    diaAtual = data;

    //busca dados da agenda
    getAgenda(data);

    //refresh ui
    update(['calendario', 'agenda']);
  }

  //Dados Mock
  void getAgenda(DateTime data) {
    //reseta lista
    agenda.clear();

    //popula lista
    if (data.day == 27) {
      agenda = [
        '09:30 : Reunião com o fulano',
        '12:30 : Reunião com o fulano2',
        '20:30 : Reunião com o fulano3',
      ];
    } else if (data.day == 28) {
      agenda = [
        '08:45 : Passeio com o cachorro',
        '12:30 : Almoço de trabalho',
        '22:00 : Palestra noturna',
      ];
    }
  }
}
