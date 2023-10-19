import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_appbar.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_searchformfield.dart';
import 'package:uruguaiana/app/routes/app_pages.dart';

import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_drawer.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

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
                            Get.toNamed('/home_detail', parameters: {
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
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white24,
                                      ),
                                      child: Icon(
                                        Icons.share,
                                        color: Get.theme.colorScheme.background,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed('/home_edit',
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
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white24,
                                          ),
                                          child: Icon(
                                            Icons.edit,
                                            color: Get
                                                .theme.colorScheme.background,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.getDialog(
                                          idItem: controller.itemList[index].id
                                              .toString(),
                                          item: controller
                                              .foundItem.value[index].name,
                                        );
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white24,
                                        ),
                                        child: Icon(
                                          Icons.delete,
                                          color:
                                              Get.theme.colorScheme.background,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 90,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white24,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                        child: Text(
                                          controller
                                              .foundItem.value[index].name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Get
                                                .theme.colorScheme.background,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Get.theme.colorScheme.primary,
        onPressed: () => Get.toNamed(Routes.home_add),
        child: Icon(
          Icons.add,
          color: Get.theme.colorScheme.background,
        ),
      ),
    );
  }
}
