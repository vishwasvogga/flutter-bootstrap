import 'package:pocvideocall/service/AppState.dart';
import 'package:pocvideocall/util/CommonElements.dart';
import 'package:pocvideocall/util/Constants.dart';
import 'package:pocvideocall/util/ProgressDialog.dart';
import 'package:pocvideocall/util/SnackBar.dart';
import 'package:pocvideocall/util/transations.dart';
import 'package:pocvideocall/view/profile/controller.dart';
import 'package:pocvideocall/view/model/Profile.dart' as ModelProfile;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../util/util.dart';

class Profile extends StatefulWidget {
  Profile() : super();

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  bool shallShowProgressDialog = false;
  String tag = "ProfileState";
  Controller _controller = Controller();
  ModelProfile.Profile _profile = ModelProfile.Profile();
  String pageName = "Profile";
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  String lang = "";
  String speciality="";
  String employement="";

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  getProfile() async {
    setState(() {
      shallShowProgressDialog = true;
    });
    _profile = await _controller.getProfile();
    //get all languages
    _profile.language.forEach((ln){
      lang = lang + ln['title']+" ";
    });
    //get all speciality
        _profile.speciality.forEach((sp){
          speciality = speciality + sp+" ";
        });

    //get all speciality
    _profile.employment.forEach((em){
      employement = employement + em['hospital_name']+","+em['designation']+"\n";
    });
    setState(() {
      shallShowProgressDialog = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = Container();

    if( _profile.name['first']!=null){
      screen = Container(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: _profile.name['first']+" "+_profile.name['last'],
              decoration: InputDecoration(labelText: "name"),
              enabled: false,
            ),
            TextFormField(
              initialValue: _profile.location['address']+" "+_profile.location['city'],
              decoration: InputDecoration(labelText: "city"),
              enabled: false,
            ),
            TextFormField(
              initialValue: _profile.email.toString(),
              decoration: InputDecoration(labelText: "email"),
              enabled: false,
            ),
            TextFormField(
              initialValue: speciality,
              decoration: InputDecoration(labelText: "speciality"),
              enabled: false,
            ),
            TextFormField(
              initialValue: lang,
              decoration: InputDecoration(labelText: "langauge"),
              enabled: false,
            ),
            TextFormField(
              initialValue: _profile.availability == true ? "Yes":"No",
              decoration: InputDecoration(labelText: "available"),
              enabled: false,
            ),
            TextFormField(
              initialValue: _profile.total_experience.toString(),
              decoration: InputDecoration(labelText: "experience"),
              enabled: false,
            ),
            TextFormField(
              initialValue: employement.toString(),
              decoration: InputDecoration(labelText: "employment"),
              enabled: false,
            ),
            TextFormField(
              initialValue: _profile.cost_for_consultation.toString(),
              decoration: InputDecoration(labelText: "cost"),
              enabled: false,
            )
          ],
          shrinkWrap: true,
        ),
        height: (Util.getScreenHeight(context)),
      );
    }

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
