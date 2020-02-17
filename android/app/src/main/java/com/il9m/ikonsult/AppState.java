package com.il9m.ikonsult;

import org.json.JSONObject;

public class AppState {
    private static final AppState ourInstance = new AppState();

    public static AppState getInstance() {
        return ourInstance;
    }

    private JSONObject onesignal_last_data = null;

    private AppState() {
    }


    public JSONObject getOnesignal_last_data() {
        return onesignal_last_data;
    }

    public void setOnesignal_last_data(JSONObject onesignal_last_data) {
        this.onesignal_last_data = onesignal_last_data;
    }

}
