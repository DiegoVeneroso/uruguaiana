import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_textformfield.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'calendar_controller.dart';

class CalendarAddPage extends StatefulWidget {
  const CalendarAddPage({Key? key}) : super(key: key);

  @override
  State<CalendarAddPage> createState() => _NewsAddPageState();
}

class _NewsAddPageState extends AppState<CalendarAddPage, CalendarController> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _foneEC = TextEditingController();
  final _addressEC = TextEditingController();
  String? valueSelectedPeriod;
  final List<String> listPeriod = [
    'Manhã',
    'Tarde',
    'Noite',
  ];

  @override
  void dispose() {
    _nameEC.dispose();
    _foneEC.dispose();
    _addressEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        appBar: CustomAppbar(
          actionsList: [
            IconButton(
              onPressed: ThemeService().switchTheme,
              icon: const Icon(Icons.contrast),
              color: Get.theme.colorScheme.background,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: AutoSizeText(
                        minFontSize: 10,
                        'AGENDAR VISITA',
                        style: Get.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 27.0, vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          'Data:',
                          style: TextStyle(
                              color: Get.theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br').format(
                            DateTime.parse(Get.parameters['date'].toString()),
                          ),
                          style: TextStyle(
                              color: Get.theme.colorScheme.primary,
                              fontSize: 18),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField2(
                    style: TextStyle(
                        color: Get.theme.colorScheme.primary,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      isDense: true,
                      labelStyle: TextStyle(
                          color: Get.theme.colorScheme.primary,
                          fontWeight: FontWeight.bold),
                      errorStyle: const TextStyle(
                          color: Colors.redAccent, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23),
                        borderSide:
                            BorderSide(color: Get.theme.colorScheme.primary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23),
                        borderSide:
                            BorderSide(color: Get.theme.colorScheme.primary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23),
                        borderSide:
                            BorderSide(color: Get.theme.colorScheme.primary),
                      ),
                      filled: true,
                      fillColor: Get.theme.colorScheme.background,
                    ),
                    isExpanded: true,
                    hint: Text(
                      'Selecione o turno',
                      style: TextStyle(
                        fontSize: 16,
                        color: Get.theme.colorScheme.primary,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Get.theme.colorScheme.primary,
                    ),
                    iconSize: 30,
                    buttonHeight: 22,
                    buttonPadding: const EdgeInsets.only(left: 0, right: 10),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(23),
                    ),
                    items: listPeriod
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione a o turno';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      valueSelectedPeriod = value.toString();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Nome completo',
                    controller: _nameEC,
                    validator:
                        Validatorless.required('Nome completo é obrigatório'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Telefone',
                    controller: _foneEC,
                    validator: Validatorless.required('Telefone é obrigatório'),
                    cellMask: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Endereço',
                    controller: _addressEC,
                    validator: Validatorless.required('Endereço é obrigatório'),
                    maxlines: 2,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: CustomButton(
                      color: Get.theme.colorScheme.primaryContainer,
                      width: double.infinity,
                      label: 'AGENDAR',
                      onPressed: () {
                        final formValid =
                            _formKey.currentState?.validate() ?? false;

                        if (formValid) {
                          controller.eventAdd({
                            'datetime': Get.parameters['date'],
                            'name': _nameEC.text,
                            'event':
                                "$valueSelectedPeriod|${_nameEC.text}|${_foneEC.text}|${_addressEC.text}"
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
