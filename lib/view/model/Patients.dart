class Patient{
  String _id="";
  dynamic mobile={"number":""};
  String full_name ="";
  String city="";
  String email="";

  parse(dynamic obj){
    if(obj != null){
      this._id  = obj['_id'];
      this.mobile  = obj['mobile'];
      this.full_name  = obj['full_name'];
      this.city  = obj['city'];
      this.email  = obj['email'];
    }
  }

  @override
  String toString() {
    return 'Patient{_id: $_id, mobile: $mobile, full_name: $full_name, city: $city, email: $email}';
  }


}