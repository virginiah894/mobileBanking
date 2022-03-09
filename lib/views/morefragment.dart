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
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';



import 'home.dart';
import 'login.dart';

class MoreFragment extends StatefulWidget {
  @override
  _MoreFragment createState() => _MoreFragment();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MoreFragment extends State<MoreFragment> {
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
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }


  String fullname="";
  String accountnumber="";
  String AuthToken="";
  String DisplayLoginTime="";
  var session = FlutterSession();
  DateTime loginDate;
  Future<void> getLoginTime() async {
    try{
      String t=await FlutterSession().get("LOGINTIME");
      String tt=await FlutterSession().get("LOGINTIME");
      setState(() {
        DisplayLoginTime=tt;
      });
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
      DisplayLoginTime="";

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

  Widget _marquee(BuildContext context){
    return Marquee(
      text: 'Last Login: '+DisplayLoginTime+'',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'CalibriBold',
        fontSize: 14,
        color: Colors.white,
      ),
      scrollAxis: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      blankSpace: 20.0,
      velocity: 100.0,
      pauseAfterRound: Duration(seconds: 1),
      startPadding: 10.0,
      accelerationDuration: Duration(seconds: 1),
      accelerationCurve: Curves.linear,
      decelerationDuration: Duration(milliseconds: 500),
      decelerationCurve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 3),
                    child: Row(
                      children: [
                        Text(
                          fullname,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'CalibriBold'
                          ),
                        ),
                      ],
                    )
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 3),
                      child: //_marquee(context)
                    Row(
                      children: [
                        Text('Last Login: '
                          ,style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'CalibriBold'
                          ),
                        ),
                        Text(DisplayLoginTime+''
                          ,style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'CalibriBold'
                          ),
                        ),
                      ],
                    )
                  )
                ],
              ),
            )
          ],
        ),
        // const Text('Home',
        //   style: TextStyle(
        //       fontFamily: 'CalibriBold'
        //   ),
        //
        // ),

        leading: Container(
          child:IconButton(
            icon: Icon(
              FontAwesomeIcons.solidUserCircle,
              size: 30,
            ),
            onPressed: (

                ){

            },
          ),
        ),
        // actions: [
        //   Icon(FontAwesomeIcons.powerOff),
        // ],
        actions: <Widget>[

        ],

        backgroundColor: const Color.fromARGB(255, 33, 29, 112),
      ),
      // appBar: AppBar(
      //   title: Row(
      //     children: <Widget>[
      //       Container(
      //
      //           child: Container(
      //             padding: EdgeInsets.all(10),
      //             child: Row(
      //
      //               children: <Widget>[
      //                 Icon(FontAwesomeIcons.solidUserCircle,
      //                   size: 50,
      //                   color: Colors.white),
      //                 Container(
      //                   margin: EdgeInsets.only(left: 20),
      //                   child: Column(
      //                     children: <Widget>[
      //                       Container(
      //                         margin: EdgeInsets.only(bottom: 3),
      //                         child: Text(
      //                           fullname,
      //                           style: TextStyle(
      //                               fontWeight: FontWeight.bold,
      //                               color: Colors.white,
      //                               fontSize: 18,
      //                               fontFamily: 'CalibriBold'
      //                           ),
      //                         ),
      //                       ),
      //                       Container(
      //                         margin: EdgeInsets.only(top: 3),
      //                         child: Text('Last Login:'
      //                           ,style: TextStyle(
      //                             fontWeight: FontWeight.bold,
      //                             color: Colors.white,
      //                             fontSize: 18,
      //                             fontFamily: 'CalibriBold'
      //                         ),
      //
      //                         ),
      //                       )
      //                     ],
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ),
      //
      //       ),
      //     ],
      //   ),
      //   backgroundColor: Colors.indigo[900],
      // ),
      body: Stack(
        children: <Widget>[

          ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.only(left: 10,top: 10,bottom: 5,right: 10),

                      child: Card(
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              Container(
                                margin: EdgeInsets.only(left: 10),
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
                                          child: Row(
                                            children: [
                                              new Padding(
                                                padding: new EdgeInsets.only(left: 30,top: 20,right: 30,bottom: 10),
                                                child: new Text("Settings",

                                                  style: TextStyle(
                                                      fontFamily: 'Calibri',
                                                      fontSize: 20,
                                                      color: Colors.black54
                                                  ),
                                                  textAlign: TextAlign.center,


                                                ),

                                              ),
                                              SizedBox(width: 130),
                                              Icon(Icons.arrow_forward_ios,
                                                color: Colors.indigo[900],),

                                            ],
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //LocateUs
                    Container(
                      margin: EdgeInsets.only(left: 10,bottom: 10,right: 10),
                      child: Card(
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // Icon(Icons.edit_outlined,
                              //   color: Colors.black54,),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(bottom: 3),
                                        child: InkWell(
                                          onTap: () => launch('https://www.cdh-malawi.com/corporate-profile'),

                                          child: Row(
                                            children: [
                                              new Padding(
                                                padding: new EdgeInsets.only(left: 30,top: 20,right: 30,bottom: 10),
                                                child: new Text("Locate Us",

                                                  style: TextStyle(
                                                      fontFamily: 'Calibri',
                                                      fontSize: 20,
                                                      color: Colors.black54
                                                  ),
                                                  textAlign: TextAlign.center,


                                                ),

                                              ),
                                              SizedBox(width: 118),
                                              Icon(Icons.arrow_forward_ios,
                                                color: Colors.indigo[900],),

                                            ],
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                    //AboutUs
                    Container(
                      margin: EdgeInsets.only(left: 10,top: 10,right: 10),
                      child: Card(
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // Icon(Icons.edit_outlined,
                              //   color: Colors.black54,),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(bottom: 3),
                                        child: InkWell(
                                          onTap: () {
                                            const url = 'https://www.cdh-malawi.com/corporate-profile';
                                            launchURL(url);},
                                          child: Row(
                                            children: [
                                              new Padding(
                                                padding: new EdgeInsets.only(left: 30,top: 20,right: 30,bottom: 10),
                                                child: new Text("About Us",

                                                  style: TextStyle(
                                                      fontFamily: 'Calibri',
                                                      fontSize: 20,
                                                      color: Colors.black54
                                                  ),
                                                  textAlign: TextAlign.center,


                                                ),

                                              ),
                                              SizedBox(width: 125),
                                              Icon(Icons.arrow_forward_ios,
                                                color: Colors.indigo[900],),

                                            ],
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10,top: 10,right: 10),
                      child: Card(
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // Icon(Icons.edit_outlined,
                              //   color: Colors.black54,),
                              Container(
                                margin: EdgeInsets.only(left: 10),
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
                                          child: Row(
                                            children: [
                                              new Padding(
                                                padding: new EdgeInsets.only(left: 30,top: 20,right: 30,bottom: 10),
                                                child: new Text("Change Password",

                                                  style: TextStyle(
                                                      fontFamily: 'Calibri',
                                                      fontSize: 20,
                                                      color: Colors.black54
                                                  ),
                                                  textAlign: TextAlign.center,


                                                ),

                                              ),
                                              SizedBox(width: 45),
                                              Icon(Icons.arrow_forward_ios,
                                                color: Colors.indigo[900],),

                                            ],
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10,top: 10,bottom: 10,right: 10),
                      child: Card(
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 10),
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
                                            //Navigator.of(context).popUntil((route) => route.isFirst);
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (BuildContext context) => LoginScreen(),
                                              ),
                                                  (route) => false,
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              new Padding(
                                                padding: new EdgeInsets.only(left: 30,top: 20,right: 30,bottom: 10),
                                                child: new Text("Log Out",

                                                  style: TextStyle(
                                                      fontFamily: 'Calibri',
                                                      fontSize: 20,
                                                      color: Colors.black54
                                                  ),
                                                  textAlign: TextAlign.center,


                                                ),

                                              ),
                                              SizedBox(width: 139),
                                              Icon(Icons.arrow_forward_ios,
                                                color: Colors.indigo[900],),

                                            ],
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),


                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),


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