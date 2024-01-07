import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_appbar.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_searchformfield.dart';

import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_drawer.dart';
import '../../repository/auth_repository.dart';
import '../auth/login/login_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'my_colaborate_controller.dart';

class MyColaboratePage extends GetView<MyCollaborateController> {
  LoginController loginController = LoginController(AuthRepository());

  MyColaboratePage({super.key});

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
            IconButton(
              onPressed: () => controller.searchVisible.toggle(),
              icon: const Icon(Icons.search),
              color: Get.theme.colorScheme.onBackground,
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
                  // child: Text(
                  //   GetStorage().read('my_collaborates_list'),
                  // ),
                  child: AutoSizeText(
                    minFontSize: 10,
                    'MINHAS COLABORAÇÕES',
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.surface,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => Visibility(
                  visible: controller.searchVisible.value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: CustomSearchformfield(
                      onChanged: (value) =>
                          controller.filtercollaborates(value),
                      onPressed: () => controller.searchVisible.toggle(),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(() => ListView.separated(
                      itemCount: controller.foundCollaborate.value.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Get.toNamed(
                              'my_collaborate_detail',
                              parameters: {
                                'idMyCollaborate': controller
                                    .mycollaborateList[index].idCollaborate
                                    .toString(),
                                'name': controller.mycollaborateList[index].name
                                    .toString(),
                                'phone': controller
                                    .mycollaborateList[index].phone
                                    .toString(),
                                'url_image': controller
                                    .mycollaborateList[index].urlImage
                                    .toString(),
                                'description': controller
                                    .mycollaborateList[index].description
                                    .toString(),
                                'date_time_created': controller
                                    .mycollaborateList[index].dateTimeCreated
                                    .toString(),
                              },
                            );
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: Get.theme.colorScheme.primary,
                          textColor: Get.theme.colorScheme.onPrimaryContainer,
                          iconColor: Get.theme.colorScheme.onPrimaryContainer,
                          titleTextStyle: const TextStyle(fontSize: 16),
                          subtitleTextStyle: const TextStyle(fontSize: 14),
                          leadingAndTrailingTextStyle:
                              const TextStyle(fontSize: 50),
                          title: AutoSizeText(
                              minFontSize: 10,
                              controller.foundCollaborate.value[index].name),
                          subtitle: Row(
                            children: [
                              AutoSizeText(
                                minFontSize: 10,
                                controller.foundCollaborate.value[index].phone
                                    .toString(),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              AutoSizeText(
                                minFontSize: 10,
                                DateFormat(DateFormat.ABBR_MONTH_DAY, 'pt_Br')
                                    .format(
                                  DateTime.parse(controller.foundCollaborate
                                      .value[index].dateTimeCreated
                                      .toString()),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              AutoSizeText(
                                minFontSize: 10,
                                DateFormat(DateFormat.HOUR24_MINUTE, 'pt_Br')
                                    .format(
                                  DateTime.parse(controller.foundCollaborate
                                      .value[index].dateTimeCreated
                                      .toString()),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
