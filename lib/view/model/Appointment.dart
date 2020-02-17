class Appointment{
  String _id="";
  String appointment_id="";
  dynamic flags={
    "isPaid":false,
    "isCompleted":false,
    "isCancelled":false
  };
  dynamic user={
    "_id":"",
    "full_name":""
  };
  dynamic slot={
    "from":"",
    "to":""
  };
  int payment;
  List<dynamic> prescription= List();
  String doctor="";
  String status="";

  parse(dynamic obj){
    if(obj != null){
      this._id  = obj['_id'];
      this.appointment_id = this._id;
      this.flags  = obj['flags'];
      this.user  = obj['user'];
      this.slot  = obj['slot'];
      this.payment  = obj['payment'];
      this.prescription  = obj['prescription'];
      this.doctor  = obj['doctor'];
      this.status  = obj['status'];
    }
  }

  @override
  String toString() {
    return 'Appointment{_id: $_id, appointment_id: $appointment_id, flags: $flags, user: $user, slot: $slot, payment: $payment, prescription: $prescription, doctor: $doctor, status: $status}';
  }


}