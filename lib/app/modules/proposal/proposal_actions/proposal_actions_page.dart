import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_appbar.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_button.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_searchformfield.dart';
import '../../../core/colors/services/theme_service.dart';
import '../../../core/ui/widgets/custom_floating_button.dart';
import '../../../repository/auth_repository.dart';
import '../../../routes/app_pages.dart';
import '../../auth/login/login_controller.dart';
import 'proposal_actions_controller.dart';

class ProposalActionPage extends GetView<ProposalActionsController> {
  LoginController loginController = LoginController(AuthRepository());

  ProposalActionPage({super.key});

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
                  Get.parameters['proposal_pilar_name'].toString(),
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
                    onChanged: (value) => controller.filterProposal(value),
                    onPressed: () => controller.searchVisible.toggle(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() => ListView.separated(
                    itemCount: controller.foundProposal.value.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Get.toNamed('/proposal_actions_detail', parameters: {
                            'id_proposal_action': controller
                                .proposalList[index].idProposalAction
                                .toString(),
                            'title':
                                controller.proposalList[index].title.toString(),
                            'url_image': controller.proposalList[index].urlImage
                                .toString(),
                            'description': controller
                                .proposalList[index].description
                                .toString(),
                            'proposal_pilar_name': Get
                                .parameters['proposal_pilar_name']
                                .toString(),
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        tileColor: Get.theme.colorScheme.primary,
                        textColor: Get.theme.colorScheme.onPrimaryContainer,
                        iconColor: Get.theme.colorScheme.onPrimaryContainer,
                        titleTextStyle: const TextStyle(fontSize: 16),
                        subtitleTextStyle: const TextStyle(fontSize: 14),
                        title:
                            Text(controller.foundProposal.value[index].title),
                        subtitle: Row(
                          children: [
                            Text(
                              controller.foundProposal.value[index].description,
                            ),
                            const SizedBox(
                              width: 20,
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
                        Icons.add,
                        color: Get.theme.colorScheme.background,
                        size: 25,
                      ),
                      Text(
                        'ADICIONAR AÇÃO',
                        style: TextStyle(
                            fontSize: 14,
                            color: Get.theme.colorScheme.background),
                      ),
                    ],
                  ),
                  backgroundColor: Get.theme.colorScheme.primary,
                  onPressed: () {
                    Get.toNamed(Routes.proposal_actions_add, parameters: {
                      'id_proposal_base':
                          Get.parameters['id_proposal_base'].toString(),
                      'proposal_pilar_name':
                          Get.parameters['proposal_pilar_name'].toString(),
                    });
                  },
                ),
              )
            : const CustomFloatingButton(),
      ),
    );
  }
}
