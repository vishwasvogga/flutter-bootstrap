import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as parse;
import 'package:http_retry/http_retry.dart';
import 'dart:async';
import 'dart:convert';
import './util.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;


class Bhttp {

  static SecurityContext securityContext = SecurityContext.defaultContext;
  int _retry_count = 3;

  Map<String,String> header = {};
  String tag = "Bhttp";

  Future Multipart(url,body,filename,List<String> mediaType) async {
    String token = await getToken();
    if(token != "" && token != null){
      header = {"Authorization":'Bearer '+token };
    }else{
      header = {};
    }

    print(header);
    print(body);
    print(url);

    var completer = new Completer();
    var uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);

    request.files.add(http.MultipartFile.fromBytes('file', body,filename: filename,contentType: parse.MediaType(mediaType[0],mediaType[1]) ));

    request.headers.addAll(header);

    http.StreamedResponse _response = await request.send();
    final response = await http.Response.fromStream(_response);

    if(response == null){
      completer.complete({'success':false,'code':-1});
    }else if(response != null && response.statusCode!= 200){
      print("Token expired");
      completer.complete({'success':false,'code':response.statusCode});
    } else{
      Util.log(response.statusCode.toString()+"Status code" ,tag);
      completer.complete({'success':true,'data':jsonDecode(response.body)});
    }
    return completer.future;
  }

  Future Post(url,body) async {
    String token = await getToken();
    if(token != "" && token != null){
      header = {"Authorization":'Bearer '+token , "Content-Type": "application/json"};
    }else{
      header = {"Content-Type": "application/json"};
    }

    print(header);
    print(body);
    print(url);

    var completer = new Completer();
    http.Response response ;
    try{
      var client = new RetryClient(http.Client(), retries: _retry_count, when: retryLogic);
      response = await client.post(url,headers: header, body:jsonEncode(body));
      client.close();
    }catch(e){
      print("Error in HTTP"+e.toString());
    }

    if(response == null){
      completer.complete({'success':false,'code':-1});
    }else if(response != null && response.statusCode!= 200){
      print("Token expired");
      completer.complete({'success':false,'code':response.statusCode});
    } else{
      Util.log(response.statusCode.toString()+"Status code" ,tag);
      completer.complete({'success':true,'data':jsonDecode(response.body)});
      print(jsonDecode(response.body));
    }
    return completer.future;
  }

  Future Patch(url,body) async {
    String token = await getToken();
    if(token != "" && token != null){
      header = {"Authorization":'Bearer '+token , "Content-Type": "application/json"};
    }else{
      header = {"Content-Type": "application/json"};
    }
    print(header);
    print(body);
    print(url);
    var completer = new Completer();
    var response ;
    try{
      var client = new RetryClient(http.Client(), retries: _retry_count, when: retryLogic);
      response = await client.patch(url,headers: header, body:jsonEncode(body));
      client.close();
    }catch(e){
      print("Error in HTTP"+e.toString());
    }

    if(response == null){
      completer.complete({'success':false,'code':-1});
    }else if(response != null && response.statusCode!= 200){
      print("Token expired");
      completer.complete({'success':false,'code':response.statusCode});
    } else{
      Util.log(response.statusCode.toString()+"Status code" ,tag);
      completer.complete({'success':true,'data':jsonDecode(response.body)});
      print(jsonDecode(response.body));
    }
    return completer.future;
  }

  Future Get(url) async {
    String token = await getToken();
    if(token != "" && token != null){
      header = {"Authorization":'Bearer '+token , "Content-Type": "application/json"};
    }else{
      header = {"Content-Type": "application/json"};
    }
    print(header);
    print(url);
    var completer = new Completer();
    var response ;
    try{
      var client = new RetryClient(http.Client(), retries: _retry_count, when: retryLogic);
      response = await client.get(url,headers: header);
      client.close();
    }catch(e){
      print("Error in HTTP"+e.toString());
    }

    if(response == null){
      completer.complete({'success':false,'code':-1});
    }else if(response != null && response.statusCode!= 200){
      print("Token expired");
      completer.complete({'success':false,'code':response.statusCode});
    } else{
      Util.log(response.statusCode.toString()+"Status code" ,tag);
      completer.complete({'success':true,'data':jsonDecode(response.body)});
      print(jsonDecode(response.body));
    }
    return completer.future;
  }

  Future Put(url,body) async {
    String token = await getToken();
    body = jsonEncode(body);
    if(token != "" && token != null){
      header = {"Authorization":'Bearer '+token ,"Content-Type": "application/json"};
    }else{
      header = {"Content-Type": "application/json"};
    }

    print(header);
    print(body);
    print(url);

    var completer = new Completer();
    var response ;
    try{
      var client = new RetryClient(http.Client(), retries: _retry_count, when: retryLogic);
      response = await client.put(url,headers: header,body: body);
      client.close();
    }catch(e){
      print("Error in HTTP"+e.toString());
    }

    if(response == null){
      completer.complete({'success':false,'code':-1});
    }else if(response != null && response.statusCode!= 200){
      print("Token expired");
      completer.complete({'success':false,'code':response.statusCode});
    } else{
      Util.log(response.statusCode.toString()+"Status code" ,tag);
      completer.complete({'success':true,'data':jsonDecode(response.body)});
      print(jsonDecode(response.body));
    }
    return completer.future;
  }

  Future Delete(url) async {
    String token = await getToken();
    if(token != "" && token != null){
      header = {"Authorization":'Bearer '+token , "Content-Type": "application/json"};
    }else{
      header = {"Content-Type": "application/json"};
    }
    print(header);
    print(url);
    var completer = new Completer();
    var response ;
    try{
      var client = new RetryClient(http.Client(), retries: _retry_count, when: retryLogic);
      response = await client.delete(url,headers: header);
      client.close();
    }catch(e){
      print(e);
      print("Error in HTTP"+e.toString());
    }

    if(response == null){
      completer.complete({'success':false,'code':-1});
    }else if(response != null && response.statusCode!= 200){
      print("Token expired");
      completer.complete({'success':false,'code':response.statusCode});
    } else{
      Util.log(response.statusCode.toString()+"Status code" ,tag);
      completer.complete({'success':true,'data':jsonDecode(response.body)});
      print(jsonDecode(response.body));
    }
    return completer.future;
  }

  getToken() async {
    dynamic bearerToken =await Util.bearerToken();
    Util.log(bearerToken, 'BHttp');
    return bearerToken;
  }

  bool retryLogic(http.BaseResponse response){
    if(response.statusCode == 503 || response.statusCode == 404){
      return true;
    }else{
      return false;
    }
  }
}