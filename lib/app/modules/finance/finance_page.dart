// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:eu_faco_parte/app/core/helpers/formatter_helper.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_appbar.dart';
import 'package:eu_faco_parte/app/models/finance_model.dart';
import 'package:eu_faco_parte/app/modules/finance/finance_controller.dart';
import 'package:eu_faco_parte/app/repository/Finance_repositories.dart';
import 'package:eu_faco_parte/app/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors/services/theme_service.dart';
import '../../routes/app_pages.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({Key? key}) : super(key: key);

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  FinanceController controller = FinanceController(
    repository: FinanceRepository(),
    authRepository: AuthRepository(),
  );

  /// List of Tab Bar Item
  List<String> items = [
    "Resumo",
    "Receitas",
    "Despesas",
  ];

  /// List of body icon
  List<IconData> icons = [
    FontAwesomeIcons.equals,
    FontAwesomeIcons.plus,
    FontAwesomeIcons.minus,
  ];
  int current = 0;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      appBar: CustomAppbar(
        actionsList: [
          IconButton(
            onPressed: ThemeService().switchTheme,
            icon: const Icon(Icons.contrast),
            color: Get.theme.colorScheme.surface,
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: AutoSizeText(
                      minFontSize: 10,
                      'FINANÇAS',
                      style: Get.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.surface,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),

                /// Tab Bar
                SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: items.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  current = index;
                                });
                                pageController.animateToPage(
                                  current,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.ease,
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.all(5),
                                width: 120,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: current == index
                                      ? Colors.white70
                                      : Colors.white12,
                                  borderRadius: current == index
                                      ? BorderRadius.circular(12)
                                      : BorderRadius.circular(12),
                                  border: current == index
                                      ? Border.all(
                                          color: Get.theme.colorScheme
                                              .primaryContainer,
                                          width: 2.5)
                                      : Border.all(
                                          color: Colors.grey.shade400,
                                          width: 2.5),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        icons[index],
                                        size: current == index ? 23 : 20,
                                        color: current == index
                                            ? Get.theme.colorScheme
                                                .primaryContainer
                                            : Colors.grey.shade400,
                                      ),
                                      Text(
                                        items[index],
                                        style: GoogleFonts.ubuntu(
                                          fontWeight: FontWeight.w500,
                                          color: current == index
                                              ? Get.theme.colorScheme
                                                  .primaryContainer
                                              : Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),

                /// MAIN BODY
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: double.infinity,
                  height: 550,
                  child: PageView.builder(
                    itemCount: icons.length,
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return current == 1
                          ? FutureBuilder(
                              future: controller.loadDataPlus(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Get.theme.colorScheme.primary,
                                    ),
                                  );
                                }

                                if (!snapshot.hasData) {
                                  return Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Center(
                                          child: AutoSizeText(
                                            minFontSize: 10,
                                            'Receitas não cadastradas!',
                                            style: Get.textTheme.titleLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Get.theme.colorScheme
                                                        .primary,
                                                    fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var listItemPlus = snapshot.data!.map((e) {
                                      return FinanceModel(
                                        idFinance: e.idFinance,
                                        description: e.description,
                                        value: e.value,
                                        type: e.type,
                                        date: e.date,
                                        urlImage: e.urlImage,
                                      );
                                    }).toList();

                                    return index == 0
                                        ? Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  FutureBuilder(
                                                      future: controller
                                                          .getValuesPlus(),
                                                      builder: (context,
                                                          AsyncSnapshot
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
                                                            child: SizedBox(
                                                              height: 30,
                                                              width: 30,
                                                              child: Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .primary,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }

                                                        if (!snapshot.hasData) {
                                                          return const SizedBox();
                                                        }

                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                      14.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'TOTAL DE RECEITAS',
                                                                style: Get
                                                                    .textTheme
                                                                    .titleLarge
                                                                    ?.copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Get
                                                                            .theme
                                                                            .colorScheme
                                                                            .surface,
                                                                        fontSize:
                                                                            20),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Text(
                                                                FormatterHelper.formatCurrency(
                                                                    double.parse(
                                                                        snapshot
                                                                            .data!
                                                                            .toString())),
                                                                style: Get
                                                                    .textTheme
                                                                    .titleLarge
                                                                    ?.copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Get
                                                                            .theme
                                                                            .colorScheme
                                                                            .surface,
                                                                        fontSize:
                                                                            20),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                ],
                                              ),
                                              buildCard(
                                                FinanceModel(
                                                  idFinance: listItemPlus[index]
                                                      .idFinance,
                                                  description:
                                                      listItemPlus[index]
                                                          .description,
                                                  value:
                                                      listItemPlus[index].value,
                                                  date:
                                                      listItemPlus[index].date,
                                                  type:
                                                      listItemPlus[index].type,
                                                  urlImage: listItemPlus[index]
                                                      .urlImage,
                                                ),
                                              ),
                                            ],
                                          )
                                        : buildCard(
                                            FinanceModel(
                                              idFinance:
                                                  listItemPlus[index].idFinance,
                                              description: listItemPlus[index]
                                                  .description,
                                              value: listItemPlus[index].value,
                                              date: listItemPlus[index].date,
                                              type: listItemPlus[index].type,
                                              urlImage:
                                                  listItemPlus[index].urlImage,
                                            ),
                                          );
                                  },
                                );
                              },
                            )
                          : current == 2
                              ? FutureBuilder(
                                  future: controller.loadDataMinus(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Get.theme.colorScheme.primary,
                                        ),
                                      );
                                    }

                                    if (!snapshot.hasData) {
                                      return Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Center(
                                              child: AutoSizeText(
                                                minFontSize: 10,
                                                'Receitas não cadastradas!',
                                                style: Get.textTheme.titleLarge
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .primary,
                                                        fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    return ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        var listItemPlus =
                                            snapshot.data!.map((e) {
                                          return FinanceModel(
                                            idFinance: e.idFinance,
                                            description: e.description,
                                            value: e.value,
                                            type: e.type,
                                            date: e.date,
                                            urlImage: e.urlImage,
                                          );
                                        }).toList();
                                        return index == 0
                                            ? Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      FutureBuilder(
                                                          future: controller
                                                              .getValuesMinus(),
                                                          builder: (context,
                                                              AsyncSnapshot
                                                                  snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        12.0),
                                                                child: SizedBox(
                                                                  height: 30,
                                                                  width: 30,
                                                                  child: Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: Get
                                                                          .theme
                                                                          .colorScheme
                                                                          .primary,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }

                                                            if (!snapshot
                                                                .hasData) {
                                                              return const SizedBox();
                                                            }

                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          14.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'TOTAL DE DESPESAS',
                                                                    style: Get.textTheme.titleLarge?.copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Get
                                                                            .theme
                                                                            .colorScheme
                                                                            .surface,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    FormatterHelper.formatCurrency(double.parse(
                                                                        snapshot
                                                                            .data!
                                                                            .toString())),
                                                                    style: Get.textTheme.titleLarge?.copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Get
                                                                            .theme
                                                                            .colorScheme
                                                                            .surface,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }),
                                                    ],
                                                  ),
                                                  buildCard(
                                                    FinanceModel(
                                                      idFinance:
                                                          listItemPlus[index]
                                                              .idFinance,
                                                      description:
                                                          listItemPlus[index]
                                                              .description,
                                                      value: listItemPlus[index]
                                                          .value,
                                                      date: listItemPlus[index]
                                                          .date,
                                                      type: listItemPlus[index]
                                                          .type,
                                                      urlImage:
                                                          listItemPlus[index]
                                                              .urlImage,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : buildCard(
                                                FinanceModel(
                                                  idFinance: listItemPlus[index]
                                                      .idFinance,
                                                  description:
                                                      listItemPlus[index]
                                                          .description,
                                                  value:
                                                      listItemPlus[index].value,
                                                  date:
                                                      listItemPlus[index].date,
                                                  type:
                                                      listItemPlus[index].type,
                                                  urlImage: listItemPlus[index]
                                                      .urlImage,
                                                ),
                                              );
                                      },
                                    );
                                  },
                                )
                              : FutureBuilder(
                                  future: controller.loadDataPlus(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Get.theme.colorScheme.primary,
                                        ),
                                      );
                                    }

                                    if (!snapshot.hasData) {
                                      return Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Center(
                                              child: AutoSizeText(
                                                minFontSize: 10,
                                                'Receitas não cadastradas!',
                                                style: Get.textTheme.titleLarge
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .primary,
                                                        fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: Center(
                                                child: AutoSizeText(
                                                  minFontSize: 10,
                                                  'RESUMO',
                                                  style: Get
                                                      .textTheme.titleLarge
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Get
                                                              .theme
                                                              .colorScheme
                                                              .surface,
                                                          fontSize: 18),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: Get.width,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 2,
                                                  color: Get.theme.colorScheme
                                                      .primary,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                  vertical: 20,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FutureBuilder(
                                                      future: controller
                                                          .getValuesPlus(),
                                                      builder: (context,
                                                          AsyncSnapshot
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Center(
                                                              child: SizedBox(
                                                                width: 30,
                                                                height: 30,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .primary,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }

                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Icon(
                                                                  FontAwesomeIcons
                                                                      .circlePlus,
                                                                  color: Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .primaryContainer,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Receitas:',
                                                                style:
                                                                    TextStyle(
                                                                  color: Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .primaryContainer,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              Text(
                                                                FormatterHelper.formatCurrency(
                                                                    double.parse(
                                                                        snapshot
                                                                            .data
                                                                            .toString())),
                                                                style:
                                                                    TextStyle(
                                                                  color: Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .primaryContainer,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    FutureBuilder(
                                                      future: controller
                                                          .getValuesMinus(),
                                                      builder: (context,
                                                          AsyncSnapshot
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Center(
                                                              child: SizedBox(
                                                                width: 30,
                                                                height: 30,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .primary,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }

                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Icon(
                                                                  FontAwesomeIcons
                                                                      .circleMinus,
                                                                  color: Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .primaryContainer,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Despesas:',
                                                                style:
                                                                    TextStyle(
                                                                  color: Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .primaryContainer,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              Text(
                                                                FormatterHelper.formatCurrency(
                                                                    double.parse(
                                                                        snapshot
                                                                            .data
                                                                            .toString())),
                                                                style:
                                                                    TextStyle(
                                                                  color: Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .primaryContainer,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 50.0),
                                                      child: Divider(
                                                        thickness: 3,
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .primaryContainer,
                                                      ),
                                                    ),
                                                    FutureBuilder(
                                                      future: controller
                                                          .getValuesTotal(),
                                                      builder: (context,
                                                          AsyncSnapshot
                                                              snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Center(
                                                              child: SizedBox(
                                                                width: 30,
                                                                height: 30,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .primary,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }

                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'Saldo:',
                                                                style:
                                                                    TextStyle(
                                                                  color: Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .primaryContainer,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              Text(
                                                                FormatterHelper.formatCurrency(
                                                                    double.parse(
                                                                        snapshot
                                                                            .data
                                                                            .toString())),
                                                                style:
                                                                    TextStyle(
                                                                  color: Get
                                                                      .theme
                                                                      .colorScheme
                                                                      .primaryContainer,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _bottomButtons(),
    );
  }

  Widget _bottomButtons() {
    return current == 1
        ? FloatingActionButton.extended(
            elevation: 0,
            isExtended: true,
            label: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Get.theme.colorScheme.background,
                  size: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                AutoSizeText(
                  minFontSize: 10,
                  'ADICIONAR\nRECEITA',
                  style: TextStyle(
                      fontSize: 14, color: Get.theme.colorScheme.background),
                ),
              ],
            ),
            backgroundColor: Get.theme.colorScheme.primary,
            onPressed: () {
              Get.toNamed(Routes.finance_add);
            },
          )
        : current == 2
            ? FloatingActionButton.extended(
                elevation: 0,
                isExtended: true,
                label: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Get.theme.colorScheme.background,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    AutoSizeText(
                      minFontSize: 10,
                      'ADICIONAR\nDESPESA',
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
              )
            : const SizedBox();
  }

  Card buildCard(FinanceModel itemFinance) {
    var heading =
        FormatterHelper.formatCurrency(double.parse(itemFinance.value));

    var supportingText = itemFinance.description;
    return Card(
      elevation: 4.0,
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                itemFinance.type == 'plus'
                    ? const Icon(
                        FontAwesomeIcons.circlePlus,
                        color: Colors.white,
                        size: 40,
                      )
                    : const Icon(
                        FontAwesomeIcons.circleMinus,
                        color: Colors.white,
                        size: 40,
                      ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  heading,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  itemFinance.date.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            dense: false,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              supportingText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              itemFinance.urlImage == ""
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Sem comprovante',
                        style: TextStyle(
                            color: Get.theme.colorScheme.onPrimaryContainer,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Com comprovante',
                        style: TextStyle(
                            color: Get.theme.colorScheme.onPrimaryContainer,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  FontAwesomeIcons.eye,
                  color: Get.theme.colorScheme.onPrimaryContainer,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  FontAwesomeIcons.pen,
                  color: Get.theme.colorScheme.onPrimaryContainer,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  FontAwesomeIcons.trash,
                  color: Get.theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
