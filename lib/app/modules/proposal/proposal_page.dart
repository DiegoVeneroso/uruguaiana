import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_appbar.dart';
import 'package:uruguaiana/app/modules/proposal/proposal_controller.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_drawer.dart';

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
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount: controller.foundProposal.value.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Column(
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
                                    bottomLeft: Radius.circular(10.0)),
                              ),
                              child: const SizedBox(
                                height: 25,
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
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 30.0),
                                child: AutoSizeText(
                                  controller.proposalList[index].title,
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
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: const SizedBox(
                                height: 20,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ],
        ));
  }
}
