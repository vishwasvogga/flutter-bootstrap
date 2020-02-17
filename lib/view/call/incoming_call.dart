import 'package:flutter/material.dart';
//import 'package:flutter_opentok/flutter_opentok.dart';
import '../../util/util.dart';
import './video_session.dart';
import './settings.dart';
import './controller.dart';


class IncommingCall extends StatefulWidget {

  Map<String,dynamic> call_data;

  IncommingCall(this.call_data);

  @override
  State createState() {
    return _state();
  }
}

class _state extends State<IncommingCall>{

  static final _sessions = List<VideoSession>();
  final _infoStrings = <String>[];
  bool muted = false;
  bool publishVideo = true;
 // OTFlutter controller;
 // OpenTokConfiguration openTokConfiguration;
  Controller _controller = new Controller();
  final tag = "IncommingCall state";

  @override
  void initState() {
    super.initState();
    _controller.DecodeKeys(widget.call_data);
    initialize();
  }

  @override
  void dispose() {
    _sessions.clear();
    super.dispose();
  }

  void initialize() {
    if (Settings.API_KEY.isEmpty) {
      setState(() {
        _infoStrings.add(
            "APP_ID missing, please provide your API_KEY in settings.dart");
        _infoStrings.add("OpenTok is not starting");
      });
      return;
    }

    if (Settings.SESSION_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
            "SESSION_ID missing, please provide your SESSION_ID in settings.dart");
        _infoStrings.add("OpenTok is not starting");
      });
      return;
    }

    if (Settings.TOKEN.isEmpty) {
      setState(() {
        _infoStrings
            .add("TOKEN missing, please provide your TOKEN in settings.dart");
        _infoStrings.add("OpenTok is not starting");
      });
      return;
    }

    Util.log("API_KEY"+Settings.API_KEY+"SESSION_ID"+Settings.SESSION_ID+"TOKEN"+Settings.TOKEN+"CALLER"+Settings.CALLER,tag);

//    openTokConfiguration = OpenTokConfiguration(
//        token: Settings.TOKEN, apiKey: Settings.API_KEY, sessionId: Settings.SESSION_ID);
//
//    _addRenderView(0, (viewId) {
//      Util.log("View id is "+viewId.toString(),tag);
//    });
  }

  // Toolbar layout
  Widget _toolbar() {
    return Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RawMaterialButton(
              onPressed: () => true,//_togglePublisherVideo(),
              child: Icon(
                publishVideo ? Icons.videocam : Icons.videocam_off,
                color: publishVideo ? Colors.white : Colors.blueAccent,
                size: 20.0,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: muted ? Colors.blueAccent : Colors.white,
              padding: const EdgeInsets.all(12.0),
            ),
            RawMaterialButton(
    onPressed: () => true,
           //   onPressed: () => _onToggleMute(),
              child: Icon(
                muted ? Icons.mic : Icons.mic_off,
                color: muted ? Colors.white : Colors.blueAccent,
                size: 20.0,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: muted ? Colors.blueAccent : Colors.white,
              padding: const EdgeInsets.all(12.0),
            ),
            RawMaterialButton(
              onPressed: () =>  true,//_onSwitchCamera(),
              child: Icon(
                Icons.switch_camera,
                color: Colors.blueAccent,
                size: 20.0,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.white,
              padding: const EdgeInsets.all(12.0),
            )
          ],
        ));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    return _sessions.map((session) => session.view).toList();
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  Widget _viewRows() {
    List<Widget> views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
              children: <Widget>[_videoView(views[0])],
            ));
      default:
    }

    return Container();
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 48),
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: ListView.builder(
                  reverse: true,
                  itemCount: _infoStrings.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (_infoStrings.length == 0) {
                      return null;
                    }
                    return Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Flexible(
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.yellowAccent,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(_infoStrings[index],
                                      style:
                                      TextStyle(color: Colors.blueGrey))))
                        ]));
                  })),
        ));
  }

  /// Create a native view and add a new video session object
//  void _addRenderView(int uid, Function(int viewId) finished) {
//    OTFlutter.onSessionConnect = () {
//      print("onSessionConnect");
//    };
//
//    OTFlutter.onSessionDisconnect = () {
//      print("onSessionDisconnect");
//    };
//
//    var publisherSettings = OTPublisherKitSettings(
//      name: "Mr. John Doe",
//      audioTrack: true,
//      videoTrack: publishVideo,
//    );
//    Widget view = OTFlutter.createNativeView(uid,
//        publisherSettings: publisherSettings, created: (viewId) async {
//          controller = await OTFlutter.init(viewId);
//
//          await controller.create(openTokConfiguration);
//        });
//
//    VideoSession session = VideoSession(uid, view);
//    _sessions.add(session);
//    Util.log("Video Session added", tag);
//
//  }
//
//  void _togglePublisherVideo() async {
//    if (publishVideo) {
//      await controller?.disablePublisherVideo();
//    } else {
//      await controller?.enablePublisherVideo();
//    }
//
//    setState(() {
//      publishVideo = !publishVideo;
//    });
//  }
//
//  void _onToggleMute() async {
//    if (muted) {
//      await controller?.unmutePublisherAudio();
//    } else {
//      await controller?.mutePublisherAudio();
//    }
//
//    setState(() {
//      muted = !muted;
//    });
//  }
//
//  void _onSwitchCamera() async {
//    await controller?.switchCamera();
//  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('OpenTok SDK'),
          ),
          backgroundColor: Colors.black,
          body: Center(
              child: Stack(
                children: <Widget>[_viewRows(), _panel(), _toolbar()],
              ))),
    );
  }
}