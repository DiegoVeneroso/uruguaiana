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
}
