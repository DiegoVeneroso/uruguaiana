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
    return Scaffold(
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
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Text(
                'Pilares da proposta',
                style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Get.theme.colorScheme.surface,
                    fontSize: 25),
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
                    crossAxisSpacing: 10,
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
                    child: Column(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.95,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Get.theme.colorScheme.onPrimaryContainer,
                              border: Border.all(
                                  color: Get.theme.colorScheme.primary),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.surface,
                                  blurRadius: 5.0,
                                )
                              ],
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(0.0),
                                bottomRight: Radius.circular(10.0),
                                topLeft: Radius.circular(0.0),
                                bottomLeft: Radius.circular(10.0),
                              ),
                            ),
                            child: const SizedBox(
                              height: 25,
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.85,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Get.theme.colorScheme.onPrimaryContainer,
                              border: Border.all(
                                  color: Get.theme.colorScheme.primary),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.surface,
                                  blurRadius: 5.0,
                                )
                              ],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const SizedBox(
                              height: 16,
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.8,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Get.theme.colorScheme.onPrimaryContainer,
                              border: Border.all(
                                  color: Get.theme.colorScheme.primary),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.surface,
                                  blurRadius: 5.0,
                                )
                              ],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const SizedBox(
                              height: 10,
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.7,
                          child: Container(
                            width: MediaQuery.of(context).size.height * 0.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Get.theme.colorScheme.onPrimaryContainer,
                              border: Border.all(
                                  color: Get.theme.colorScheme.primary),
                              boxShadow: [
                                BoxShadow(
                                  color: Get.theme.colorScheme.surface,
                                  blurRadius: 5.0,
                                )
                              ],
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: SizedBox(
                              height: 70,
                              child: Center(
                                child: AutoSizeText(
                                  controller.proposalList[index].title
                                      .toString(),
                                  style: TextStyle(
                                    color: Get.theme.colorScheme.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  minFontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.9,
                          child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Get.theme.colorScheme.onPrimaryContainer,
                                border: Border.all(
                                    color: Get.theme.colorScheme.primary),
                                boxShadow: [
                                  BoxShadow(
                                    color: Get.theme.colorScheme.surface,
                                    blurRadius: 5.0,
                                  )
                                ],
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10.0),
                                  bottomRight: Radius.circular(0.0),
                                  topLeft: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(0.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(
                                      Icons.edit,
                                      color: Get.theme.colorScheme.primary,
                                      // size: 20,
                                    ),
                                    onPressed: () {
                                      Get.toNamed(Routes.proposal_edit,
                                          parameters: {
                                            'id_proposal_base': controller
                                                .proposalList[index].idProposal
                                                .toString(),
                                            'proposal_pilar_name': controller
                                                .proposalList[index].title
                                                .toString(),
                                          });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Get.theme.colorScheme.primary,
                                      // size: 20,
                                    ),
                                    onPressed: () {
                                      Get.defaultDialog(
                                        titlePadding:
                                            const EdgeInsets.only(top: 10),
                                        contentPadding: const EdgeInsets.only(
                                            top: 30, bottom: 20),
                                        title: 'Atenção!',
                                        middleText:
                                            'Somente pilares sem ações cadastradas podem ser excluídos!',
                                        backgroundColor: Get.theme.colorScheme
                                            .onPrimaryContainer,
                                        titleStyle: TextStyle(
                                            color: Get
                                                .theme.colorScheme.onSurface),
                                        middleTextStyle: TextStyle(
                                            color: Get
                                                .theme.colorScheme.onSurface),
                                        radius: 30,
                                        confirm: CustomButton(
                                          color: Get.theme.colorScheme.onError,
                                          height: 40,
                                          width: 100,
                                          label: 'Excluir',
                                          onPressed: () async {
                                            await controller.proposalDelete(
                                                controller.proposalList[index]
                                                    .idProposal
                                                    .toString());
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )),
                        ),
                      ],
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
                        'ADICIONAR PILAR',
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
              )
            : const CustomFloatingButton(),
      ),
    );
  }
}
