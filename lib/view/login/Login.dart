import 'package:flutter/material.dart';
import 'package:pocvideocall/util/util.dart';
import 'package:pocvideocall/view/model/User.dart';
import '../../util/CommonElements.dart';
import '../../util/transations.dart';
import '../../util/Constants.dart';
import '../../util/ProgressDialog.dart';
import './Controller.dart';

class Login extends StatefulWidget {
  @override
  State createState() {return _Login();}
}

class _Login extends State<Login> {
  Controller _controller;
  GlobalKey<ScaffoldState> key  = new GlobalKey<ScaffoldState>();
  bool shallShowProgressDialog=false;
  String tag = "Login";

  @override
  void initState() {
    super.initState();
    _controller = new Controller();
  }

  @override
  Widget build(BuildContext context) {

    return  new WillPopScope(child: Scaffold(key:key,
      body: ProgressDialog().ProgressDialogMask(shallShowProgressDialog, Translations.of(context).text('almost_there'),
          SizedBox(child:  Center(
            child: BbMaterialApp.verticalStackWdiget([
              //space
              BbMaterialApp.getSizedBox(double.maxFinite, 100.0),
              //edit text email
              SizedBox(height: 40.0,width: 300.0,child:   TextField(
                key: new Key("email"),
                obscureText: false,
                controller: _controller.tc_email,
                style: BbMaterialApp.textFieldStyle,
                autofocus: false,
                focusNode: _controller.fc_email,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                    hintText: Translations.of(context).text('ul_email'),
                    hintStyle: BbMaterialApp.hintTextStyle,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(color: Constants.ColorTextPrimary)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(color: Constants.ColorTextPrimary))),
                onSubmitted: (data) {
                  FocusScope.of(context).requestFocus(_controller.fc_password);
                },
              ),),
              SizedBox(height: 32.0,width: double.maxFinite,),
              //edit text password
              SizedBox(height: 40.0,width: 300.0,child: TextField(
                key: new Key("password"),
                controller: _controller.tc_password,
                obscureText: true,
                style: BbMaterialApp.textFieldStyle,
                focusNode: _controller.fc_password,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                    hintText: Translations.of(context).text('ul_password'),
                    hintStyle: BbMaterialApp.hintTextStyle,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(color: Constants.ColorTextPrimary)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(color: Constants.ColorTextPrimary))),
              ),),
              SizedBox(height: 48.0,width: double.maxFinite,),
              BbMaterialApp.getOutlineButton(Translations.of(context).text('dc_login'), () async{
                setState(() {
                  shallShowProgressDialog = true;
                });
                User user = await _controller.login(context, key);
                Util.log(user.toString(), tag);
                setState(() {
                  shallShowProgressDialog = false;
                });
              }),
              SizedBox(height: 32.0,width: double.maxFinite,),
              FlatButton(child: BbTextViewLight(Translations.of(context).text('ul_forgot_password'), Constants.h6, Constants.ColorTextPrimary),onPressed: (){
                // send otp and await for otp
                _controller.fp_askEmail(context,key);
              },)
            ]),
          ),width: double.infinity,height: Util.getScreenHeight(context),),isScroll: true),
    ), onWillPop: () async => true);



  }
}
