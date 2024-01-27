// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eu_faco_parte/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:eu_faco_parte/app/modules/question/question_controller.dart';
import 'package:group_radio_button/group_radio_button.dart';

import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_button.dart';

class QuestionResponsePage extends StatefulWidget {
  const QuestionResponsePage({
    Key? key,
  }) : super(key: key);

  @override
  State<QuestionResponsePage> createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState
    extends AppState<QuestionResponsePage, QuestionController> {
  String? _verticalGroupValue;

  String? idQuestion = Get.parameters['id_question'];

  @override
  void initState() {
    super.initState();
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
        body: FutureBuilder(
            future: controller.getQuestions(idQuestion.toString()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: Center(
                  child: CircularProgressIndicator(),
                ));
              }
              String listString = snapshot.data!.data['list_options'];
              List<String> listOptions = listString
                  .replaceAll('[', '')
                  .replaceAll(']', '')
                  .replaceAll(' ', '')
                  .split(',')
                  .toList();
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Get.theme.colorScheme.surface),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                  child: AutoSizeText(
                                    minFontSize: 10,
                                    'ENQUETE',
                                    style: Get.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Get.theme.colorScheme.surface,
                                        fontSize: 24),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                          bottom: 10,
                                          top: 0,
                                        ),
                                        child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: '------',
                                                style: TextStyle(
                                                  color: Get.theme.colorScheme
                                                      .background,
                                                )),
                                            TextSpan(
                                              text: snapshot
                                                  .data!.data['question'],
                                              style: TextStyle(
                                                color: Get
                                                    .theme.colorScheme.surface,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ]),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 20),
                                child: Column(
                                  children: <Widget>[
                                    RadioGroup<String>.builder(
                                      groupValue:
                                          _verticalGroupValue.toString(),
                                      onChanged: (value) => setState(() {
                                        _verticalGroupValue = value ?? '';
                                      }),
                                      items: listOptions,
                                      itemBuilder: (item) {
                                        return RadioButtonBuilder(
                                          item,
                                        );
                                      },
                                      fillColor: Get
                                          .theme.colorScheme.primaryContainer,
                                      textStyle: TextStyle(
                                        color: Get
                                            .theme.colorScheme.primaryContainer,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: CustomButton(
                                  color: Get.theme.colorScheme.primaryContainer,
                                  width: double.infinity,
                                  label: 'RESPONDER',
                                  onPressed: () async {
                                    await controller.questionResponseAdd({
                                      'id_question': idQuestion,
                                      'response': _verticalGroupValue,
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: CustomButton(
                            color: Get.theme.colorScheme.error,
                            width: double.infinity,
                            label: 'NÃO PARTICIPAR',
                            onPressed: () {
                              Get.toNamed(Routes.splash);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
