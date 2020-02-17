package com.il9m.ikonsult;


import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import com.onesignal.NotificationExtenderService;
import com.onesignal.OSNotificationDisplayedResult;
import com.onesignal.OSNotificationReceivedResult;
import 	androidx.core.app.NotificationCompat;
import java.math.BigInteger;

import static java.lang.Integer.parseInt;


public class OneSignalBackgroundService extends NotificationExtenderService {


    @Override
    protected boolean onNotificationProcessing(OSNotificationReceivedResult receivedResult) {
        // Read properties from result.
        String additionalData = receivedResult.payload.additionalData.toString();
        Log.d("One signal notification",additionalData);

        OverrideSettings overrideSettings = new OverrideSettings();
        overrideSettings.androidNotificationId=1005;
        overrideSettings.extender = new NotificationCompat.Extender() {
            @Override
            public NotificationCompat.Builder extend(NotificationCompat.Builder builder) {
                // Sets the background notification color to Green on Android 5.0+ devices.
                return builder.setColor(new BigInteger("FF00FF00", 16).intValue());
            }
        };

        OSNotificationDisplayedResult displayedResult = displayNotification(overrideSettings);
        Log.d("OneSignalExample", "Notification displayed with id: " + displayedResult.androidNotificationId);

        // Return true to stop the notification from displaying
        if(additionalData.contains("apiKey") && additionalData.contains("session") && additionalData.contains("token") ){
            AppState.getInstance().setOnesignal_last_data(receivedResult.payload.additionalData);
            Intent i = new Intent(getApplicationContext(), MainActivity.class);
            i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
            startActivity(i);
        }

        return true;
    }
}
