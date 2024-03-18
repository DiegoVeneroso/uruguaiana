// ignore_for_file: deprecated_member_use

import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_appbar.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_view_responsive_card.dart';
import 'package:eu_faco_parte/app/models/view_model.dart';
import 'package:eu_faco_parte/app/modules/view_peaple/view_peaple_controller.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:eu_faco_parte/app/repository/view_peaple_repositories.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:read_more_text/read_more_text.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_searchformfield.dart';
import '../../routes/app_pages.dart';

class ViewPeaplePage extends GetView<ViewPeapleController> {
  const ViewPeaplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ViewPeapleController controller = ViewPeapleController(
      repository: ViewPeapleRepository(),
      authRepository: AuthRepository(),
    );

    return Scaffold(
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
      body: SafeArea(
        child: FutureBuilder(
          future: controller.loadData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Get.theme.colorScheme.primary,
                  ),
                ),
              );
            }

            var listView = snapshot.data.map((e) {
              return ViewModel(
                title: e.title,
                description: e.description,
                date: e.date,
                nameUser: e.nameUser,
                phone: e.phone,
                bairro: e.bairro,
                urlImage: e.urlImage,
                status: e.status,
              );
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
                  child: Center(
                    child: AutoSizeText(
                      minFontSize: 10,
                      'URUGUAIANA QUE O POVO VÊ',
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
                        onChanged: (value) => controller.search(value),
                        onPressed: () => controller.searchVisible.toggle(),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => controller.search.value == "" ||
                          controller.search.value.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: listView.length,
                              itemBuilder: (ctx, index) {
                                getShareDialog() {
                                  Get.defaultDialog(
                                    title: 'Compartilhar',
                                    titleStyle: TextStyle(
                                      color: Get.theme.colorScheme.primary,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            var pathImageUrl = await controller
                                                .getVideoTypeFileUrl(
                                                    listView[index].urlImage);

                                            String message =
                                                '${listView[index].title}\n\n${listView[index].description}';

                                            AppinioSocialShare()
                                                .shareToWhatsapp(message,
                                                    filePath: pathImageUrl
                                                        .toString());
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.whatsapp,
                                            size: 40,
                                            color:
                                                Get.theme.colorScheme.primary,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            var pathImageUrl = await controller
                                                .getVideoTypeFileUrl(
                                                    listView[index].urlImage);

                                            String message =
                                                '${listView[index].title}\n\n${listView[index].description}';

                                            AppinioSocialShare()
                                                .shareToFacebook(message,
                                                    pathImageUrl.toString());
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.facebook,
                                            size: 40,
                                            color:
                                                Get.theme.colorScheme.primary,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            var pathImageUrl = await controller
                                                .getVideoTypeFileUrl(
                                                    listView[index].urlImage);

                                            AppinioSocialShare()
                                                .shareToInstagramFeed(
                                                    pathImageUrl.toString());
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.instagram,
                                            size: 40,
                                            color:
                                                Get.theme.colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                if (controller.search.value.isEmpty) {
                                  listView = listView;
                                } else {
                                  List result = listView
                                      .where((element) => element.title
                                          .toString()
                                          .toLowerCase()
                                          .contains(controller.search.value
                                              .toLowerCase()))
                                      .toList();

                                  result.isEmpty
                                      ? listView = listView
                                      : listView = result;
                                }

                                return Column(children: [
                                  CustomViewResponsiveCard(
                                    elevation: 5, //elevation
                                    titleGap:
                                        5, // gap between title and leading
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
                                            'Bairro: ${listView[index].bairro}',
                                            style: TextStyle(
                                                color: Get
                                                    .theme.colorScheme.primary,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            listView[index].date,
                                            style: TextStyle(
                                                color: Get
                                                    .theme.colorScheme.primary,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: Text(
                                            listView[index].title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Get
                                                    .theme.colorScheme.primary,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subTitle: ReadMoreText(
                                      listView[index].description,
                                      numLines: 2,
                                      readMoreText: 'Ler mais',
                                      readLessText: 'Ler menos',
                                      readMoreTextStyle: TextStyle(
                                          color: Get.theme.colorScheme.primary,
                                          fontWeight: FontWeight.bold),
                                      readMoreIconColor:
                                          Get.theme.colorScheme.primary,
                                      style: TextStyle(
                                          color: Get.theme.colorScheme.primary,
                                          fontSize: 14),
                                    ),

                                    leading: GestureDetector(
                                      onTap: () {
                                        final imageProvider = Image.network(
                                                listView[index].urlImage)
                                            .image;
                                        showImageViewer(context, imageProvider,
                                            onViewerDismissed: () {
                                          print("dismissed");
                                        });
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          listView[index].urlImage,
                                          fit: BoxFit.cover,
                                          width: context.width,
                                          height: context.height * 0.3,
                                          frameBuilder: (context, child, frame,
                                              wasSynchronouslyLoaded) {
                                            return child;
                                          },
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: context.width,
                                                  height: context.height * 0.3,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Get.theme
                                                          .colorScheme.primary,
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
                                          Visibility(
                                            visible:
                                                controller.getIsAdmin() == true,
                                            child: ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: const Size(80, 30),
                                                side: BorderSide(
                                                  width: 1.0,
                                                  color: Get.theme.colorScheme
                                                      .onPrimaryContainer,
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                                textStyle: TextStyle(
                                                  color: Get.theme.colorScheme
                                                      .onPrimaryContainer,
                                                ),
                                              ),
                                              child: Text(
                                                'Aprovar',
                                                style: TextStyle(
                                                  color: Get.theme.colorScheme
                                                      .onPrimaryContainer,
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              getShareDialog();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Get
                                                      .theme.colorScheme.shadow,
                                                ),
                                                child: Icon(
                                                  Icons.share,
                                                  color: Get.theme.colorScheme
                                                      .background,
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
                                    visible: index == listView.length - 1
                                        ? true
                                        : false,
                                    child: SizedBox(
                                      height: context.height * 0.2,
                                    ),
                                  ),
                                ]);
                              }),
                        )
                      : const CircularProgressIndicator(),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 8,
        isExtended: true,
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: Get.theme.colorScheme.onPrimaryContainer,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            AutoSizeText(
              minFontSize: 10,
              'REGISTRAR O\nQUE VOCÊ VÊ',
              style: TextStyle(
                  fontSize: 14,
                  color: Get.theme.colorScheme.onPrimaryContainer),
            ),
          ],
        ),
        backgroundColor: Get.theme.colorScheme.primary,
        onPressed: () {
          Get.toNamed(Routes.view_people_add);
        },
      ),
    );
  }
}
