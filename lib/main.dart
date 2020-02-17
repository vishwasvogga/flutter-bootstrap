import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pocvideocall/service/AppState.dart';
import 'package:pocvideocall/util/util.dart';
import 'package:pocvideocall/view/model/User.dart';
import 'package:pocvideocall/view/splash.dart';
import './util/CommonElements.dart';
import './view/login/Login.dart';
import './view/dashboard/dashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  State createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp>{
  //initial route
  Widget initialRoue = Splash();
  String tag = "main.dart";
  //analytics
  //FirebaseAnalytics analytics = FirebaseAnalytics();
  //form your routes here
  Map<String, WidgetBuilder> getRoutes() {
    Map<String, WidgetBuilder> routes = {
      '/login':(BuildContext context) => new Login(),
    };
    return routes;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Util.log("Initialising the state ", tag);
    Future.delayed(Duration(seconds: 1),(){
      naviagate();
    });
  }


  @override
  Widget build(BuildContext context) {
    //go to the login screen
    return BbMaterialApp.getMaterialCover(BbMaterialApp().getMaterialApp("",
        // just to get th context below main app context
        Builder(builder: (context) {
          return initialRoue;
        }), context, getRoutes(), [
         // FirebaseAnalyticsObserver(analytics: analytics, onError: (error) {}),
        ]));
  }

  naviagate () async {
    //check if user is alredy logged in
    String token = await Util.bearerToken();

    Future.delayed(Duration(seconds: 2),() async {
      if (token != "" && token != null) {
        User user = new User();
        user.parse(jsonDecode(await Util.currentUser()));
      AppState.user = user;
      setState(() {
      initialRoue = Dashboard();
      });
      } else {
      setState(() {
      initialRoue = Login();
      });
      }

    });


  }
}
