import 'dart:async';

class BbTimer {
  Timer timer;

   setSingleTimer(Duration duration , Function callback){
    Timer timer;
    innerCallback(){
      timer.cancel();
      callback();
    }
    timer = new Timer(duration, innerCallback);
    this.timer = timer;
  }


   Future getDelay(Duration duration ){
     Completer completer = new Completer();
     Timer timer;
     innerCallback(){
       timer.cancel();
       completer.complete();
     }
     timer = new Timer(duration, innerCallback);
     this.timer = timer;
     return completer.future;
   }

  setPeriodicTimerInSeconds(Duration duration , Function callback, {Duration tick = const Duration(seconds: 1)} ){
     Timer timer;
     innerCallback(Timer mtimer){
       if(duration.inSeconds>mtimer.tick){
         callback(mtimer.tick);
       }else{
         mtimer.cancel();
         callback(-1);
       }
     }
     timer = new Timer.periodic(tick, innerCallback);
     this.timer = timer;
  }

  cancelAllTimers(){
     if(this.timer != null){
       timer.cancel();
     }
  }

}