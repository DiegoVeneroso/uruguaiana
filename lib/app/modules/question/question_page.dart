import 'package:eu_faco_parte/app/modules/question/question_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_appbar.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_searchformfield.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_drawer.dart';
import '../../core/ui/widgets/custom_floating_button.dart';
import '../../routes/app_pages.dart';
import 'package:auto_size_text/auto_size_text.dart';

class QuestionPage extends GetView<QuestionController> {
  const QuestionPage({super.key});

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
            IconButton(
              onPressed: () => controller.searchVisible.toggle(),
              icon: const Icon(Icons.search),
              color: Get.theme.colorScheme.background,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: AutoSizeText(
                    minFontSize: 10,
                    'ENQUETES',
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.surface,
                    ),
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: controller.searchVisible.value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: CustomSearchformfield(
                      onChanged: (value) =>
                          controller.filternotifications(value),
                      onPressed: () => controller.searchVisible.toggle(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(() => ListView.separated(
                      itemCount: controller.foundQuestion.value.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Get.toNamed(Routes.question_detail, parameters: {
                              'id_question': controller
                                  .foundQuestion.value[index].idQuestion
                                  .toString(),
                              'question': controller
                                  .foundQuestion.value[index].question
                                  .toString(),
                              'list_options': controller
                                  .foundQuestion.value[index].listOptions
                                  .toString()
                            });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          tileColor: Get.theme.colorScheme.primary,
                          textColor: Get.theme.colorScheme.onPrimaryContainer,
                          titleTextStyle: const TextStyle(fontSize: 16),
                          title: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 8.0,
                            ),
                            child: AutoSizeText(
                              minFontSize: 10,
                              controller.foundQuestion.value[index].question,
                              style: TextStyle(
                                color: Get.theme.colorScheme.onPrimaryContainer,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        );
                      },
                    )),
              ),
            ],
          ),
        ),
        floatingActionButton: Obx(
          () => controller.isAdmin()
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton.extended(
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Get.theme.colorScheme.background,
                          size: 25,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        AutoSizeText(
                          minFontSize: 10,
                          'Criar enquete',
                          style: TextStyle(
                              fontSize: 14,
                              color: Get.theme.colorScheme.background),
                        ),
                      ],
                    ),
                    backgroundColor: Get.theme.colorScheme.primary,
                    onPressed: () {
                      Get.toNamed(Routes.question_add);
                    },
                  ),
                )
              : CustomFloatingButton(),
        ),
      ),
    );
  }
}
