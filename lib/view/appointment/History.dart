import 'package:get_version/get_version.dart';
import 'package:pocvideocall/service/AppState.dart';
import 'package:pocvideocall/util/CommonElements.dart';
import 'package:pocvideocall/util/Constants.dart';
import 'package:pocvideocall/util/ProgressDialog.dart';
import 'package:pocvideocall/util/SnackBar.dart';
import 'package:pocvideocall/util/transations.dart';
import 'package:pocvideocall/view/appointment/Appointment.dart';
import 'package:pocvideocall/view/appointment/Prescription.dart';
import 'package:pocvideocall/view/appointment/controller.dart';
import 'package:pocvideocall/view/model/Appointment.dart' as ModelAppoitment;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import '../../util/util.dart';

class AppointHistory extends StatefulWidget {
  AppointHistory() : super();



  @override
  AppointHistoryState createState() => AppointHistoryState();
}

class AppointHistoryState extends State<AppointHistory> {
  bool shallShowProgressDialog=false;
  String tag = "AppointHistoryState";
  Controller _controller = Controller();
  List<ModelAppoitment.Appointment> allAppointments = new List();
  String pageName = "Appointment history";
  GlobalKey<ScaffoldState> key  = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initOnAppoint();
  }


  initOnAppoint() async {
    getAppointments(DateTime.now().toIso8601String());
  }

  getAppointments(String date) async {
    setState(() {
      shallShowProgressDialog = true;
    });
    allAppointments = await _controller.getAllAppointmentsSpan(date);
    setState(() {
      shallShowProgressDialog = false;
    });
  }

  getAppointmentsView(){
    List<Widget> appointments = new List();
    this.allAppointments.forEach((appoint){
      appointments.add(BbMaterialApp.horizontalStackWdiget([
        Container(child: BbMaterialApp.verticalStackWdiget([
          BbTextViewBold(appoint.user['full_name'],Constants.h4,Constants.ColorPrimary),
          SizedBox(height: 16,),

          BbTextView(Util.formatdate(
              DateTime.parse(appoint.slot['from'].toString()).add(Duration(hours: 5,minutes: 30)), "HH:mm")+ " - "+
              Util.formatdate(
                  DateTime.parse(appoint.slot['to'].toString()).add(Duration(hours: 5,minutes: 30)), "HH:mm"),Constants.h5,Constants.ColorSecondary),
          SizedBox(height: 8,),
          BbTextViewLight(appoint.status,Constants.h5,Constants.ColorTextPrimary)
        ],mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start),padding: EdgeInsets.all(8),),

        (Container(child: IconButton(icon:Icon(Icons.more_vert,size: Constants.h2,), onPressed: (){
          //on action on appointment
          showCupertinoModalPopup(context: context, builder: (mcontext){
            return _controller.showAppointmentActions(context, appoint);
          }).then((action) async {
            if(action['code'] ==0){
              //cancel
              setState(() {
                shallShowProgressDialog = true;
              });
              bool res =  await _controller.cancelAppointment(action['id']);

              if(res){
                BbSnackBar.showToast(Translations.of(context).text('success'), context,key);
                initOnAppoint();
              }else{
                BbSnackBar.showToast(Translations.of(context).text('fail'), context,key);
              }
            }else if(action['code']==1){
              //approve
              setState(() {
                shallShowProgressDialog = true;
              });
              bool res = await _controller.approveAppointment(action['id']);

              if(res){
                BbSnackBar.showToast(Translations.of(context).text('success'), context,key);
                initOnAppoint();
              }else{
                 BbSnackBar.showToast(Translations.of(context).text('fail'), context,key);
              }
            }else if(action['code']==2){
              //add prescription
              Navigator.push(context, SlideRightRoute(page: Prescription(appoint.user['_id'],appoint.appointment_id)));
            }
          });

        }),padding: EdgeInsets.all(8),) )

      ],mainAxisAlignment: MainAxisAlignment.spaceBetween)) ;
      appointments.add(Divider(color: Constants.ColorTextPrimary.withOpacity(0.2),));
    });
    return appointments;
  }

  checkAppointmentExpire(String from){
    if(DateTime.now().isAfter(DateTime.parse(from))){
      return true;
    }else{
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {

    Widget screen = Container(child: ListView(
      padding: const EdgeInsets.all(8),
      children: getAppointmentsView(),
      shrinkWrap: true,
    ) ,height: (Util.getScreenHeight(context)),);

    return new WillPopScope(
        child: BbMaterialApp.StackWdiget([
          Scaffold(
            key: key,
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            appBar: new AppBar(
              title: BbTextView(pageName,Constants.h3,Constants.ColorTextPrimary),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: new Icon(
                    Icons.arrow_back,
                    size: 35,
                    color:  Constants.ColorTextPrimary,
                  ),
                  onPressed: () => Navigator.of(context).pop()
                ),
              ),
              actions: <Widget>[
              ],
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
    Future.delayed(Duration(seconds: 1),(){
      AppState.appointmentChanged.notifyListeners();
    });
  }


}