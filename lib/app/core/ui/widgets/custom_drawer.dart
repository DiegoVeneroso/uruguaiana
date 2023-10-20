import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uruguaiana/app/modules/auth/login/login_controller.dart';
import 'package:uruguaiana/app/repository/auth_repository.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = LoginController(AuthRepository());
    return Drawer(
      backgroundColor: context.theme.colorScheme.background,
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
                    text: "Notícias",
                    onTap: () => navigate(5),
                    tileColor: Get.currentRoute == '/news'
                        ? Get.theme.colorScheme.primary
                        : null,
                    textIconColor: Get.currentRoute == '/news'
                        ? Get.theme.colorScheme.onPrimaryContainer
                        : Get.theme.colorScheme.primary,
                  ),
                  buildDrawerItem(
                    icon: Icons.question_mark,
                    text: "Quem somos",
                    onTap: () => navigate(3),
                    tileColor: Get.currentRoute == '/about'
                        ? Get.theme.colorScheme.primary
                        : null,
                    textIconColor: Get.currentRoute == '/about'
                        ? Get.theme.colorScheme.onPrimaryContainer
                        : Get.theme.colorScheme.primary,
                  ),
                  buildDrawerItem(
                    icon: Icons.lightbulb_outline,
                    text: "Repense e colabore",
                    onTap: () => navigate(4),
                    tileColor: Get.currentRoute == '/collaborate'
                        ? Get.theme.colorScheme.primary
                        : null,
                    textIconColor: Get.currentRoute == '/collaborate'
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future: controller.getContactFacebook(),
                        builder: (context, snap2) {
                          print(snap2.data?.documents.first.data['url']);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Uri url = Uri.parse(
                                      snap2.data?.documents.first.data['url'] ??
                                          '');
                                  launchUrl(url);
                                },
                                icon: const Icon(FontAwesomeIcons.facebook),
                                iconSize: 40,
                                color: Get.theme.colorScheme.primary,
                              ),
                            ],
                          );
                        },
                      ),
                      FutureBuilder(
                        future: controller.getContactInstagram(),
                        builder: (context, snap3) {
                          print(snap3.data?.documents.first.data['url']);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Uri url = Uri.parse(
                                      snap3.data?.documents.first.data['url'] ??
                                          '');
                                  launchUrl(url);
                                },
                                icon: const Icon(FontAwesomeIcons.instagram),
                                iconSize: 40,
                                color: Get.theme.colorScheme.primary,
                              ),
                            ],
                          );
                        },
                      ),
                      FutureBuilder(
                        future: controller.getContactWhatsapp(),
                        builder: (context, snap4) {
                          print(snap4.data?.documents.first.data['url']);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Uri url = Uri.parse(
                                      snap4.data?.documents.first.data['url'] ??
                                          '');
                                  launchUrl(url);
                                },
                                icon: const Icon(FontAwesomeIcons.whatsapp),
                                iconSize: 40,
                                color: Get.theme.colorScheme.primary,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Uri url = Uri.parse('');
                          launchUrl(url);
                        },
                        child: const Text(
                          '2023\u00a9FrontApp',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 133, 3, 81)),
                        ),
                      )
                    ],
                  )
                ],
              );
            } else {
              return const Text('');
            }
          }),
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
    } else if (index == 2) {
      Get.toNamed('/admin');
    } else if (index == 3) {
      Get.toNamed('/about');
    } else if (index == 4) {
      Get.toNamed('/collaborate');
    } else if (index == 5) {
      Get.toNamed('/news');
    }
  }
}
