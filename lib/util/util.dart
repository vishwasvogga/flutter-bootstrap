import 'package:random_string/random_string.dart' as random;
import 'dart:math';
import './transations.dart';
import './Constants.dart';
import './Storage.dart';
import 'package:image_picker/image_picker.dart';
import './Timer.dart';
import 'dart:io' ;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:image/image.dart' as lib;
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info/device_info.dart';
import 'package:intl/intl.dart';



class Util {
  //is log enabled
  static BbTimer _connectionCheckTimer;
  bool isLogEnabled = true;
  static String tag = "Util";

  static log(String msg,String tag){
    if(msg != null){
      print("["+tag+"]"+msg);
    }else{
      print("["+tag+"]"+"msg is null");
    }
  }

  static Future  getDelay(Duration dur){
    return BbTimer().getDelay(dur);
  }

  static formatdate(date, format){
    // "dd-MM-yyyy"
    return DateFormat(format).format(date);
  }

  static checkNullAndEmptyString(String str){
    bool isPass = false;
    if(str!=null && str !="")
      isPass = true;

    return isPass;
  }

  static getRandomString(int length){
    return random.randomAlphaNumeric(length);
  }

  static String getFormattedDateString(DateTime datetime){
    return datetime.day.toString() + "-"+datetime.month.toString()+"-"+datetime.year.toString();
  }

  static String getFormattedTimeString(DateTime datetime){
    String minute = "";
    if(datetime.minute<10){
      minute = "0"+datetime.minute.toString();
    }else{
      minute = datetime.minute.toString();
    }
    return datetime.hour.toString() + ":"+minute;
  }

  static num fixDecimal(num value){
    int decimals = 1;
    int fac = pow(10, decimals);
    value = (value* fac).round() / fac;
    return value;
  }

  static getErrorMessage(code,context){
    String err_key = 'unknown_err';
    print("Error code "+code.toString());
    Constants.errors.forEach((err){
      if(err['code']==code){
        err_key =  err['key'];
      }
    });
    if(code==-2){
      Util.bearerToken(token: "");
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    }
    if(context  == null){
      return err_key;
    }else{
      return Translations.of(context).text(err_key);
    }
  }

  static bearerToken({token}){
    if(token == null ){
      return BbStorage.getInstance(Constants.App_key).get('bearertoken');
    }else{
      log("Storing token "+token, "util");
      return BbStorage.getInstance(Constants.App_key).put(token,'bearertoken');
    }
  }

  static currentUser({user}){
    if(user == null){
      return BbStorage.getInstance(Constants.App_key).get('current_user');
    }else{
      log("Storing user "+user.toString(), "util");
      return BbStorage.getInstance(Constants.App_key).put(user,'current_user');
    }
  }

  static Future<File> pickImage(ImageSource source) async{
    try{
      File image =  await ImagePicker.pickImage(source: source,maxHeight: 1024,maxWidth: 768);
    //  List<int> imageBytes = await image.readAsBytes();
    //  return base64Encode(imageBytes);
      return image;
    }catch(e){
      Util.log(e.toString(), tag);
      return null;
    }
  }

  static getScreenHeight(BuildContext context){
    return  MediaQuery.of(context).size.height;
  }

  static String getFileName(String strPath) {
    return basename(strPath);
  }

  static String stringToDateTime(String date){
    try{
      return DateFormat('dd-MM-yyyy').format( DateTime.parse(date));
    }catch(e){
      return "";
    }
  }

  static String timeAgo(String time1){
    try{
      DateTime time = DateTime.parse(time1);
      final difference = new DateTime.now().difference(time );
    //  time = time.toLocal();
    //  time = new DateTime(time.year, time.month, time.day, time.hour, difference.inMinutes, time.second, time.millisecond, time.microsecond);
      return timeago.format(time, locale: 'en_short');
    }catch(e){
      Util.log(e.toString(), 'time ago util');
      return "";
    }

  }

  static double parseFloat(String val){
    try{
      return double.parse(val);
    }catch(e){
      Util.log(e.toString(), 'util');
      return 0.0;
    }
  }

  static int parseInt(String val){
    try{
      return num.parse(val);
    }catch(e){
      Util.log(e.toString(), 'util');
      return 0;
    }
  }

  static dynamic getScreenSize(BuildContext context){
    Map<String , double> screen ={'height':500.0,'width':300.0};
    screen['height'] =  MediaQuery.of(context).size.height;
    screen['width'] = MediaQuery.of(context).size.width;
    return screen;
  }

  static doubleToInt(double number){
    return number.round();
  }

  static Future<bool> getFileStoragePerm() async{
    Completer<bool> completer = new Completer();
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if(permission == PermissionStatus.granted){
       completer.complete(true);
       return completer.future;
    }else{
      completer.complete(false);
      return completer.future;
    }
  }
  static Future<bool> getAudioPerm() async{
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.microphone]);
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.microphone);
    if(permission == PermissionStatus.granted){
      return true;
    }else{
      return false;
    }
  }
  static Future<bool> getCameraPerm() async{
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    if(permission == PermissionStatus.granted){
      return true;
    }else{
      return false;
    }
  }

  static Future<String> capturePng(GlobalKey key) async {
    Completer<String> completer = new Completer();
    try {
      RenderRepaintBoundary boundary =
      key.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 0.5);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(bs64);
      completer.complete(bs64);
    } catch (e) {
      print(e);
      completer.complete(null);
    }
    return completer.future;
  }

  static Future<String> saveToFile(String base64Str,String filename) async {
    Completer<String> completer = new Completer();
    try{
      Directory tempDir = await getExternalStorageDirectory();
      Uint8List bytes = base64.decode(base64Str);
      String dir = (tempDir).path;
      //check if path exists
      File file = File(dir);
      if(! await file.exists()){
        print(await new Directory(file.path).create(recursive: true));
      }
      file = File("$dir/" +filename);

      file= await file.writeAsBytes(bytes);
      Uri fileUri = Uri.file(file.path);
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if(androidInfo.version.sdkInt>23){
        completer.complete(file.path);
      }else{
        completer.complete(fileUri.toString());
      }

    }catch(e){completer.complete(null);}
    return completer.future;
  }

  static checkInternetConnection(bool start){
    if(start && _connectionCheckTimer==null){
      _connectionCheckTimer = BbTimer();
      _connectionCheckTimer.setPeriodicTimerInSeconds(Duration(days: 100), (tick) async {
        //check internet connection
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result[0].rawAddress.isNotEmpty && result[0].rawAddress.isNotEmpty) {

          }else{
          //  _displayNoInternetText();
          }
        } on SocketException catch (_) {
          //dislay toast
        //  _displayNoInternetText();
          print('not connected');
        }

      },tick: Duration(seconds: 10));
    }else{
      if(_connectionCheckTimer != null){
        _connectionCheckTimer.cancelAllTimers();
        _connectionCheckTimer = null;
      }
    }
  }

//  static _displayNoInternetText(){
//    Fluttertoast.showToast(
//        msg: "No intenet access",
//        toastLength: Toast.LENGTH_LONG,
//        gravity: ToastGravity.BOTTOM,
//        timeInSecForIos: 1,
//        backgroundColor: Colors.blueGrey,
//        textColor: Colors.white,
//        fontSize: 16.0
//    );
//  }
}