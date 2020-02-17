import 'package:flutter/cupertino.dart';
import '../login/Controller.dart' as LoginController;
import '../../service/OneSignalService.dart';
class Controller {




  logout(BuildContext context){
    LoginController.Controller().logout(context);
  }

  venderRegister() async {
    String push_token = await OneSignalService.getInstance().getPlayerId();
    LoginController.Controller().venderRegister(push_token);
  }
}