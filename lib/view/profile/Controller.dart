
import 'package:pocvideocall/service/AppState.dart';
import 'package:pocvideocall/util/BHttp.dart';
import 'package:pocvideocall/util/Constants.dart';
import 'package:pocvideocall/util/util.dart';
import 'package:pocvideocall/view/model/Profile.dart';

class Controller {

  String tag="Profile controller";


  getProfile() async {
    Profile _profile = new Profile();
    dynamic profile = await Bhttp().Get(Constants.baseUrl+Constants.profile+AppState.user.doctor_id);
    Util.log(profile.toString(), tag);
    if(profile['success']==true && profile['data']['result']!=null){
      _profile.parse( profile['data']['result']);
    }
    return _profile;
  }
}