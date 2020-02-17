import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pocvideocall/service/AppState.dart';
import 'package:pocvideocall/util/BHttp.dart';
import 'package:pocvideocall/util/CommonElements.dart';
import 'package:pocvideocall/util/Constants.dart';
import 'package:pocvideocall/util/SnackBar.dart';
import 'package:pocvideocall/util/transations.dart';
import 'package:pocvideocall/view/model/Patients.dart';
import '../../util/util.dart';
import 'package:flutter/cupertino.dart';


class Controller{
  String tag = "Appointments Controller";

  getAllPatients() async {
    List<Patient> _patients = new List();
    dynamic patients = await Bhttp().Get(Constants.baseUrl+Constants.getPatients+AppState.user.doctor_id);
    if(patients['success']==true && patients['data']['result']!=null){
      patients['data']['result'].forEach((pt){
        Patient patient = new Patient();
        patient.parse(pt);
        _patients.add(patient);
      });
    }
    Util.log(_patients.toString(), tag);
    return _patients;
  }
}