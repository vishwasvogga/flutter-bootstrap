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

class PrecsriptionHistory extends StatefulWidget {
  ModelAppoitment.Appointment appointment;
  PrecsriptionHistory(this.appointment) : super();



  @override
  PrescriptionHistoryState createState() => PrescriptionHistoryState();
}

class PrescriptionHistoryState extends State<PrecsriptionHistory> {
  bool shallShowProgressDialog=false;
  String tag = "PrescriptionHistoryState";
  Controller _controller = Controller();

  String pageName = "Prescriptions";
  GlobalKey<ScaffoldState> key  = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }



  getAppointmentsView(){
    List<Widget> wprescriptis = new List();
    (this.widget.appointment.prescription==null || this.widget.appointment.prescription.length==0) ?
    wprescriptis.add(Container(child:  BbTextViewLight(Translations.of(context).text('no_prescriptions'),Constants.h4,Constants.ColorTextPrimary),padding:  EdgeInsets.all(16)))  :
    this.widget.appointment.prescription.forEach((prescription){
      if(prescription['flags']['isRemoved']==true){
        return;
      }

      wprescriptis.add(BbMaterialApp.verticalStackWdiget([
      SizedBox(height: 16,width: 1,),
        Image.network(Constants.baseUrl+"/media/"+prescription['media'][0]),
        SizedBox(height: 16,width: 1,),
        BbTextViewLight(prescription['notes'],Constants.h5,Constants.ColorTextPrimary)
      ],mainAxisAlignment: MainAxisAlignment.spaceBetween)) ;
      wprescriptis.add(Divider(color: Constants.ColorTextPrimary.withOpacity(0.2),));
    });
    return wprescriptis;
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
  }


}