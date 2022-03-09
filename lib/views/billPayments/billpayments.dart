import 'dart:convert';

import 'package:cdh/models/member.dart';
import 'package:cdh/models/response.dart';
import 'package:cdh/views/billPayments/billelectricity.dart';
import 'package:cdh/views/billPayments/dstvboxoffice.dart';
import 'package:cdh/views/billtelephone.dart';
import 'package:cdh/views/billPayments/billtv.dart';
import 'package:cdh/views/billPayments/billwater.dart';
import 'package:cdh/views/forcechangepassword.dart';
import 'package:cdh/views/home.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../login.dart';

class BillPaymentsScreen extends StatefulWidget{
  @override
  _BillPaymentsScreen createState() => _BillPaymentsScreen();
}

class _BillPaymentsScreen extends State<BillPaymentsScreen> {
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
  Future<List<dynamic>> utilitybillTypeList = Future.value(List<dynamic>());
  List data;
  List utilitiesData;
  bool loadingutilitybillType = false;
  String AuthToken = "";DateTime loginDate;
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
      getLoginTime();
    });
    getLoginTime();
    loadingutilitybillType = false;
    utilitybillTypeList = Future.value(List<dynamic>());
    getUtilityBillTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          onPressed: (){
            Navigator.pop(context,
              MaterialPageRoute(builder: (context) => HomeScreen()),)
            ;

          },
          icon:Icon(
            Icons.arrow_back,
            size: 30,),),
        title: Row(
          children: <Widget>[

            Spacer(),
            Text("Bill Payment",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CalibriBold',
                  fontSize: 20,
              ),),
            Spacer(),
            Spacer(),
            Icon(
              Icons.menu,
              size: 30,
            )
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 33, 29, 112),
      ),
      body: Stack(
        children: <Widget>[

          ListView(
            children: [

              Container(

                margin: EdgeInsets.only(left: 10,top: 30,bottom: 5,right: 10),

                child: Card(
                  elevation: 4,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(bottom: 3),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => BillWaterScreen()),
                                      );
                                    },

                                    child: Row(
                                      children: [
                                        new Padding(
                                          padding: new EdgeInsets.only(left: 10,top: 10,right: 10,bottom: 10),
                                          child: new Text("Water Bill",

                                            style: TextStyle(
                                                fontFamily: 'Calibri',
                                                fontSize: 20,
                                                color: Colors.black54
                                            ),
                                            textAlign: TextAlign.center,


                                          ),

                                        ),
                                        SizedBox(width: 190),
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
              //Electricity
              Container(
                margin: EdgeInsets.only(left: 10,top: 10,bottom: 5,right: 10),
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
                          margin: EdgeInsets.only(left: 5),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(bottom: 3),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => BillElectricityScreen()),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        new Padding(
                                          padding: new EdgeInsets.only(left: 10,top: 10,right: 10,bottom: 10),
                                          child: new Text("Electricity Bill",

                                            style: TextStyle(
                                                fontFamily: 'Calibri',
                                                fontSize: 20,
                                                color: Colors.black54
                                            ),
                                            textAlign: TextAlign.center,


                                          ),

                                        ),
                                        SizedBox(width: 150),
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
              //Tv Subscriptions
              Container(
                margin: EdgeInsets.only(left: 10,top: 10,bottom: 5,right: 10),
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
                          margin: EdgeInsets.only(left: 5),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(bottom: 3),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => BillTvScreen()),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        new Padding(
                                          padding: new EdgeInsets.only(left: 10,top: 10,right: 10,bottom: 10),
                                          child: new Text("Tv Subscriptions",

                                            style: TextStyle(
                                                fontFamily: 'Calibri',
                                                fontSize: 20,
                                                color: Colors.black54
                                            ),
                                            textAlign: TextAlign.center,


                                          ),

                                        ),
                                        SizedBox(width: 120),
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
              // DstvBoxOffice
              Container(
                margin: EdgeInsets.only(left: 10,top: 10,bottom: 5,right: 10),
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
                                        MaterialPageRoute(builder: (context) => DSTVBoxOfficeScreen()),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        new Padding(
                                          padding: new EdgeInsets.only(left: 10,top: 10,right: 10,bottom: 10),
                                          child: new Text("DSTV Box Office",

                                            style: TextStyle(
                                                fontFamily: 'Calibri',
                                                fontSize: 20,
                                                color: Colors.black54
                                            ),
                                            textAlign: TextAlign.center,


                                          ),

                                        ),
                                        SizedBox(width: 120),
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


  Future<void> getUtilityBillTypes() async {
    String u = await FlutterSession().get("USERNAME");
    String P = await FlutterSession().get("PASSWORD");

    Member member = Member(username: u, password: P);
    try {
      fetchUtilityBillType(member, AuthToken).then((value) =>
      {

        populateBillTypes(value)
      });
    } on Exception catch (_) {
      print(_);
      Fluttertoast.showToast(
          msg: "Faild to fetch bill types! Please try again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
      );
    }
  }


  populateBillTypes(UtilityBillTypeResponse utilityBillTypeResponse) {
    print("POPULATE BILL TYPES");
    if (utilityBillTypeResponse != null) {
      if (utilityBillTypeResponse.status) {
        setState(() {
          loadingutilitybillType = true;
        });
      } else {
        setState(() {
          loadingutilitybillType= false;
        });
      }
    } else {
      setState(() {
        loadingutilitybillType = false;
      });
    }
    this.setState(() {
      data = utilityBillTypeResponse.utilities;
    });

   String dataencoded = jsonEncode(data);
   utilitiesData = jsonDecode(dataencoded);

    print(utilitiesData[1]['UTILITYNAME']);



    try{
      setState(() {
        utilitybillTypeList=Future.value(utilityBillTypeResponse.utilities);
      });
    }on Exception catch(_){
      print(_);
    }
  }
}








