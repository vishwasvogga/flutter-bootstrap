import 'package:pocvideocall/service/AppState.dart';
import 'package:pocvideocall/util/CommonElements.dart';
import 'package:pocvideocall/util/Constants.dart';
import 'package:pocvideocall/util/ProgressDialog.dart';
import 'package:pocvideocall/util/SnackBar.dart';
import 'package:pocvideocall/util/transations.dart';
import 'package:pocvideocall/view/appointment/Prescription.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pocvideocall/view/availability/Controller.dart';
import 'package:pocvideocall/view/model/Availability.dart';
import 'package:pocvideocall/view/model/Profile.dart';

import '../../util/util.dart';

class Availability extends StatefulWidget {
  Availability() : super();

  @override
  AvailabilityState createState() => AvailabilityState();
}

class AvailabilityState extends State<Availability> {
  bool shallShowProgressDialog = false;
  String tag = "AvailabilityState";
  String pageName = "Availability";
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  AvailabilityWeek availability = new AvailabilityWeek();
  Controller _controller = Controller();
  Profile profile = Profile();
  TimeOfDay dt_from = new TimeOfDay(hour: 9, minute: 0);
  TimeOfDay dt_to = new TimeOfDay(hour: 21, minute: 0);

  @override
  void initState() {
    super.initState();
    initOnAppoint();
  }

  initOnAppoint() async {
    getAvailability();
  }

  getAvailability() async {
    setState(() {
      shallShowProgressDialog = true;
    });
    profile = await _controller.getProfile();
    dynamic temp = await _controller.getAvailability();
    availability.parse(temp['result']);
    Util.log(availability.toString(), tag);
    setState(() {
      shallShowProgressDialog = false;
    });
  }

  getTimingArray(List<dynamic> timings) {
    List<Widget> _timings = [];
    int i = 0;
    timings.forEach((t) {
      _timings.add(
        SizedBox(
          width: 16,
          height: 1,
        ),
      );
      _timings.add(MaterialButton(
          child: BbMaterialApp.horizontalStackWdiget([
            BbTextView(t['from'].toString() + "-" + t['to'].toString(),
                Constants.h6, Constants.ColorTextPrimary),
            SizedBox(
              width: 4,
              height: 1,
            ),
            Icon(
              Icons.cancel,
              size: Constants.h5,
            )
          ], mainAxisAlignment: MainAxisAlignment.start),
          color: Constants.ColorPrimary.withOpacity(0.5),
          padding: EdgeInsets.all(4),
          onPressed: () async {
            //remove
            Util.log("timing button press", tag);
            timings.remove(t);
            updateAvailability();
          }));

      i++;
    });
    return _timings;
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = Container(
      padding: EdgeInsets.all(16),
      child: BbMaterialApp.verticalStackWdiget([
        BbMaterialApp.horizontalStackWdiget([
          BbTextViewLight(Translations.of(context).text("available"),
              Constants.h3, Constants.ColorTextPrimary),
          Switch(
            value: availability.available,
            onChanged: (changeVal) async {
              Util.log(
                  "Availability status change " + changeVal.toString(), tag);
              if (changeVal != null) {
                this.availability.available = changeVal;
                updateAvailability();
              }
            },
          )
        ], mainAxisAlignment: MainAxisAlignment.spaceBetween),

        // week section
        SizedBox(
          height: 32,
          width: 10,
        ),
        availability.available==true ? BbMaterialApp.verticalStackWdiget([
          //sunday
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: BbMaterialApp.horizontalStackWdiget([
              BbTextViewLight("Sunday", Constants.h4, Constants.ColorTextPrimary),
              SizedBox(
                width: 16,
              ),
              Switch(
                value: availability.sunday.status,
                onChanged: (changeVal) async {
                  availability.sunday.status = changeVal;
                  updateAvailability();
                },
              ),
              availability.sunday.status == true ? BbMaterialApp.horizontalStackWdiget([
                SizedBox(
                  width: 24,
                ),
                // timing buttons
                MaterialButton(
                    child: BbTextView(Translations.of(context).text('add'),
                        Constants.h6, Constants.ColorTextPrimary),
                    color: Constants.ColorSecondary.withOpacity(0.5),
                    padding: EdgeInsets.all(4),
                    onPressed: () async {
                      dynamic resp = await selectTimeSlot(dt_from, dt_to);

                      if (resp != null && resp['from'] != null) {
                        Util.log(resp.toString(), tag);
                        this.availability.sunday.time.add({
                          'from': resp['from'].format(context),
                          'to': resp['to'].format(context)
                        });
                        updateAvailability();
                      }
                    }),
                SizedBox(
                  width: 8,
                ),
                Container(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: getTimingArray(availability.sunday.time),
                    shrinkWrap: true,
                  ),
                  height: 36,
                )
              ]) : Container()
            ], mainAxisAlignment: MainAxisAlignment.start),
          ),
          //monday
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: BbMaterialApp.horizontalStackWdiget([
              BbTextViewLight("Monday", Constants.h4, Constants.ColorTextPrimary),
              SizedBox(
                width: 16,
              ),
              Switch(
                value: availability.monday.status,
                onChanged: (changeVal) async {
                  availability.monday.status = changeVal;
                  updateAvailability();
                },
              ),
              availability.monday.status == true ? BbMaterialApp.horizontalStackWdiget([
                SizedBox(
                  width: 24,
                ),
                // timing buttons
                MaterialButton(
                    child: BbTextView(Translations.of(context).text('add'),
                        Constants.h6, Constants.ColorTextPrimary),
                    color: Constants.ColorSecondary.withOpacity(0.5),
                    padding: EdgeInsets.all(4),
                    onPressed: () async {
                      dynamic resp = await selectTimeSlot(dt_from, dt_to);

                      if (resp != null && resp['from'] != null) {
                        Util.log(resp.toString(), tag);
                        this.availability.monday.time.add({
                          'from': resp['from'].format(context),
                          'to': resp['to'].format(context)
                        });
                        updateAvailability();
                      }
                    }),
                SizedBox(
                  width: 8,
                ),
                Container(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: getTimingArray(availability.monday.time),
                    shrinkWrap: true,
                  ),
                  height: 36,
                )
              ]) : Container()
            ], mainAxisAlignment: MainAxisAlignment.start),
          ),
          //truesday
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: BbMaterialApp.horizontalStackWdiget([
              BbTextViewLight("Tuesday", Constants.h4, Constants.ColorTextPrimary),
              SizedBox(
                width: 16,
              ),
              Switch(
                value: availability.tuesday.status,
                onChanged: (changeVal) async {
                  availability.tuesday.status = changeVal;
                  updateAvailability();
                },
              ),
              availability.tuesday.status == true ? BbMaterialApp.horizontalStackWdiget([
                SizedBox(
                  width: 24,
                ),
                // timing buttons
                MaterialButton(
                    child: BbTextView(Translations.of(context).text('add'),
                        Constants.h6, Constants.ColorTextPrimary),
                    color: Constants.ColorSecondary.withOpacity(0.5),
                    padding: EdgeInsets.all(4),
                    onPressed: () async {
                      dynamic resp = await selectTimeSlot(dt_from, dt_to);

                      if (resp != null && resp['from'] != null) {
                        Util.log(resp.toString(), tag);
                        this.availability.tuesday.time.add({
                          'from': resp['from'].format(context),
                          'to': resp['to'].format(context)
                        });
                        updateAvailability();
                      }
                    }),
                SizedBox(
                  width: 8,
                ),
                Container(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: getTimingArray(availability.tuesday.time),
                    shrinkWrap: true,
                  ),
                  height: 36,
                )
              ]) : Container()
            ], mainAxisAlignment: MainAxisAlignment.start),
          ),
          //wednesday
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: BbMaterialApp.horizontalStackWdiget([
              BbTextViewLight("Wednesday", Constants.h4, Constants.ColorTextPrimary),
              SizedBox(
                width: 16,
              ),
              Switch(
                value: availability.wednesday.status,
                onChanged: (changeVal) async {
                  availability.wednesday.status = changeVal;
                  updateAvailability();
                },
              ),
              availability.wednesday.status == true ? BbMaterialApp.horizontalStackWdiget([
                SizedBox(
                  width: 24,
                ),
                // timing buttons
                MaterialButton(
                    child: BbTextView(Translations.of(context).text('add'),
                        Constants.h6, Constants.ColorTextPrimary),
                    color: Constants.ColorSecondary.withOpacity(0.5),
                    padding: EdgeInsets.all(4),
                    onPressed: () async {
                      dynamic resp = await selectTimeSlot(dt_from, dt_to);

                      if (resp != null && resp['from'] != null) {
                        Util.log(resp.toString(), tag);
                        this.availability.wednesday.time.add({
                          'from': resp['from'].format(context),
                          'to': resp['to'].format(context)
                        });
                        updateAvailability();
                      }
                    }),
                SizedBox(
                  width: 8,
                ),
                Container(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: getTimingArray(availability.wednesday.time),
                    shrinkWrap: true,
                  ),
                  height: 36,
                )
              ]) : Container()
            ], mainAxisAlignment: MainAxisAlignment.start),
          ),
          //Thursday
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: BbMaterialApp.horizontalStackWdiget([
              BbTextViewLight("Thursday", Constants.h4, Constants.ColorTextPrimary),
              SizedBox(
                width: 16,
              ),
              Switch(
                value: availability.thursday.status,
                onChanged: (changeVal) async {
                  availability.thursday.status = changeVal;
                  updateAvailability();
                },
              ),
              availability.thursday.status == true ? BbMaterialApp.horizontalStackWdiget([
                SizedBox(
                  width: 24,
                ),
                // timing buttons
                MaterialButton(
                    child: BbTextView(Translations.of(context).text('add'),
                        Constants.h6, Constants.ColorTextPrimary),
                    color: Constants.ColorSecondary.withOpacity(0.5),
                    padding: EdgeInsets.all(4),
                    onPressed: () async {
                      dynamic resp = await selectTimeSlot(dt_from, dt_to);

                      if (resp != null && resp['from'] != null) {
                        Util.log(resp.toString(), tag);
                        this.availability.thursday.time.add({
                          'from': resp['from'].format(context),
                          'to': resp['to'].format(context)
                        });
                        updateAvailability();
                      }
                    }),
                SizedBox(
                  width: 8,
                ),
                Container(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: getTimingArray(availability.thursday.time),
                    shrinkWrap: true,
                  ),
                  height: 36,
                )
              ]) : Container()
            ], mainAxisAlignment: MainAxisAlignment.start),
          ),
          //Friday
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: BbMaterialApp.horizontalStackWdiget([
              BbTextViewLight("Friday", Constants.h4, Constants.ColorTextPrimary),
              SizedBox(
                width: 16,
              ),
              Switch(
                value: availability.friday.status,
                onChanged: (changeVal) async {
                  availability.friday.status = changeVal;
                  updateAvailability();
                },
              ),
              availability.friday.status == true ? BbMaterialApp.horizontalStackWdiget([
                SizedBox(
                  width: 24,
                ),
                // timing buttons
                MaterialButton(
                    child: BbTextView(Translations.of(context).text('add'),
                        Constants.h6, Constants.ColorTextPrimary),
                    color: Constants.ColorSecondary.withOpacity(0.5),
                    padding: EdgeInsets.all(4),
                    onPressed: () async {
                      dynamic resp = await selectTimeSlot(dt_from, dt_to);

                      if (resp != null && resp['from'] != null) {
                        Util.log(resp.toString(), tag);
                        this.availability.friday.time.add({
                          'from': resp['from'].format(context),
                          'to': resp['to'].format(context)
                        });
                        updateAvailability();
                      }
                    }),
                SizedBox(
                  width: 8,
                ),
                Container(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: getTimingArray(availability.friday.time),
                    shrinkWrap: true,
                  ),
                  height: 36,
                )
              ]) : Container()
            ], mainAxisAlignment: MainAxisAlignment.start),
          ),
          //Saturday
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: BbMaterialApp.horizontalStackWdiget([
              BbTextViewLight("Saturday", Constants.h4, Constants.ColorTextPrimary),
              SizedBox(
                width: 16,
              ),
              Switch(
                value: availability.saturday.status,
                onChanged: (changeVal) async {
                  availability.saturday.status = changeVal;
                  updateAvailability();
                },
              ),
              availability.saturday.status == true ? BbMaterialApp.horizontalStackWdiget([
                SizedBox(
                  width: 24,
                ),
                // timing buttons
                MaterialButton(
                    child: BbTextView(Translations.of(context).text('add'),
                        Constants.h6, Constants.ColorTextPrimary),
                    color: Constants.ColorSecondary.withOpacity(0.5),
                    padding: EdgeInsets.all(4),
                    onPressed: () async {
                      dynamic resp = await selectTimeSlot(dt_from, dt_to);

                      if (resp != null && resp['from'] != null) {
                        Util.log(resp.toString(), tag);
                        this.availability.saturday.time.add({
                          'from': resp['from'].format(context),
                          'to': resp['to'].format(context)
                        });
                        updateAvailability();
                      }
                    }),
                SizedBox(
                  width: 8,
                ),
                Container(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: getTimingArray(availability.saturday.time),
                    shrinkWrap: true,
                  ),
                  height: 36,
                )
              ]) : Container()
            ], mainAxisAlignment: MainAxisAlignment.start),
          ),

        ],mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start) : new Container()
      ], mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start),
    );

    return new WillPopScope(
        child: BbMaterialApp.StackWdiget([
          Scaffold(
            key: key,
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            appBar: new AppBar(
              title: BbTextView(
                  pageName, Constants.h3, Constants.ColorTextPrimary),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: Builder(
                builder: (context) => IconButton(
                    icon: new Icon(
                      Icons.arrow_back,
                      size: 35,
                      color: Constants.ColorTextPrimary,
                    ),
                    onPressed: () => Navigator.of(context).pop()),
              ),
              actions: <Widget>[],
            ),
            body: ProgressDialog().ProgressDialogMask(shallShowProgressDialog,
                Translations.of(context).text('almost_there'), screen,
                isScroll: false, color: Colors.transparent),
          ),
        ]),
        onWillPop: () async {
          return true;
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  updateAvailability() async {
    //update avaiability
    setState(() {
      shallShowProgressDialog = true;
    });
    dynamic temp = await _controller.putAvailability(this.availability);
    setState(() {
      shallShowProgressDialog = false;
    });
    if (temp == true) {
      BbSnackBar.showToast(
          Translations.of(context).text("success"), context, key);
    } else {
      BbSnackBar.showToast(Translations.of(context).text("fail"), context, key);
    }
  }

  Future<dynamic> selectTimeSlot(dt_from, dt_to) {
    AlertDialog alert = AlertDialog(
      actions: [],
      content: TimeSelect(dt_from, dt_to),
    );

    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class TimeSelect extends StatefulWidget {
  TimeOfDay dt_from;
  TimeOfDay dt_to;

  TimeSelect(this.dt_from, this.dt_to);

  @override
  State createState() {
    return TimeSelectState();
  }
}

class TimeSelectState extends State<TimeSelect> {
  String tag = "TimeSelectState";

  @override
  Widget build(BuildContext context) {
    return BbMaterialApp.verticalStackWdiget([
      SizedBox(
        height: 16,
      ),
      BbMaterialApp.horizontalStackWdiget(
        [
          new RaisedButton(
              child: BbTextView(Translations.of(context).text('from'),
                  Constants.h6, Constants.ColorTextPrimary),
              onPressed: () async {
                dynamic temp = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: 9, minute: 0));
                if (temp != null) {
                  widget.dt_from = temp;
                }
                setState(() {
                  Util.log(widget.dt_from.toString(), tag);
                });
              }),
          SizedBox(
            width: 32,
          ),
          BbTextView(widget.dt_from.format(context), Constants.h6,
              Constants.ColorPrimary),
        ],
      ),
      SizedBox(
        height: 16,
      ),
      BbMaterialApp.horizontalStackWdiget([
        new RaisedButton(
            child: BbTextView(Translations.of(context).text('to'), Constants.h6,
                Constants.ColorTextPrimary),
            onPressed: () async {
              dynamic temp = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(hour: 21, minute: 0));
              if (temp != null) {
                widget.dt_to = temp;
              }
              setState(() {
                Util.log(widget.dt_to.toString(), tag);
              });
            }),
        SizedBox(
          width: 32,
        ),
        BbTextView(
            widget.dt_to.format(context), Constants.h6, Constants.ColorPrimary),
      ]),
      SizedBox(
        height: 32,
      ),
      BbMaterialApp.horizontalStackWdiget([
        new FlatButton(
          child: BbTextView(Translations.of(context).text('cancel'),
              Constants.h6, Constants.ColorTextPrimary),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: BbTextView(Translations.of(context).text('add'), Constants.h6,
              Constants.ColorTextPrimary),
          onPressed: () {
            //add to array
            Navigator.of(context)
                .pop({"from": widget.dt_from, 'to': widget.dt_to});
            Util.log(widget.dt_to.toString(), tag);
            Util.log(widget.dt_from.toString(), tag);
          },
        )
      ])
    ], mainAxisSize: MainAxisSize.min);
  }
}
