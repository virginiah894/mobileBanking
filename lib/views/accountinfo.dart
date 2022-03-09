import 'package:cdh/service/requests.dart';
import 'package:cdh/views/balance.dart';
import 'package:cdh/views/changepassword.dart';
import 'package:cdh/views/ministatement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'home.dart';
import 'login.dart';

class AccountInfoScreen extends StatefulWidget{
  @override
  _AccountInfoScreen createState() =>_AccountInfoScreen();
}

class _AccountInfoScreen extends State<AccountInfoScreen>{
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
  String fullname="";
  String accountnumber="";
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
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      username="";
      password="";
      fullname="";
      accountnumber="";
      AuthToken="";
      getLoginTime();
      getUserSessionData();
      getUserTokenData();
    });
    getLoginTime();
    //getUserSessionData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            // Image(
            //   image: AssetImage("images/cdhlogo.png"),
            //   width: 50,
            // ),
            Spacer(),
            Text("Account Information",
              style: TextStyle(
                  fontFamily: 'CalibriBold'
              ),
            ),
            Spacer()
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
          ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 20,top: 20,bottom: 15,right: 20),
                        padding: EdgeInsets.only(left: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Account Information",
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
                              Icon(Icons.account_balance,
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
                                              MaterialPageRoute(builder: (context) => BalanceScreen()),
                                            );
                                          },
                                          child: new Padding(
                                            padding: new EdgeInsets.all(10.0),
                                            child: new Text("Balance Enquiry",
                                              style: TextStyle(
                                                  fontFamily: 'CalibriBold',
                                                color: Colors.black54,
                                                fontSize: 18,
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
                              Icon(FontAwesomeIcons.list,
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
                                              MaterialPageRoute(builder: (context) => MinistatementScreen()),
                                            );
                                          },
                                          child: new Padding(
                                            padding: new EdgeInsets.all(10.0),
                                            child: new Text("Ministatement",
                                              style: TextStyle(
                                                  fontFamily: 'CalibriBold',
                                                color: Colors.black54,
                                                fontSize: 18,
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

  Future<void> getUserSessionData() async {
    print("UsernameStoredSec: "+(await session.get("USERNAME")));
    String u=await FlutterSession().get("USERNAME");
    String p=await FlutterSession().get("PASSWORD");
    String f = await FlutterSession().get("FULLNAME");
    String a = await FlutterSession().get("ACCOUNTNUMBER");
    setState(() {
      fullname = f!=null?f:"";
      accountnumber = a!=null?a:"";
    });
    setState(() {
      username=u;
      password=p;
    });
  }


}