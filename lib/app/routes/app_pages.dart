import 'package:uruguaiana/app/modules/about/about_bindings.dart';
import 'package:uruguaiana/app/modules/about/about_page.dart';
import 'package:uruguaiana/app/modules/auth/recovery_password/recovery_password_bindings.dart';
import 'package:uruguaiana/app/modules/auth/recovery_password/recovery_password_page.dart';
import 'package:get/get.dart';
import 'package:uruguaiana/app/modules/collaborate/collaborate_bindings.dart';
import 'package:uruguaiana/app/modules/collaborate/collaborate_page.dart';
import 'package:uruguaiana/app/modules/home/home_detail_page.dart';
import 'package:uruguaiana/app/modules/home/home_page.dart';
import 'package:uruguaiana/app/modules/auth/register/register_bindigns.dart';
import 'package:uruguaiana/app/modules/auth/register/register_page.dart';
import 'package:uruguaiana/app/modules/news/news_bindings.dart';
import 'package:uruguaiana/app/modules/news/news_detail_page.dart';
import 'package:uruguaiana/app/modules/news/news_page.dart';
import 'package:uruguaiana/app/modules/profile/profile_bindings.dart';
import 'package:uruguaiana/app/modules/profile/profile_page.dart';

import '../modules/admin/admin_bindings.dart';
import '../modules/admin/admin_page.dart';
import '../modules/auth/login/login_bindings.dart';
import '../modules/auth/login/login_page.dart';
import '../modules/home/home_add_page.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_edit_page.dart';
import '../modules/news/news_add_page.dart';
import '../modules/news/news_edit_page.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_page.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginPage(),
      binding: LoginBindings(),
    ),
    GetPage(
      name: _Paths.register,
      page: () => const RegisterPage(),
      binding: RegisterBindings(),
    ),
    GetPage(
      name: _Paths.recovery_password,
      page: () => const RecoveyPasswordPage(),
      binding: RecoveyPasswordBindings(),
    ),
    GetPage(
      name: _Paths.home,
      page: () => HomePage(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: _Paths.home_add,
      page: () => const HomeAddPage(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: _Paths.home_edit,
      page: () => const HomeEditPage(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: _Paths.home_detail,
      page: () => const HomeDetailPage(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: _Paths.admin,
      page: () => const AdminPage(),
      binding: AdminBindings(),
    ),
    GetPage(
      name: _Paths.profile,
      page: () => const ProfilePage(),
      binding: ProfileBindings(),
    ),

    //news
    GetPage(
      name: _Paths.news,
      page: () => NewsPage(),
      binding: NewsBindings(),
    ),
    GetPage(
      name: _Paths.news_add,
      page: () => const NewsAddPage(),
      binding: NewsBindings(),
    ),
    GetPage(
      name: _Paths.news_edit,
      page: () => const NewsEditPage(),
      binding: NewsBindings(),
    ),
    GetPage(
      name: _Paths.news_detail,
      page: () => const NewsDetailPage(),
      binding: NewsBindings(),
    ),

    //about
    GetPage(
      name: _Paths.about,
      page: () => const AboutPage(),
      binding: AboutBindings(),
    ), //about
    GetPage(
      name: _Paths.collaborate,
      page: () => const CollaboratePage(),
      binding: CollaborateBindings(),
    ),
  ];
}
