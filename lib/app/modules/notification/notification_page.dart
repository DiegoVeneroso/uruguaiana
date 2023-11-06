import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_appbar.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_searchformfield.dart';
import 'package:uruguaiana/app/modules/notification/notification_controller.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_drawer.dart';
import '../../core/ui/widgets/custom_floating_button.dart';
import '../../routes/app_pages.dart';
import 'package:auto_size_text/auto_size_text.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({super.key});

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
                child: AutoSizeText(
                  minFontSize: 10,
                  'Notificações enviadas',
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
                    onChanged: (value) => controller.filternotifications(value),
                    onPressed: () => controller.searchVisible.toggle(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() => ListView.separated(
                    itemCount: controller.foundNotification.value.length,
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
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            minFontSize: 10,
                            controller.foundNotification.value[index].title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Get.theme.colorScheme.onPrimaryContainer,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        subtitle: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              child: Row(
                                children: [
                                  AutoSizeText(
                                    minFontSize: 10,
                                    controller
                                        .foundNotification.value[index].message
                                        .toString(),
                                    style: TextStyle(
                                      color: Get
                                          .theme.colorScheme.onPrimaryContainer,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AutoSizeText(
                                    minFontSize: 10,
                                    DateFormat(
                                            DateFormat.ABBR_MONTH_DAY, 'pt_Br')
                                        .format(
                                      DateTime.parse(controller
                                          .foundNotification
                                          .value[index]
                                          .dateTimeCreated
                                          .toString()),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  AutoSizeText(
                                    minFontSize: 10,
                                    DateFormat(
                                            DateFormat.HOUR24_MINUTE, 'pt_Br')
                                        .format(
                                      DateTime.parse(controller
                                          .foundNotification
                                          .value[index]
                                          .dateTimeCreated
                                          .toString()),
                                    ),
                                  ),
                                ],
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
      floatingActionButton: Obx(
        () => controller.isAdmin()
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notification_add_outlined,
                        color: Get.theme.colorScheme.background,
                        size: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      AutoSizeText(
                        minFontSize: 10,
                        'Enviar notificação',
                        style: TextStyle(
                            fontSize: 14,
                            color: Get.theme.colorScheme.background),
                      ),
                    ],
                  ),
                  backgroundColor: Get.theme.colorScheme.primary,
                  onPressed: () {
                    Get.toNamed(Routes.notification_add);
                  },
                ),
              )
            : const CustomFloatingButton(),
      ),
    );
  }
}
