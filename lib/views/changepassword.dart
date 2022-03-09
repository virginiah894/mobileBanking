import 'package:cdh/models/changepassword.dart';
import 'package:cdh/models/member.dart';
import 'package:cdh/models/ministatement.dart';
import 'package:cdh/models/response.dart';
import 'package:cdh/views/morefragment.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'home.dart';
import 'login.dart';

class ChangepasswordScreen extends StatefulWidget {
  @override
  _ChangepasswordScreen createState() => _ChangepasswordScreen();
}

/// This is the private State class that goes with MyStatefulWidget.
class _ChangepasswordScreen extends State<ChangepasswordScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => HomeScreen(selectedFragment:_selectedIndex),
      ),
          (route) => false,
    );
  }
  String username="";
  String password="";
  String oldpassword="";
  String newpassword="";
  String confirmpassword="";
  bool ischangedsuccess=false;
  String AuthToken="";
  bool loading=false;
  bool canclick=true;
  String loadingtext="Save";
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
    // TODO: implement initState
    super.initState();
    setState(() {
      username="";
      password="";
      oldpassword="";
      AuthToken="";
      newpassword="";
      canclick=true;
      ischangedsuccess=false;
      loadingtext="Save";
      loading=false;
      AuthToken="";
      errortext="";
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
      appBar: AppBar(
        leading:IconButton(
          onPressed: (){
            Navigator.pop(context,
              MaterialPageRoute(builder: (context) =>MoreFragment()),)
            ;

          },
          icon:Icon(
            Icons.arrow_back,
            size: 40,),),
        title: Row(
          children: <Widget>[
            // Image(
            //   image: AssetImage("images/cdhlogo.png"),
            //   width: 50,
            // ),
            Spacer(),
            Text(" Password",
            style: TextStyle(
                fontFamily: 'CalibriBold',
                fontSize: 24
            ),),
            Spacer(),
            Icon(Icons.menu,
              size: 30,),

          ],
        ),
        backgroundColor: const Color.fromARGB(255, 33, 29, 112),
      ),
      body: Stack(
        children: <Widget>[
          // Image(
          //   image: AssetImage("images/blue_background.jpg"),
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height,
          //   fit: BoxFit.cover,
          // ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextField(
                        obscureText: true,

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Old Password',
                          hintText: 'Enter current password',
                        ),
                        onChanged: (text){
                          setState(() {
                            oldpassword=text;
                          });
                        },
                      ),
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(left: 25,right: 25,top: 40),
                    ),
                    Container(
                      child: TextField(
                        obscureText: true,

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'New Password',
                          hintText: 'Enter new password',
                        ),
                        onChanged: (text){
                          setState(() {
                            newpassword=text;
                          });
                        },
                      ),
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(left: 25,right: 25),
                    ),
                    Container(
                      child: TextField(
                        obscureText: true,

                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confirm Password',
                          hintText: 'Confirm password',
                        ),
                        onChanged: (text){
                          setState(() {
                            confirmpassword=text;
                          });
                        },
                      ),
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(left: 25,right: 25),
                    ),
                    Container(
                      child: SizedBox(
                        width: 220,
                        height: 60,
                        child: RaisedButton(
                          textColor: Colors.white,
                          child: Text(loadingtext,
                          style: TextStyle(
                              fontFamily: 'CalibriBold',
                            fontSize: 24,
                          ),),
                          color: Colors.orange[700],
                          shape: RoundedRectangleBorder(
                              borderRadius:BorderRadius.circular(12)
                          ),
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
                                  //Future<LoginResponse> loginResponse=login(member,token:AuthToken);
                                  Future<LoginResponse> loginResponse=security(member,token:AuthToken);
                                  print(loginResponse);
                                  LoginResponse l;
                                  var order = loginResponse.then((value) => {
                                    updateValues(value.code,value.Status,"Success!",value)
                                  });
                                }
                              } on Exception catch (_) {
                                updateError();
                                print('never reached');
                              }
                            }
                          },
                        ),
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top:25,left: 25,right: 25),
                    )
                  ],
                ),
              ),
              Spacer()
            ],
          ),
          Container(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: MaterialButton(
                onPressed: () => {},
                child: Text('copyright @ 2021 CDH Investment Bank Limited',
                  style: new TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    fontFamily: 'CalibriRegular',
                    color: Colors.black,
                  ),),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
                color: Colors.grey[500],
                offset: Offset(0, -0.5)
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance),
              label: 'Account balance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help_outline_outlined),
              label: 'Help',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'More',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[800],
          unselectedItemColor: Colors.black54,
          onTap: _onItemTapped,
        ),
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
      loadingtext="Save";
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