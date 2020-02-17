import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:moment/moment.dart';
import 'package:pocvideocall/service/AppState.dart';
import 'package:pocvideocall/util/SnackBar.dart';
import 'package:pocvideocall/util/util.dart';
import 'package:pocvideocall/view/appointment/Prescription.dart';
import 'package:pocvideocall/view/model/Appointment.dart' as ModelAppointment;
import '../../util/CommonElements.dart';
import '../../util/transations.dart';
import '../../util/Constants.dart';
import '../../util/ProgressDialog.dart';
import './Controller.dart';
import '../../util/MDate.dart';
import 'package:flutter/cupertino.dart';

class Appointment extends StatefulWidget {

  Appointment();

  @override
  State createState() {
    return _Appointment();
  }
}

class _Appointment extends State<Appointment> with SingleTickerProviderStateMixin {
  Controller _controller = Controller();
  bool shallShowProgressDialog = false;
  String tag = "Appointment";
  List<dynamic> dates;
  MDate mDate = new MDate();
  String cur_month = "";
  List<Widget> week_display = new List();
  List<ModelAppointment.Appointment> allAppointments = new List();
  List<ModelAppointment.Appointment> filteredAppointments = new List();
  int tab_seleced = 0;
  TabController tabController;
  String curr_date =  Util.formatdate(DateTime.parse(DateTime.now().toIso8601String()), "yyyy-MM-dd");

  @override
  void initState() {
    super.initState();
    _controller = new Controller();
    tabController = new TabController(length: 3, vsync:this);
    dates = mDate.weeks_day();
    cur_month = mDate.month();
    getAppointments(curr_date);

    //check for appointment changes
    AppState.appointmentChanged.addListener((){
      //get initial appointments
      getAppointments(curr_date);
    });
  }

  clearDatePressed(List<dynamic> dates, mdate) {
    Util.log("Date clicked " + mdate.toString(), tag);
    this.curr_date = Util.formatdate(
        DateTime.parse(mdate['date_obj'].toString()), "yyyy-MM-dd");
    getAppointments(curr_date);
    setState(() {
      dates.forEach((date) {
        if (date['date'].toString() == mdate['date'].toString()) {
          date['is_clicked'] = true;
        } else {
          date['is_clicked'] = false;
        }
      });
    });
  }

  getAppointments(String date) async {
    setState(() {
      shallShowProgressDialog = true;
    });
    allAppointments = await _controller.getAllAppointments(date);
    filterAppointments();
    setState(() {
      shallShowProgressDialog = false;
    });
    Util.log(allAppointments.toString(), tag);
  }

  getWeekDisplay() {
    week_display = new List();
    dates.forEach((date) {
      if (date['is_clicked'] == true) {
        week_display.add(Container(
            height: 40.0,
            width: 55.0,
            color: Colors.transparent,
            child: Center(
                child: BbMaterialApp.verticalStackWdiget([
              BbTextView(date['day'].toString(), Constants.h6,
                  Constants.ColorTextPrimary),
              SizedBox(
                height: 8,
                width: 1,
              ),
              MaterialButton(
                onPressed: () {
                  clearDatePressed(dates, date);
                },
                child: BbTextView(date['date'].toString(), Constants.h6,
                    Constants.ColorTextPrimary),
                color: Constants.ColorPrimary,
              )
            ]))));
      } else {
        week_display.add(Container(
            height: 40.0,
            width: 55.0,
            color: Colors.transparent,
            child: Center(
                child: BbMaterialApp.verticalStackWdiget([
              BbTextView(date['day'].toString(), Constants.h6,
                  Constants.ColorTextPrimary),
              SizedBox(
                height: 8,
                width: 1,
              ),
              MaterialButton(
                onPressed: () {
                  clearDatePressed(dates, date);
                },
                child: BbTextView(date['date'].toString(), Constants.h6,
                    Constants.ColorTextPrimary),
              )
            ]))));
      }
      week_display.add(SizedBox(
        width: 2,
        height: 2,
      ));
    });
  }

  filterAppointments(){
    this.filteredAppointments = new List();
    this.allAppointments.forEach((appoint){
      if(tab_seleced==0 && appoint.status == "pending"){
        this.filteredAppointments.add(appoint);
      }else if(tab_seleced==1 && appoint.status == "approved"){
        this.filteredAppointments.add(appoint);
      }else if(tab_seleced==2 && appoint.status == "rejected"){
        this.filteredAppointments.add(appoint);
      }
    });
    Util.log("Filtered appointments "+this.filteredAppointments.toString(), tag);
  }

  getAppointmentsView(){
    List<Widget> appointments = new List();
    this.filteredAppointments.forEach((appoint){
      appointments.add(BbMaterialApp.horizontalStackWdiget([
        Container(child: BbMaterialApp.verticalStackWdiget([
          BbTextViewBold(appoint.user['full_name'],Constants.h4,Constants.ColorPrimary),
          SizedBox(height: 16,),

          BbTextView(Util.formatdate(
              DateTime.parse(appoint.slot['from'].toString()).add(Duration(hours: 5,minutes: 30)), "HH:mm")+ " - "+
              Util.formatdate(
                  DateTime.parse(appoint.slot['to'].toString()).add(Duration(hours: 5,minutes: 30)), "HH:mm"),Constants.h5,Constants.ColorSecondary),
        ],mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start),padding: EdgeInsets.all(8),),

        ( Container(child: IconButton(icon:Icon(Icons.more_vert,size: Constants.h2,), onPressed: (){
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
                BbSnackBar.showToastContext(Translations.of(context).text('success'), context);
                getAppointments(curr_date);
              }else{
                BbSnackBar.showToastContext(Translations.of(context).text('fail'), context);
              }
            }else if(action['code']==1){
              //approve
              setState(() {
                shallShowProgressDialog = true;
              });
              bool res = await _controller.approveAppointment(action['id']);

              if(res){
                BbSnackBar.showToastContext(Translations.of(context).text('success'), context);
                getAppointments(curr_date);
              }else{
                BbSnackBar.showToastContext(Translations.of(context).text('fail'), context);
              }
            }else if(action['code']==2){
              //add prescription
              Navigator.push(context, SlideRightRoute(page: Prescription(appoint.user['_id'],appoint.appointment_id)));
            }
          });

        }),padding: EdgeInsets.all(8),) )

      ],mainAxisAlignment: MainAxisAlignment.spaceBetween)) ;
    });
    return appointments;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Util.log(state.toString(), "Appointment page resumed");
    if (state == AppLifecycleState.resumed) {
      //get initial appointments
      getAppointments(curr_date);
    }
  }

  @override
  Widget build(BuildContext context) {
    getWeekDisplay();

    Widget head = BbMaterialApp.verticalStackWdiget([
      Center(
        child: Container(
          child: BbMaterialApp.verticalStackWdiget([
            SizedBox(
              height: 8,
              width: 10,
            ),
            BbTextViewBold(cur_month, Constants.h4, Constants.ColorTextPrimary),
            SizedBox(
              height: 8,
              width: 10,
            ),
            Container(
              child: ListView(
                  padding: const EdgeInsets.all(8),
                  scrollDirection: Axis.horizontal,
                  children: week_display),
              height: 120,
            )
          ]),
          height: 165,
          color: Constants.ColorDisabled.withOpacity(0.3),
        ),
      )
    ], mainAxisAlignment: MainAxisAlignment.start);

    Widget appointment_tabs = new DefaultTabController(
      length: 3,
      child:  new Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        new TabBar(
          tabs: [
            new Tab(child: BbTextView(Translations.of(context).text('pending'),Constants.h6,Constants.ColorTextPrimary),),
            new Tab(child: BbTextView(Translations.of(context).text('confirmed'),Constants.h6,Constants.ColorTextPrimary),),
            new Tab(child: BbTextView(Translations.of(context).text('cancelled'),Constants.h6,Constants.ColorTextPrimary),),
          ],
          controller: tabController,
          onTap: (int tab){
            Util.log("Tab pressed "+tab.toString(), tag);
            tab_seleced = tab;
            setState(() {
              filterAppointments();
            });
          },
        ),
      ],
    ),
    );

    Widget appointment_lists = Container(child:ListView(
      padding: const EdgeInsets.all(8),
      children: getAppointmentsView(),
      shrinkWrap: true,
    ) ,height: (Util.getScreenHeight(context)-370),);

    Widget screen = BbMaterialApp.verticalStackWdiget([
      head,
      SizedBox(
        height: 16,
      ),
      appointment_tabs,
      SizedBox(
        height: 16,
      ),
      appointment_lists
    ], mainAxisAlignment: MainAxisAlignment.start);

    return ProgressDialog().ProgressDialogMask(shallShowProgressDialog,
        Translations.of(context).text('almost_there'), screen,
        isScroll: false, color: Colors.transparent);
  }

  @override
  void dispose() {
    super.dispose();
    AppState.appointmentChanged.removeListener(null);
  }


}
