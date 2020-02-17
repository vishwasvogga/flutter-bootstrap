import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pocvideocall/util/Constants.dart';
import '../util/CommonElements.dart';


class Splash extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(child: BbMaterialApp.verticalStackWdiget([
      Image.asset('assets/imgs/spalsh.png',height: 450,),
      SizedBox(height: 32,),
      BbTextViewBold("Ilove9months",Constants.h2,Constants.ColorTextPrimary),
      BbTextView("Ultimate Guide to Pregnancy",Constants.h4,Constants.ColorTextPrimary),
    ],mainAxisAlignment: MainAxisAlignment.center),padding: EdgeInsets.all(16),color: Colors.white,);
  }
}
