import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/modules/question/question_controller.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';

class QuestionDetailPage extends StatefulWidget {
  const QuestionDetailPage({Key? key}) : super(key: key);

  @override
  State<QuestionDetailPage> createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState
    extends AppState<QuestionDetailPage, QuestionController> {
  @override
  Widget build(BuildContext context) {
    // final List<String> finalList = List<String>.from(
    //     json.decode(Get.parameters['list_options'].toString()));

    print(Get.parameters['list_options']);

    String str = Get.parameters['list_options'].toString();

    List<String> intList =
        str.replaceAll('[', '').replaceAll(']', '').split(',');

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
        body: SingleChildScrollView(
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
                    'RESULTADO',
                    style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.surface,
                        fontSize: 26),
                  ),
                ),
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
                          left: 16.0,
                          right: 16.0,
                          bottom: 20,
                          top: 10,
                        ),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: '------',
                                style: TextStyle(
                                  color: Get.theme.colorScheme.background,
                                )),
                            TextSpan(
                              text: Get.parameters['question'].toString(),
                              style: TextStyle(
                                color: Get.theme.colorScheme.surface,
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
              Visibility(
                visible: intList[0] == ' ' ? false : true,
                child: const SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                visible: intList[0] == ' ' ? false : true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              text: intList[0],
                              style: TextStyle(
                                color: Get.theme.colorScheme.surface,
                                fontSize: 18,
                              ),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Get.theme.colorScheme.primary),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              text: '253',
                              style: TextStyle(
                                color: Get.theme.colorScheme.onPrimaryContainer,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: intList[1] == ' ' ? false : true,
                child: const SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                visible: intList[1] == ' ' ? false : true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              text: intList[1],
                              style: TextStyle(
                                color: Get.theme.colorScheme.surface,
                                fontSize: 18,
                              ),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Get.theme.colorScheme.primary),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              text: '253',
                              style: TextStyle(
                                color: Get.theme.colorScheme.onPrimaryContainer,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: intList[2] == ' ' ? false : true,
                child: const SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                visible: intList[2] == ' ' ? false : true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              text: intList[2],
                              style: TextStyle(
                                color: Get.theme.colorScheme.surface,
                                fontSize: 18,
                              ),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Get.theme.colorScheme.primary),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              text: '253',
                              style: TextStyle(
                                color: Get.theme.colorScheme.onPrimaryContainer,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: intList[3] == ' ' ? false : true,
                child: const SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                visible: intList[3] == ' ' ? false : true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              text: intList[3],
                              style: TextStyle(
                                color: Get.theme.colorScheme.surface,
                                fontSize: 18,
                              ),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Get.theme.colorScheme.primary),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              text: '253',
                              style: TextStyle(
                                color: Get.theme.colorScheme.onPrimaryContainer,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: intList[4] == ' ' ? false : true,
                child: const SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                visible: intList[4] == ' ' ? false : true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            text: intList[4],
                            style: TextStyle(
                              color: Get.theme.colorScheme.surface,
                              fontSize: 18,
                            ),
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Get.theme.colorScheme.primary),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            text: '2534',
                            style: TextStyle(
                              color: Get.theme.colorScheme.onPrimaryContainer,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            text: 'TOTAL',
                            style: TextStyle(
                              color: Get.theme.colorScheme.surface,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Get.theme.colorScheme.background),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RichText(
                          text: TextSpan(
                            text: '253',
                            style: TextStyle(
                              color: Get.theme.colorScheme.primaryContainer,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
