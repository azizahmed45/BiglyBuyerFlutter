class RegisterModel {
  String email;
  String password;
  String name;
  String phone;
  String companyName;
  String address;
  String country;

  RegisterModel({this.email, this.password,this.name, this.phone,this.companyName, this.address, this.country});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    name = json['name'];
    phone = json['contact_number'];
    companyName = json['company_name'];
    country = json['country'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['password_confirmation'] = this.password;
    data['name'] = this.name;
    data['contact_number'] = this.phone;
    data['company_name'] = this.companyName;
    data['address'] = this.address;
    data['country'] = this.country;
    return data;
  }
}
