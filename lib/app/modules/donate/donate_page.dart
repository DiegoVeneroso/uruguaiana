import 'package:auto_size_text/auto_size_text.dart';

import 'package:eu_faco_parte/app/modules/donate/donate_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_appbar.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_drawer.dart';
import '../../repository/auth_repository.dart';
import '../../routes/app_pages.dart';
import '../auth/login/login_controller.dart';

class DonatePage extends GetView<DonateController> {
  LoginController loginController = LoginController(AuthRepository());

  DonatePage({super.key});

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
                color: Get.theme.colorScheme.background,
              ),
            ],
          ),
          body: FutureBuilder(
              future: controller.loadData(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ));
                }
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                          child: AutoSizeText(
                            minFontSize: 10,
                            'DOAÇÕES',
                            style: Get.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Get.theme.colorScheme.surface,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Get.theme.colorScheme.secondary,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 32.0,
                              horizontal: 12,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Center(
                                    child: AutoSizeText(
                                      minFontSize: 10,
                                      'Informações não cadastradas!',
                                      style: Get.textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Get.theme.colorScheme.primary,
                                          fontSize: 20),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                CustomButton(
                                  label: 'CADASTRAR TOKEN DE PAGAMENTO',
                                  onPressed: () {
                                    Get.toNamed(Routes.donate_add_credentials);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [Text(snapshot.data!.first.value.toString())],
                  );
                }
              }))),
    );
  }
}
