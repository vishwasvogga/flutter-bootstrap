import 'package:flutter/material.dart';
import 'package:pocvideocall/view/model/User.dart';

class AppState{
  static BuildContext context;
  static User user = User();
  static ChangeNotifier appointmentChanged = new ChangeNotifier();
}