import 'package:flutter/material.dart';
import './transations.dart';
import './Constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:catcher/catcher_plugin.dart';

//class to hold the textview params
class TextViewParams {
  String data;
  double size;
  Color color;
  bool isUnderline = false;
  TextAlign align = TextAlign.start;
}

///This class is wrapper on the material text of flutter
class BbTextView extends StatelessWidget {
  //to hold the textview params
  final TextViewParams _textViewParams = new TextViewParams();

  ///Constructor
  BbTextView(String text, double size, Color color,
      {bool isUnderline = false, TextAlign align = TextAlign.start}) {
    _textViewParams.color = color;
    _textViewParams.size = size;
    _textViewParams.data = text;
    _textViewParams.isUnderline = isUnderline;
    _textViewParams.align = align;
  }

  @override
  Widget build(BuildContext context) {
    TextDecoration decoration;

    if (_textViewParams.isUnderline == true) {
      decoration = TextDecoration.underline;
    } else {
      decoration = TextDecoration.none;
    }

    if (_textViewParams.data == null) _textViewParams.data = "";

    return new Text(_textViewParams.data,
        textAlign: _textViewParams.align,
        style: TextStyle(
            color: _textViewParams.color,
            fontSize: _textViewParams.size,
            fontWeight: FontWeight.w700,
            fontFamily: 'BarDef',
            decoration: decoration));
  }
}

///This class is wrapper on the material text of flutter (bold)
class BbTextViewBold extends StatelessWidget {
  //to hold the textview params
  final TextViewParams _textViewParams = new TextViewParams();

  ///Constructor
  BbTextViewBold(String text, double size, Color color,
      {bool isUnderline = false, TextAlign align = TextAlign.start}) {
    _textViewParams.color = color;
    _textViewParams.size = size;
    _textViewParams.data = text;
    _textViewParams.isUnderline = isUnderline;
    _textViewParams.align = align;
  }

  @override
  Widget build(BuildContext context) {
    TextDecoration decoration;
    if (_textViewParams.isUnderline == true) {
      decoration = TextDecoration.underline;
    } else {
      decoration = TextDecoration.none;
    }

    if (_textViewParams.data == null) _textViewParams.data = "";

    return new Text(
      _textViewParams.data,
      textAlign: _textViewParams.align,
      style: TextStyle(
        color: _textViewParams.color,
        fontSize: _textViewParams.size,
        fontWeight: FontWeight.w900,
        fontFamily: 'BarDef',
        decoration: decoration,
      ),
      overflow: TextOverflow.fade,
    );
  }
}

///This class is wrapper on the material text of flutter (light)
class BbTextViewLight extends StatelessWidget {
  //to hold the textview params
  final TextViewParams _textViewParams = new TextViewParams();
  var softWrap;
  var key;

  ///Constructor
  BbTextViewLight(String text, double size, Color color,
      {bool isUnderline = false,
      softWrap = true,
      key,
      align = TextAlign.start}) {
    _textViewParams.color = color;
    _textViewParams.size = size;
    _textViewParams.data = text;
    _textViewParams.isUnderline = isUnderline;
    _textViewParams.align = align;
    this.softWrap = softWrap;
    this.key = key;
  }

  @override
  Widget build(BuildContext context) {
    TextDecoration decoration;
    if (_textViewParams.isUnderline == true) {
      decoration = TextDecoration.underline;
    } else {
      decoration = TextDecoration.none;
    }

    if (_textViewParams.data == null) _textViewParams.data = "";

    if (key != null) {
      return new Text(
        _textViewParams.data,
        textAlign: _textViewParams.align,
        style: TextStyle(
            color: _textViewParams.color,
            decoration: decoration,
            fontSize: _textViewParams.size,
            fontWeight: FontWeight.w500,
            fontFamily: 'BarDef'),
        softWrap: softWrap,
        key: key,
      );
    } else {
      return new Text(
        _textViewParams.data,
        textAlign: _textViewParams.align,
        style: TextStyle(
            color: _textViewParams.color,
            decoration: decoration,
            fontSize: _textViewParams.size,
            fontWeight: FontWeight.w500,
            fontFamily: 'BarDef'),
        softWrap: softWrap,
      );
    }
  }
}

/// This is typical app scaleton with navigation bars and floating icon
class BbScaffold extends State {
  BbScaffold(
      {this.pageTittle,
      this.children,
      this.shallFloatingButtonIcon,
      this.onFloatingButtonPress,
      this.floatingButtonIcon});

  final String pageTittle;
  final Function onFloatingButtonPress;
  final Icon floatingButtonIcon;
  final bool shallFloatingButtonIcon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    //set state in case anything is changed here
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });

    //check if the floating button is needed
    FloatingActionButton getFloatingButton() {
      if (this.shallFloatingButtonIcon) {
        return FloatingActionButton(
          onPressed: this.onFloatingButtonPress,
          child: Icon(
            Icons.add,
            color: Constants.ColorTextPrimary,
          ),
        );
      } else {
        return null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(pageTittle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: this.children,
      ),
      floatingActionButton: getFloatingButton(),
    );
  }
}

///matereial wrapper class , which keeps the overall material theme of its children
class BbMaterialApp {
  Widget getMaterialApp(String tittle, Widget home, BuildContext context,
      Map<String, WidgetBuilder> routes, List<NavigatorObserver> nObservers) {
    return new DynamicTheme(
        defaultBrightness: Brightness.dark,
        data: (brightness) => ThemeData(
              primarySwatch: MaterialColor(0xFFFF5722,
                  Constants.primaryColorSwatch), // Constants.ColorPrimary,
              accentColor: Colors.grey,
              cursorColor: Color(0xFFFF5722),
              fontFamily: 'BarDef',
              brightness: brightness,
              iconTheme: IconThemeData(
                color: Constants.ColorTextPrimary, //change your color here
              ),
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            navigatorKey: Catcher.navigatorKey,
            title: tittle,
//            color: Constants.ColorBackGround,
//              theme: ThemeData(
//                  primarySwatch: MaterialColor(0xFF1A237E,
//                      Constants.primaryColorSwatch), // Constants.ColorPrimary,
//                  accentColor: Colors.grey,
//                  cursorColor: Color(0xFF1A237E),
//                  fontFamily: 'BarDef',
//              ),
            localizationsDelegates: [
              const TranslationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''),
            ],
            navigatorObservers: nObservers,
            home: home,
            routes: routes,
          );
        });
  }

  //contain the widget
  static Widget containTheWidget(Widget widget, EdgeInsets margin,
      {EdgeInsets padding}) {
    if (padding == null) {
      padding = new EdgeInsets.all(0);
    }
    return new Container(
      child: widget,
      margin: margin,
      padding: padding,
    );
  }

  static EdgeInsets getInsetsAll(double value) {
    return new EdgeInsets.all(value);
  }

  static Widget verticalStackWdiget(List<Widget> widgets,
      {mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize : MainAxisSize.max}) {
    return new Column(
      mainAxisSize : mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: widgets,
    );
  }

  static Widget horizontalStackWdiget(List<Widget> widgets,
      {mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize : MainAxisSize.max}) {
    return new Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: widgets,
    );
  }

  static Widget StackWdiget(List<Widget> widgets) {
    return new Stack(children: widgets, fit: StackFit.expand);
  }

  //text style for input fields
  static TextStyle textFieldStyle = new TextStyle(
      color: Constants.ColorTextPrimary,
      fontWeight: FontWeight.w600,
      fontFamily: 'BarDef',
      fontSize: Constants.h4);

  //text style for Buttons
  static TextStyle buttonTextStyle = new TextStyle(
      color: Constants.ColorTextPrimary,
      fontWeight: FontWeight.w600,
      fontFamily: 'BarDef',
      fontSize: Constants.h4);

  //text style for edit text
  static TextStyle hintTextStyle = new TextStyle(
      color: Constants.ColorDisabled,
      fontWeight: FontWeight.w300,
      fontFamily: 'BarDef',
      fontSize: Constants.h4);

  static getOutlineButton(String text, Function onClick,
      {borderColor, textColor, padding: null}) {
    if (padding == null) {
      padding = new EdgeInsets.all(8.0);
    }
    if (borderColor == null) {
      borderColor = Constants.ColorTextPrimary;
    }
    if (textColor == null) {
      textColor = Constants.ColorTextPrimary;
    }

    return new OutlineButton(
        child: containTheWidget(
            BbTextViewBold(text, Constants.h4, textColor), EdgeInsets.all(0),
            padding: padding),
        onPressed: () {
          onClick();
        },
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        disabledBorderColor: Constants.ColorSecondary,
        highlightedBorderColor: Constants.ColorSecondary,
        borderSide: BorderSide(color: borderColor));
  }

  static getFullButton(String text, Function onClick) {
    return new MaterialButton(
      child: containTheWidget(
          BbTextViewBold(text, Constants.h4, Constants.ColorTextPrimary),
          EdgeInsets.all(0),
          padding: EdgeInsets.all(8)),
      onPressed: () {
        onClick();
      },
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      disabledColor: Constants.ColorSecondary,
      highlightColor: Constants.ColorSecondary,
      color: Constants.ColorBackGround,
    );
  }

  static getBackground(Widget child) {
    return new Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [Constants.ColorBackGrad1, Constants.ColorBackGrad2],
              begin: Alignment.bottomLeft,
              end: Alignment(0.3, 0),
              tileMode: TileMode.clamp),
        ),
        child: child);
  }

  static getBackgroundOnly() {
    return new Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [
              Constants.ColorBackGrad1,
              Constants.ColorBackGrad2
            ], //[Constants.ColorBackGroundShade,Constants.ColorBackGround],
            begin: Alignment.bottomLeft,
            end: Alignment(0.3, 0),
            tileMode: TileMode.clamp),
      ),
    );
  }

  static getMaterialCover(Widget child) {
    return new Material(
      child: child,
    );
  }

  static getSizedBox(width, height) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  static gestureDetect(child, onClick, {onlongClick}) {
    return new InkWell(
        onTap: () {
          onClick();
        },
        child: child);
  }
}

//fade page transition
class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          settings: RouteSettings(name: page.toStringShort()),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
