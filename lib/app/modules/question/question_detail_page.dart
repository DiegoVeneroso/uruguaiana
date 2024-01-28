import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/modules/question/question_controller.dart';
import 'package:get_storage/get_storage.dart';
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

    List<String> intList = str
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(' ', '')
        .split(',')
        .toList();

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
        body: ListView.builder(
            itemCount: intList.length,
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                child: Column(children: [
                  Visibility(
                    visible: index == 0 ? true : false,
                    child: Padding(
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
                  ),
                  Visibility(
                    visible: index == 0 ? true : false,
                    child: Row(
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
                  ),
                  const SizedBox(
                    height: 10,
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
                                text: intList[index],
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
                        FutureBuilder(
                          future: controller.countResultQuestion(
                            idQuestion:
                                Get.parameters['id_question'].toString(),
                            response: intList[index],
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Get.theme.colorScheme.primary),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  text: TextSpan(
                                    text: snapshot.data!.toString(),
                                    style: TextStyle(
                                      color: Get
                                          .theme.colorScheme.onPrimaryContainer,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: index == intList.length - 1 ? true : false,
                    child: const SizedBox(
                      height: 45,
                    ),
                  ),
                  Visibility(
                    visible: index == intList.length - 1 ? true : false,
                    child: FutureBuilder(
                      future: controller.totalResultQuestion(
                        idQuestion: Get.parameters['id_question'].toString(),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Row(
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
                                    text: snapshot.data!.toString(),
                                    style: TextStyle(
                                      color: Get
                                          .theme.colorScheme.primaryContainer,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ]),
              );
            }),
      ),
    );
  }
}
