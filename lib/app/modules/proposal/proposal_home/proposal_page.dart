import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_appbar.dart';
import '../../../core/colors/services/theme_service.dart';
import '../../../core/ui/widgets/custom_button.dart';
import '../../../core/ui/widgets/custom_drawer.dart';
import '../../../core/ui/widgets/custom_floating_button.dart';
import '../../../routes/app_pages.dart';
import 'proposal_controller.dart';

class ProposalPage extends GetView<ProposalController> {
  const ProposalPage({super.key});

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
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 0),
              child: Center(
                child: AutoSizeText(
                  minFontSize: 10,
                  'ÁREAS',
                  style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.colorScheme.surface,
                      fontSize: 22),
                ),
              ),
            ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(20.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 15,
                      childAspectRatio: 15 / 9,
                      mainAxisSpacing: 10),
                  itemCount: controller.foundProposal.value.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.proposal_actions, parameters: {
                          'id_proposal_base': controller
                              .proposalList[index].idProposal
                              .toString(),
                          'proposal_pilar_name':
                              controller.proposalList[index].title.toString(),
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Get.theme.colorScheme.onPrimaryContainer,
                          border:
                              Border.all(color: Get.theme.colorScheme.primary),
                          boxShadow: [
                            BoxShadow(
                              color: Get.theme.colorScheme.surface,
                              blurRadius: 6.0,
                            )
                          ],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: AutoSizeText(
                                  controller.proposalList[index].title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Get.theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  minFontSize: 10.0,
                                ),
                              ),
                              Obx(() => controller.isAdmin()
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: Icon(
                                              Icons.edit,
                                              color:
                                                  Get.theme.colorScheme.primary,
                                              // size: 20,
                                            ),
                                            onPressed: () {
                                              Get.toNamed(Routes.proposal_edit,
                                                  parameters: {
                                                    'id_proposal_base':
                                                        controller
                                                            .proposalList[index]
                                                            .idProposal
                                                            .toString(),
                                                    'proposal_pilar_name':
                                                        controller
                                                            .proposalList[index]
                                                            .title
                                                            .toString(),
                                                  });
                                            },
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: Icon(
                                              Icons.delete,
                                              color:
                                                  Get.theme.colorScheme.primary,
                                              // size: 20,
                                            ),
                                            onPressed: () {
                                              Get.defaultDialog(
                                                titlePadding:
                                                    const EdgeInsets.only(
                                                        top: 10),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        top: 30, bottom: 20),
                                                title: 'ATENÇÃO!',
                                                middleText:
                                                    'Somente pilares sem ações cadastradas podem ser excluídos!',
                                                backgroundColor: Get
                                                    .theme
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                                titleStyle: TextStyle(
                                                    color: Get.theme.colorScheme
                                                        .onSurface),
                                                middleTextStyle: TextStyle(
                                                    color: Get.theme.colorScheme
                                                        .onSurface),
                                                radius: 30,
                                                confirm: CustomButton(
                                                  color: Get.theme.colorScheme
                                                      .onError,
                                                  height: 40,
                                                  width: 100,
                                                  label: 'Excluir',
                                                  onPressed: () async {
                                                    await controller
                                                        .proposalDelete(
                                                            controller
                                                                .proposalList[
                                                                    index]
                                                                .idProposal
                                                                .toString());
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: Icon(
                                              Icons.visibility,
                                              color:
                                                  Get.theme.colorScheme.primary,
                                              // size: 20,
                                            ),
                                            onPressed: () {
                                              Get.toNamed(
                                                  Routes.proposal_actions,
                                                  parameters: {
                                                    'id_proposal_base':
                                                        controller
                                                            .proposalList[index]
                                                            .idProposal
                                                            .toString(),
                                                    'proposal_pilar_name':
                                                        controller
                                                            .proposalList[index]
                                                            .title
                                                            .toString(),
                                                  });
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox())
                            ]),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Obx(
          () => controller.isAdmin()
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          // offset: Offset(2, 0),
                          blurRadius: 8,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: FloatingActionButton.extended(
                      elevation: 0,
                      isExtended: true,
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Get.theme.colorScheme.background,
                            size: 25,
                          ),
                          AutoSizeText(
                            minFontSize: 10,
                            'ADICIONAR ÁREA',
                            style: TextStyle(
                                fontSize: 14,
                                color: Get.theme.colorScheme.background),
                          ),
                        ],
                      ),
                      backgroundColor: Get.theme.colorScheme.primary,
                      onPressed: () {
                        Get.toNamed(Routes.proposal_add);
                      },
                    ),
                  ),
                )
              : const CustomFloatingButton(),
        ),
      ),
    );
  }
}
