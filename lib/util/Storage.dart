import 'package:localstorage/localstorage.dart';
import './util.dart';
import 'dart:async';
class BbStorage{
  LocalStorage storage;
  String tag = "storage";
  static BbStorage _bbStorage=null;

  static BbStorage getInstance(String key){
    if(_bbStorage==null) {
      _bbStorage = new BbStorage(key);
    }
    return _bbStorage;
  }

  BbStorage(String key){
    storage  = new LocalStorage(key);
    checkIfInitSuccess();
  }

  put(dynamic json,String key) async {
    await checkIfInitSuccess();
    return storage.setItem(key, json);
  }

  dynamic get(String key) async {
    await checkIfInitSuccess();
    return storage.getItem(key);
  }

  Future<bool> checkIfInitSuccess() async{
    Completer<bool> completer = new Completer();
    bool isReady = await  storage.ready;
    Util.log("Is storage ready "+isReady.toString(), tag);
    completer.complete(isReady);
    return completer.future;
  }
}