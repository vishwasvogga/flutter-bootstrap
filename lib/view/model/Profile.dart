class Profile{
  String _id="";
  dynamic name ={}; //{name: {first: Vishwas, last: Poojary K},
  dynamic location={}; //{address: Mangalore, city: Vogga},
  dynamic tokens={}; // {onesignal: 76713c61-3c06-4810-8dc8-01b4cca82809},
  dynamic speciality=[]; //[Psychologist],
  dynamic language={}; // [{_id: 5bfcdd3e936dcc74ce8c8d31, title: English},{_id: 5bfcdd52bea5ed74c6f5d7dc, title: Malayalam}],
  bool availability  = true;
  int total_experience = 1;
  dynamic employment =[]; //[{_id: 5da33f24346d2e328e679a21, hospital_name: Happy town, designation: Healer}],
  String photo;  //5cd3dd25c5cda8710bb1335d,
  int cost_for_consultation=0; // 300,
  String email=""; //vishwasvogga@gmail.com,
  int mobile=0; // 9632276375,
  dynamic education=[] ;
  dynamic registration= [];


  parse(dynamic obj){
    if(obj != null){
      this._id  = obj['_id'];
      this.name  = obj['name'];
      this.location  = obj['location'];
      this.tokens  = obj['tokens'];
      this.speciality  = obj['speciality'];
      this.language  = obj['language'];
      this.availability  = obj['availability'];
      this.total_experience  = obj['total_experience'];
      this.employment  = obj['employment'];
      this.cost_for_consultation  = obj['cost_for_consultation'];
      this.email  = obj['email'];
      this.mobile  = obj['mobile'];
      this.education  = obj['education'];
      this.registration  = obj['registration'];
    }
  }

  @override
  String toString() {
    return 'Profile{_id: $_id, name: $name, location: $location, tokens: $tokens, speciality: $speciality, language: $language, availability: $availability, total_experience: $total_experience, employment: $employment, photo: $photo, cost_for_consultation: $cost_for_consultation, email: $email, mobile: $mobile, education: $education, registration: $registration}';
  }


}