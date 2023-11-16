import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uruguaiana/app/modules/news/news_controller.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_player_video.dart';

class NewsDetailPage extends StatefulWidget {
  const NewsDetailPage({Key? key}) : super(key: key);

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends AppState<NewsDetailPage, NewsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: CustomAppbar(
        actionsList: [
          IconButton(
            onPressed: ThemeService().switchTheme,
            icon: const Icon(Icons.contrast),
            color: Get.theme.colorScheme.onBackground,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: controller
                  .getVideoTypeFileUrl(Get.parameters['url_image'].toString()),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: double.infinity,
                    height: 230,
                    decoration: BoxDecoration(
                      border: Border.all(color: Get.theme.colorScheme.primary),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CircularProgressIndicator(
                              color: Get.theme.colorScheme.primary,
                            ),
                          )
                        ]),
                  );
                }
                if (snapshot.data!['type'] == 'video') {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CustomPlayerVideo(
                      videoUri:
                          Uri.parse(Get.parameters['url_image'].toString()),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: double.infinity,
                      height: 600,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Get.theme.colorScheme.primary),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(
                              Get.parameters['url_image'].toString()),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }
              }),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10, top: 10.0, bottom: 15),
                      child: RichText(
                        text: TextSpan(
                          text: Get.parameters['title'].toString(),
                          style: TextStyle(
                            color: Get.theme.colorScheme.surface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 3,
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: Get.parameters['date'].toString(),
                          style: TextStyle(
                            color: Get.theme.colorScheme.surface,
                            fontSize: 12,
                          ),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          text: Get.parameters['description'].toString(),
                          style: TextStyle(
                            color: Get.theme.colorScheme.surface,
                            fontSize: 16,
                          ),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
