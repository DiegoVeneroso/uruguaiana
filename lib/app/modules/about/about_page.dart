import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_appbar.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_floating_button.dart';
import 'package:uruguaiana/app/modules/about/about_controller.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_drawer.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.foundAbout.value.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              width: double.infinity,
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    controller.foundAbout.value[index].urlImage
                                        .toString(),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [],
                              ),
                            ),
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
                                      text: controller
                                          .foundAbout.value[index].description,
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
                child: FloatingActionButton(
                  backgroundColor: Get.theme.colorScheme.primary,
                  onPressed: () {
                    Get.toNamed(Routes.about_add);
                  },
                  child: Icon(
                    Icons.add,
                    color: Get.theme.colorScheme.background,
                  ),
                ),
              )
            : const CustomFloatingButton(),
      ),
    );
  }
}
