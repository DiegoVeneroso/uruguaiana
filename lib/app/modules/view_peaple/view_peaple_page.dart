// ignore_for_file: deprecated_member_use

import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_appbar.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_view_responsive_card.dart';
import 'package:eu_faco_parte/app/models/view_model.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:read_more_text/read_more_text.dart';
import '../../routes/app_pages.dart';
import './view_peaple_controller.dart';

class ViewPeaplePage extends GetView<ViewPeapleController> {
  const ViewPeaplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(),
      body: SafeArea(
        child: FutureBuilder(
          future: Future(() {
            return [
              ViewModel(
                  title:
                      'FASDFDSAF Ffdsafas dfsad f adsf sadfsda fsdf dsaf sdf asdf fdsa',
                  description:
                      'fdsfadsf sfsda fsad fdsa fsad fsa fs afsad fsd fdsf asd fads fads fdas  fds fsadf sfds afdsa fdsa fdsaf sdfsdafasd fsadf asdfa sfd sd',
                  date: '16 de março de 2024',
                  nameUser: 'nameUser',
                  phone: 'phone',
                  bairro: 'João Paulo',
                  urlImage:
                      "https://images.unsplash.com/photo-1526666923127-b2970f64b422",
                  status: 'false'),
              ViewModel(
                  title: 'title',
                  description: 'description',
                  date: 'date',
                  nameUser: 'nameUser',
                  phone: 'phone',
                  bairro: 'bairro',
                  urlImage:
                      "https://images.unsplash.com/photo-1526666923127-b2970f64b422",
                  status: 'false'),
            ];
          }),
          builder: (context, AsyncSnapshot snapshot) {
            var listView = snapshot.data!.map((e) {
              return ViewModel(
                title: e.title,
                description: e.description,
                date: e.date,
                nameUser: e.nameUser,
                phone: e.phone,
                bairro: e.bairro,
                urlImage: e.urlImage,
                status: e.status,
              );
            }).toList();
            if (snapshot.connectionState == ConnectionState.none &&
                !snapshot.hasData) {
              //print('project snapshot data is: ${projectSnap.data}');
              return const Text('erro de internet ou sem dados');
            }
            if (snapshot.hasError) {
              print(snapshot
                  .error); //type '_InternalLinkedHashMap<String, dynamic>' is not a subtype of type 'Map<String, String>'
            }
            if (snapshot.hasData) print(snapshot.data);

            getShareDialog() {
              Get.defaultDialog(
                title: 'Compartilhar',
                titleStyle: TextStyle(
                  color: Get.theme.colorScheme.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        var pathImageUrl = await controller
                            .getVideoTypeFileUrl(listView.urlImage);

                        String message =
                            '${listView.title}\n\n${listView.description}';

                        // AppinioSocialShare()
                        //     .shareToWhatsapp(message, filePath: pathImageUrl);
                      },
                      icon: Icon(
                        FontAwesomeIcons.whatsapp,
                        size: 40,
                        color: Get.theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton(
                      onPressed: () async {
                        var pathImageUrl = await controller
                            .getVideoTypeFileUrl(listView.urlImage);

                        String message =
                            '${listView.title}\n\n${listView.description}';

                        // AppinioSocialShare()
                        //     .shareToFacebook(message, pathImageUrl);
                      },
                      icon: Icon(
                        FontAwesomeIcons.facebook,
                        size: 40,
                        color: Get.theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton(
                      onPressed: () async {
                        var pathImageUrl = await controller
                            .getVideoTypeFileUrl(listView.urlImage);

                        // AppinioSocialShare().shareToInstagramFeed(pathImageUrl);
                      },
                      icon: Icon(
                        FontAwesomeIcons.instagram,
                        size: 40,
                        color: Get.theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
                itemCount: listView.length,
                itemBuilder: (ctx, index) {
                  return Column(children: [
                    Visibility(
                      visible: index == 0 ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Center(
                          child: AutoSizeText(
                            minFontSize: 10,
                            'URUGUAIANA QUE O POVO VÊ',
                            style: Get.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Get.theme.colorScheme.surface,
                                fontSize: 22),
                          ),
                        ),
                      ),
                    ),
                    CustomViewResponsiveCard(
                      elevation: 5, //elevation
                      titleGap: 5, // gap between title and leading
                      bgColor: Colors.white,
                      borderColor: Get.theme.colorScheme.primary,
                      shadowColor:
                          Get.theme.colorScheme.shadow, // card background color
                      screenWidth:
                          600, // After this range of screen width it will work as a listtile
                      title: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Bairro: ${listView[index].bairro}',
                              style: TextStyle(
                                  color: Get.theme.colorScheme.primary,
                                  fontSize: 12),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              listView[index].date,
                              style: TextStyle(
                                  color: Get.theme.colorScheme.primary,
                                  fontSize: 12),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              listView[index].title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Get.theme.colorScheme.primary,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      subTitle: ReadMoreText(
                        listView[index].description,
                        numLines: 2,
                        readMoreText: 'Ler mais',
                        readLessText: 'Ler menos',
                        readMoreTextStyle: TextStyle(
                            color: Get.theme.colorScheme.primary,
                            fontWeight: FontWeight.bold),
                        readMoreIconColor: Get.theme.colorScheme.primary,
                        style: TextStyle(
                            color: Get.theme.colorScheme.primary, fontSize: 14),
                      ),

                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          listView[index].urlImage,
                          fit: BoxFit.cover,
                          width: context.width,
                          height: context.height * 0.3,
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            return child;
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: context.width,
                                  height: context.height * 0.3,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Get.theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      action: Positioned(
                        // You can use any kind of widget here
                        right: 5,
                        top: 5,
                        child: Row(
                          children: [
                            Visibility(
                              visible: controller.isAdmin(),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(80, 30),
                                  side: BorderSide(
                                    width: 1.0,
                                    color: Get
                                        .theme.colorScheme.onPrimaryContainer,
                                  ),
                                  backgroundColor: Colors.transparent,
                                  textStyle: TextStyle(
                                    color: Get
                                        .theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                child: Text(
                                  'Aprovar',
                                  style: TextStyle(
                                    color: Get
                                        .theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                getShareDialog();
                              },
                              icon: Icon(
                                Icons.share_rounded,
                                color: Get.theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 8.0, vertical: 4.0),
                    //   child: Container(
                    //     height: context.height * 0.3,
                    //     width: context.width,
                    //     clipBehavior: Clip.antiAlias,
                    //     decoration: BoxDecoration(
                    //       boxShadow: [
                    //         BoxShadow(
                    //             color: Get.theme.colorScheme.primary,
                    //             blurRadius: 3.0,
                    //             offset: const Offset(0.0, 0.5))
                    //       ],
                    //       border: Border.all(
                    //         color: Get.theme.colorScheme.primary,
                    //       ),
                    //       borderRadius: BorderRadius.circular(10),
                    //       color: Get.theme.colorScheme.onPrimaryContainer,
                    //     ),
                    //     child: Center(
                    //       child: Image.network(
                    //         listView[index].urlImage,
                    //         fit: BoxFit.cover,
                    //         width: context.width,
                    //         height: context.height,
                    //         frameBuilder: (context, child, frame,
                    //             wasSynchronouslyLoaded) {
                    //           return child;
                    //         },
                    //         loadingBuilder: (context, child, loadingProgress) {
                    //           if (loadingProgress == null) {
                    //             return child;
                    //           } else {
                    //             return Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Center(
                    //                 child: CircularProgressIndicator(
                    //                   color: Get.theme.colorScheme.primary,
                    //                 ),
                    //               ),
                    //             );
                    //           }
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ]);
                });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        isExtended: true,
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: Get.theme.colorScheme.onPrimaryContainer,
              size: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            AutoSizeText(
              minFontSize: 10,
              'REGISTRAR O\nQUE VOCÊ VÊ',
              style: TextStyle(
                  fontSize: 14,
                  color: Get.theme.colorScheme.onPrimaryContainer),
            ),
          ],
        ),
        backgroundColor: Get.theme.colorScheme.primary,
        onPressed: () {
          Get.toNamed(Routes.view_people_add);
        },
      ),
    );
  }
}
