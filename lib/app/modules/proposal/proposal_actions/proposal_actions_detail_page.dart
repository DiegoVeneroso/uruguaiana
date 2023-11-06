import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uruguaiana/app/routes/app_pages.dart';
import '../../../core/colors/services/theme_service.dart';
import '../../../core/ui/app_state.dart';
import '../../../core/ui/widgets/custom_appbar.dart';
import '../../../core/ui/widgets/custom_button.dart';
import '../../../core/ui/widgets/custom_floating_button.dart';
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
            FutureBuilder(
              future: controller
                  .getVideoTypeFileUrl(Get.parameters['url_image'].toString()),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: double.infinity,
                      height: 210,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Get.theme.colorScheme.primary),
                        borderRadius: BorderRadius.circular(20),
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
                    ),
                  );
                }
                if (snapshot.data!['type'] == 'video') {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomPlayerVideo(
                      videoUri:
                          Uri.parse(Get.parameters['url_image'].toString()),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Get.theme.colorScheme.primary),
                        borderRadius: BorderRadius.circular(20),
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
      floatingActionButton: Obx(
        () => controller.isAdmin()
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton.extended(
                    heroTag: 'Editar',
                    label: AutoSizeText(
                      minFontSize: 10,
                      'Editar',
                      style: TextStyle(
                          color: Get.theme.colorScheme.onPrimaryContainer),
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.proposal_actions_edit, parameters: {
                        "proposal_pilar_name":
                            Get.parameters['proposal_pilar_name'].toString(),
                        'id_proposal_action':
                            Get.parameters['id_proposal_action'].toString(),
                        'title': Get.parameters['title'].toString(),
                        'url_image': Get.parameters['url_image'].toString(),
                        'description': Get.parameters['description'].toString(),
                      });
                    },
                    backgroundColor: Get.theme.colorScheme.primaryContainer,
                    icon: Icon(Icons.edit,
                        color: Get.theme.colorScheme.onPrimaryContainer),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  FloatingActionButton.extended(
                    heroTag: 'excluir',
                    label: AutoSizeText(
                      minFontSize: 10,
                      'Excluir',
                      style: TextStyle(
                          color: Get.theme.colorScheme.onPrimaryContainer),
                    ),
                    onPressed: () {
                      Get.defaultDialog(
                        titlePadding: const EdgeInsets.only(top: 30),
                        contentPadding:
                            const EdgeInsets.only(top: 30, bottom: 20),
                        title: 'Deseja excluir a ação?',
                        backgroundColor:
                            Get.theme.colorScheme.onPrimaryContainer,
                        titleStyle: TextStyle(
                            color: Get.theme.colorScheme.primary,
                            fontWeight: FontWeight.bold),
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              minFontSize: 10,
                              Get.parameters['title'].toString(),
                              style: TextStyle(
                                color: Get.theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            CustomButton(
                              label: 'Excluir',
                              height: 40,
                              onPressed: () async {
                                controller.proposalActionDelete({
                                  "idProposal": Get
                                      .parameters['id_proposal_action']
                                      .toString(),
                                  "proposal_pilar_name": Get
                                      .parameters['proposal_pilar_name']
                                      .toString(),
                                });
                              },
                            ),
                          ],
                        ),
                        radius: 20,
                      );
                    },
                    backgroundColor: Get.theme.colorScheme.primaryContainer,
                    icon: Icon(Icons.delete,
                        color: Get.theme.colorScheme.onPrimaryContainer),
                  ),
                ],
              )
            : const CustomFloatingButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
