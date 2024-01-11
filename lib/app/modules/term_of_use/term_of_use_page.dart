import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_appbar.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_button.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_floating_button.dart';
import 'package:eu_faco_parte/app/modules/term_of_use/term_of_use_controller.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_drawer.dart';
import '../../core/ui/widgets/custom_player_video.dart';
import '../../repository/auth_repository.dart';
import '../../routes/app_pages.dart';
import '../auth/login/login_controller.dart';

class TermOfUsePage extends GetView<TermOfUseController> {
  LoginController loginController = LoginController(AuthRepository());

  TermOfUsePage({super.key});

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
                color: Get.theme.colorScheme.onBackground,
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: AutoSizeText(
                    minFontSize: 10,
                    'TERMO DE USO',
                    style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.surface,
                        fontSize: 22),
                  ),
                ),
              ),
              Expanded(
                child: Obx(() => ListView.builder(
                      itemCount: controller.foundAbout.value.isEmpty ? 1 : 1,
                      itemBuilder: (context, index) {
                        if (controller.foundAbout.value.isEmpty) {
                          if (controller.isAdmin()) {
                            return Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      Get.theme.colorScheme.onPrimaryContainer,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 32.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Center(
                                          child: AutoSizeText(
                                            minFontSize: 10,
                                            'Sem informações!',
                                            style: Get.textTheme.titleLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Get.theme.colorScheme
                                                        .surface,
                                                    fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      CustomButton(
                                        label: 'CADASTRAR  "TERMO DE USO"',
                                        onPressed: () {
                                          Get.toNamed(Routes.term_of_use_add);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        } else {
                          return Column(
                            children: [
                              Visibility(
                                visible: controller.isAdmin(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.defaultDialog(
                                              titlePadding:
                                                  const EdgeInsets.only(
                                                      top: 10),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      top: 30, bottom: 20),
                                              title: 'ATENÇÃO',
                                              middleText:
                                                  'Deseja realmente excluir o termo?',
                                              backgroundColor: Get
                                                  .theme
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                              titleStyle: TextStyle(
                                                  color: Get.theme.colorScheme
                                                      .onSurface),
                                              middleTextStyle: TextStyle(
                                                  color: Get.theme.colorScheme
                                                      .onSurface),
                                              radius: 30,
                                              confirm: CustomButton(
                                                color: Get
                                                    .theme.colorScheme.onError,
                                                height: 40,
                                                width: 100,
                                                label: 'Excluir',
                                                onPressed: () async {
                                                  await controller
                                                      .termOfUseDelete(
                                                          controller
                                                              .termList[index]
                                                              .idTerm
                                                              .toString());
                                                },
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color:
                                                  Get.theme.colorScheme.primary,
                                            ),
                                            child: Icon(
                                              Icons.delete,
                                              color: Get
                                                  .theme.colorScheme.background,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.toNamed(Routes.term_of_use_edit,
                                                parameters: {
                                                  'idTerm': controller
                                                      .termList[index].idTerm
                                                      .toString(),
                                                  'description': controller
                                                      .termList[index]
                                                      .descripton
                                                      .toString(),
                                                });
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color:
                                                  Get.theme.colorScheme.primary,
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              color: Get
                                                  .theme.colorScheme.background,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            text: controller.foundAbout
                                                .value[index].descripton,
                                            style: TextStyle(
                                              color:
                                                  Get.theme.colorScheme.surface,
                                              fontSize: 16,
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
                          );
                        }
                        return null;
                      },
                    )),
              ),
            ],
          ),
          floatingActionButton: Obx(
            () => controller.isAdmin()
                ? const SizedBox()
                : CustomFloatingButton(),
          )),
    );
  }
}
