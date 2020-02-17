import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocvideocall/service/AppState.dart';
import 'package:pocvideocall/util/BHttp.dart';
import 'package:pocvideocall/util/CommonElements.dart';
import 'package:pocvideocall/util/Constants.dart';
import 'package:pocvideocall/util/SnackBar.dart';
import 'package:pocvideocall/util/transations.dart';
import 'package:pocvideocall/view/model/Appointment.dart';
import '../../util/util.dart';
import 'package:flutter/cupertino.dart';

import 'HistoryPrescription.dart';


class Controller{
  String tag = "Appointments Controller";
  getAllAppointments(date) async {
    List<Appointment> appoints = new List();
    dynamic appointments = await Bhttp().Get(Constants.baseUrl+Constants.getAppointments+AppState.user.doctor_id+"&date="+date);
    if(appointments['success']==true && appointments['data']['result']!=null){
      appointments['data']['result'].forEach((app){
        Appointment appointment = new Appointment();
        appointment.parse(app);
        appoints.add(appointment);
      });
    }
    Util.log(appoints.toString(), tag);
    return appoints;
  }

  getAllAppointmentsSpan(date) async {
    String from = DateTime.parse(date).subtract(Duration(days: 366)).toIso8601String();
    String till = DateTime.parse(date).add(Duration(days: 366)).toIso8601String();

    List<Appointment> appoints = new List();
    dynamic appointments = await Bhttp().Get(Constants.baseUrl+Constants.getAppointments+AppState.user.doctor_id+"&from="+from+"&till="+till);
    if(appointments['success']==true && appointments['data']['result']!=null){
      appointments['data']['result'].forEach((app){
        Appointment appointment = new Appointment();
        appointment.parse(app);
        appoints.add(appointment);
      });
    }
    appoints.sort((a,b){
      if(DateTime.parse(a.slot['from']).isAfter(DateTime.parse(b.slot['from']))){
        return -1;
      }else{
        return 1;
      }
    });
    Util.log(appoints.toString(), tag);
    return appoints;
  }

  checkAppointmentExpire(String from){
    if(DateTime.now().isAfter(DateTime.parse(from))){
      return true;
    }else{
      return false;
    }
  }

  Widget showAppointmentActions(BuildContext context,Appointment appointment){
    if(checkAppointmentExpire(appointment.slot['from'])){
      return CupertinoActionSheet(/*title: BbTextViewLight( Translations.of(context).text("actons"),Constants.h3,Constants.ColorTextPrimary),*/
        actions: <Widget>[
          CupertinoActionSheetAction(child: BbTextViewLight( Translations.of(context).text("add_prescription"),Constants.h4,Constants.ColorTextPrimary),onPressed: (){
            //aprove
            Navigator.pop(context,{"code":2,"id":appointment.appointment_id});
          },),
          CupertinoActionSheetAction(child: BbTextViewLight( Translations.of(context).text("view_prescription"),Constants.h4,Constants.ColorTextPrimary),onPressed: (){
            //aprove
            Navigator.pop(context,{"code":-1});
            Navigator.push(context, SlideRightRoute(page: PrecsriptionHistory(appointment)));
          },)
        ],cancelButton:
      CupertinoActionSheetAction(child: BbTextViewLight( Translations.of(context).text("back"),Constants.h4,Constants.ColorTextPrimary),onPressed: (){
        //go back
        Navigator.pop(context,{"code":-1,"id":appointment.appointment_id});
        {}},isDefaultAction: true,),);
    }else{
      return CupertinoActionSheet(/*title: BbTextViewLight( Translations.of(context).text("actons"),Constants.h3,Constants.ColorTextPrimary),*/
        actions: <Widget>[
          CupertinoActionSheetAction(child: BbTextViewLight( Translations.of(context).text("cancel_Appointment"),Constants.h4,Constants.ColorTextPrimary),onPressed: (){
            //cancel appointment
            Navigator.pop(context,{"code":0,"id":appointment.appointment_id});
          },),
          CupertinoActionSheetAction(child: BbTextViewLight( Translations.of(context).text("approve_Appointment"),Constants.h4,Constants.ColorTextPrimary),onPressed: (){
            //aprove
            Navigator.pop(context,{"code":1,"id":appointment.appointment_id});
          },),
          CupertinoActionSheetAction(child: BbTextViewLight( Translations.of(context).text("add_prescription"),Constants.h4,Constants.ColorTextPrimary),onPressed: (){
            //aprove
            Navigator.pop(context,{"code":2,"id":appointment.appointment_id});
          },),
          CupertinoActionSheetAction(child: BbTextViewLight( Translations.of(context).text("view_prescription"),Constants.h4,Constants.ColorTextPrimary),onPressed: (){
            //aprove
            Navigator.pop(context,{"code":-1});
            Navigator.push(context, SlideRightRoute(page: PrecsriptionHistory(appointment)));
          },)
        ],cancelButton:
      CupertinoActionSheetAction(child: BbTextViewLight( Translations.of(context).text("back"),Constants.h4,Constants.ColorTextPrimary),onPressed: (){
        //go back
        Navigator.pop(context,{"code":-1,"id":appointment.appointment_id});
        {}},isDefaultAction: true,),);
    }
  }


  Widget imageAddActions(BuildContext context){
    return CupertinoActionSheet(/*title: BbTextViewLight( Translations.of(context).text("actons"),Constants.h3,Constants.ColorTextPrimary),*/
      actions: <Widget>[
        CupertinoActionSheetAction(child: BbTextViewLight( Translations.of(context).text("camera"),Constants.h4,Constants.ColorTextPrimary),onPressed: (){
          //aprove
          Navigator.pop(context,{"code":1});
        },),
        CupertinoActionSheetAction(child: BbTextViewLight( Translations.of(context).text("gallery"),Constants.h4,Constants.ColorTextPrimary),onPressed: (){
          //aprove
          Navigator.pop(context,{"code":2});
        },)
      ],cancelButton:
    CupertinoActionSheetAction(child: BbTextViewLight( Translations.of(context).text("back"),Constants.h4,Constants.ColorTextPrimary),onPressed: (){
      //go back
      Navigator.pop(context,{"code":-1});
      {}},isDefaultAction: true,),);
  }

  cancelAppointment(String id) async {
    Util.log("Cancelling "+id.toString(), tag);
    dynamic acion_data = await Bhttp().Put(Constants.baseUrl+Constants.cancelAppointments+id+"/cancel",{});
    Util.log(acion_data.toString(), tag);
    if(acion_data['success']==true ){
      return true;
    }else{
      return false;
    }
  }

  approveAppointment(String id) async {
    dynamic acion_data = await Bhttp().Put(Constants.baseUrl+Constants.ApproveAppointments+id+"/approve",{});
    Util.log(acion_data.toString(), tag);
    if(acion_data['success']==true ){
      return true;
    }else{
      return false;
    }
  }

  addPrescription(body) async {
    dynamic acion_data = await Bhttp().Post(Constants.baseUrl+Constants.add_prescription,body);
    Util.log(acion_data.toString(), tag);
    if(acion_data['success']==true ){
      return true;
    }else{
      return false;
    }
  }


}