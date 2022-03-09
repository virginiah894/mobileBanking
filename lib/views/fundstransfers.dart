import 'package:cdh/models/member.dart';
import 'package:cdh/models/response.dart';
import 'package:cdh/views/billPayments/billwater.dart';
import 'package:cdh/views/forcechangepassword.dart';
import 'package:cdh/views/home.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

import 'ftinteraccounts.dart';
import 'ftlocal.dart';
import 'ftownaccounts.dart';
import 'homefragment.dart';
import 'login.dart';

class FundsTransfersScreen extends StatefulWidget{
  @override
  _FundsTransfersScreen createState() => _FundsTransfersScreen();
}

class _FundsTransfersScreen extends State<FundsTransfersScreen> {
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
    builder: (context,widget)=> ResponsiveWrapper.builder(
      ClampingScrollWrapper.builder(context, widget),
      breakpoints: [
        ResponsiveBreakpoint.resize(350, name:MOBILE),
        ResponsiveBreakpoint.autoScale(600,name: TABLET),
        ResponsiveBreakpoint.autoScale(800,name: DESKTOP),
        ResponsiveBreakpoint.autoScale(1700,name:'xl')
      ],
    );
    return Scaffold(

      appBar: AppBar(
        leading:IconButton(
          onPressed: (){
            Navigator.pop(context,
              MaterialPageRoute(builder: (context) => HomeFragment()),)
            ;

          },
          icon:Icon(
            Icons.arrow_back,
            size: 30,),),
        title: Row(
          children: <Widget>[
            Spacer(),
            Text("Funds Transfer",
            style: TextStyle(
                fontFamily: 'CalibriBold',
                fontSize: 20
            ),),
            Spacer(),
            Icon(
              Icons.menu,
              size: 30,
            )
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 33, 29, 112),
        /*actions: [
          IconButton(icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).iconTheme.color),
              onPressed: (){
                Navigator.pop(context);
          })
        ],*/
      ),
      body: Stack(
        children: <Widget>[

          ListView(

            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Column(
                  children: <Widget>[
                    // Inter Accounts
                    Container(
                      margin: EdgeInsets.only(left: 5,top: 10,bottom: 10,right: 10),

                      child: Card(
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[

                              Container(
                                margin: EdgeInsets.only(left: 2),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(bottom: 3),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => FtInterAccountsScreen()),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon:Image.asset('images/trans1.png'

                                                ),
                                                onPressed: (){

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => FtInterAccountsScreen()),
                                                    );
                                                },
                                              ),
                                              new Padding(
                                                padding: new EdgeInsets.only(top: 20,right: 30,bottom: 10),
                                                child: new Text("Inter Accounts",

                                                  style: TextStyle(
                                                      fontFamily: 'Calibri',
                                                      fontSize: 20,
                                                      color: Colors.black54
                                                  ),
                                                  textAlign: TextAlign.center,


                                                ),

                                              ),
                                              SizedBox(width: 90),
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
                    //Ft Own Accs
                    Container(
                      margin: EdgeInsets.only(left: 5,top: 10,bottom: 10,right: 10),
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
                                margin: EdgeInsets.only(left: 2),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(bottom: 3),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => FtOwnAccountsScreen()),
                                            );
                                          },

                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon:Image.asset('images/Own.png'),

                                                onPressed: (){

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => FtOwnAccountsScreen()),
                                                  );
                                                },
                                              ),
                                              new Padding(
                                                padding: new EdgeInsets.only(top: 10,right: 30,bottom: 10),
                                                child: new Text("Own Accounts",

                                                  style: TextStyle(
                                                      fontFamily: 'Calibri',
                                                      fontSize: 20,
                                                      color: Colors.black54
                                                  ),
                                                  textAlign: TextAlign.center,


                                                ),

                                              ),
                                              SizedBox(width: 90),
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
                    //Ft Local Banks
                    Container(
                      margin: EdgeInsets.only(left: 5,top: 10,bottom: 10,right: 10),
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
                                margin: EdgeInsets.only(left: 2),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(bottom: 3),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => FtLocalScreen()),
                                            );
                                          },

                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon:Image.asset('images/local.png'),

                                                onPressed: (){

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => FtLocalScreen()),
                                                  );
                                                },
                                              ),
                                              new Padding(
                                                padding: new EdgeInsets.only(top: 10,right: 30,bottom: 10),
                                                child: new Text("Local Banks",

                                                  style: TextStyle(
                                                      fontFamily: 'Calibri',
                                                      fontSize: 20,
                                                      color: Colors.black54
                                                  ),
                                                  textAlign: TextAlign.center,

                                                ),

                                              ),
                                              SizedBox(width: 110),
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

}