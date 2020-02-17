import 'dart:convert';
import 'dart:core';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pocvideocall/service/AppState.dart';
import '../util/util.dart';
import '../view/call/incoming_call.dart';
import 'dart:io' show Platform;

class OneSignalService {
    // user is 5a426bcd-0f98-4719-a427-1e5a1f3951d4
    static final OneSignalService ourInstance = new OneSignalService();
    var appId = 'a0eed42d-1f0b-4e12-8033-948e28355254';
    //method channel to invoke android service and call screen
    static const oncall_platform = const MethodChannel('ikonsult.android.call.in');
    var tag = "OneSignalService";

    static OneSignalService getInstance() {
        return ourInstance;
    }

    OneSignalService() {
    }

    initialise() async{
        await OneSignal.shared.init(
            appId,
            iOSSettings: {
                OSiOSSettings.autoPrompt: true,
                OSiOSSettings.inAppLaunchUrl: true
            }
        );
        await OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

        OneSignal.shared.setNotificationOpenedHandler(_handleNotificationOpened);

        OneSignal.shared.setNotificationReceivedHandler(_handleNotificationReceived);

        return true;
    }

    void _handleNotificationReceived(OSNotification notification) {
        print('Handle notification recieved');
        print(notification.payload.additionalData.toString());
        String result = notification.payload.additionalData.toString();
    //    invoke_call_screen_android();
        if(result != null && result !="" ){
            goToCallScreen(notification.payload.additionalData);
        }

    }

    void _handleNotificationOpened(OSNotificationOpenedResult result) {
        print('Handle notification Opened');
        print(result.notification.payload.additionalData.toString());
        String _result = result.notification.payload.additionalData.toString();
        //    invoke_call_screen_android();
        if(_result != null && _result !="" ){
            goToCallScreen(result.notification.payload.additionalData);
        }
    }

    Future<String> getPlayerId() async {
        var status = await OneSignal.shared.getPermissionSubscriptionState();
        int retry=0;
        while(status.subscriptionStatus.userId == null){
            await Util.getDelay(Duration(seconds: 1));
            status = await OneSignal.shared.getPermissionSubscriptionState();
            Util.log("Trying to get player id after re initialising"+retry.toString(), tag);
            retry++;
        }
        return status.subscriptionStatus.userId;
    }


    void sendNotification() async {
        var status = await OneSignal.shared.getPermissionSubscriptionState();

        var playerId = status.subscriptionStatus.userId;
        print("User id is  "+playerId);

        var imgUrlString =
            "http://cdn1-www.dogtime.com/assets/uploads/gallery/30-impossibly-cute-puppies/impossibly-cute-puppy-2.jpg";

        var notification = OSCreateNotification(
            playerIds: [playerId],
            content: "this is a test from OneSignal's Flutter SDK",
            heading: "Test Notification",
            iosAttachments: {"id1": imgUrlString},
            bigPicture: imgUrlString,
            buttons: [
                OSActionButton(text: "test1", id: "id1"),
                OSActionButton(text: "test2", id: "id2")
            ]);

        var response = await OneSignal.shared.postNotification(notification);
        print("Test send notification responce "+response.toString());
    }


    //invoke call screen android
    Future<void> get_call_screen_data_android() async {
        try {
            final dynamic result = await oncall_platform.invokeMethod('android_call_in_data');
            if(result !=null){
                goToCallScreen(jsonDecode(result));
            }
        } on PlatformException catch (e) {
            print("An error occured in invoking the android call screen");
        }
    }

    goToCallScreen(dynamic data){
        if(data != null && data['apiKey']!=null){
            Util.log("Notification data is  "+data.toString()+"Of type"+data.runtimeType.toString(),tag);
            //check for valid data
            // apiKey , session , userName , token ,
            if(AppState.context!= null){

                if (Platform.isAndroid) {
                    // Android-specific code
                    Util.log("Waiting for system stabilise to call.........", tag);
                    Future.delayed(Duration(milliseconds: 500),(){
                        Util.log("Calling now........ ", tag);
                        goToCallScreenAndroid(data);
                    });

                } else if (Platform.isIOS) {
                    // iOS-specific code
                    Navigator.push(
                        AppState.context,
                        MaterialPageRoute(builder: (context) => IncommingCall(data)),
                    );
                }
            }
        }

    }

    goToCallScreenAndroid(dynamic data) async{
        try {
            final dynamic result = await oncall_platform.invokeMethod('android_on_call',data);
            Util.log(result.toString(), tag);
        } on PlatformException catch (e) {
            print("An error occured in invoking the android_on_call");
        }
    }
}
