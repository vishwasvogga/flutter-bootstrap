import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moment/moment.dart';
import 'package:pocvideocall/service/AppState.dart';
import 'package:pocvideocall/util/BHttp.dart';
import 'package:pocvideocall/util/SnackBar.dart';
import 'package:pocvideocall/util/util.dart';
import 'package:pocvideocall/view/model/Appointment.dart' as ModelAppointment;
import '../../util/CommonElements.dart';
import '../../util/transations.dart';
import '../../util/Constants.dart';
import '../../util/ProgressDialog.dart';
import './Controller.dart';
import '../../util/MDate.dart';
import 'package:flutter/cupertino.dart';

class Prescription extends StatefulWidget {
  String pateint_id;
  String appoint_id;
  Prescription(this.pateint_id, this.appoint_id);

  @override
  State createState() {
    return _Prescription();
  }
}

class _Prescription extends State<Prescription> {
  Controller _controller = Controller();
  bool shallShowProgressDialog = false;
  String tag = "Add Prescription";
  String pageName = "Add Prescription";
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  TextEditingController notes_ctrl = new TextEditingController(text: "");
  String img_url = "";
  String img_media_id = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = Container(
      child: BbMaterialApp.verticalStackWdiget([
        BbMaterialApp.verticalStackWdiget([
          img_url == ""
              ? Container()
              : Image.network(
                  img_url,
                  fit: BoxFit.contain ,
                ),
          SizedBox(
            height: 16,
            width: 10,
          ),
          SizedBox(
            width: 200,
            child: MaterialButton(
              child: img_media_id == "" || img_media_id == null
                  ? BbTextView(Translations.of(context).text('add_image'),
                      Constants.h5, Constants.ColorTextPrimary)
                  : BbTextView(Translations.of(context).text('change_image'),
                      Constants.h5, Constants.ColorTextPrimary),
              color: Colors.transparent,
              padding: EdgeInsets.all(8),
              onPressed: () async {
                //add image

                dynamic action = await showCupertinoModalPopup(
                    context: context,
                    builder: (mcontext) {
                      return _controller.imageAddActions(context);
                    });

                ImageSource source = ImageSource.camera;
                if (action['code'] == 2) {
                  source = ImageSource.gallery;
                }else if(action['code'] == -1){
                  return;
                }

                File file = await Util.pickImage(source);
                setState(() {
                  shallShowProgressDialog = true;
                });
                var resp = await Bhttp().Multipart(
                    Constants.baseUrl + Constants.mediaUpload,
                    file.readAsBytesSync(),
                    Util.getRandomString(8),
                    ['image', 'jpeg']);
                if (resp['success'] == true &&
                    resp['data']['result'] != null &&
                    resp['data']['result'][0] != null) {
                  setState(() {
                    shallShowProgressDialog = false;
                    this.img_url = Constants.baseUrl +
                        "/media/" +
                        resp['data']['result'][0];
                    img_media_id = resp['data']['result'][0];
                  });
                  BbSnackBar.showToast(
                      Translations.of(context).text('success'), context, key);
                  Util.log(resp.toString(), tag);
                } else {
                  setState(() {
                    shallShowProgressDialog = false;
                  });
                  BbSnackBar.showToast(
                      Translations.of(context).text('fail'), context, key);
                  Util.log(resp.toString(), tag);
                }
              },
            ),
          ),
          SizedBox(
            height: 16,
            width: 10,
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: Translations.of(context).text('note')),
            keyboardType: TextInputType.multiline,
            enabled: true,
            maxLines: null,
            controller: notes_ctrl,
          ),
          SizedBox(
            height: 16,
            width: 10,
          ),
        ]),
        MaterialButton(
            child: BbTextView(Translations.of(context).text('add'),
                Constants.h3, Constants.ColorBackGround),
            color: Constants.ColorPrimary,
            padding: EdgeInsets.all(8),
            minWidth: Util.getScreenSize(context)['width'] - 25,
            onPressed: () async {
              //add precsription
              if (img_media_id == "" || img_media_id == null) {
                BbSnackBar.showToast(
                    Translations.of(context).text('valid_image'), context, key);
                return;
              }
              if (notes_ctrl.text == "" || notes_ctrl.text == null) {
                BbSnackBar.showToast(
                    Translations.of(context).text('valid_note'), context, key);
                return;
              }
              dynamic pres = {
                "notes": this.notes_ctrl.text,
                "media": this.img_media_id,
                "user": widget.pateint_id,
                "doctor": AppState.user.doctor_id,
                "appointment": widget.appoint_id
              };
              setState(() {
                shallShowProgressDialog = true;
              });
              dynamic resp = await _controller.addPrescription(pres);
              setState(() {
                shallShowProgressDialog = false;
              });
              if (resp == true) {
                BbSnackBar.showToast(
                    Translations.of(context).text('prescription_added'),
                    context,
                    key);
                Future.delayed(Duration(seconds: 1), () {
                  Navigator.of(context).pop();
                });
              } else {
                BbSnackBar.showToast(
                    Translations.of(context).text('unknown_err'), context, key);
              }
            })
      ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
      height: Util.getScreenHeight(context)+150,
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
                isScroll: true, color: Colors.transparent),
          ),
        ]),
        onWillPop: () async {
          return true;
        });
  }

  @override
  void dispose() {
    super.dispose();
    notes_ctrl.dispose();
  }
}
