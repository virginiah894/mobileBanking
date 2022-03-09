import 'package:cdh/models/changepassword.dart';
import 'package:cdh/models/member.dart';
import 'package:cdh/models/response.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'home.dart';
import 'login.dart';

class HelpFragment extends StatefulWidget {
  @override
  _HelpFragment createState() => _HelpFragment();
}

/// This is the private State class that goes with MyStatefulWidget.
class _HelpFragment extends State<HelpFragment> {
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
  String AuthToken="";
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
      getLoginTime();
    });
    getLoginTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text('Do you have a Question?',
          style: TextStyle(
              fontFamily: 'CalibriBold',
            fontSize: 20
          ),

        ),

        leading: Container(
          child:IconButton(
            icon:Image.asset('images/logout1.png'

            ),
            onPressed: (){
              setState(() {
                _selectedIndex = 0;
              });
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen(selectedFragment:_selectedIndex),
                ),
                    (route) => false,
              );
            },
          ),
        ),
        // actions: [
        //   Icon(FontAwesomeIcons.powerOff),
        // ],
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {

              },
              child: Icon(
                Icons.menu,
                size: 30.0,
              ),
            ),
          ),

        ],

        backgroundColor: const Color.fromARGB(255, 33, 29, 112),

      ),
      // appBar: AppBar(
      //   title: Row(
      //     children: <Widget>[
      //       Icon(FontAwesomeIcons.home,
      //         size: 30,),
      //
      //       Spacer(),
      //       Text("Do you have a Question?",
      //         style: TextStyle(
      //             fontFamily: 'CalibriBold'
      //         ),),
      //       Spacer(),
      //       Icon(Icons.menu,
      //         size: 30,),
      //
      //     ],
      //   ),
      //   backgroundColor: Colors.indigo[900],
      // ),
      body: Stack(
        children: <Widget>[

          ListView(
            children: [
              Container(
                // margin: EdgeInsets.only(top: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 20,top: 20,bottom: 15,right: 20),
                        padding: EdgeInsets.only(left: 8),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  left: 25, right: 5, top: 10
                              ),
                              child: Text('copyright @ 2021 CDH Investment Bank Limited',
                                style: new TextStyle(
                                  // fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    fontFamily: 'CalibriRegular',
                                    color: Colors.black,
                                ),

                              ),
                            ),

                          ],
                        )
                    ),
                    Container(

                      margin: EdgeInsets.only(top: 10,bottom: 15),

                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  // child: Icon(
                                  //   FontAwesomeIcons.question,
                                  //   color: Colors.white,
                                  // ),
                                )
                              ),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                )
                              ),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Text("Send an Email or Call with your Query to :",
                                    style: TextStyle(
                                      fontFamily: 'CalibriRegular',

                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text("info@cdh-malawi.com",
                                    style: TextStyle(
                                      fontFamily: 'CalibriRegular',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text("Help line: +2651821300",
                                    style: TextStyle(
                                      fontFamily: 'CalibriRegular',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: new AssetImage(
                                  'images/Background-2.jpg'),
                            ),

                          ),
                        ),



                    ),

                  ],
                ),

              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20,bottom: 10, top:10,right: 20),
                      padding: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.0
                          ),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Spacer(),

                          Text(
                            "Get In Touch",
                            style: TextStyle(
                              fontFamily: 'CalibriBold',
                              fontSize: 20,
                              color: Colors.orange[700],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 4,
                          ),

                          Spacer(),

                        ],
                      ),

                    ),
                    SizedBox(height: 20,),
                    Container(
                        margin: EdgeInsets.only(left: 20,bottom: 20,right: 20),
                        padding: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.0
                          ),
                        ),
                      ),
                        child: Row(
                          children: <Widget>[


                            Text(
                              "Name",
                              style: TextStyle(
                                fontFamily: 'CalibriBold',
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),


                            Spacer(),

                          ],
                        ),

                    ),
                    SizedBox(height: 20,),
                    Container(
                      margin: EdgeInsets.only(left: 20,bottom: 20,right: 20),
                      padding: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.0
                          ),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[

                          Text(
                            "Email",
                            style: TextStyle(
                              fontFamily: 'CalibriBold',
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),

                          Spacer(),

                        ],
                      ),

                    ),
                    SizedBox(height: 20,),
                    Container(
                      margin: EdgeInsets.only(left: 20,bottom: 20,right: 20),
                      padding: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.0
                          ),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[

                          Text(
                            "Company",
                            style: TextStyle(
                              fontFamily: 'CalibriBold',
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),

                          Spacer(),

                        ],
                      ),

                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 40,
                      margin: EdgeInsets.only(left: 20,bottom: 20,right: 20),
                      padding: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1.0
                          ),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[


                          Text(
                            "Message",
                            style: TextStyle(
                              fontFamily: 'CalibriBold',
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),



                        ],
                      ),

                    ),
                    Container(
                      height: 60,
                      width: 220,
                      child:RaisedButton(
                        textColor: Colors.white,
                        child: Text('Submit',
                          style: TextStyle(
                            fontFamily: 'CalibriBold',
                            fontSize: 24,
                          ),),
                        color: Colors.orange[700],
                        shape: RoundedRectangleBorder(
                            borderRadius:BorderRadius.circular(12)
                        ),
                        onPressed: () => {},

                      ),

                    ),


                  ],
                ),


              ),


            ],
          ),


        ],
      ),

    );
  }

}