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
  static const news = _Paths.news;
  static const news_add = _Paths.news_add;
  static const news_edit = _Paths.news_edit;
  static const news_detail = _Paths.news_detail;
  static const about = _Paths.about;
  static const about_add = _Paths.about_add;
  static const about_edit = _Paths.about_edit;
  static const collaborate = _Paths.collaborate;
  static const collaborate_add = _Paths.collaborate_add;
  static const collaborate_detail = _Paths.collaborate_detail;

  static const proposal = _Paths.proposal;
  static const proposal_add = _Paths.proposal_add;
  static const proposal_detail = _Paths.proposal_detail;
  static const proposal_edit = _Paths.proposal_edit;
  static const proposal_actions = _Paths.proposal_actions;
  static const proposal_actions_add = _Paths.proposal_actions_add;

  static const notification = _Paths.notification;
  static const notification_add = _Paths.notification_add;
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
  static const news = '/news';
  static const news_add = '/news_add';
  static const news_edit = '/news_edit';
  static const news_detail = '/news_detail';
  static const about = '/about';
  static const about_add = '/about_add';
  static const about_edit = '/about_edit';
  static const collaborate = '/collaborate';
  static const collaborate_add = '/collaborate_add';
  static const collaborate_detail = '/collaborate_detail';

  static const proposal = '/proposal';
  static const proposal_add = '/proposal_add';
  static const proposal_detail = '/proposal_detail';
  static const proposal_edit = '/proposal_edit';
  static const proposal_actions = '/proposal_actions';
  static const proposal_actions_add = '/proposal_actions_add';

  static const notification = '/notification';
  static const notification_add = '/notification_add';
}
