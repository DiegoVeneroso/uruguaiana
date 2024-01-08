import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_appbar.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_floating_button.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_searchformfield.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_view_news.dart';
import 'package:uruguaiana/app/modules/news/news_controller.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_drawer.dart';
import '../../repository/auth_repository.dart';
import '../../routes/app_pages.dart';
import '../auth/login/login_controller.dart';

class NewsPage extends GetView<NewsController> {
  LoginController loginController = LoginController(AuthRepository());

  NewsPage({super.key});

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
                  'NOTÍCIAS',
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
                    itemCount: controller.foundNews.value.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: FutureBuilder(
                          future: controller.getVideoTypeFileUrl(
                              controller.foundNews.value[index].urlImage),
                          builder: ((context, snapshot) {
                            getShareDialog() {
                              Get.defaultDialog(
                                title: 'Compartilhar',
                                titleStyle: TextStyle(
                                  color: Get.theme.colorScheme.primary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        var pathImageUrl = await controller
                                            .getImageXFileByUrl(controller
                                                .newsList[index].urlImage);

                                        String message =
                                            '${controller.newsList[index].title}\n\n${controller.newsList[index].description}';

                                        AppinioSocialShare().shareToWhatsapp(
                                            message,
                                            filePath: pathImageUrl);
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.whatsapp,
                                        size: 40,
                                        color: Get.theme.colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        var pathImageUrl = await controller
                                            .getImageXFileByUrl(controller
                                                .newsList[index].urlImage);

                                        String message =
                                            '${controller.newsList[index].title}\n\n${controller.newsList[index].description}';

                                        AppinioSocialShare().shareToFacebook(
                                            message, pathImageUrl);
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.facebook,
                                        size: 40,
                                        color: Get.theme.colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        var pathImageUrl = await controller
                                            .getImageXFileByUrl(controller
                                                .newsList[index].urlImage);

                                        AppinioSocialShare()
                                            .shareToInstagramFeed(pathImageUrl);
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.instagram,
                                        size: 40,
                                        color: Get.theme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

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
                                  color:
                                      Get.theme.colorScheme.onPrimaryContainer,
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Get.theme.colorScheme.primary,
                                  ),
                                ),
                              );
                            }

                            return snapshot.data!['type'] == 'video'
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed('/news_detail',
                                              parameters: {
                                                'idNews': controller
                                                    .newsList[index].idNews
                                                    .toString(),
                                                'date': controller
                                                    .newsList[index].date
                                                    .toString(),
                                                'title': controller
                                                    .newsList[index].title
                                                    .toString(),
                                                'url_image': controller
                                                    .newsList[index].urlImage
                                                    .toString(),
                                                'description': controller
                                                    .newsList[index].description
                                                    .toString(),
                                              });
                                        },
                                        child: CustomViewNews(
                                          videoUri: Uri.parse(controller
                                              .foundNews.value[index].urlImage),
                                        ),
                                      ),
                                      Positioned(
                                        right: 10,
                                        top: 10,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Visibility(
                                              visible: controller.isAdmin(),
                                              child: GestureDetector(
                                                onTap: () {
                                                  controller.getDialog(
                                                    idNews: controller
                                                        .newsList[index].idNews
                                                        .toString(),
                                                    news: controller.foundNews
                                                        .value[index].title,
                                                  );
                                                },
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Get.theme.colorScheme
                                                        .shadow,
                                                  ),
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Get.theme.colorScheme
                                                        .background,
                                                    size: 22,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Visibility(
                                              visible: controller.isAdmin(),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(Routes.news_edit,
                                                      parameters: {
                                                        'idNews': controller
                                                            .newsList[index]
                                                            .idNews
                                                            .toString(),
                                                        'date': controller
                                                            .newsList[index]
                                                            .date
                                                            .toString(),
                                                        'title': controller
                                                            .newsList[index]
                                                            .title
                                                            .toString(),
                                                        'url_image': controller
                                                            .newsList[index]
                                                            .urlImage
                                                            .toString(),
                                                        'description':
                                                            controller
                                                                .newsList[index]
                                                                .description
                                                                .toString(),
                                                      });
                                                },
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Get.theme.colorScheme
                                                        .shadow,
                                                  ),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Get.theme.colorScheme
                                                        .background,
                                                    size: 22,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                getShareDialog();
                                              },
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
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
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        left: 10,
                                        bottom: 10,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 16),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Get
                                                    .theme.colorScheme.shadow,
                                              ),
                                              child: RichText(
                                                text: TextSpan(
                                                  text: controller.foundNews
                                                      .value[index].title,
                                                  style: TextStyle(
                                                    color: Get.theme.colorScheme
                                                        .background,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.toNamed('/news_detail',
                                                  parameters: {
                                                    'idNews': controller
                                                        .newsList[index].idNews
                                                        .toString(),
                                                    'date': controller
                                                        .newsList[index].date
                                                        .toString(),
                                                    'title': controller
                                                        .newsList[index].title
                                                        .toString(),
                                                    'url_image': controller
                                                        .newsList[index]
                                                        .urlImage
                                                        .toString(),
                                                    'description': controller
                                                        .newsList[index]
                                                        .description
                                                        .toString(),
                                                  });
                                            },
                                            child: Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Get
                                                    .theme.colorScheme.shadow,
                                              ),
                                              child: Icon(
                                                Icons.play_arrow,
                                                color: Get.theme.colorScheme
                                                    .background,
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed('/news_detail',
                                              parameters: {
                                                'idNews': controller
                                                    .newsList[index].idNews
                                                    .toString(),
                                                'date': controller
                                                    .newsList[index].date
                                                    .toString(),
                                                'title': controller
                                                    .newsList[index].title
                                                    .toString(),
                                                'url_image': controller
                                                    .newsList[index].urlImage
                                                    .toString(),
                                                'description': controller
                                                    .newsList[index].description
                                                    .toString(),
                                              });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          width: double.infinity,
                                          height: Get.height * 0.35,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(controller
                                                  .foundNews
                                                  .value[index]
                                                  .urlImage),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 10,
                                        top: 10,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Visibility(
                                              visible: controller.isAdmin(),
                                              child: GestureDetector(
                                                onTap: () {
                                                  controller.getDialog(
                                                    idNews: controller
                                                        .newsList[index].idNews
                                                        .toString(),
                                                    news: controller.foundNews
                                                        .value[index].title,
                                                  );
                                                },
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Get.theme.colorScheme
                                                        .shadow,
                                                  ),
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Get.theme.colorScheme
                                                        .background,
                                                    size: 22,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Visibility(
                                              visible: controller.isAdmin(),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                    Routes.news_edit,
                                                    parameters: {
                                                      'idNews': controller
                                                          .newsList[index]
                                                          .idNews
                                                          .toString(),
                                                      'date': controller
                                                          .newsList[index].date
                                                          .toString(),
                                                      'title': controller
                                                          .newsList[index].title
                                                          .toString(),
                                                      'url_image': controller
                                                          .newsList[index]
                                                          .urlImage
                                                          .toString(),
                                                      'description': controller
                                                          .newsList[index]
                                                          .description
                                                          .toString(),
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Get.theme.colorScheme
                                                        .shadow,
                                                  ),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Get.theme.colorScheme
                                                        .background,
                                                    size: 22,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                getShareDialog();
                                              },
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
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
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        left: 10,
                                        bottom: 10,
                                        // child: Container(
                                        //   height: 40,
                                        //   width: Get.width * .94,
                                        //   color: Colors.red,
                                        //   child: RichText(
                                        //     text: TextSpan(
                                        //       text: controller
                                        //           .foundNews.value[index].title,
                                        //       style: TextStyle(
                                        //         color: Get.theme.colorScheme
                                        //             .background,
                                        //         fontSize: 16,
                                        //         fontWeight: FontWeight.bold,
                                        //       ),
                                        //     ),
                                        //     textAlign: TextAlign.justify,
                                        //   ),
                                        // ),
                                        child: Container(
                                          // height: 40,
                                          width: Get.width * .94,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 16),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Get.theme.colorScheme.shadow,
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3.0),
                                            child: RichText(
                                              text: TextSpan(
                                                text: controller.foundNews
                                                    .value[index].title,
                                                style: TextStyle(
                                                  color: Get.theme.colorScheme
                                                      .background,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          }),
                        ),
                      );
                    },
                  )),
            ),
          ],
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
                          size: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              AutoSizeText(
                                minFontSize: 10,
                                'ADICIONAR',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Get.theme.colorScheme.background),
                              ),
                              AutoSizeText(
                                minFontSize: 10,
                                'NOTÍCIA',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Get.theme.colorScheme.background),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Get.theme.colorScheme.primary,
                    onPressed: () {
                      Get.toNamed(Routes.news_add);
                    },
                  ),
                )
              : CustomFloatingButton(),
        ),
      ),
    );
  }
}
