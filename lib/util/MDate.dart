import 'package:moment/moment.dart';
import 'package:pocvideocall/util/util.dart';

class MDate{
  List<String> weeks = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
  List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
 String tag = "MDate";

  constructor() { }

  getDaysArray(year, month) {
    const names = [ 'sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat' ];
    DateTime date = new DateTime(year, month - 1, 1);
    dynamic result = [];
    while (date.month == month - 1) {
      result.add({"date": date, 'day': names[date.day], 'datetime': Moment(date).format("DD-MM-YYYY")});
      date.add(Duration(days: 1));
    }
    return result;
  } 

  today() {
    return {
      "date": this.format(this.now, 'YYYY-MM-DD')
    };
  }

  weeks_day() {
    //get week's sunday's date
    DateTime today = DateTime.now();
    int today_day = today.weekday;

    List<dynamic> dates = [];
    for (int i = today_day; i < 21+today_day; i++) {
      int week_day = i % 7;
      dynamic _date;

      if(today_day == i){
        _date = {
          "day": this.weeks[week_day],
          "is_clicked": true,
          "date": today.add(Duration(days: i-today_day)).day,
          "date_obj":today.add(Duration(days: i-today_day))
        };
      }else{
        _date = {
          "day": this.weeks[week_day],
          "is_clicked": false,
          "date": today.add(Duration(days: i-today_day)).day,
          "date_obj":today.add(Duration(days: i-today_day))
        };
      }

      dates.add(_date);
    }

    return dates;
  }

  next7Days() {
    const dates = [];
    dates.add({
      "day": Moment().format('ddd'),
      "date": Moment().format('yyyy-MM-dd')
    });

    for (int i = 0; i < 6; i++) {
      dates.add({
        "day": Moment().add(i + 1, Unit.day).format('ddd'),
        "date": Moment().add(i + 1, Unit.day).format('yyyy-MM-dd')
      });
    }

    return dates;
  }

  now() {
    return Moment().toString();
  }

  format(date, format) {
    return Moment(date).format(format);
  }

  month() {
    return this.months[DateTime.now().month-1];
  }
}