import 'package:brasil_fields/brasil_fields.dart';
import 'package:dio/dio.dart';
import 'package:eu_faco_parte/app/modules/admin/admin_controller.dart';

import 'package:eu_faco_parte/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:get/get.dart';
import 'package:validatorless/validatorless.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/app_state.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_textformfield.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DonateAddPage extends StatefulWidget {
  const DonateAddPage({Key? key}) : super(key: key);

  @override
  State<DonateAddPage> createState() => _DonatePageState();
}

class _DonatePageState extends AppState<DonateAddPage, AdminController> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _valueEC = TextEditingController();

  RxBool loadingButton = false.obs;

  @override
  void dispose() {
    _nameEC.dispose();
    _valueEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void launchURL(BuildContext context, {required double value}) async {
      try {
        final dio = Dio();
        final response = await dio.post(
          'https://api.mercadopago.com/checkout/preferences',
          data: {
            "items": [
              {
                "title":
                    "Doação para \"Uruguaiana que queremos - Eu faço parte\"",
                "description": "Doação espontânea de apoiador",
                "category_id": "doacao",
                "quantity": 1,
                "currency_id": "R\$",
                "unit_price": value
              }
            ],
            "marketplace_fee": null,
            "metadata": null,
            "payer": {
              "phone": {"number": null},
              "identification": {},
              "address": {"street_number": null}
            },
            "payment_methods": {
              "excluded_payment_methods": [{}],
              "excluded_payment_types": [
                {
                  "id": "credit_card",
                },
                {
                  "id": "debit_card",
                },
                {
                  "id": "ticket",
                },
                // {
                //   "id": "bank_transfer",
                // }
              ],
              "installments": null,
              "default_installments": null
            },
            "shipments": {
              "local_pickup": false,
              "default_shipping_method": null,
              "free_methods": [
                {"id": null}
              ],
              "cost": null,
              "free_shipping": false,
              "receiver_address": {"street_number": null}
            },
          },
          options: Options(
            //produção
            // headers: {
            //   'Content-Type': 'application/json',
            //   'Accept': 'application/json',
            //   'Authorization':
            //       'Bearer APP_USR-7757082514884448-100623-462804bc4607bb84c020b146d4e828c5-181498122',
            // },

            //teste
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization':
                  'Bearer TEST-7757082514884448-100623-17afc7de1b829eb9c714f48759d3af28-181498122',
            },
          ),
        );

        await launch(
          response.data['init_point'],
          customTabsOption: CustomTabsOption(
            toolbarColor: Get.theme.colorScheme.primary,
            enableDefaultShare: false,
            enableUrlBarHiding: false,
            showPageTitle: false,
          ),
          safariVCOption: SafariViewControllerOption(
            preferredBarTintColor: Get.theme.colorScheme.primary,
            preferredControlTintColor: Get.theme.colorScheme.onPrimaryContainer,
            barCollapsingEnabled: true,
            entersReaderIfAvailable: false,
            dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
          ),
        );
      } catch (e) {
        // An exception is thrown if browser app is not installed on Android device.
        debugPrint(e.toString());
      }
    }

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
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Center(
                      child: AutoSizeText(
                        minFontSize: 10,
                        'DOAÇÕES',
                        style: Get.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Center(
                      child: AutoSizeText(
                        minFontSize: 6,
                        'Colabore e doe para este projeto!',
                        style: Get.textTheme.titleLarge?.copyWith(
                          color: Get.theme.colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Nome (opcional)',
                    controller: _nameEC,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextformfield(
                    label: 'Valor',
                    controller: _valueEC,
                    validator: Validatorless.required('Valor é obrigatório'),
                    keyboardType: TextInputType.number,
                    moneyMask: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Center(
                  //   child: CustomButton(
                  //     color: Get.theme.colorScheme.primaryContainer,
                  //     width: double.infinity,
                  //     label: 'FAZER DOAÇÃO',
                  //     onPressed: () {
                  //       final formValid =
                  //           _formKey.currentState?.validate() ?? false;

                  //       if (formValid) {
                  //         controller.loading.toggle();
                  //         launchURL(context,
                  //             value: UtilBrasilFields.converterMoedaParaDouble(
                  //                 _valueEC.text));
                  //       }
                  //       controller.loading.toggle();
                  //     },
                  //   ),
                  // ),
                  Obx(
                    () => !loadingButton.value
                        ? SizedBox(
                            width: Get.width,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                final formValid =
                                    _formKey.currentState?.validate() ?? false;

                                if (formValid) {
                                  loadingButton.value = true;
                                  launchURL(context,
                                      value: UtilBrasilFields
                                          .converterMoedaParaDouble(
                                              _valueEC.text));
                                }

                                await Future.delayed(
                                    const Duration(seconds: 15));

                                Get.offAllNamed(Routes.news);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: Get.theme.colorScheme.primary,
                              ),
                              child: Text(
                                'FAZER DOAÇÃO',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Get
                                        .theme.colorScheme.onPrimaryContainer),
                              ),
                            ),
                          )
                        : SizedBox(
                            width: Get.width,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: Get.theme.colorScheme.primary,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    color: Get
                                        .theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ),
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
