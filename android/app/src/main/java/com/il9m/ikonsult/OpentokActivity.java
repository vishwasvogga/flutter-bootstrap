package com.il9m.ikonsult;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import android.app.NotificationManager;
import android.content.Context;
import android.media.AudioManager;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.util.Log;

import com.opentok.android.Connection;
import com.opentok.android.Session;
import com.opentok.android.Stream;
import com.opentok.android.Publisher;
import com.opentok.android.PublisherKit;
import com.opentok.android.Subscriber;
import com.opentok.android.OpentokError;
import androidx.annotation.NonNull;
import android.Manifest;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.opengl.GLSurfaceView;
import android.widget.ImageButton;
import android.widget.RelativeLayout;
import android.widget.TextView;


public class OpentokActivity extends AppCompatActivity implements  Session.SessionListener , PublisherKit.PublisherListener {
    private static String API_KEY = "";
    private static String SESSION_ID = "";
    private static String TOKEN = "";
    private static String CALLER="";
    private static final String LOG_TAG = com.il9m.ikonsult.MainActivity.class.getSimpleName();


    private Session mSession;
    private FrameLayout mPublisherViewContainer;
    private RelativeLayout mSubscriberViewContainer;
    private Publisher mPublisher;
    private Subscriber mSubscriber;

    private boolean isConnected = false;
    private Ringtone r=null;
    private Vibrator v=null;
    private Handler callMonitorHandler;
    private boolean isCallRecieved=false;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Window window = getWindow();
        window.addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
                | WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
                | WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
                | WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD);
        //get the params from intent
        setContentView(R.layout.callactivity);
        //get data from intent
        API_KEY = getIntent().getExtras().getString("API_KEY");
        SESSION_ID = getIntent().getExtras().getString("SESSION_ID");
        TOKEN = getIntent().getExtras().getString("TOKEN");
        CALLER = getIntent().getExtras().getString("CALLER");
        initialiseSession();
        initUiComponents();
    }

    @Override
    protected void onPostCreate(@Nullable Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        playRingtone();
        startCallMonitor();
        //close notification if displayed
        NotificationManager notificationManager = (NotificationManager) getApplicationContext().getSystemService(Context.NOTIFICATION_SERVICE);
        try{
            new Handler(getMainLooper()).postDelayed(new Runnable() {
                @Override
                public void run() {
                    notificationManager.cancel(1005);
                    notificationManager.cancelAll();
                }
            },2000);

        }catch (Exception e){
        }
    }

    private void initialiseSession(){
        mPublisherViewContainer = findViewById(R.id.publisher_container);
        mSubscriberViewContainer = findViewById(R.id.subscriber_container);

        mSession = new Session.Builder(this, API_KEY, SESSION_ID).build();
        mSession.setSessionListener(this);
        mSession.connect(TOKEN);

    }


    private void initUiComponents(){
        ImageButton receiveCall = findViewById(R.id.receiveCall);
        ImageButton rejectCall = findViewById(R.id.rejectCall);

        ImageButton rejectCallCentered = findViewById(R.id.rejectCallCentered);

        ImageButton muteAudio = findViewById(R.id.muteAudio);
        ImageButton resumeAudio = findViewById(R.id.resumeAudio);

        ImageButton muteVideo = findViewById(R.id.muteVideo);
        ImageButton resumeVideo = findViewById(R.id.resumeVideo);

        RelativeLayout callSection = findViewById(R.id.rel_call_button_section);
        TextView connectionStatus = findViewById(R.id.txt_connection_status);

        muteAudio.setVisibility(View.GONE);
        muteVideo.setVisibility(View.GONE);
        resumeAudio.setVisibility(View.GONE);
        resumeVideo.setVisibility(View.GONE);
        rejectCallCentered.setVisibility(View.GONE);
        mPublisherViewContainer.setVisibility(View.GONE);
        mSubscriberViewContainer.setVisibility(View.INVISIBLE);

        connectionStatus.setText(CALLER+" is calling...");



        //receive call
        receiveCall.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Log.d(LOG_TAG,"Starting connection");

                //recieve the call
                //enable audio and video
                isCallRecieved = true;
                rejectCall.setVisibility(View.GONE);
                receiveCall.setVisibility(View.GONE);
                muteAudio.setVisibility(View.VISIBLE);
                muteVideo.setVisibility(View.VISIBLE);
                callSection.setVisibility(View.GONE);
                rejectCallCentered.setVisibility(View.VISIBLE);
                mSubscriberViewContainer.setVisibility(View.VISIBLE);
                connectionStatus.setText("Connecting to "+CALLER+"..");
                stopRingtone();
                callMonitorHandler.removeCallbacks(null);


                new Thread(new Runnable() {
                    @Override
                    public void run() {

                        //wait till the call gets connected
                        int retry = 0;

                        while ((!isConnected || mSubscriber==null) && retry<30){
                            Log.d(LOG_TAG,"Trying to connect server");

                            try{
                                Thread.sleep(1000);
                            }catch (Exception e){

                            }
                            retry++;
                        }

                        Handler handler = new Handler(Looper.getMainLooper());

                        handler.post(new Runnable() {
                            @Override
                            public void run() {

                                if(isConnected){
                                    connectionStatus.setText("Connected to "+CALLER);
                                    mSubscriber.setSubscribeToAudio(true);
                                    mSubscriber.setSubscribeToVideo(true);
                                    mPublisherViewContainer.setVisibility(View.VISIBLE);
                                    mPublisher = new Publisher.Builder(OpentokActivity.this)
                                            .resolution(Publisher.CameraCaptureResolution.MEDIUM)
                                            .frameRate(Publisher.CameraCaptureFrameRate.FPS_30)
                                            .audioBitrate(8000)
                                            .build();
                                    mPublisher.setPublisherListener(OpentokActivity.this);

                                    mPublisherViewContainer.addView(mPublisher.getView());

                                    if (mPublisher.getView() instanceof GLSurfaceView){
                                        ((GLSurfaceView) mPublisher.getView()).setZOrderOnTop(true);
                                    }

                                    mSession.publish(mPublisher);
                                }else{
                                    //if call not connected after 30 sec close the connection and activity
                                    closeCall();
                                }
                            }
                        });
                    }
                }).start();
            }
        });

        //reject call
        rejectCall.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                closeCall();
            }
        });

        rejectCallCentered.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                closeCall();
            }
        });

        //mute audio
        muteAudio.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(isConnected ==true && mPublisher!=null){
                    mPublisher.setPublishAudio(false);
                    resumeAudio.setVisibility(View.VISIBLE);
                    muteAudio.setVisibility(View.GONE);
                }
            }
        });

        //resume audio
        resumeAudio.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(isConnected ==true && mPublisher!=null){
                    mPublisher.setPublishAudio(true);
                    resumeAudio.setVisibility(View.GONE);
                    muteAudio.setVisibility(View.VISIBLE);
                }
            }
        });


        //mute audio
        muteVideo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(isConnected ==true && mPublisher!=null){
                    mPublisher.setPublishVideo(false);
                    resumeVideo.setVisibility(View.VISIBLE);
                    muteVideo.setVisibility(View.GONE);
                }
            }
        });

        //resume audio
        resumeVideo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(isConnected ==true && mPublisher!=null){
                    mPublisher.setPublishVideo(true);
                    resumeVideo.setVisibility(View.GONE);
                    muteVideo.setVisibility(View.VISIBLE);
                }
            }
        });
    }


    @Override
    public void onConnected(Session session) {
        Log.i(LOG_TAG, "Session Connected");
        isConnected = true;
    }

    @Override
    public void onDisconnected(Session session) {
        Log.i(LOG_TAG, "Session Disconnected");
        closeCall();
    }

    @Override
    public void onStreamReceived(Session session, Stream stream) {
        Log.i(LOG_TAG, "Stream Received");
        if (mSubscriber == null) {
            mSubscriber = new Subscriber.Builder(this, stream).build();
            mSubscriber.setSubscribeToAudio(false);
            mSubscriber.setSubscribeToVideo(false);
            mSession.subscribe(mSubscriber);

            RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(
                    getResources().getDisplayMetrics().widthPixels, getResources()
                    .getDisplayMetrics().heightPixels+300);

            mSubscriberViewContainer.addView(mSubscriber.getView(),layoutParams);
        }
    }

    @Override
    public void onStreamDropped(Session session, Stream stream) {
        Log.i(LOG_TAG, "Stream Dropped");


        if (mSubscriber != null) {
            mSubscriber = null;
            mSubscriberViewContainer.removeAllViews();
        }

        closeCall();
    }

    @Override
    public void onError(Session session, OpentokError opentokError) {
        Log.e(LOG_TAG, "Session error: " + opentokError.getMessage());
    }
    // PublisherListener methods

    @Override
    public void onStreamCreated(PublisherKit publisherKit, Stream stream) {
        Log.i(LOG_TAG, "Publisher onStreamCreated");
    }

    @Override
    public void onStreamDestroyed(PublisherKit publisherKit, Stream stream) {
        Log.i(LOG_TAG, "Publisher onStreamDestroyed");
    }

    @Override
    public void onError(PublisherKit publisherKit, OpentokError opentokError) {
        Log.e(LOG_TAG, "Publisher error: " + opentokError.getMessage());
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        closeCall();
    }


    private void closeCall(){
        stopRingtone();
        callMonitorHandler.removeCallbacks(null);
        if(mSession != null)
            mSession.disconnect();
        if(mSubscriber != null)
            mSubscriber.destroy();
        if(mPublisher != null)
            mPublisher.destroy();

        finishAffinity();
        System.exit(0);
    }

    private void playRingtone(){
        AudioManager manager = (AudioManager)this.getSystemService(Context.AUDIO_SERVICE);
        if(manager.getMode()==AudioManager.MODE_IN_CALL ){
            v = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
            // Vibrate for 500 milliseconds
            long[] pattern = {0, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000,
                    500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500,
                    1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000};
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O ) {
                v.vibrate(VibrationEffect.createWaveform(pattern,-1));
            } else {
                //deprecated in API 26
                v.vibrate(pattern,-1);
            }
        }
        else{
            Uri notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE);
            r = RingtoneManager.getRingtone(getApplicationContext(), notification);
            r.play();

            v = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
            // Vibrate for 500 milliseconds
            long[] pattern = {0, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000,
                    500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500,
                    1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000, 500, 1000};
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O ) {
                v.vibrate(VibrationEffect.createWaveform(pattern,-1));
            } else {
                //deprecated in API 26
                v.vibrate(pattern,-1);
            }
        }
    }

    private void stopRingtone(){
        if(r!=null && r.isPlaying()){
            r.stop();
        }
        if(v!=null ){
            v.cancel();
        }
    }

    private void startCallMonitor(){
        //wait and ring for 30 sec
        callMonitorHandler = new Handler();
        callMonitorHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                if(!isCallRecieved){
                    closeCall();
                }
            }
        },30000);

    }

}
