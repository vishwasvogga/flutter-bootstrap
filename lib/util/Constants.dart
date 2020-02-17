import 'package:flutter/material.dart';

class Constants {
  //App key
  static const App_key = "ikonsult";

  static const Map<int, Color> primaryColorSwatch = {
    50: Color.fromRGBO(0xea, 0x2e, 0x80, .1),
    100: Color.fromRGBO(0xea, 0x2e, 0x80, .2),
    200: Color.fromRGBO(0xea, 0x2e, 0x80, .3),
    300: Color.fromRGBO(0xea, 0x2e, 0x80, .4),
    400: Color.fromRGBO(0xea, 0x2e, 0x80, .5),
    500: Color.fromRGBO(0xea, 0x2e, 0x80, .6),
    600: Color.fromRGBO(0xea, 0x2e, 0x80, .7),
    700: Color.fromRGBO(0xea, 0x2e, 0x80, .8),
    800: Color.fromRGBO(0xea, 0x2e, 0x80, .9),
    900: Color.fromRGBO(0xea, 0x2e, 0x80, 1),
  };

  //primary color of the application  126caa
  static Color ColorPrimary =Color(0xFFEA2E80); //MaterialColor(0xFF1A237E, primaryColorSwatch) ;
  static Color ColorSecondary = Color(0xFF126caa);
  static Color ColorDisabled = Colors.grey;
  static Color ColorBackGround =Colors.white;
  static Color ColorBackGrad1 = Color(0xE0000000);
  static Color ColorBackGrad2 = Color(0xEE000000);
  //font color
  static Color ColorTextPrimary = Colors.black;
  static Color ColorTextHighLight =ColorPrimary;
  static Color ColorTextSuccess = Colors.green;

  //font sizes
  static const double h1 = 35;
  static const double h2 = 30;
  static const double h3 = 25;
  static const double h4 = 20;
  static const double h5 = 15;
  static const double h6 = 12;


  //network
  static const String baseUrl ="https://google.com";
  static const String login = "/doctor/auth/login";
  static const String forgotPassword = "/doctor/auth/forgot-password";
  static const String changePassword = "/doctor/auth/reset-password";
  static const String getAppointments = "/doctor/appointments?doctor_id=";
  static const String ApproveAppointments = "/doctor/appointments/";
  static const String cancelAppointments ="/doctor/appointments/";
  static const String getAvailability = "/doctor/availability?doctor_id=";
  static const String putAvailability = "/doctor/availability";
  static const String getPatients = "/doctor/patients?doctor_id=";
  static const String writePrescription = "/prescription/write";
  static const String venderRegister = "/doctor/profile/notification?doctor_id=";
  static const String profile = "/doctor/profile/";
  static const String mediaUpload = '/media/upload';
  static const String add_prescription = "/prescription/write";


  //error codes
  static const errors = [
    {'code': 1000, 'key': "err_in_app_ver"},
    {'code': -1, 'key': "err_in_connection"},
    {'code': 1002, 'key': "usr_not_found"},
    {'code': 1062, 'key': "usr_already_exists"},
    {'code': 1004, 'key': "user_pass_mis_match"},
    {'code': 10002, 'key': "you_have_entered_wrong"},
    {'code': -2, 'key': "token_expire"}
  ];
}
