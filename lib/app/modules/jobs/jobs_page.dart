import 'package:auto_size_text/auto_size_text.dart';
import 'package:eu_faco_parte/app/models/jobs_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/helpers/formatter_helper.dart';
import '../../core/ui/widgets/custom_appbar.dart';
import '../../core/ui/widgets/custom_drawer.dart';
import '../../routes/app_pages.dart';
import './jobs_controller.dart';

class JobsPage extends GetView<JobsController> {
  const JobsPage({Key? key}) : super(key: key);

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
            IconButton(
              onPressed: () => controller.searchVisible.toggle(),
              icon: const Icon(Icons.search),
              color: Get.theme.colorScheme.background,
            ),
          ],
        ),
        body: FutureBuilder(
            future: controller.loadData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
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
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: AutoSizeText(
                          minFontSize: 10,
                          'Trabalhadores não cadastrados!',
                          style: Get.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Get.theme.colorScheme.primary,
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
                  var listItem = snapshot.data!.map((e) {
                    return JobsModel(
                      idJob: e.idJob,
                      name: e.name,
                      phone: e.phone,
                      cpf: e.cpf,
                      rg: e.rg,
                      old: e.old,
                      address: e.address,
                      dateInitJob: e.dateInitJob,
                      urlAvatar: e.urlAvatar,
                      urlDocument: e.urlDocument,
                      pix: e.pix,
                      function: e.function,
                    );
                  }).toList();

                  return index == 0
                      ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'TRABALHADORES',
                                        style: Get.textTheme.titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Get
                                                    .theme.colorScheme.surface,
                                                fontSize: 22),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            buildCard(
                              JobsModel(
                                idJob: listItem[index].idJob,
                                name: listItem[index].name,
                                phone: listItem[index].phone,
                                address: listItem[index].address,
                                cpf: listItem[index].cpf,
                                rg: listItem[index].rg,
                                old: listItem[index].old,
                                dateInitJob: listItem[index].dateInitJob,
                                urlDocument: listItem[index].urlDocument,
                                urlAvatar: listItem[index].urlAvatar,
                                pix: listItem[index].pix,
                                function: listItem[index].function,
                              ),
                            ),
                          ],
                        )
                      : buildCard(
                          JobsModel(
                            idJob: listItem[index].idJob,
                            name: listItem[index].name,
                            phone: listItem[index].phone,
                            address: listItem[index].address,
                            cpf: listItem[index].cpf,
                            rg: listItem[index].rg,
                            old: listItem[index].old,
                            dateInitJob: listItem[index].dateInitJob,
                            urlDocument: listItem[index].urlDocument,
                            urlAvatar: listItem[index].urlAvatar,
                            pix: listItem[index].pix,
                            function: listItem[index].function,
                          ),
                        );
                },
              );
            }),
        floatingActionButton: FloatingActionButton.extended(
          elevation: 4,
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
                'ADICIONAR\nTRABALHADOR',
                style: TextStyle(
                    fontSize: 14, color: Get.theme.colorScheme.background),
              ),
            ],
          ),
          backgroundColor: Get.theme.colorScheme.primary,
          onPressed: () {
            Get.toNamed(Routes.jobs_add);
          },
        ),
      ),
    );
  }

  Card buildCard(JobsModel itemJob) {
    var heading = itemJob.name;

    var supportingText = itemJob.function;
    return Card(
      elevation: 4.0,
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    heading,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            // subtitle: Row(
            //   children: [
            //     Expanded(
            //       child: Text(
            //         itemJob.function.toString(),
            //         style: const TextStyle(
            //           color: Colors.white,
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            leading: Container(
              child: CircleAvatar(
                backgroundColor: Get.theme.colorScheme.onPrimaryContainer,
                backgroundImage: AssetImage(itemJob.urlAvatar),
                radius: 30,
              ),
            ),
            dense: false,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              supportingText.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              // Expanded(
              //   child: Text(
              //     itemJob.phone,
              //     style: TextStyle(
              //         color: Get.theme.colorScheme.onPrimaryContainer,
              //         fontSize: 18,
              //         fontWeight: FontWeight.bold),
              //   ),
              // ),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                onPressed: () {
                  var phone =
                      itemJob.phone.toString().replaceAll(RegExp('[^0-9]'), '');

                  Uri url =
                      Uri.parse('https://api.whatsapp.com/send?phone=$phone');
                  launchUrl(url);
                },
                icon: Icon(
                  FontAwesomeIcons.whatsapp,
                  color: Get.theme.colorScheme.onPrimaryContainer,
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.toNamed(Routes.jobs_detail, parameters: {
                    "JobObjetc": itemJob.toString(),
                  });
                },
                icon: Icon(
                  FontAwesomeIcons.eye,
                  color: Get.theme.colorScheme.onPrimaryContainer,
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.toNamed(Routes.jobs_edit);
                },
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
