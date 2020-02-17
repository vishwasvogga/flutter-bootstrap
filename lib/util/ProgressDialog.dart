import 'package:flutter/material.dart';
import 'dart:math';
import './Constants.dart';
import './CommonElements.dart';

class ProgressDialog{


   show(String msg){
    //return new Card(child:_buildAnimation() ,elevation: 100,color: Constants.ColorBackGround,);
     return new CircularProgressIndicator();
  }


   Widget _buildAnimation() {
     double circleWidth = 10.0 * 2;
     Widget circles = new Container(
       width: 70,
       height: 70,
       child: new Center(child:new Column(
         children: <Widget>[
           new Row (
             children: <Widget>[
               _buildCircle(circleWidth,Constants.ColorPrimary),
               _buildCircle(circleWidth,Constants.ColorTextPrimary),
             ],
           ),
           new Row (
             children: <Widget>[
               _buildCircle(circleWidth,Constants.ColorTextPrimary),
               _buildCircle(circleWidth,Constants.ColorPrimary),
             ],
           ),
         ],
       ) ,)
     );

     double angleInDegrees = 45;
     return new Transform.rotate(
       angle: angleInDegrees / 360 * 2 * 3.14,
       child: new Container(
         child: circles,
       ),
     );
   }

   Widget _buildCircle(double circleWidth, Color color) {
     return new Container(
       width: circleWidth,
       height: circleWidth,
       decoration: new BoxDecoration(
         color: color,
         shape: BoxShape.circle,
       ),
     );
   }



   ProgressDialogMask(bool shallShowProgressDialog,String msg,Widget uiFront,{isScroll:true,color}){
     if(color==null){
       color = Constants.ColorBackGround;
     }
     //pogress dialog
     Widget progressDialogConatiner;
     if (shallShowProgressDialog) {
       progressDialogConatiner = new Container(
           child: new Center(
             child: this.show(msg),
           ));
     } else {
       progressDialogConatiner = new Container();
     }

     Widget singleChild;
     if(isScroll){
       singleChild = SingleChildScrollView(
           child: uiFront
       );
     }else{
       singleChild = new Material(
           color:color,
           child: uiFront);
     }

     //enable/disable screen
     Widget screen = new AbsorbPointer(
       child:singleChild ,
       absorbing: shallShowProgressDialog);

     List<Widget> widgets = new List();
     widgets.add(screen);
     widgets.add(progressDialogConatiner);

     return BbMaterialApp.StackWdiget(widgets);
   }

}