import 'package:brasil_fields/brasil_fields.dart';
import 'package:dio/dio.dart';
import 'package:eu_faco_parte/app/modules/donate/donate_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/modules/notification/notification_controller.dart';
import 'package:validatorless/validatorless.dart';
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
            "back_urls": {
              "success": "https://frontapp.com.br",
              "pending": "https://frontapp.com.br",
              "failure": "https://frontapp.com.br",
            },
            "auto_return": "approved",
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
                    controller: _nameEC,
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
                      onPressed: () {
                        final formValid =
                            _formKey.currentState?.validate() ?? false;

                        if (formValid) {
                          launchURL(context,
                              value: UtilBrasilFields.converterMoedaParaDouble(
                                  _valueEC.text));
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



// import 'dart:ffi';

// import 'package:dio/dio.dart';
// import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import '../../routes/app_pages.dart';
// import './donate_controller.dart';

// class DonatePage extends GetView<DonateController> {
//   const DonatePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     void launchURL(BuildContext context, {required double value}) async {
//       try {
//         final dio = Dio();
//         final response = await dio.post(
//           'https://api.mercadopago.com/checkout/preferences',
//           data: {
//             "items": [
//               {
//                 "title": "Doação para campanha",
//                 "description": "Doação espontânea de apoiador",
//                 "category_id": "doacao",
//                 "quantity": 1,
//                 "currency_id": "R\$",
//                 "unit_price": value
//               }
//             ],
//             "marketplace_fee": null,
//             "metadata": null,
//             "payer": {
//               "phone": {"number": null},
//               "identification": {},
//               "address": {"street_number": null}
//             },
//             "payment_methods": {
//               "excluded_payment_methods": [{}],
//               "excluded_payment_types": [
//                 {
//                   "id": "credit_card",
//                 },
//                 {
//                   "id": "debit_card",
//                 }
//               ],
//               "installments": null,
//               "default_installments": null
//             },
//             "shipments": {
//               "local_pickup": false,
//               "default_shipping_method": null,
//               "free_methods": [
//                 {"id": null}
//               ],
//               "cost": null,
//               "free_shipping": false,
//               "receiver_address": {"street_number": null}
//             },
//             "back_urls": {
//               "success": "https://frontapp.com.br",
//               "pending": "https://frontapp.com.br",
//               "failure": "https://frontapp.com.br",
//             },
//             "auto_return": "approved",
//           },
//           options: Options(
//             //produção
//             // headers: {
//             //   'Content-Type': 'application/json',
//             //   'Accept': 'application/json',
//             //   'Authorization':
//             //       'Bearer APP_USR-7757082514884448-100623-462804bc4607bb84c020b146d4e828c5-181498122',
//             // },

//             //teste
//             headers: {
//               'Content-Type': 'application/json',
//               'Accept': 'application/json',
//               'Authorization':
//                   'Bearer TEST-7757082514884448-100623-17afc7de1b829eb9c714f48759d3af28-181498122',
//             },
//           ),
//         );

//         await launch(
//           response.data['init_point'],
//           customTabsOption: CustomTabsOption(
//             toolbarColor: Get.theme.colorScheme.primary,
//             enableDefaultShare: false,
//             enableUrlBarHiding: false,
//             showPageTitle: false,
//           ),
//           safariVCOption: SafariViewControllerOption(
//             preferredBarTintColor: Get.theme.colorScheme.primary,
//             preferredControlTintColor: Get.theme.colorScheme.onPrimaryContainer,
//             barCollapsingEnabled: true,
//             entersReaderIfAvailable: false,
//             dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
//           ),
//         );
//       } catch (e) {
//         // An exception is thrown if browser app is not installed on Android device.
//         debugPrint(e.toString());
//       }
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('donate'),
//       ),
//       // body: Center(
//       //   child: TextButton(
//       //     child: const Text('Show Flutter homepage'),
//       //     onPressed: () => launchURL(context),
//       //   ),
//       // ),
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               ElevatedButton(
//                 onPressed: () => launchURL(context, value: 1.60),
//                 // onPressed: () async {
//                 //   final dio = Dio();
//                 //   final response = await dio.post(
//                 //     'https://api.mercadopago.com/checkout/preferences',
//                 //     data: {
//                 //       "items": [
//                 //         {
//                 //           "title": "Doação para campanha",
//                 //           "description": "Doação espontânea de apoiador",
//                 //           "category_id": "doacao",
//                 //           "quantity": 1,
//                 //           "currency_id": "R\$",
//                 //           "unit_price": 1
//                 //         }
//                 //       ],
//                 //       "marketplace_fee": null,
//                 //       "metadata": null,
//                 //       "payer": {
//                 //         "phone": {"number": null},
//                 //         "identification": {},
//                 //         "address": {"street_number": null}
//                 //       },
//                 //       "payment_methods": {
//                 //         "excluded_payment_methods": [{}],
//                 //         "excluded_payment_types": [{}],
//                 //         "installments": null,
//                 //         "default_installments": null
//                 //       },
//                 //       "shipments": {
//                 //         "local_pickup": false,
//                 //         "default_shipping_method": null,
//                 //         "free_methods": [
//                 //           {"id": null}
//                 //         ],
//                 //         "cost": null,
//                 //         "free_shipping": false,
//                 //         "receiver_address": {"street_number": null}
//                 //       }
//                 //     },
//                 //     options: Options(
//                 //       //produção
//                 //       // headers: {
//                 //       //   'Content-Type': 'application/json',
//                 //       //   'Accept': 'application/json',
//                 //       //   'Authorization':
//                 //       //       'Bearer APP_USR-7757082514884448-100623-462804bc4607bb84c020b146d4e828c5-181498122',
//                 //       // },

//                 //       //teste
//                 //       headers: {
//                 //         'Content-Type': 'application/json',
//                 //         'Accept': 'application/json',
//                 //         'Authorization':
//                 //             'Bearer TEST-7757082514884448-100623-17afc7de1b829eb9c714f48759d3af28-181498122',
//                 //       },
//                 //     ),
//                 //   );

//                 //   // Uri url = Uri.parse(response.data['init_point']);
//                 //   // launchUrl(url);

//                 //   launchURL(context);

//                 //   // if (response.data['init_point'].toString() != "") {
//                 //   //   Get.toNamed(Routes.donate_checkout, parameters: {
//                 //   //     'urlWebview': response.data['init_point'].toString(),
//                 //   //   });
//                 //   // }

//                 //   print(response.data['init_point']);
//                 //   print(response.data);
//                 // },
//                 child: const Text(
//                   'pagar',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
