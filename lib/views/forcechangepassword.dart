import 'package:cdh/models/changepassword.dart';
import 'package:cdh/models/member.dart';
import 'package:cdh/models/response.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'login.dart';

class ForceChangePasswordScreen extends StatefulWidget{
  @override
  _ForceChangePasswordScreen createState() => _ForceChangePasswordScreen();
}

class _ForceChangePasswordScreen extends State<ForceChangePasswordScreen> {

  String username="";
  String password="";
  String oldpassword="";
  String newpassword="";
  String AuthToken="";
  String confirmpassword="";
  bool ischangedsuccess=false;
  bool loading=false;
  bool canclick=true;
  String loadingtext="Change password";
  String errortext="";
  DateTime loginDate;
  Future<void> getLoginTime() async {
    try{
      String t=await FlutterSession().get("LOGINTIME");
      print("LOGINTIME");
      print(t);
      loginDate=DateTime.parse(t);
      final difference = DateTime.now().difference(loginDate).inMinutes;
      if(difference>5){
        Fluttertoast.showToast(
            msg: "Session timed out!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM
        );
        Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext context) => LoginScreen(),
                                              ),
                                                  (route) => false,
                                            );
      }else{
        var loginTime = DateTime.now();
        final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
        final String formattedDate = formatter.format(loginTime);
        await session.set("LOGINTIME", formattedDate);
      }
      print(loginDate);
      setState(() {
        loginDate=loginDate;
      });

    }on Exception catch(_){
      print(_);
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      username="";
      password="";
      oldpassword="";
      newpassword="";
      ischangedsuccess=false;
      canclick=true;
      loadingtext="Change password";
      loading=false;
      errortext="";
      AuthToken="";
      getLoginTime();
      getUserSessionData();
      getUserTokenData();
    });
    getLoginTime();
  }
  Future<void> getUserTokenData() async {
    try{
      String at=await FlutterSession().get("AUTHTOKEN");
      setState(() {
        AuthToken=at;
      });
    }on Exception catch(_){

    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage("images/blue_background.jpg"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Column(
            children: <Widget>[
              Spacer(),
              Center(
                child: Image(
                  image: AssetImage("images/cdhlogo.png"),
                  width: 200,
                ),
              ),
              Center(
                child:  Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Text("Change password",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 24,
                          fontFamily: 'CalibriBold'
                      )
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextField(
                        obscureText: true,

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Current Password',
                          hintText: 'Enter current password',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (text){
                          setState(() {
                            oldpassword=text;
                          });
                        },
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                    Container(
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'New Password',
                          hintText: 'Enter new password',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (text){
                          setState(() {
                            newpassword=text;
                          });
                        },
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                    Container(
                      child: TextField(
                        obscureText: true,

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confirm Password',
                          hintText: 'Confirm password',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (text){
                          setState(() {
                            confirmpassword=text;
                          });
                        },
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                    Container(
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: RaisedButton(
                          textColor: Colors.white,
                          child: Text(loadingtext,
                          style: TextStyle(
                              fontFamily: 'CalibriBold'
                          ),),
                          color: Colors.indigoAccent[700],
                          onPressed: (){
                            if(username==null){
                              Navigator.pop(context);
                            }
                            if(username==""){
                              Navigator.pop(context);
                            }
                            if(newpassword=="" || oldpassword=="" || confirmpassword==""){
                              setState(() {
                                errortext="Fill in all the fields!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }else if(newpassword.length<3){
                              setState(() {
                                errortext="New password must be greater than 3 characters!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }else if(newpassword!=oldpassword){
                              setState(() {
                                errortext="New password and confirm password do not match!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }else {

                              Member member=Member(username: username,password: oldpassword,OPERATION: "CHANGEPASSWORD",
                                  changepassword: ChangePassword(oldpass: oldpassword,newpass: newpassword));
                              try {
                                if(canclick){
                                  setState(() {
                                    canclick=false;
                                  });
                                  Future<LoginResponse> loginResponse=security(member,token:AuthToken);
                                  print(loginResponse);
                                  LoginResponse l;
                                  var order = loginResponse.then((value) => {
                                    updateValues(value.code,value.Status,"Success!",value)
                                  });
                                }
                              } on Exception catch (_) {
                                setState(() {
                                  canclick=true;
                                });
                                updateError();
                                print('never reached');
                              }
                            }
                          },
                        ),
                      ),
                      padding: EdgeInsets.all(10),
                    )
                  ],
                ),
              ),
              Spacer()
            ],
          )
        ],
      ),
    );
  }


  void updateValues(int code,bool isloggedin,String message,LoginResponse loginResponse)  {
    setState(() {
      canclick=true;
    });
    try{
      setState(() {
        loadingtext="Login";
        errortext="";
      });

      if(isloggedin){
        setState(() {
          canclick=true;
        });
        Fluttertoast.showToast(
            msg: "Password changed successfully!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM
        );
        Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext context) => LoginScreen(),
                                              ),
                                                  (route) => false,
                                            );
      }else{
        setState(() {
          canclick=true;
        });
        Fluttertoast.showToast(
            msg: "Invalid credentials! Try again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM
        );
      }
    }on Exception catch(_){
      setState(() {
        canclick=true;
      });
      setState(() {
        loadingtext="Login";
        errortext="";
      });
    }

    print("Update");
  }

  void updateError(){
    setState(() {
      canclick=true;
    });
    setState(() {
      loadingtext="Change password";
      errortext="";
    });
    Fluttertoast.showToast(
        msg: "Network failure!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM
    );
  }

  Future<void> getUserSessionData() async {
    print("UsernameStoredSec: "+(await session.get("USERNAME")));
    String u=await FlutterSession().get("USERNAME");
    String p=await FlutterSession().get("PASSWORD");
    setState(() {
      username=u;
      //password=p;
    });
  }

}