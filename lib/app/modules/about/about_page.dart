import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_appbar.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_button.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_floating_button.dart';
import 'package:uruguaiana/app/modules/about/about_controller.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_drawer.dart';
import '../../core/ui/widgets/custom_player_video.dart';
import '../../repository/auth_repository.dart';
import '../../routes/app_pages.dart';
import '../auth/login/login_controller.dart';

class AboutPage extends GetView<AboutController> {
  LoginController loginController = LoginController(AuthRepository());

  AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: AutoSizeText(
                  minFontSize: 10,
                  'QUEM SOMOS',
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
                        return Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Get.theme.colorScheme.onPrimaryContainer,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 32.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Center(
                                      child: AutoSizeText(
                                        minFontSize: 10,
                                        'Informações não cadastradas!',
                                        style: Get.textTheme.titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Get
                                                    .theme.colorScheme.surface,
                                                fontSize: 22),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  CustomButton(
                                    label: 'CADASTRAR  "QUEM SOMOS"',
                                    onPressed: () {
                                      Get.toNamed(Routes.about_add);
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            Visibility(
                              visible: controller.isAdmin(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32.0),
                                    child: CustomButton(
                                      label: 'ALTERAR',
                                      onPressed: () {
                                        Get.toNamed(Routes.about_edit);
                                      },
                                      height: 30,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            FutureBuilder(
                              future: controller.getVideoTypeFileUrl(controller
                                  .foundAbout.value.first.urlImage
                                  .toString()),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                    height: Get.size.height * 0.35,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Get.theme.colorScheme.primary,
                                      ),
                                      // borderRadius: BorderRadius.circular(10),
                                      color: Get
                                          .theme.colorScheme.onPrimaryContainer,
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Get.theme.colorScheme.primary,
                                      ),
                                    ),
                                  );
                                }

                                if (snapshot.data!['type'] == 'video') {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CustomPlayerVideo(
                                        videoUri: Uri.parse(controller
                                            .foundAbout.value.first.urlImage
                                            .toString()),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Container(
                                      height: Get.size.height * 0.35,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.symmetric(
                                          horizontal: BorderSide(
                                            color:
                                                Get.theme.colorScheme.primary,
                                            width: 1,
                                          ),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Get.theme.colorScheme.primary,
                                              blurRadius: 3.0,
                                              offset: const Offset(0.0, 0.5))
                                        ],
                                        image: DecorationImage(
                                          image: NetworkImage(controller
                                              .foundAbout.value.first.urlImage
                                              .toString()),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: controller
                                            .foundAbout.value[index].title,
                                        style: TextStyle(
                                          color: Get.theme.colorScheme.surface,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: controller.foundAbout.value[index]
                                            .description,
                                        style: TextStyle(
                                          color: Get.theme.colorScheme.surface,
                                          fontSize: 16,
                                        ),
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ),
                              ],
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
              : const CustomFloatingButton(),
        ));
  }
}
