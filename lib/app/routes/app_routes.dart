part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const splash = _Paths.splash;
  static const login = _Paths.login;
  static const register = _Paths.register;
  static const recovery_password = _Paths.recovery_password;
  static const code_recovery_password = _Paths.code_recovery_password;
  static const new_password = _Paths.new_password;
  static const home = _Paths.home;
  static const home_add = _Paths.home_add;
  static const home_edit = _Paths.home_edit;
  static const home_detail = _Paths.home_detail;
  static const admin = _Paths.admin;
  static const profile = _Paths.profile;
}

abstract class _Paths {
  _Paths._();
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const recovery_password = '/recovery_password';
  static const code_recovery_password = '/code_recovery_password';
  static const new_password = '/new_password';
  static const home = '/home';
  static const home_add = '/home_add';
  static const home_edit = '/home_edit';
  static const home_detail = '/home_detail';
  static const admin = '/admin';
  static const profile = '/profile';
}
