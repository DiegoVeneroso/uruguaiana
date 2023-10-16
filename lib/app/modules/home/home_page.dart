import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:uruguaiana/app/core/ui/widgets/custom_appbar.dart';
import 'package:uruguaiana/app/routes/app_pages.dart';

import '../../core/colors/services/theme_service.dart';
import '../../core/ui/widgets/custom_drawer.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  RxBool searchVisible = false.obs;

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      drawer: const CustomDrawer(),
      appBar: CustomAppbar(
        actionsList: [
          IconButton(
            onPressed: ThemeService().switchTheme,
            icon: const Icon(Icons.contrast),
            color: Get.theme.colorScheme.primary,
          ),
          IconButton(
            onPressed: () => searchVisible.toggle(),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Visibility(
                visible: searchVisible.value,
                child: const SizedBox(
                  height: 20,
                ),
              ),
              Obx(
                () => Visibility(
                  visible: searchVisible.value,
                  child: TextField(
                    onChanged: (value) => controller.filterItem(value),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 16),
                      isDense: true,
                      labelText: 'Pesquisar',
                      labelStyle:
                          TextStyle(color: Get.theme.colorScheme.secondary),
                      errorStyle: TextStyle(color: Get.theme.colorScheme.error),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(23),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        onPressed: () => searchVisible.toggle(),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Obx(() => ListView.builder(
                      itemCount: controller.foundItem.value.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Row(
                              children: [
                                Container(
                                  width: 100,
                                  height: 60,
                                  margin:
                                      const EdgeInsets.fromLTRB(16, 8, 8, 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Stack(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 180,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Get
                                                  .theme.colorScheme.secondary,
                                            ),
                                          ),
                                        ),
                                        Image.network(
                                          controller
                                              .foundItem.value[index].image,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 180,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller
                                              .foundItem.value[index].name,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          controller.itemList[index].cidade
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Get
                                                  .theme.colorScheme.primary),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        controller.getDialog(
                                            idItem: controller
                                                .itemList[index].id
                                                .toString(),
                                            item: controller
                                                .foundItem.value[index].name);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Get.theme.colorScheme.error,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Get.toNamed('/home_edit', parameters: {
                                          'name': controller
                                              .itemList[index].name
                                              .toString(),
                                          'id': controller.itemList[index].id
                                              .toString(),
                                          'image': controller
                                              .itemList[index].image
                                              .toString(),
                                          'cidade': controller
                                              .itemList[index].cidade
                                              .toString(),
                                        });
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Get.theme.colorScheme.surface,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              color: Colors.grey[200],
                              height: 2,
                            ),
                          ],
                        );
                      },
                    )),
              ),
            ],
          ),
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
