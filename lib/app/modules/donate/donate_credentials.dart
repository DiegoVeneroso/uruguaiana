import 'package:eu_faco_parte/app/modules/donate/donate_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_button.dart';
import '../../core/ui/widgets/custom_textformfield.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DonateCredentialsPage extends StatefulWidget {
  const DonateCredentialsPage({Key? key}) : super(key: key);

  @override
  State<DonateCredentialsPage> createState() => _DonatePageState();
}

class _DonatePageState
    extends AppState<DonateCredentialsPage, DonateController> {
  final _formKey = GlobalKey<FormState>();
  final _tokenEC = TextEditingController();

  RxBool loadingButton = false.obs;

  @override
  void dispose() {
    _tokenEC.dispose();

    super.dispose();
  }

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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: AutoSizeText(
                        minFontSize: 10,
                        'DOAÇÕES',
                        style: Get.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.surface,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 20),
                          child: RichText(
                            text: TextSpan(
                              text:
                                  'Cadastre o "access token" da conta do mercado pago para recebimento das doações!',
                              style: TextStyle(
                                color: Get.theme.colorScheme.surface,
                                fontSize: 16,
                              ),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Access Token do Mercado Pago',
                    controller: _tokenEC,
                    maxlines: 5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: CustomButton(
                      color: Get.theme.colorScheme.primaryContainer,
                      width: double.infinity,
                      label: 'CADASTRAR',
                      onPressed: () async {
                        final formValid =
                            _formKey.currentState?.validate() ?? false;

                        if (formValid) {
                          controller.tokenAdd({"value": _tokenEC.text});
                        }
                      },
                    ),
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
