import 'dart:convert';
import '../../util/util.dart';
import './settings.dart';


class Controller {
  var tag = "call Controller";


  DecodeKeys(Map<String,dynamic> call_data){
    // apiKey , session , userName , token
    Util.log(call_data.toString(), tag);
    Settings.API_KEY = call_data['apiKey'].toString();
    Settings.SESSION_ID =call_data["session"].toString();
    Settings.TOKEN =call_data["token"].toString();
    Settings.CALLER =call_data["userName"].toString();
    Util.log("API_KEY"+Settings.API_KEY+"SESSION_ID"+Settings.SESSION_ID+"TOKEN"+Settings.TOKEN+"CALLER"+Settings.CALLER,tag);
  }
}