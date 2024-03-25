// ignore_for_file: deprecated_member_use

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:eu_faco_parte/app/modules/view_peaple/view_peaple_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_appbar.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_searchformfield.dart';
import 'package:read_more_text/read_more_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_drawer.dart';
import '../../core/ui/widgets/custom_view_responsive_card.dart';
import '../../repository/auth_repository.dart';
import '../auth/login/login_controller.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AdminViewPeaplePage extends GetView<ViewPeapleController> {
  LoginController loginController = LoginController(AuthRepository());

  AdminViewPeaplePage({super.key});

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
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: AutoSizeText(
                  minFontSize: 10,
                  'APROVAR CADASTRO DE VISÃO',
                  style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.surface,
                      fontSize: 22),
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: controller.searchVisible.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 10.0),
                  child: CustomSearchformfield(
                    onChanged: (value) => controller.filterNews(value),
                    onPressed: () => controller.searchVisible.toggle(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.adminFoundNews.value.length,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        CustomViewResponsiveCard(
                          elevation: 5, //elevation
                          titleGap: 5, // gap between title and leading
                          bgColor: Colors.white,
                          borderColor: Get.theme.colorScheme.primary,
                          shadowColor: Get.theme.colorScheme
                              .shadow, // card background color
                          screenWidth:
                              600, // After this range of screen width it will work as a listtile
                          title: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Nome: ${controller.adminViewsList[index].nameUser}',
                                  style: TextStyle(
                                      color: Get.theme.colorScheme.primary,
                                      fontSize: 12),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Telefone: ${controller.adminViewsList[index].phone}',
                                  style: TextStyle(
                                      color: Get.theme.colorScheme.primary,
                                      fontSize: 12),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Bairro: ${toBeginningOfSentenceCase(controller.adminViewsList[index].bairro).toString()}',
                                  style: TextStyle(
                                      color: Get.theme.colorScheme.primary,
                                      fontSize: 12),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  controller.adminViewsList[index].date,
                                  style: TextStyle(
                                      color: Get.theme.colorScheme.primary,
                                      fontSize: 12),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: Text(
                                    toBeginningOfSentenceCase(controller
                                            .adminViewsList[index].title)
                                        .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Get.theme.colorScheme.primary,
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subTitle: ReadMoreText(
                            toBeginningOfSentenceCase(controller
                                    .adminViewsList[index].description)
                                .toString(),
                            numLines: 2,
                            readMoreText: 'Ler mais',
                            readLessText: 'Ler menos',
                            readMoreTextStyle: TextStyle(
                                color: Get.theme.colorScheme.primary,
                                fontWeight: FontWeight.bold),
                            readMoreIconColor: Get.theme.colorScheme.primary,
                            style: TextStyle(
                                color: Get.theme.colorScheme.primary,
                                fontSize: 14),
                          ),

                          leading: GestureDetector(
                            onTap: () {
                              final imageProvider = Image.network(controller
                                      .adminViewsList[index].urlImage
                                      .toString())
                                  .image;
                              showImageViewer(context, imageProvider,
                                  onViewerDismissed: () {
                                print("dismissed");
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                controller.adminViewsList[index].urlImage
                                    .toString(),
                                fit: BoxFit.cover,
                                width: context.width,
                                height: context.height * 0.3,
                                frameBuilder: (context, child, frame,
                                    wasSynchronouslyLoaded) {
                                  return child;
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: context.width,
                                        height: context.height * 0.3,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color:
                                                Get.theme.colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          action: Positioned(
                            // You can use any kind of widget here
                            right: 5,
                            top: 5,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    controller.getDialog(
                                      idView: controller
                                          .adminViewsList[index].idView
                                          .toString(),
                                      name: controller
                                          .adminViewsList[index].nameUser
                                          .toString(),
                                      title: 'Atenção!',
                                      message:
                                          'Deseja aprovar a publicação de\n${controller.adminViewsList[index].nameUser.toString()}',
                                      label: 'Aprovar',
                                      onPressed: () {
                                        controller.setAprovedViewPeaple({
                                          "idView": controller
                                              .adminViewsList[index].idView
                                              .toString()
                                        });
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 100,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Get.theme.colorScheme.shadow,
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Aprovar',
                                          style: TextStyle(
                                            color: Get.theme.colorScheme
                                                .onPrimaryContainer,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    controller.getDialog(
                                      idView: controller
                                          .adminViewsList[index].idView
                                          .toString(),
                                      name: controller
                                          .adminViewsList[index].nameUser
                                          .toString(),
                                      title: 'Atenção!',
                                      message:
                                          'Deseja excluir a publicação de\n${controller.adminViewsList[index].nameUser.toString()}',
                                      label: 'Excluir',
                                      onPressed: () {
                                        controller.deleteViewPeaple({
                                          "idView": controller
                                              .adminViewsList[index].idView
                                              .toString()
                                        });
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Get.theme.colorScheme.shadow,
                                      ),
                                      child: Icon(
                                        FontAwesomeIcons.trash,
                                        color: Get.theme.colorScheme.background,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    var phone = controller
                                        .adminViewsList[index].phone
                                        .toString()
                                        .toString()
                                        .replaceAll(RegExp('[^0-9]'), '');

                                    Uri url = Uri.parse(
                                        'https://api.whatsapp.com/send?phone=$phone');
                                    launchUrl(url);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Get.theme.colorScheme.shadow,
                                      ),
                                      child: Icon(
                                        FontAwesomeIcons.whatsapp,
                                        color: Get.theme.colorScheme.background,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: index == controller.adminViewsList.length - 1
                              ? true
                              : false,
                          child: SizedBox(
                            height: context.height * 0.2,
                          ),
                        ),
                      ]);
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
