import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/modules/news/news_controller.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        appBar: CustomAppbar(
          actionsList: [
            IconButton(
              onPressed: ThemeService().switchTheme,
              icon: const Icon(Icons.contrast),
              color: Get.theme.colorScheme.background,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: controller.getVideoTypeFileUrl(
                    Get.parameters['url_image'].toString()),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: Get.size.height * 0.35,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Get.theme.colorScheme.primary,
                        ),
                        // borderRadius: BorderRadius.circular(10),
                        color: Get.theme.colorScheme.onPrimaryContainer,
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
                          videoUri:
                              Uri.parse(Get.parameters['url_image'].toString()),
                        ),
                      ],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        height: Get.size.height * 0.35,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: Get.theme.colorScheme.background,
                              width: 1,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Get.theme.colorScheme.background,
                                blurRadius: 3.0,
                                offset: const Offset(0.0, 0.5))
                          ],
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
                      decoration: const BoxDecoration(
                          // borderRadius: BorderRadius.circular(8),
                          ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, bottom: 15),
                        child: RichText(
                          text: TextSpan(
                            text: Get.parameters['title'].toString(),
                            style: TextStyle(
                              color: Get.theme.colorScheme.surface,
                              fontSize: 22,
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
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          bottom: 10,
                          top: 0,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: Get.parameters['date'].toString(),
                            style: TextStyle(
                              color: Get.theme.colorScheme.surface,
                              fontSize: 14,
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
                              fontSize: 18,
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
      ),
    );
  }
}
