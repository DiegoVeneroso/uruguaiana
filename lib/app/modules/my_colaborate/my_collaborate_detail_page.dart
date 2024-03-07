import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_button.dart';
import 'package:eu_faco_parte/app/modules/my_colaborate/my_colaborate_controller.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_player_video.dart';

class MyCollaborateDetailPage extends StatefulWidget {
  const MyCollaborateDetailPage({Key? key}) : super(key: key);

  @override
  State<MyCollaborateDetailPage> createState() =>
      _MyCollaborateDetailPageState();
}

class _MyCollaborateDetailPageState
    extends AppState<MyCollaborateDetailPage, MyCollaborateController> {
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
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
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
                      if (snapshot.hasData) {
                        if (snapshot.data!['type'] == 'video') {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomPlayerVideo(
                                videoUri: Uri.parse(
                                    Get.parameters['url_image'].toString()),
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
                      } else {
                        return const SizedBox();
                      }
                    }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
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
                                    text: DateFormat(
                                            DateFormat.YEAR_MONTH_DAY, 'pt_Br')
                                        .format(
                                      DateTime.parse(
                                        Get.parameters['date_time_created']
                                            .toString(),
                                      ),
                                    ),
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
                                    text: Get.parameters['name'].toString(),
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
                                    text: Get.parameters['description']
                                        .toString(),
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
                      const SizedBox(
                        height: 30,
                      ),
                      Visibility(
                        visible: controller.isAdmin.value,
                        child: CustomButton(
                          label: 'Entrar em contato',
                          height: 40,
                          onPressed: () {
                            var phone = Get.parameters['phone']
                                .toString()
                                .replaceAll(RegExp('[^0-9]'), '');

                            Uri url = Uri.parse(
                                'https://api.whatsapp.com/send?phone=$phone');
                            launchUrl(url);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
