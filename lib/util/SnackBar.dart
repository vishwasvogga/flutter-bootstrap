import 'package:flutter/material.dart';
import './transations.dart';
import './Constants.dart';
import './CommonElements.dart';

class BbSnackBar {
  static showToast (String msg,BuildContext context, GlobalKey<ScaffoldState> key,{isButton:bool}){

    ScaffoldFeatureController<SnackBar, SnackBarClosedReason> lastController;

    final snackBar = SnackBar(content: BbTextView(msg,Constants.h5,Constants.ColorTextPrimary), action:
    isButton==false ? null :
    SnackBarAction(
        label:  Translations.of(context).text('ok'),
        onPressed: () {
          // close the snack bar
          lastController.close();
        },

      ),
      backgroundColor: Constants.ColorSecondary,
    );

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    if(key.currentState != null){
      lastController = key.currentState.showSnackBar(snackBar);
    }
  }

  static showToastContext (String msg,BuildContext context,{isButton:bool}){

    ScaffoldFeatureController<SnackBar, SnackBarClosedReason> lastController;

    final snackBar = SnackBar(content: BbTextView(msg,Constants.h5,Constants.ColorTextPrimary), action:
    isButton==false ? null :
    SnackBarAction(
      label:  Translations.of(context).text('ok'),
      onPressed: () {
        // close the snack bar
        lastController.close();
      },

    ),
      backgroundColor: Constants.ColorSecondary,
    );

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    if(context != null){
      lastController =Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}