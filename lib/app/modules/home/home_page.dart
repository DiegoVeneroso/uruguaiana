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
      body: SafeArea(
        child: Padding(
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
                        return SingleChildScrollView(
                          child: Column(
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
                                                color: Get.theme.colorScheme
                                                    .secondary,
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
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.foundItem.value[index].name,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        controller.itemList[index].cidade
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Get.theme.colorScheme.primary),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      controller.getDialog(
                                          idItem: controller.itemList[index].id
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
                                        'name': controller.itemList[index].name
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
                                  IconButton(
                                    onPressed: () {
                                      Get.toNamed('/home_detail', parameters: {
                                        'name': controller.itemList[index].name
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
                                      Icons.visibility,
                                      color: Get.theme.colorScheme.surface,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
