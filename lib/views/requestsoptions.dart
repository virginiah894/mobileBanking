import 'package:cdh/models/member.dart';
import 'package:cdh/models/response.dart';
import 'package:cdh/views/billPayments/billwater.dart';
import 'package:cdh/views/chequebooks.dart';
import 'package:cdh/views/forcechangepassword.dart';
import 'package:cdh/views/home.dart';
import 'package:cdh/views/homefragment.dart';
import 'package:cdh/views/standingorders.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'login.dart';


class RequestsScreen extends StatefulWidget{
  @override
  _RequestsScreen createState() => _RequestsScreen();
}

class _RequestsScreen extends State<RequestsScreen> {
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
    // ignore: unnecessary_statements
    builder: (context,widget)=> ResponsiveWrapper.builder(ClampingScrollWrapper.builder(context, widget),
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
            Text("Requests",
              style: TextStyle(
                  fontFamily: 'CalibriBold',
                  fontSize: 20
              ),),


            Spacer(),

            Icon(Icons.menu,
              size: 30,

            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 33, 29, 112),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 15,top: 10,bottom: 10,right: 20),
                        child: Card(
                          elevation: 4,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(

                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(bottom: 3),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => StandingOrdersScreen()),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                new Padding(
                                                  padding: new EdgeInsets.only(left: 20,top: 20,right: 30,bottom: 10),
                                                  child: new Text("Standing Order",
                                                    style: TextStyle(
                                                        fontFamily: 'Calibri',
                                                        fontSize: 20,
                                                        color: Colors.black54
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(width: 80),
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
                      margin: EdgeInsets.only(left: 15,top: 10,bottom: 10,right: 20),
                      child: Card(
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(

                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(bottom: 3),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ChequebooksScreen()),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              new Padding(
                                                padding: new EdgeInsets.only(left: 20,top: 20,right: 30,bottom: 10),
                                                child: new Text("Cheque Book",
                                                  style: TextStyle(
                                                      fontFamily: 'Calibri',
                                                      fontSize: 20,
                                                      color: Colors.black54
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              SizedBox(width: 85),
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

                    // Container(
                    //   margin: EdgeInsets.only(left: 15,top: 10,bottom: 10,right: 20),
                    //     child: Card(
                    //       elevation: 4,
                    //       child: Container(
                    //         padding: EdgeInsets.all(10),
                    //         child: Row(
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: <Widget>[
                    //             // Icon(Icons.edit_outlined,
                    //             //   color: Colors.black54,),
                    //             Container(
                    //               margin: EdgeInsets.only(left: 20),
                    //               child: Column(
                    //                 children: <Widget>[
                    //                   Container(
                    //                       margin: EdgeInsets.only(bottom: 3),
                    //                       child: InkWell(
                    //                         onTap: () {
                    //                           Navigator.push(
                    //                             context,
                    //                             MaterialPageRoute(builder: (context) => ChequebooksScreen()),
                    //                           );
                    //                         },
                    //                         child: Row(
                    //                           children: [
                    //                             new Padding(
                    //                               padding: new EdgeInsets.only(left: 30,top: 20,right: 30,bottom: 10),
                    //                               child: new Text("Cheque Book",
                    //                                 style: TextStyle(
                    //                                     fontFamily: 'Calibri',
                    //                                     fontSize: 20,
                    //                                     color: Colors.black54
                    //                                 ),
                    //                                 textAlign: TextAlign.center,
                    //                               ),
                    //                             ),
                    //                             SizedBox(width: 93),
                    //                             Icon(Icons.arrow_forward_ios,
                    //                               color: Colors.indigo[900],),
                    //                           ],
                    //                         ),
                    //                       )
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //
                    // ),

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