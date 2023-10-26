import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_appbar.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_searchformfield.dart';
import 'package:uruguaiana/app/modules/collaborate/collaborate_controller.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_drawer.dart';
import '../../repository/auth_repository.dart';
import '../auth/login/login_controller.dart';

class CollaboratePage extends GetView<CollaborateController> {
  LoginController loginController = LoginController(AuthRepository());

  CollaboratePage({super.key});

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
                child: Text(
                  'Colaborações',
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
                    onChanged: (value) => controller.filtercollaborates(value),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        tileColor: Get.theme.colorScheme.primary,
                        textColor: Get.theme.colorScheme.onPrimaryContainer,
                        iconColor: Get.theme.colorScheme.onPrimaryContainer,
                        titleTextStyle: const TextStyle(fontSize: 16),
                        subtitleTextStyle: const TextStyle(fontSize: 14),
                        leadingAndTrailingTextStyle:
                            const TextStyle(fontSize: 50),
                        title:
                            Text(controller.foundCollaborate.value[index].name),
                        subtitle: Row(
                          children: [
                            Text(
                              controller.foundCollaborate.value[index].phone
                                  .toString(),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
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
                            Text(
                              DateFormat(DateFormat.HOUR24_MINUTE, 'pt_Br')
                                  .format(
                                DateTime.parse(controller.foundCollaborate
                                    .value[index].dateTimeCreated
                                    .toString()),
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              Get.toNamed('/collaborate_detail', parameters: {
                                'idCollaborate': controller
                                    .collaborateList[index].idCollaborate
                                    .toString(),
                                'name': controller.collaborateList[index].name
                                    .toString(),
                                'phone': controller.collaborateList[index].phone
                                    .toString(),
                                'url_image': controller
                                    .collaborateList[index].urlImage
                                    .toString(),
                                'description': controller
                                    .collaborateList[index].description
                                    .toString(),
                                'date_time_created': controller
                                    .collaborateList[index].dateTimeCreated
                                    .toString(),
                              });
                            },
                            icon: const Icon(Icons.visibility)),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
