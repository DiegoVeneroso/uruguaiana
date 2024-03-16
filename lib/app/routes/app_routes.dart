// ignore_for_file: constant_identifier_names

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

  static const my_collaborate = _Paths.my_colaborate;
  static const my_collaborate_detail = _Paths.my_colaborate_detail;

  static const my_contact = _Paths.my_contact;
  static const dev_contact = _Paths.dev_contact;

  static const term_of_use = _Paths.term_of_use;
  static const term_of_use_add = _Paths.term_of_use_add;
  static const term_of_use_edit = _Paths.term_of_use_edit;

  static const proposal = _Paths.proposal;
  static const proposal_add = _Paths.proposal_add;
  static const proposal_detail = _Paths.proposal_detail;
  static const proposal_edit = _Paths.proposal_edit;
  static const proposal_actions = _Paths.proposal_actions;
  static const proposal_actions_add = _Paths.proposal_actions_add;
  static const proposal_actions_edit = _Paths.proposal_actions_edit;
  static const proposal_actions_detail = _Paths.proposal_actions_detail;

  static const notification = _Paths.notification;
  static const notification_add = _Paths.notification_add;

  static const donate = _Paths.donate;
  static const donate_credentials = _Paths.donate_credentials;
  static const donate_add_credentials = _Paths.donate_add_credentials;
  static const donate_edit_credentials = _Paths.donate_edit_credentials;
  static const donate_admin_page = _Paths.donate_admin_page;

  static const calendar = _Paths.calendar;
  static const calendar_add = _Paths.calendar_add;

  static const question = _Paths.question;
  static const question_add = _Paths.question_add;
  static const question_detail = _Paths.question_detail;
  static const question_response = _Paths.question_response;

  static const finance = _Paths.finance;
  static const finance_add = _Paths.finance_add;
  static const finance_detail = _Paths.finance_detail;
  static const finance_edit = _Paths.finance_edit;

  static const jobs = _Paths.jobs;
  static const jobs_add = _Paths.jobs_add;
  static const jobs_detail = _Paths.jobs_detail;
  static const jobs_edit = _Paths.jobs_edit;

  static const activities = _Paths.activities;
  static const activities_add = _Paths.activities_add;
  static const activities_detail = _Paths.activities_detail;
  static const activities_edit = _Paths.activities_edit;

  static const view_people = _Paths.view_people;
  static const view_people_add = _Paths.view_people_add;
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

  static const my_colaborate = '/my_colaborate';
  static const my_colaborate_detail = '/my_collaborate_detail';

  static const my_contact = '/my_contact';
  static const dev_contact = '/dev_contact';

  static const term_of_use = '/term_of_use';
  static const term_of_use_add = '/term_of_use_add';
  static const term_of_use_edit = '/term_of_use_edit';

  static const proposal = '/proposal';
  static const proposal_add = '/proposal_add';
  static const proposal_detail = '/proposal_detail';
  static const proposal_edit = '/proposal_edit';
  static const proposal_actions = '/proposal_actions';
  static const proposal_actions_add = '/proposal_actions_add';
  static const proposal_actions_edit = '/proposal_actions_edit';
  static const proposal_actions_detail = '/proposal_actions_detail';

  static const notification = '/notification';
  static const notification_add = '/notification_add';

  static const donate = '/donate';
  static const donate_credentials = '/donate_credentials';
  static const donate_add_credentials = '/donate_add_credentials';
  static const donate_edit_credentials = '/donate_edit_credentials';
  static const donate_admin_page = '/donate_admin_page';

  static const calendar = '/calendar';
  static const calendar_add = '/calendar_add';

  static const question = '/question';
  static const question_add = '/question_add';
  static const question_detail = '/question_detail';
  static const question_response = '/question_response';

  static const finance = '/finance';
  static const finance_add = '/finance_add';
  static const finance_detail = '/finance_detail';
  static const finance_edit = '/finance_edit';

  static const jobs = '/jobs';
  static const jobs_add = '/jobs_add';
  static const jobs_detail = '/jobs_detail';
  static const jobs_edit = '/jobs_edit';

  static const activities = '/activities';
  static const activities_add = '/activities_add';
  static const activities_detail = '/activities_detail';
  static const activities_edit = '/activities_edit';

  static const view_people = '/view_people';
  static const view_people_add = '/view_people_add';
}
