package com.il9m.ikonsult;
import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.view.Window;
import android.view.WindowManager;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "ikonsult.android.call.in";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Window window = getWindow();
    window.addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            | WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
            | WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
            | WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD);
    GeneratedPluginRegistrant.registerWith(this);

    //method call handler
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, Result result) {
                //incoming call
                // unused
                if (call.method.equals("android_call_in_data")) {
                    if(AppState.getInstance().getOnesignal_last_data() != null){
                        result.success(AppState.getInstance().getOnesignal_last_data().toString());
                    }else {
                        result.success(null);
                    }
                  //clear the data
                  AppState.getInstance().setOnesignal_last_data(null);
                }else if(call.method.equals("android_on_call")){
                    Log.d("Main activity android android_on_call",call.arguments.toString());

                    Intent i = new Intent(getApplicationContext(), OpentokActivity.class);
                    i.putExtra("API_KEY",call.argument("apiKey").toString());
                    i.putExtra("SESSION_ID",call.argument("session").toString());
                    i.putExtra("TOKEN",call.argument("token").toString());
                    i.putExtra("CALLER",call.argument("userName").toString());
                    i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
                    startActivity(i);

                    result.success(true);
                }
                else {
                  result.notImplemented();
                }
              }
            });
  }

}
