import 'package:pocvideocall/service/AppState.dart';
import 'package:pocvideocall/util/CommonElements.dart';
import 'package:pocvideocall/util/Constants.dart';
import 'package:pocvideocall/util/ProgressDialog.dart';
import 'package:pocvideocall/util/SnackBar.dart';
import 'package:pocvideocall/util/transations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pocvideocall/view/login/Login.dart';
import './Controller.dart';

import '../../util/util.dart';

class ForgotPassword extends StatefulWidget {
  String email;
  ForgotPassword(this.email) : super();

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  bool shallShowProgressDialog = false;
  String tag = "ForgotPasswordState";
  String pageName = "Reset password";
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController tc_otp = new TextEditingController(text: "");
  TextEditingController tc_new_password = new TextEditingController(text: "");
  TextEditingController tc_old_password= new TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = Container(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: "OTP"),
            enabled: true,
            controller: tc_otp,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "New password"),
            enabled: true,
            controller: tc_new_password,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Confirm password"),
            enabled: true,
            controller: tc_old_password,
          ),

          SizedBox(height: 32,),

          new RaisedButton(onPressed: () async {
            //check if fields are not empty
            String otp = tc_otp.text;
            String newPas = tc_new_password.text;
            String oldPass = tc_old_password.text;

            if(otp==null ||otp==""){
              BbSnackBar.showToast(Translations.of(context).text('invalid_otp'), context, key);
              return;
            }

            if(newPas==null ||newPas=="" || newPas.length<6){
              BbSnackBar.showToast(Translations.of(context).text('invalid_password'), context, key);
              return;
            }

            if(oldPass==null ||oldPass=="" || oldPass.length<6){
              BbSnackBar.showToast(Translations.of(context).text('invalid_password'), context, key);
              return;
            }

            if(newPas != oldPass){
              BbSnackBar.showToast(Translations.of(context).text('invalid_confirm_password'), context, key);
              return;
            }

            //send reset request
            dynamic body ={
              'otp' : otp,
              'email' : widget.email,
              'password':newPas,
              'confirm':oldPass
            };

            setState(() {
              shallShowProgressDialog = true;
            });
            dynamic resp = await Controller().resetPassword(body);
            setState(() {
              shallShowProgressDialog = false;
            });
            if(resp['success']==true){
              BbSnackBar.showToast(
                  Translations.of(context).text('password_reset_success'),
                  context,
                  key);
              Future.delayed(Duration(seconds: 1),(){
                Navigator.push(context, SlideRightRoute(page: Login()));
              });

            }else{
              BbSnackBar.showToast(
                  Translations.of(context).text('unknown_err'),
                  context,
                  key);
            }
          }, child: BbTextViewLight(Translations.of(context).text('change'), Constants.h3, Constants.ColorTextPrimary))
        ],
        shrinkWrap: true,
      ),
      height: (Util.getScreenHeight(context)),
    );

    return new WillPopScope(
        child: BbMaterialApp.StackWdiget([
          Scaffold(
            key: key,
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            appBar: new AppBar(
              title: BbTextView(
                  pageName, Constants.h3, Constants.ColorTextPrimary),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: Builder(
                builder: (context) => IconButton(
                    icon: new Icon(
                      Icons.arrow_back,
                      size: 35,
                      color: Constants.ColorTextPrimary,
                    ),
                    onPressed: () => Navigator.of(context).pop()),
              ),
              actions: <Widget>[],
            ),
            body: ProgressDialog().ProgressDialogMask(shallShowProgressDialog,
                Translations.of(context).text('almost_there'), screen,
                isScroll: false, color: Colors.transparent),
          ),
        ]),
        onWillPop: () async {
          return true;
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
