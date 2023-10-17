import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uruguaiana/app/modules/auth/login/login_controller.dart';
import 'package:uruguaiana/app/repository/auth_repository.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = LoginController(AuthRepository());
    return Drawer(
      backgroundColor: context.theme.colorScheme.background,
      child: Container(
        child: FutureBuilder(
            future: controller.getProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Get.theme.colorScheme.primary,
                  ),
                );
              }

              if (snapshot.hasData) {
                return ListView(
                  children: [
                    buildDrawerHeader(),
                    Divider(
                      color: Get.theme.colorScheme.secondary,
                    ),
                    buildDrawerItem(
                      icon: Icons.home,
                      text: "Página Inicial",
                      onTap: () => navigate(0),
                      tileColor: Get.currentRoute == '/home'
                          ? Get.theme.colorScheme.primary
                          : null,
                      textIconColor: Get.currentRoute == '/home'
                          ? Get.theme.colorScheme.onPrimaryContainer
                          : Get.theme.colorScheme.primary,
                    ),
                    buildDrawerItem(
                      icon: Icons.person,
                      text: "Perfil",
                      onTap: () => navigate(1),
                      tileColor: Get.currentRoute == '/profile'
                          ? Get.theme.colorScheme.primary
                          : null,
                      textIconColor: Get.currentRoute == '/profile'
                          ? Get.theme.colorScheme.onPrimaryContainer
                          : Get.theme.colorScheme.primary,
                    ),
                    Visibility(
                      visible: snapshot.data!.profile == 'Administrador',
                      child: buildDrawerItem(
                        icon: Icons.settings,
                        text: 'Administração',
                        onTap: () => navigate(2),
                        tileColor: Get.currentRoute == '/admin'
                            ? Get.theme.colorScheme.primary
                            : null,
                        textIconColor: Get.currentRoute == '/admin'
                            ? Get.theme.colorScheme.onPrimaryContainer
                            : Get.theme.colorScheme.primary,
                      ),
                    ),
                    buildDrawerItem(
                      icon: Icons.exit_to_app,
                      text: "Sair",
                      onTap: () => controller.logout(),
                      tileColor: null,
                      textIconColor: Get.theme.colorScheme.primary,
                    ),
                  ],
                );
              } else {
                return const Text('');
              }
            }),
      ),
    );
  }

  Widget buildDrawerHeader() {
    var urlAvatar = GetStorage().read('url_avatar');
    var name = GetStorage().read('name');
    var email = GetStorage().read('email');
    var profile = GetStorage().read('profile');

    return UserAccountsDrawerHeader(
      accountName: Text(name),
      accountEmail: Text(email),
      currentAccountPicture: urlAvatar != ''
          ? CircleAvatar(backgroundImage: NetworkImage(urlAvatar))
          : Initicon(
              text: GetStorage().read('name'),
              elevation: 4,
              size: 80,
              backgroundColor: Colors.white,
              style: const TextStyle(color: Colors.blue),
            ),
      currentAccountPictureSize: const Size.square(72),
      otherAccountsPictures: [
        Text(
          profile,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
      otherAccountsPicturesSize: const Size.square(100),
    );
  }

  Widget buildDrawerItem({
    required String text,
    required IconData icon,
    required Color textIconColor,
    required Color? tileColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textIconColor),
      title: Text(
        text,
        style: TextStyle(color: textIconColor),
      ),
      tileColor: tileColor,
      onTap: onTap,
    );
  }

  navigate(int index) {
    if (index == 0) {
      Get.toNamed('/home');
    } else if (index == 1) {
      Get.toNamed('/profile');
    }
    if (index == 2) {
      Get.toNamed('/admin');
    }
  }
}
