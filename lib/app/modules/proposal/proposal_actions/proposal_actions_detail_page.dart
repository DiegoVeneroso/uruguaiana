import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/routes/app_pages.dart';
import '../../../core/colors/services/theme_service.dart';
import '../../../core/ui/app_state.dart';
import '../../../core/ui/widgets/custom_appbar.dart';
import '../../../core/ui/widgets/custom_button.dart';
import '../../../core/ui/widgets/custom_player_video.dart';
import 'proposal_actions_controller.dart';

class ProposalActionsDetailPage extends StatefulWidget {
  const ProposalActionsDetailPage({Key? key}) : super(key: key);

  @override
  State<ProposalActionsDetailPage> createState() =>
      _ProposalActionsDetailPageState();
}

class _ProposalActionsDetailPageState
    extends AppState<ProposalActionsDetailPage, ProposalActionsController> {
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
              color: Get.theme.colorScheme.onBackground,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: AutoSizeText(
                    minFontSize: 10,
                    Get.parameters['proposal_pilar_name'].toString(),
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.surface,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: controller.isAdmin(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.defaultDialog(
                              titlePadding: const EdgeInsets.only(top: 10),
                              contentPadding:
                                  const EdgeInsets.only(top: 30, bottom: 20),
                              title: 'ATENÇÃO',
                              middleText: 'Deseja realmente excluir a ação?',
                              backgroundColor:
                                  Get.theme.colorScheme.onPrimaryContainer,
                              titleStyle: TextStyle(
                                  color: Get.theme.colorScheme.onSurface),
                              middleTextStyle: TextStyle(
                                  color: Get.theme.colorScheme.onSurface),
                              radius: 30,
                              confirm: CustomButton(
                                color: Get.theme.colorScheme.onError,
                                height: 40,
                                width: 100,
                                label: 'Excluir',
                                onPressed: () async {
                                  await controller.proposalActionDelete({
                                    "idProposal": Get
                                        .parameters['id_proposal_action']
                                        .toString(),
                                    "proposal_pilar_name": Get
                                        .parameters['proposal_pilar_name']
                                        .toString(),
                                  });
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Get.theme.colorScheme.primary,
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Get.theme.colorScheme.background,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.proposal_actions_edit,
                                parameters: {
                                  "proposal_pilar_name": Get
                                      .parameters['proposal_pilar_name']
                                      .toString(),
                                  'id_proposal_action': Get
                                      .parameters['id_proposal_action']
                                      .toString(),
                                  'title': Get.parameters['title'].toString(),
                                  'url_image':
                                      Get.parameters['url_image'].toString(),
                                  'description':
                                      Get.parameters['description'].toString(),
                                });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Get.theme.colorScheme.primary,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Get.theme.colorScheme.background,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                              color: Get.theme.colorScheme.primary,
                              width: 1,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Get.theme.colorScheme.primary,
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
              Column(
                children: [
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
            ],
          ),
        ),
      ),
    );
  }
}
