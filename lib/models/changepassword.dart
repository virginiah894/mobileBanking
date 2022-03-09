
class ChangePassword{
  String oldpass;
  String newpass;

  ChangePassword({this.oldpass, this.newpass});

  Map<String, dynamic> toJson() => {
    "oldpass": this.oldpass!=null?this.oldpass:"",
    "newpass": this.newpass!=null?this.newpass:""
  };

  factory ChangePassword.fromJson(Map<String, dynamic> json) {
    return ChangePassword(
        newpass: json['newpass'],
        oldpass: json['oldpass']
    );
  }
}