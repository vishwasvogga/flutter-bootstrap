import 'package:get_version/get_version.dart';
import 'package:pocvideocall/service/AppState.dart';
import 'package:pocvideocall/util/CommonElements.dart';
import 'package:pocvideocall/util/Constants.dart';
import 'package:pocvideocall/util/ProgressDialog.dart';
import 'package:pocvideocall/util/SnackBar.dart';
import 'package:pocvideocall/util/transations.dart';
import 'package:pocvideocall/view/appointment/Appointment.dart';
import 'package:pocvideocall/view/patients/controller.dart';
import 'package:pocvideocall/view/model/Patients.dart' as ModelPatient;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import '../../util/util.dart';

class PatientsHistory extends StatefulWidget {
  PatientsHistory() : super();

  @override
  PatientsHistoryState createState() => PatientsHistoryState();
}

class PatientsHistoryState extends State<PatientsHistory> {
  bool shallShowProgressDialog=false;
  String tag = "PatientsHistoryState";
  Controller _controller = Controller();
  List<ModelPatient.Patient> allPatients = new List();
  String pageName = "Patients";
  GlobalKey<ScaffoldState> key  = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initOnAppoint();
  }


  initOnAppoint() async {
    getPatients();
  }

  getPatients() async {
    setState(() {
      shallShowProgressDialog = true;
    });
    allPatients = await _controller.getAllPatients();
    setState(() {
      shallShowProgressDialog = false;
    });
  }

  getPatientsView(){
    List<Widget> appointments = new List();
    this.allPatients.forEach((patient){
      appointments.add(BbMaterialApp.horizontalStackWdiget([
        Container(child: BbMaterialApp.verticalStackWdiget([
          SizedBox(height: 16,),
          BbTextViewBold(patient.full_name,Constants.h4,Constants.ColorPrimary),
          SizedBox(height: 16,),
          BbTextView(patient.city,Constants.h4,Constants.ColorSecondary),
        ],mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start),padding: EdgeInsets.all(8),)

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
      children: getPatientsView(),
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
  }


}