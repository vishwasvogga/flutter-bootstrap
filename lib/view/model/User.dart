class User{
  bool success=false;
  int code=-1;
  dynamic fullname={'first':"","last":""};
  int mobile=0;
  String email="";
  String doctor_id="";
  String token="";

  parse(dynamic obj){
    if(obj != null && obj['success']==true && obj['data']!=null){
      this.code = 200;
      this.success=true;
      if(obj['data']['result']['full_name'] !=null){
        this.fullname['first']=obj['data']['result']['full_name']['first'];
        this.fullname['last']=obj['data']['result']['full_name']['last'];
      }
      this.mobile = obj['data']['result']['mobile'];
      this.email = obj['data']['result']['email'];
      this.doctor_id = obj['data']['result']['doctor_id'];
      this.token = obj['data']['result']['token'];
    }else if(obj != null && obj['success']==false ){
      this.code = obj['code'];
      this.success = false;
    }
  }


  @override
  String toString() {
    return 'User{success: $success, code: $code, fullname: $fullname, mobile: $mobile, email: $email, doctor_id: $doctor_id, token: $token}';
  }


}