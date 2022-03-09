
import 'dart:async';
import 'dart:convert';

import 'package:cdh/models/changepassword.dart';
import 'package:cdh/models/member.dart';
import 'package:cdh/models/ministatement.dart';
import 'package:cdh/models/response.dart';
import 'package:cdh/views/accountinfo.dart';
import 'package:cdh/views/balancefragment.dart';
import 'package:cdh/views/banktowallet.dart';
import 'package:cdh/views/billPayments/airtime.dart';
import 'package:cdh/views/billPayments/billairtime.dart';
import 'package:cdh/views/billPayments/billelectricity.dart';
import 'package:cdh/views/billPayments/billpayments.dart';
import 'package:cdh/views/billPayments/billtv.dart';
import 'package:cdh/views/billPayments/billwater.dart';
import 'package:cdh/views/billPayments/dstvboxoffice.dart';
import 'package:cdh/views/billtelephone.dart';
import 'package:cdh/views/fundstransfers.dart';
import 'package:cdh/views/home.dart';
import 'package:cdh/views/loaders.dart';
import 'package:cdh/views/ministatement.dart';
import 'package:cdh/views/prnnumber.dart';
import 'package:cdh/views/requestsoptions.dart';
import 'package:cdh/views/taxpayment.dart';
import 'package:cdh/views/wallettransfers.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:cdh/views/loaders.dart';

import 'balance.dart';
import 'login.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragment createState() => _HomeFragment();
}

/// This is the private State class that goes with MyStatefulWidget.
class _HomeFragment extends State<HomeFragment> {
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
  SharedPreferences airtimesharedpref;

  String fullnames = "";
  String accountnumber = "";
  String currentbalance = "";
  String AuthToken = "";
  String availablebalance = "";
  bool loadingsomething = false;

  final oCcy = new NumberFormat("#,##0.00", "en_US");
  var session = FlutterSession();

  Future<List<dynamic>> utilitybillTypeList = Future.value(List<dynamic>());
  List data;
  List utilitiesData;
  bool loadingutilitybillType = false;
  Utilities utilitiesModel;

  List Providers = [];
  List providerName;
  Future<List<dynamic>> airtimebillTypeList = Future.value(List<dynamic>());
  List<String> providerList = [];
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
      fullnames = "";
      accountnumber = "";
      currentbalance = "";
      availablebalance = "";
      loadingsomething = false;
      AuthToken = "";
      getLoginTime();
      getAccounts();
      getUserTokenData();
      WidgetsBinding.instance
          .addPostFrameCallback((_) => getAccounts());
    });
    getLoginTime();
    loadingutilitybillType = false;
    utilitybillTypeList = Future.value(List<dynamic>());


    _getAccounts();
    getProviders();
    getUtilityBillTypes();
    getUserTokenData();
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

  Future<void> getUserTokenData() async {
    try {
      String at = await FlutterSession().get("AUTHTOKEN");
      setState(() {
        AuthToken = at;
      });
    } on Exception catch (_) {

    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_label
    builder: (context,widget)=> ResponsiveWrapper.builder(ClampingScrollWrapper.builder(context, widget),
      breakpoints: [
        ResponsiveBreakpoint.resize(350, name:MOBILE),
        ResponsiveBreakpoint.autoScale(600,name: TABLET),
        ResponsiveBreakpoint.autoScale(800,name: DESKTOP),
        ResponsiveBreakpoint.autoScale(1700,name:'xl')
      ],
    );
    return new Scaffold(
      appBar: AppBar(
        title: const Text('Home',
          style: TextStyle(
              fontFamily: 'CalibriBold',
              fontSize: 24,
          ),

        ),

        leading: Container(
          child:IconButton(
            icon:Image.asset('images/icon-5.png',
              color: Colors.white,
            ),
            onPressed: (){

            },
          ),
        ),
        // actions: [
        //   Icon(FontAwesomeIcons.powerOff),
        // ],
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: GestureDetector(
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
              child:IconButton(
                icon:Image.asset('images/logout.png'

                ),
                onPressed: (){

                },
              ),
            ),
          ),

        ],

        backgroundColor: const Color.fromARGB(255, 33, 29, 112),
        // backgroundColor: Colors.indigo[900],
      ),

      body: Stack(


        children: <Widget>[

          ListView(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10,bottom: 10),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Image(
                        image: AssetImage("images/cdhlogo.png"),
                        width: 100,
                      ),
                    ),
                    Center(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(
                                top: 10),
                              child: Text("Welcome",
                                  style: TextStyle(

                                      fontSize: 18,
                                      fontFamily: 'CalibriRegular',
                                    color: Colors.grey[700],

                                  )),
                            ),
                            Padding(padding: EdgeInsets.all(1.5),
                              child: Text(fullnames,
                                  //child: Text("Almost before we knew it, we had left the ground.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                      fontSize: 20,
                                      fontFamily: 'CalibriBold',
                                  )
                              ),
                            ),
                            Container(


                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: new AssetImage(
                                      'images/Background-2.jpg'),
                                ),
                              ),

                              margin: EdgeInsets.only(
                                 top: 05, bottom: 05),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Center(
                                      child:Icon(
                                        Icons.account_balance_outlined,
                                        color: Colors.white,
                                        size: 30,

                                      ),


                                    ),
                                    Center(
                                      child:Column(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(),
                                            child: Text("Account",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'Calibri'
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10),
                                            child: Text(accountnumber,
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  color: Colors.white,
                                                  fontFamily: 'CalibriRegular',
                                                fontSize: 16,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                    Center(
                                      child: Container(
                                        margin: EdgeInsets.only(top: 8),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              alignment: FractionalOffset
                                                  .center,
                                              child: Center(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .center,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: <Widget>[
                                                    Text("Available Balance ",
                                                      style: TextStyle(
                                                          // fontWeight: FontWeight
                                                          //     .bold,
                                                          color: Colors.white,
                                                          fontFamily: 'Calibri',
                                                          fontSize: 14
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width:MediaQuery.of(context).size.width,
                                              margin: EdgeInsets.only(
                                                  top: 4, bottom: 3),
                                              alignment: FractionalOffset
                                                  .center,
                                              child: Center(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .center,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: <Widget>[

                                                    // Spacer(),
                                                    // Spacer(),
                                                    if(loadingsomething)
                                                      OneLineTextPlaceholder()
                                                    //Loaders._buildSimpleTextPlaceholder(TextAlign.left);
                                                    else
                                                      Spacer(),
                                                      Text(availablebalance,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            color: Colors.white,
                                                            fontFamily: 'CalibriRegular'
                                                        ),
                                                      ),
                                                    Spacer(),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        margin: EdgeInsets.only(top: 4,
                                            bottom: 4,
                                            left: 5,
                                            right: 5),
                                        alignment: FractionalOffset.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceEvenly,
                                          children: <Widget>[

                                          ],
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //color: Colors.blue,
                            ),
                            Container(
                              width:MediaQuery.of(context).size.width,

                              margin: EdgeInsets.only(
                                  top: 7, bottom: 10),
                              padding: EdgeInsets.only(
                                  top: 7, bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white,
                              ),

                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 5,),
                                  Row(
                                    children: <Widget>[
                                     Spacer(),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: InkWell(
                                            onTap: () {
                                              navigateRequestOptions();
                                              /*Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => RequestsScreen()),
                                              );*/
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 2),
                                                  width: 48.0,
                                                  height: 48.0,
                                                  decoration: new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: new DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: new AssetImage(
                                                            'images/icon-19.png'),
                                                      ),

                                                    border: Border.all(
                                                      color: Colors.white,
                                                    )
                                                  ),

                                                ),
                                                Container(
                                                  child: Text("Requests",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal,
                                                          color: Colors.black54,
                                                          fontSize: 16,
                                                          fontFamily: 'CalibriRegular'
                                                      )
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                      ),
                                      Spacer(),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: InkWell(
                                            onTap: () {
                                              navigateFundsTransfers();
                                              /*Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => FundsTransfersScreen()),
                                              );*/
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 2),
                                                  width: 48.0,
                                                  height: 48.0,
                                                  decoration: new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    image: new DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: new AssetImage(
                                                          'images/icon-20.png'),
                                                    ),

                                                      border: Border.all(
                                                        color: Colors.white,
                                                      )

                                                  ),

                                                ),
                                                Container(
                                                  child: Text("Funds Transfer",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal,
                                                          color: Colors.black54,
                                                          fontSize: 16,
                                                          fontFamily: 'CalibriRegular'
                                                      )
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                      ),
                                      Spacer(),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: InkWell(
                                            onTap: () {
                                              // navigateBillPayments();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => BillPaymentsScreen()),
                                              );
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 2),
                                                  width: 48.0,
                                                  height: 48.0,
                                                  decoration: new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: Colors.white,

                                                      ),
                                                    image: new DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: new AssetImage(
                                                        'images/icon-21.png'),
                                                  ),
                                                  ),
                                                  // child: ClipOval(
                                                  //   child: Icon(
                                                  //     FontAwesomeIcons.receipt,
                                                  //     color: Colors.indigo[900],),
                                                  //
                                                  // ),
                                                ),
                                                Container(
                                                  child: Text("Bill Payment",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal,
                                                          color: Colors.black54,
                                                          fontSize: 16,
                                                          fontFamily: 'CalibriRegular'
                                                      )
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    children: <Widget>[
                                      Spacer(),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 5, right: 5, top: 20),
                                          child: InkWell(
                                            onTap: () {

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => PRNNumberScreen()),
                                              );
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 2),
                                                  width: 48.0,
                                                  height: 48.0,
                                                  decoration: new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.white,

                                                      ),
                                                    image: new DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: new AssetImage(
                                                          'images/icon-22.png'),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Text("Tax Payment",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal,
                                                          color: Colors.black54,
                                                          fontSize: 16,
                                                          fontFamily: 'CalibriRegular'
                                                      )
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                      ),
                                      Spacer(),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 5, right: 5, top: 20),
                                          child: InkWell(
                                            onTap: () {

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => AirtimePaymentsScreen()),
                                              );

                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 2),
                                                  width: 48.0,
                                                  height: 48.0,
                                                  decoration: new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    image: new DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: new AssetImage(
                                                          'images/icon-23.png'),
                                                    ),
                                                  ),

                                                ),
                                                Container(
                                                  child: Text("Airtime",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal,
                                                          color: Colors.black54,
                                                          fontSize: 16,
                                                          fontFamily: 'CalibriRegular'
                                                      )
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                      ),
                                      Spacer(),
                                      Container(
                                          margin: EdgeInsets.only(
                                              left: 5, right: 5, top: 20),
                                          child: InkWell(
                                            onTap: () {
                                              // navigateWalletTransfers();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => BankToWalletScreen()),
                                              );
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 2),
                                                  width: 48.0,
                                                  height: 48.0,
                                                  decoration: new BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      ),
                                                    image: new DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: new AssetImage(
                                                          'images/icon-24.png',
                                                      ),
                                                    ),
                                                  ),

                                                ),
                                                Container(
                                                  child: Text("Wallet Transfer",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal,
                                                          color: Colors.black54,
                                                          fontSize: 16,
                                                          fontFamily: 'CalibriRegular'
                                                      )
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                      ),
                                      Spacer(),

                                    ],
                                  )


                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),



            ],

          ),
          SizedBox(height: 3,),
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
    );
  }

  void navigateFundsTransfers() {
    Route route = MaterialPageRoute(
        builder: (context) => FundsTransfersScreen());
    Navigator.push(context, route).then(onGoBack);
  }

  void navigateRequestOptions() {
    Route route = MaterialPageRoute(builder: (context) => RequestsScreen());
    Navigator.push(context, route).then(onGoBack);
  }

  void navigateWalletTransfers() {
    Route route = MaterialPageRoute(
        builder: (context) => WalletTransfersScreen());
    Navigator.push(context, route).then(onGoBack);
  }

  void navigateBillPayments() {
    /* Route route = MaterialPageRoute(builder: (context) => BillPaymentsScreen());
    Navigator.push(context, route).then(onGoBack);*/
    _utilityBillsBottomSheet(context);
  }

  void navigateTaxPayment() {
    Route route = MaterialPageRoute(builder: (context) => TaxPaymentScreen());
    Navigator.push(context, route).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    getAccounts();
    //setState(() {});
  }

  Future<void> getAccounts() async {
    print("GET");
    String u = await FlutterSession().get("USERNAME");
    String P = await FlutterSession().get("PASSWORD");
    Member member = Member(username: u, password: P, OPERATION: "Accounts");
    setState(() {
      loadingsomething = true;
    });
    print(member);
    try {
      fetchAccount(member).then((value) =>
      {
        polulate(value.ministatement, value.Accounts, value)
      });
    } on Exception catch (_) {
      print(_);
      Fluttertoast.showToast(
          msg: "Faild to fetch details! Login again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
      );
      setState(() {
        accountnumber = "";
        fullnames = "";
        currentbalance = "0.0";
        availablebalance = "0.0";
        loadingsomething = false;
      });
    }
  }

  Future<void> _getAccounts() async {
    print("GET Refresh");
    String u = await FlutterSession().get("USERNAME");
    String P = await FlutterSession().get("PASSWORD");
    Member member = Member(username: u, password: P, OPERATION: "Accounts");
    setState(() {
      loadingsomething = true;
    });
    print(member);
    try {
      fetchAccount(member).then((value) =>
      {
        polulate(value.ministatement, value.Accounts, value)
      });
    } on Exception catch (_) {
      print(_);
      Fluttertoast.showToast(
          msg: "Faild to fetch details! Login again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
      );
      setState(() {
        accountnumber = "";
        fullnames = "";
        currentbalance = "0.0";
        availablebalance = "0.0";
        loadingsomething = false;
      });
    }
  }

  Future<void> getBalance(String Account) async {
    setState(() {
      loadingsomething = true;
    });
    String u = await FlutterSession().get("USERNAME");
    String P = await FlutterSession().get("PASSWORD");
    Ministatement ministatement = Ministatement(AccountNo: Account);
    Member member = Member(username: u,
        password: P,
        OPERATION: "BALANCE",
        ministatement: ministatement);
    try {
      fetchBalance(member).then((value) =>
      {
        populateBalance(value)
      });
    } on Exception catch (_) {
      print(_);
      Fluttertoast.showToast(
          msg: "Faild to fetch balance! Login again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
      );
      setState(() {
        accountnumber = "";
        fullnames = "";
        currentbalance = "0.0";
        availablebalance = "0.0";
        loadingsomething = false;
      });
    }
  }

  void polulate(String name, List<String> accounts,
      AccountResponse accountResponse) {
    print("POPULATE");
    setState(() {
      loadingsomething = false;
    });
    try {
      setState(() {
        accountnumber = accounts.first != null ? accounts.first : "";
        fullnames = name != null ? name : "";
        loadingsomething = false;
        currentbalance = "MWK " + oCcy.format(accountResponse.CurrentBal != null
            ? accountResponse.CurrentBal
            : "");
        availablebalance = "MWK " + oCcy.format(
            accountResponse.AvailableBal != null
                ? accountResponse.AvailableBal
                : "");
      });
      try {
        session.set("FULLNAME", accountResponse.ministatement);
      } on Exception catch (_) {
        print(_);
        setState(() {
          loadingsomething = false;
        });
      }
      try {
        session.set("ACCOUNTNUMBER", accounts.first);
      } on Exception catch (_) {
        print(_);
        setState(() {
          loadingsomething = false;
        });
      }
      try {
        getBalance(accounts.first);
      } on Exception catch (_) {
        setState(() {
          loadingsomething = false;
        });
      }
      //setFullnameSession(accountResponse.ministatement);
    } on Exception catch (_) {
      print(_);
      setState(() {
        loadingsomething = false;
      });
    }
  }

  void populateBalance(BalanceResponse balanceResponse) {
    try {
      setState(() {
        loadingsomething = false;
        currentbalance = "MWK " + oCcy.format(balanceResponse.CurrentBal != null
            ? balanceResponse.CurrentBal
            : "");
        availablebalance = "MWK " + oCcy.format(
            balanceResponse.AvailableBal != null
                ? balanceResponse.AvailableBal
                : "");
      });
    } on Exception catch (_) {
      print(_);
      setState(() {
        loadingsomething = false;
      });
    }
  }

  Future<void> setFullnameSession(String fullname) async {
    //await session.set("FULLNAME", fullname);
    try {
      session.set("FULLNAME", fullname);
    } on Exception catch (_) {

    }
  }

  Widget _loadingAnimation() {
    return Container(
      width: 200,
      child: Placeholder(),
    );
  }

  void _utilityBillsBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(

            child: new Wrap(

              children: <Widget>[
                Container(

                  child: Text(
                    "BILL PAYMENT",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'CalibriBold',
                        color: Colors.black54,
                        fontSize: 18
                    ),
                  ),
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(15),
                ),
                new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: utilitiesData == null ? 0 : utilitiesData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
                      child: Container(

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // Container(
                            //   child: Icon(
                            //     Icons.liq
                            //   ),
                            //   margin: EdgeInsets.only(right: 20),
                            // ),
                            //FaIcon(FontAwesomeIcons.water,size: 20,color: Colors.blue,),
                            Container(

                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,

                                  border: Border.all(
                                    color: Colors.white,

                                  )
                              ),
                              child: Icon(
                                Icons.view_list, size: 20, color: Colors.indigo[900],),
                            ),

                            Container(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        getNextScreen(
                                            utilitiesData[index]['UTILITYNAME'])),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),

                                  child: Text(
                                    utilitiesData[index]['UTILITYNAME'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'CalibriBold',
                                        color: Colors.black54,
                                        fontSize: 18
                                    ),
                                  ),
                                ),
                              ),
                              margin: EdgeInsets.only(left: 15),
                            ),

                          ],
                        ),
                        margin: EdgeInsets.only(bottom: 5),
                      ),
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(left: 10, right: 10),
                    );
                  },
                )

              ],
            ),
          );
        }
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
    print(utilityBillTypeResponse.status);
    if (utilityBillTypeResponse != null) {
      if (utilityBillTypeResponse.status) {
        setState(() {
          loadingutilitybillType = true;
        });
      } else {
        setState(() {
          loadingutilitybillType = false;
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
    //utilitiesData.add("DSTV Box Office");



      utilitiesModel = Utilities(UTILITYID: 7,UTILITYNAME: 'DSTV Box Office',UTILITYCODE: "07",REMARKS: "DSTV Box Office");


      utilitiesData.insert(5, utilitiesModel.toJson());


    print("UTILITIES DATA");
    print(utilitiesData);


    try {
      setState(() {
        utilitybillTypeList = Future.value(utilityBillTypeResponse.utilities);
        print(utilitybillTypeList);
      });
    } on Exception catch (_) {
      print(_);
    }
  }

  Future<void> getProviders() async {
    print("GET");
    String u = await FlutterSession().get("USERNAME");
    String P = await FlutterSession().get("PASSWORD");
    Member member = Member(username: u,
        password: P,
        OPERATION: "Utility",
        utility: "AIRTIME",
        utilityname: "AIRTIME");

    try {
      newfetchProviders("AIRTIME", member, token: AuthToken).then((value) =>
      {
        polulateProviders(value.ministatement, value.utilityProviders, value)
      });
    } on Exception catch (_) {
      print(_);
      Fluttertoast.showToast(
          msg: "Faild to fetch details! Login again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
      );
    }
  }

  void polulateProviders(String name, List<UtilityProviders> accounts,
      newUtilityProvidersResponse newutilityprovidersResponse) {
    print("POPULATE PROVIDERS");
    try {
      if (newutilityprovidersResponse != null) {
        if (newutilityprovidersResponse.utilityProviders != null) {
          if (newutilityprovidersResponse.status) {
            setState(() {
              loadingutilitybillType = true;
            });
          } else {
            setState(() {
              loadingutilitybillType = false;
            });
          }
          setState(() {
            Providers = newutilityprovidersResponse.utilityProviders;
            String dataencoded = jsonEncode(Providers);
            providerName = jsonDecode(dataencoded);


            print(providerName);
          });


        } else {
          setState(() {
            loadingutilitybillType = false;
          });
        }
      } else {
        setState(() {
          loadingutilitybillType = false;
        });
      }
    } on Exception catch (_) {
      print(_);
    }
  }

  void _airtimeBillsBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(

            child: new Wrap(

              children: <Widget>[
                Container(

                  child: Text(
                    "AIRTIME",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'CalibriBold',
                        color: Colors.black54,
                        fontSize: 18
                    ),
                  ),
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(15),
                ),
                new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: providerName == null ? 0 : providerName.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
                      child: Container(

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // Container(
                            //   child: Icon(
                            //     Icons.liq
                            //   ),
                            //   margin: EdgeInsets.only(right: 20),
                            // ),
                            //FaIcon(FontAwesomeIcons.water,size: 20,color: Colors.blue,),
                            Container(

                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],

                              ),
                              child: Icon(
                                Icons.view_list, size: 20, color: Colors.indigo[900],),
                            ),

                            Container(
                              child: InkWell(
                                onTap: () {
                                  _saveSharedPrefs(providerName[index]['PROVIDERNAME']);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),

                                  child: Text(
                                    providerName[index]['PROVIDERNAME'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'CalibriBold',
                                        color: Colors.black54,
                                        fontSize: 18
                                    ),
                                  ),
                                ),
                              ),
                              margin: EdgeInsets.only(left: 15),
                            ),

                          ],
                        ),
                        margin: EdgeInsets.only(bottom: 5),
                      ),
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(left: 10, right: 10),
                    );
                  },
                )

              ],
            ),
          );
        }
    );
  }

  void _saveSharedPrefs(String value) async {

    airtimesharedpref = await SharedPreferences.getInstance();
    airtimesharedpref.setString("airtimePrefs", value);

    Navigator.push(context,
      MaterialPageRoute(
          builder: (context) => AirtimeScreen()),
    );
  }

  getNextScreen(utilitiesData) {
    print(utilitiesData);

    if (utilitiesData == "WATER") {
      return BillWaterScreen();
    } else if (utilitiesData == "ELECTRICITY") {
      return BillElectricityScreen();
    } else if (utilitiesData == "TELEPHONE") {
      return HomeScreen(selectedFragment: 0);
    } else if (utilitiesData == "RENT") {
      return HomeScreen(selectedFragment: 0);
    } else if (utilitiesData == "TV") {
      return BillTvScreen();
    } else if(utilitiesData == "DSTV Box Office"){
      return DSTVBoxOfficeScreen();
    }else{
      return HomeScreen(selectedFragment: 0);//selectedFragment: 0;
    }
  }
}
