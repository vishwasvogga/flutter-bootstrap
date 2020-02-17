import 'dart:convert';

class AvailabilityWeek {
  Availability sunday = new Availability();
  Availability monday = new Availability();
  Availability tuesday = new Availability();
  Availability wednesday = new Availability();
  Availability thursday = new Availability();
  Availability friday = new Availability();
  Availability saturday = new Availability();
  bool available = false;
  String doctor = "";

  parse(dynamic obj) {
    if (obj != null) {
      sunday.parse(obj['availability']['sunday']);
      monday.parse(obj['availability']['monday']);
      tuesday.parse(obj['availability']['tuesday']);
      wednesday.parse(obj['availability']['wednesday']);
      thursday.parse(obj['availability']['thursday']);
      friday.parse(obj['availability']['friday']);
      saturday.parse(obj['availability']['saturday']);
      if (obj['available']) {
        available = obj['available'];
      }
      this.doctor = obj['doctor'];
    }
  }

  @override
  String toString() {
    return '{sunday: $sunday, monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, available: $available, doctor: $doctor}';
  }

  dynamic toJson() {
    dynamic obj = {
      'sunday': this.sunday.toJson(),
      'monday': this.monday.toJson(),
      'tuesday': this.tuesday.toJson(),
      'wednesday': this.wednesday.toJson(),
      'thursday': this.thursday.toJson(),
      'friday': this.friday.toJson(),
      'saturday': this.saturday.toJson()
    };
    return {'availability': obj,'available': available,'doctor': doctor};
  }
}

class Availability {
  bool status = false;
  List<dynamic> time = [
    {"from": "12:00", "to": "12:00"}
  ];

  parse(dynamic obj) {
    if (obj != null) {
      this.status = obj['status'];
      this.time = obj['time'];
    }
  }

  @override
  String toString() {
    return 'Availability{status: $status, time: $time}';
  }

  dynamic toJson() {
    dynamic obj = {'status': this.status, 'time': this.time};
    return obj;
  }
}
