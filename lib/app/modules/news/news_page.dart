import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_appbar.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_floating_button.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_searchformfield.dart';
import 'package:uruguaiana/app/modules/news/news_controller.dart';
import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_drawer.dart';
import '../../repository/auth_repository.dart';
import '../../routes/app_pages.dart';
import '../auth/login/login_controller.dart';

class NewsPage extends GetView<NewsController> {
  LoginController loginController = LoginController(AuthRepository());

  NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      drawer: const CustomDrawer(),
      appBar: CustomAppbar(
        actionsList: [
          IconButton(
            onPressed: ThemeService().switchTheme,
            icon: const Icon(Icons.contrast),
            color: Get.theme.colorScheme.onBackground,
          ),
          IconButton(
            onPressed: () => controller.searchVisible.toggle(),
            icon: const Icon(Icons.search),
            color: Get.theme.colorScheme.onBackground,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Obx(
              () => Visibility(
                visible: controller.searchVisible.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: CustomSearchformfield(
                    onChanged: (value) => controller.filterItem(value),
                    onPressed: () => controller.searchVisible.toggle(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.foundItem.value.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed('/news_detail', parameters: {
                              'name':
                                  controller.itemList[index].name.toString(),
                              'id': controller.itemList[index].id.toString(),
                              'image':
                                  controller.itemList[index].image.toString(),
                              'cidade':
                                  controller.itemList[index].cidade.toString(),
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(
                                    controller.foundItem.value[index].image),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Visibility(
                                      visible: controller.isAdmin(),
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.getDialog(
                                            idItem: controller
                                                .itemList[index].id
                                                .toString(),
                                            item: controller
                                                .foundItem.value[index].name,
                                          );
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Get.theme.colorScheme.shadow,
                                          ),
                                          child: Icon(
                                            Icons.delete,
                                            color:
                                                Get.theme.colorScheme.surface,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Visibility(
                                      visible: controller.isAdmin(),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.toNamed('/news_edit',
                                              parameters: {
                                                'name': controller
                                                    .itemList[index].name
                                                    .toString(),
                                                'id': controller
                                                    .itemList[index].id
                                                    .toString(),
                                                'image': controller
                                                    .itemList[index].image
                                                    .toString(),
                                                'cidade': controller
                                                    .itemList[index].cidade
                                                    .toString(),
                                              });
                                        },
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.toNamed('/news_edit',
                                                parameters: {
                                                  'name': controller
                                                      .itemList[index].name
                                                      .toString(),
                                                  'id': controller
                                                      .itemList[index].id
                                                      .toString(),
                                                  'image': controller
                                                      .itemList[index].image
                                                      .toString(),
                                                  'cidade': controller
                                                      .itemList[index].cidade
                                                      .toString(),
                                                });
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color:
                                                  Get.theme.colorScheme.shadow,
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              color:
                                                  Get.theme.colorScheme.surface,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Get.theme.colorScheme.shadow,
                                        ),
                                        child: Icon(
                                          Icons.share,
                                          color: Get.theme.colorScheme.surface,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 140,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Get.theme.colorScheme.shadow,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RichText(
                                            text: TextSpan(
                                              text: controller
                                                  .foundItem.value[index].name,
                                              style: TextStyle(
                                                color: Get
                                                    .theme.colorScheme.surface,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => controller.isAdmin()
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  backgroundColor: Get.theme.colorScheme.primary,
                  onPressed: () => Get.toNamed(Routes.news_add),
                  child: Icon(
                    Icons.add,
                    color: Get.theme.colorScheme.background,
                  ),
                ),
              )
            : const CustomFloatingButton(),
      ),
    );
  }
}
