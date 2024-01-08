import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uruguaiana/app/modules/auth/login/login_controller.dart';
import 'package:uruguaiana/app/repository/auth_repository.dart';

class CustomDrawer extends StatelessWidget {
  GetStorage storage = GetStorage();
  CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    LoginController controller = LoginController(AuthRepository());
    return Drawer(
      width: Get.width * 0.80,
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

            if (storage.read('id_user') == null ||
                storage.read('id_user') == '') {
              return ListView(
                children: [
                  buildDrawerHeaderNotLogged(),
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
                    icon: Icons.library_books,
                    text: "Proposta",
                    onTap: () => navigate(7),
                    tileColor: Get.currentRoute == '/proposal'
                        ? Get.theme.colorScheme.primary
                        : null,
                    textIconColor: Get.currentRoute == '/proposal'
                        ? Get.theme.colorScheme.onPrimaryContainer
                        : Get.theme.colorScheme.primary,
                  ),
                  buildDrawerItem(
                    icon: Icons.lightbulb_outline,
                    text: "Colabore e faça parte",
                    onTap: () => navigate(4),
                    tileColor: Get.currentRoute == '/collaborate_add'
                        ? Get.theme.colorScheme.primary
                        : null,
                    textIconColor: Get.currentRoute == '/collaborate_add'
                        ? Get.theme.colorScheme.onPrimaryContainer
                        : Get.theme.colorScheme.primary,
                  ),
                  buildDrawerItem(
                    icon: Icons.note_add_outlined,
                    text: "Minhas colaborações",
                    onTap: () => navigate(8),
                    tileColor: Get.currentRoute == '/my_colaborate'
                        ? Get.theme.colorScheme.primary
                        : null,
                    textIconColor: Get.currentRoute == '/my_colaborate'
                        ? Get.theme.colorScheme.onPrimaryContainer
                        : Get.theme.colorScheme.primary,
                  ),
                  buildDrawerItem(
                    icon: Icons.settings,
                    text: 'Administração',
                    onTap: () => navigate(6),
                    tileColor: Get.currentRoute == '/login'
                        ? Get.theme.colorScheme.primary
                        : null,
                    textIconColor: Get.currentRoute == '/login'
                        ? Get.theme.colorScheme.onPrimaryContainer
                        : Get.theme.colorScheme.primary,
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
                          if (snap2.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          }

                          if (snap2.data!.documents.isEmpty) {
                            return const SizedBox();
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Uri url = Uri.parse(snap2.data?.documents
                                            .first.data['url'] ??
                                        '');
                                    launchUrl(url);
                                  },
                                  icon: const Icon(FontAwesomeIcons.facebook),
                                  iconSize: 40,
                                  color: Get.theme.colorScheme.primary,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      FutureBuilder(
                        future: controller.getContactInstagram(),
                        builder: (context, snap3) {
                          if (snap3.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          }

                          if (snap3.data!.documents.isEmpty) {
                            return const SizedBox();
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Uri url = Uri.parse(snap3.data?.documents
                                            .first.data['url'] ??
                                        '');
                                    launchUrl(url);
                                  },
                                  icon: const Icon(FontAwesomeIcons.instagram),
                                  iconSize: 40,
                                  color: Get.theme.colorScheme.primary,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      FutureBuilder(
                        future: controller.getContactWhatsapp(),
                        builder: (context, snap4) {
                          if (snap4.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          }

                          if (snap4.data!.documents.isEmpty) {
                            return const SizedBox();
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Uri url = Uri.parse(snap4.data?.documents
                                            .first.data['url'] ??
                                        '');
                                    launchUrl(url);
                                  },
                                  icon: const Icon(FontAwesomeIcons.whatsapp),
                                  iconSize: 40,
                                  color: Get.theme.colorScheme.primary,
                                ),
                              ],
                            );
                          }
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
                        child: const AutoSizeText(
                          minFontSize: 10,
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
              return ListView(
                children: [
                  buildDrawerHeaderLogged(),
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
                    icon: Icons.library_books,
                    text: "Proposta",
                    onTap: () => navigate(7),
                    tileColor: Get.currentRoute == '/proposal'
                        ? Get.theme.colorScheme.primary
                        : null,
                    textIconColor: Get.currentRoute == '/proposal'
                        ? Get.theme.colorScheme.onPrimaryContainer
                        : Get.theme.colorScheme.primary,
                  ),
                  buildDrawerItem(
                    icon: Icons.lightbulb_outline,
                    text: "Colabore e faça parte",
                    onTap: () => navigate(4),
                    tileColor: Get.currentRoute == '/collaborate'
                        ? Get.theme.colorScheme.primary
                        : null,
                    textIconColor: Get.currentRoute == '/collaborate'
                        ? Get.theme.colorScheme.onPrimaryContainer
                        : Get.theme.colorScheme.primary,
                  ),
                  // buildDrawerItem(
                  //   icon: Icons.person,
                  //   text: "Perfil",
                  //   onTap: () => navigate(1),
                  //   tileColor: Get.currentRoute == '/profile'
                  //       ? Get.theme.colorScheme.primary
                  //       : null,
                  //   textIconColor: Get.currentRoute == '/profile'
                  //       ? Get.theme.colorScheme.onPrimaryContainer
                  //       : Get.theme.colorScheme.primary,
                  // ),
                  // buildDrawerItem(
                  //   icon: Icons.note_add_outlined,
                  //   text: "Minhas colaborações",
                  //   onTap: () => navigate(8),
                  //   tileColor: Get.currentRoute == '/my_colaborate'
                  //       ? Get.theme.colorScheme.primary
                  //       : null,
                  //   textIconColor: Get.currentRoute == '/my_colaborate'
                  //       ? Get.theme.colorScheme.onPrimaryContainer
                  //       : Get.theme.colorScheme.primary,
                  // ),
                  buildDrawerItem(
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
                          if (snap2.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          }

                          if (snap2.data!.documents.isEmpty) {
                            return const SizedBox();
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Uri url = Uri.parse(snap2.data?.documents
                                            .first.data['url'] ??
                                        '');
                                    launchUrl(url);
                                  },
                                  icon: const Icon(FontAwesomeIcons.facebook),
                                  iconSize: 40,
                                  color: Get.theme.colorScheme.primary,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      FutureBuilder(
                        future: controller.getContactInstagram(),
                        builder: (context, snap3) {
                          if (snap3.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          }

                          if (snap3.data!.documents.isEmpty) {
                            return const SizedBox();
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Uri url = Uri.parse(snap3.data?.documents
                                            .first.data['url'] ??
                                        '');
                                    launchUrl(url);
                                  },
                                  icon: const Icon(FontAwesomeIcons.instagram),
                                  iconSize: 40,
                                  color: Get.theme.colorScheme.primary,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      FutureBuilder(
                        future: controller.getContactWhatsapp(),
                        builder: (context, snap4) {
                          if (snap4.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          }

                          if (snap4.data!.documents.isEmpty) {
                            return const SizedBox();
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Uri url = Uri.parse(snap4.data?.documents
                                            .first.data['url'] ??
                                        '');
                                    launchUrl(url);
                                  },
                                  icon: const Icon(FontAwesomeIcons.whatsapp),
                                  iconSize: 40,
                                  color: Get.theme.colorScheme.primary,
                                ),
                              ],
                            );
                          }
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
                        child: const AutoSizeText(
                          minFontSize: 10,
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
            }
          }),
    );
  }

  Widget buildDrawerHeaderLogged() {
    var urlAvatar = GetStorage().read('url_avatar');
    var name = GetStorage().read('name');
    var email = GetStorage().read('email');
    var profile = GetStorage().read('profile');

    return UserAccountsDrawerHeader(
      accountName: AutoSizeText(
        name,
        minFontSize: 10.0,
      ),
      accountEmail: AutoSizeText(email, minFontSize: 10.0),
      currentAccountPicture: urlAvatar != ''
          ? CircleAvatar(backgroundImage: NetworkImage(urlAvatar))
          : Initicon(
              text: name,
              elevation: 4,
              size: 80,
              backgroundColor: Get.theme.colorScheme.onPrimaryContainer,
              style: TextStyle(color: Get.theme.colorScheme.primary),
            ),
      currentAccountPictureSize: const Size.square(72),
      otherAccountsPictures: [
        AutoSizeText(
          profile,
          style: TextStyle(
            color: Get.theme.colorScheme.onPrimaryContainer,
            fontSize: 14,
          ),
          minFontSize: 10.0,
        ),
      ],
      otherAccountsPicturesSize: const Size.square(100),
    );
  }

  Widget buildDrawerHeaderNotLogged() {
    return UserAccountsDrawerHeader(
      accountName: const AutoSizeText(
        'Convidado',
        minFontSize: 10.0,
      ),
      accountEmail: null,
      currentAccountPicture: Initicon(
        text: 'Convidado',
        elevation: 4,
        size: 80,
        backgroundColor: Get.theme.colorScheme.onPrimaryContainer,
        style: TextStyle(
          color: Get.theme.colorScheme.primary,
          fontSize: 40,
        ),
      ),
      currentAccountPictureSize: const Size.square(80),
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
      title: AutoSizeText(
        text,
        minFontSize: 10.0,
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
      Get.toNamed('/collaborate_add');
    } else if (index == 5) {
      Get.toNamed('/news');
    } else if (index == 6) {
      Get.toNamed('/login');
    } else if (index == 7) {
      Get.toNamed('/proposal');
    } else if (index == 8) {
      Get.toNamed('/my_colaborate');
    }
  }
}
