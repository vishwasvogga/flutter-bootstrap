import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pocvideocall/service/AppState.dart';
import 'package:pocvideocall/util/BHttp.dart';
import 'package:pocvideocall/util/CommonElements.dart';
import 'package:pocvideocall/util/Constants.dart';
import 'package:pocvideocall/util/SnackBar.dart';
import 'package:pocvideocall/view/dashboard/dashboard.dart';
import 'package:pocvideocall/view/login/ForgotPassword.dart';
import 'package:pocvideocall/view/model/User.dart';
import '../../util/util.dart';
import '../../util/transations.dart';

class Controller {
  FocusNode fc_email = new FocusNode();
  FocusNode fc_password = new FocusNode();
  TextEditingController tc_email = new TextEditingController(text: '');
  TextEditingController tc_password = new TextEditingController(text: '');
  String tag = "Login controller";

  login(BuildContext context, Key key) async {
    String email = tc_email.text.toString();
    String password = tc_password.text.toString();
    //check email
    if (email.length > 0 && email.contains('@') && email.contains('.')) {
      //check password
      if (password.length > 0) {
        //try to login
        var body = {"email": email, "password": password};
        var resp =
            await Bhttp().Post(Constants.baseUrl + Constants.login, body);
        Util.log(resp.toString(), tag);
        User user = User();
        user.parse(resp);
        if (user.success == false && user.code == 403) {
          BbSnackBar.showToast(
              Translations.of(context).text('invalid_creds'), context, key);
        } else if (user.success == false) {
          BbSnackBar.showToast(
              Translations.of(context).text('unknown_err'), context, key);
        } else if (user.success == true &&
            user.code == 200 &&
            user.token != null &&
            user.token != "") {
          //login success
          BbSnackBar.showToast(
              Translations.of(context).text('ul_successfully_logged_in'),
              context,
              key);
          //store the token and go to dashboard
          await Util.bearerToken(token: user.token);
          await Util.currentUser(user: jsonEncode(resp));
          AppState.user = user;
          Navigator.push(context, SlideRightRoute(page: Dashboard()));
        }
        return user;
      } else {
        BbSnackBar.showToast(
            Translations.of(context).text('ul_enter_valid_password'),
            context,
            key);
        return User();
      }
    } else {
      BbSnackBar.showToast(
          Translations.of(context).text('ul_enter_valid_user'), context, key);
      return User();
    }
  }

  logout(BuildContext context) {
    Util.bearerToken(token: "");
    Util.currentUser(user: {});
    AppState.user = new User();
    Navigator.popAndPushNamed(context, '/login');
  }

  venderRegister(String pushToken) async {
    var body = {"token": pushToken};
    var resp = await Bhttp().Put(
        Constants.baseUrl + Constants.venderRegister + AppState.user.doctor_id,
        body);
    Util.log(resp.toString(), tag);
  }

  resetPassword(dynamic  body) async {
    var resp = await Bhttp().Post(
        Constants.baseUrl + Constants.changePassword,
        body);
    Util.log(resp.toString(), tag);
    return resp;
  }

  fp_askEmail(BuildContext context, Key key) {
    TextEditingController tc_memail = new TextEditingController(text: "");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: BbTextViewLight(
              Translations.of(context).text('forgot_password_phrase'),
              Constants.h4,
              Constants.ColorTextPrimary),
          content: SizedBox(
            height: 40.0,
            width: 200.0,
            child: TextField(
              key: new Key("email"),
              obscureText: false,
              controller: tc_memail,
              style: BbMaterialApp.textFieldStyle,
              autofocus: false,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
                  hintText: Translations.of(context).text('ul_email'),
                  hintStyle: BbMaterialApp.hintTextStyle,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide:
                          BorderSide(color: Constants.ColorTextPrimary)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide:
                          BorderSide(color: Constants.ColorTextPrimary))),
              onSubmitted: (data) {
                //send otp and
                //go to OTP page
                String email = tc_memail.text;
                if (email == "" ||
                    !email.contains('@') ||
                    !email.contains('.')) {
                  BbSnackBar.showToast(
                      Translations.of(context).text('ul_enter_valid_user'),
                      context,
                      key);
                } else {
                  ///
                  Navigator.of(context).pop();
                  Navigator.push(context, SlideRightRoute(page: ForgotPassword(email)));

                  Bhttp().Post(Constants.baseUrl + Constants.forgotPassword,
                      {"email": email}).then((data) {
                    Util.log(data.toString(), tag);
                    if (data['success'] == true) {
                      //go to reset page

                    } else {
//                      BbSnackBar.showToast(
//                          Translations.of(context).text('unknown_err'),
//                          context,
//                          key);
                    }
                  });
                }
              },
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Proceed"),
              onPressed: () {
                //send otp and
                //go to OTP page
                String email = tc_memail.text;
                if (email == "" ||
                    !email.contains('@') ||
                    !email.contains('.')) {
                  BbSnackBar.showToast(
                      Translations.of(context).text('ul_enter_valid_user'),
                      context,
                      key);
                }else {
                  ///
                  Navigator.of(context).pop();
                  Navigator.push(context, SlideRightRoute(page: ForgotPassword(email)));

                  Bhttp().Post(Constants.baseUrl + Constants.forgotPassword,
                      {"email": email}).then((data) {
                    Util.log(data.toString(), tag);
                    if (data['success'] == true) {
                      //go to reset page

                    } else {
//                      BbSnackBar.showToast(
//                          Translations.of(context).text('unknown_err'),
//                          context,
//                          key);
                    }
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}
