import 'package:get_version/get_version.dart';
import 'package:pocvideocall/service/AppState.dart';
import 'package:pocvideocall/util/CommonElements.dart';
import 'package:pocvideocall/util/Constants.dart';
import 'package:pocvideocall/util/ProgressDialog.dart';
import 'package:pocvideocall/util/transations.dart';
import 'package:pocvideocall/view/appointment/Appointment.dart';
import 'package:pocvideocall/view/appointment/History.dart';
import 'package:pocvideocall/view/availability/Availability.dart' as prefix0;
import 'package:pocvideocall/view/dashboard/controller.dart';
import 'package:pocvideocall/view/model/Availability.dart';
import 'package:pocvideocall/view/patients/Patients.dart';
import 'package:pocvideocall/view/profile/Profile.dart';
import '../../service/OneSignalService.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
//import 'package:get_version/get_version.dart';

import '../../util/util.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.title}) : super(key: key);

  final String title;


  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> with AfterLayoutMixin<Dashboard>,WidgetsBindingObserver {
  String isStateCalled = "false";
  bool shallShowProgressDialog=false;
  GlobalKey<ScaffoldState> key  = new GlobalKey<ScaffoldState>();
  String projectVersion="";
  String userName="";
  String userEmail="";
  Controller _controller = new Controller();
  String tag = "DashboardState";




  @override
  void initState() {
    super.initState();
    userEmail = AppState.user.email;
    userName = AppState.user.fullname['first'] + " "  +  AppState.user.fullname['last'];
    getAppDetails();
    getPermissions();
    WidgetsBinding.instance.addObserver(this);
  }

  getPermissions() async {
    await Util.getAudioPerm();
    await Util.getCameraPerm();
  }

  getAppDetails() async {
    try {
      projectVersion = await GetVersion.projectVersion;
    } on Exception {
      projectVersion = 'Failed to get app ID.';
    }
    if (!mounted) return;
    setState(() {});
  }

  @override
  void afterFirstLayout(BuildContext context) {
    //initialise once signal
    //check if we have any call data
    print("After the first layout build");
    AppState.context = context;
    initOnSignal();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      Util.log("Dashboard widget state change "+state.toString(), tag);
    });
  }

  initOnSignal() async {
    await OneSignalService.getInstance().initialise();
    OneSignalService.getInstance().get_call_screen_data_android();
    setState(() {
      isStateCalled = "true";
    });
    //get one signal player id and update
    _controller.venderRegister();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = Container(child: Appointment(),height: Util.getScreenHeight(context));

      return new WillPopScope(
          child: BbMaterialApp.StackWdiget([
            Scaffold(
              resizeToAvoidBottomInset: true,
              key: key,
              backgroundColor: Colors.transparent,
              appBar: new AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: new Icon(
                      Icons.menu,
                      size: 35,
                      color:  Constants.ColorTextPrimary,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                actions: <Widget>[
                ],
              ),
              body: ProgressDialog().ProgressDialogMask(shallShowProgressDialog,
                  Translations.of(context).text('almost_there'), screen,
                  isScroll: false, color: Colors.transparent),
              drawer: Theme(
                  data: Theme.of(context).copyWith(
                    // Set the transparency here
                    canvasColor: Constants.ColorBackGround,
                  ),
                  child: Drawer(
                      child: BbMaterialApp.verticalStackWdiget([
                        DrawerHeader(
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.all(4),
                          child: BbMaterialApp.verticalStackWdiget([
                            SizedBox(
                              height: 10,
                            ),
                            BbTextView(
                                userName, Constants.h5, Constants.ColorTextPrimary),
                            BbTextView(
                                userEmail, Constants.h5, Constants.ColorTextPrimary),
                            BbTextView("V" + this.projectVersion, Constants.h5,
                                Constants.ColorTextPrimary)
                          ]),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                        ),
                        Flexible(child: ListView(
                          shrinkWrap: false,
                          // Important: Remove any padding from the ListView.
                          padding: EdgeInsets.zero,
                          children: <Widget>[
                            ListTile(
                              title: BbTextView(
                                  Translations.of(context).text('profile'),
                                  Constants.h4,
                                  Constants.ColorTextPrimary),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.push(context, SlideRightRoute(page: Profile()));
                              },
                              leading: Icon(
                                Icons.verified_user,
                                size: Constants.h4,
                                color: Constants.ColorTextPrimary,
                              ),
                              contentPadding: EdgeInsets.only(left: 16, top: 0),
                            ),
                            ListTile(
                              title: BbTextView(
                                  Translations.of(context).text('availability'),
                                  Constants.h4,
                                  Constants.ColorTextPrimary),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.push(context, SlideRightRoute(page: prefix0.Availability()));
                              },
                              leading: Icon(
                                Icons.library_books,
                                size: Constants.h4,
                                color: Constants.ColorTextPrimary,
                              ),
                              contentPadding: EdgeInsets.only(left: 16, top: 0),
                            ),
                            ListTile(
                              title: BbTextView(
                                  Translations.of(context).text('appointments'),
                                  Constants.h4,
                                  Constants.ColorTextPrimary),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.push(context, SlideRightRoute(page: AppointHistory()));
                              },
                              leading: Icon(
                                Icons.history,
                                size: Constants.h4,
                                color: Constants.ColorTextPrimary,
                              ),
                              contentPadding: EdgeInsets.only(left: 16, top: 0),
                            ),
                            ListTile(
                              title: BbTextView(
                                  Translations.of(context).text('patients'),
                                  Constants.h4,
                                  Constants.ColorTextPrimary),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.push(context, SlideRightRoute(page: PatientsHistory()));
                              },
                              leading: Icon(
                                Icons.supervised_user_circle,
                                size: Constants.h4,
                                color: Constants.ColorTextPrimary,
                              ),
                              contentPadding: EdgeInsets.only(left: 16, top: 0),
                            ),
                            ListTile(
                              title: BbTextView(
                                  Translations.of(context).text('ul_logout'),
                                  Constants.h4,
                                  Constants.ColorTextPrimary),
                              onTap: () {
                                _controller.logout(context);
                              },
                              contentPadding: EdgeInsets.only(left: 16, top: 0),
                              leading: Icon(
                                Icons.exit_to_app,
                                size: Constants.h4,
                                color: Constants.ColorTextPrimary,
                              ),
                            ),
                          ],
                        ) ,)
                        ,
                      ]))),
            ),
          ]),
          onWillPop: () async {
            return true;
          });
    }
  }