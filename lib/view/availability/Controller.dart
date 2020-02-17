import 'dart:convert';

import 'package:pocvideocall/service/AppState.dart';
import 'package:pocvideocall/util/BHttp.dart';
import 'package:pocvideocall/util/Constants.dart';
import 'package:pocvideocall/util/util.dart';
import 'package:pocvideocall/view/model/Availability.dart';
import 'package:pocvideocall/view/model/Profile.dart';

class Controller{
  String tag = "Availability controller";

  getAvailability() async {
    dynamic resp = await Bhttp().Get(Constants.baseUrl+Constants.getAvailability+AppState.user.doctor_id);
    if(resp['success']==true){
      return resp['data'];
    }else{
      return null;
    }
  }


  putAvailability(AvailabilityWeek body) async {
    dynamic resp = await Bhttp().Put(Constants.baseUrl+Constants.putAvailability,body.toJson());
    if(resp['success']==true){
      Util.log(resp['data'].toString(), tag);
      return true;
    }else{
      return false;
    }
  }

  getProfile() async {
    Profile _profile = new Profile();
    dynamic profile = await Bhttp().Get(Constants.baseUrl+Constants.profile+AppState.user.doctor_id);
    if(profile['success']==true && profile['data']['result']!=null){
      _profile.parse( profile['data']['result']);
    }
    return _profile;
  }
}