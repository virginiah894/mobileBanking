import 'package:cdh/models/changepassword.dart';
import 'package:cdh/models/member.dart';
import 'package:cdh/models/response.dart';
import 'package:cdh/views/changepassword.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'home.dart';
import 'login.dart';

class NewMoreFragment extends StatefulWidget {
  @override
  _NewMoreFragment createState() => _NewMoreFragment();
}

/// This is the private State class that goes with MyStatefulWidget.
class _NewMoreFragment extends State<NewMoreFragment> {
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
  String fullname="";
  String accountnumber="";
  String AuthToken="";
  var session = FlutterSession();
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
      fullname="";
      accountnumber="";
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
          ListView(
            children: [
              Container(
                //margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.only(top: 30,bottom: 30),
                //color: Colors.indigoAccent[700],
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 20,top: 20,bottom: 15,right: 20),
                        padding: EdgeInsets.only(left: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "More",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'CalibriBold'
                              ),
                            ),
                            Spacer()
                          ],
                        )
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20,top: 20,bottom: 15,right: 20),
                      child: Card(
                        elevation: 4,
                        color: Colors.transparent,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Center(
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Icon(
                                      FontAwesomeIcons.user,
                                      color: Colors.indigoAccent[700],
                                      size: 40,
                                    ),
                                  )
                              ),
                              Center(
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child :Text(fullname,
                                      style: TextStyle(
                                        fontFamily: 'CalibriBold',
                                        fontWeight: FontWeight.normal,
                                        color: Colors.indigoAccent[700],
                                        fontSize: 22,
                                      ),),
                                  )
                              ),
                              Center(
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: Text(accountnumber,
                                      style: TextStyle(
                                        fontFamily: 'CalibriRegular',
                                        fontWeight: FontWeight.normal,
                                        color: Colors.indigoAccent[700],
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20,top: 20,bottom: 15,right: 20),
                      child: Card(
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.person_outline_sharp,
                                size: 50,
                                color: Colors.black54,),
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(bottom: 3),
                                      child: Text(
                                        fullname,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                            fontSize: 18,
                                            fontFamily: 'CalibriBold'
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      child: Text(accountnumber,style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontFamily: 'CalibriBold'
                                      ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20,top: 20,bottom: 15,right: 20),
                      child: Card(
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.edit_outlined,
                                color: Colors.black54,),
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(bottom: 3),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ChangepasswordScreen()),
                                            );
                                          },
                                          child: new Padding(
                                            padding: new EdgeInsets.all(10.0),
                                            child: new Text("Change password",
                                              style: TextStyle(
                                                  fontFamily: 'CalibriBold'
                                              ),),
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20,top: 20,bottom: 15,right: 20),
                      child: Card(
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.logout,
                                color: Colors.black54,),
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(bottom: 3),
                                        child: InkWell(
                                          onTap: () {
                                            clearSession();
                                            Fluttertoast.showToast(
                                                msg: "Logout successful!",
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
                                          },
                                          child: new Padding(
                                            padding: new EdgeInsets.all(10.0),
                                            child: new Text("Logout",
                                              style: TextStyle(
                                                  fontFamily: 'CalibriBold'
                                              ),),
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> getUserSessionData() async {
    print("UsernameStoredSec: " + (await session.get("USERNAME")));
    String f = await FlutterSession().get("FULLNAME");
    String a = await FlutterSession().get("ACCOUNTNUMBER");
    setState(() {
      fullname = f!=null?f:"";
      accountnumber = a!=null?a:"";
    });
  }

  Future<void> clearSession() async {
    try{
      await FlutterSession().set("FULLNAME","");
      await FlutterSession().set("ACCOUNTNUMBER","");
      await FlutterSession().set("USERNAME","");
      await FlutterSession().set("PASSWORD","");
    }on Exception catch(_){

    }
  }


}