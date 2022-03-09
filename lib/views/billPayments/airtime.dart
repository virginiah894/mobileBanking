import 'dart:convert';
import 'dart:math';

import 'package:cdh/models/billpayment.dart';
import 'package:cdh/models/member.dart';
import 'package:cdh/models/response.dart';
import 'package:cdh/models/utilitytransaction.dart';
import 'package:cdh/views/billPayments/billAlertDialog.dart';
import 'package:cdh/views/billPayments/billairtime.dart';
import 'package:cdh/views/forcechangepassword.dart';
import 'package:cdh/views/home.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';

class AirtimeScreen extends StatefulWidget{
  @override
  _AirtimeScreen createState() => _AirtimeScreen();
}

class _AirtimeScreen extends State<AirtimeScreen> {
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
  SharedPreferences sharedpref;
  String airtimeProvider ="";
  String dropdownValue="First";
  String _selectedCompany="First";
  String _selectedProvider="First";
  String currentbalance="MWK 0.0";
  String availablebalance="MWK 0.0";
  String phonenumber="";
  String amount="";
  String narration="";
  bool isloggedin=false;
  String AuthToken="";
  bool loading=false;
  bool canclick=true;
  String loadingtext="Buy";
  String errortext="";

  List<String> Accounts=[];
  List Providers=[];
  List providerName;
  List<String> providerList=[];
  List<String> Numbers=['First', 'Second', 'Third', 'Fourth'];
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  List<DropdownMenuItem<String>> _dropdownProviders;
  var session = FlutterSession();
  String username;
  TnmAirtimeTopupTransactionData tnmAirtimeTopupTransactionData;
  AirtelAirtimeTopupTransaction airtelAirtimeTopupTransaction;
  UtilityTransaction utilityTransaction;
  RegExp regExp;

  String ProviderCode="";


  bool isFdh=false;
  bool isNitel=false;

  List<UtilityProviders> utilityProviders;DateTime loginDate;
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
    _dropdownMenuItems = buildDropdownMenuItems(Accounts);
    _dropdownProviders = buildDropdownProviders(Providers);
    _selectedCompany = _dropdownMenuItems[0].value;
    _selectedProvider = _dropdownProviders[0].value;
    setState(() {
      phonenumber="";
      amount="";
      narration="";
      AuthToken="";
      canclick=true;
      getAccounts();
      getProviders();
      _dropdownMenuItems = buildDropdownMenuItems(Accounts);
      _dropdownProviders = buildDropdownProviders(Providers);
      currentbalance="MWK 0.0";
      availablebalance="MWK 0.0";

      getUserTokenData();
      getLoginTime();

    });

    getSharedPref();
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
  void getSharedPref() async{

    sharedpref = await SharedPreferences.getInstance();
    airtimeProvider = sharedpref.getString("airtimePrefs");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          onPressed: (){
            print("Popping");
            //Navigator.pop(context);
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => AirtimePaymentsScreen(),
              ),
            );
            // Navigator.pop(context,
            //   MaterialPageRoute(builder: (context) => AirtimePaymentsScreen()),)
            // ;

          },
          icon:Icon(
            Icons.arrow_back,
            size: 30,),),
        title: Row(
          children: <Widget>[
            // Image(
            //   image: AssetImage("images/cdhlogo.png"),
            //   width: 50,
            // ),
            Spacer(),
            Text(airtimeProvider,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CalibriBold',
                fontSize: 20
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

          ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Column(
                  children: <Widget>[
                    /*Container(
                      child: Center(
                        child: DropdownButton(
                          value: _selectedCompany,
                          items: _dropdownMenuItems,
                          onChanged: onChangeDropdownItem,
                        ),
                      ),
                      padding: EdgeInsets.all(10),
                    ),
                    Container(
                      child: Center(
                        child: DropdownButton(
                          value: _selectedProvider,
                          items: _dropdownProviders,
                          onChanged: onChangeDropdownProvider,
                        ),
                      ),
                      padding: EdgeInsets.all(10),
                    ),*/
                    my_dropdown_accounts(context),

                    Container(
                      child: TextField(
                        decoration: InputDecoration(
                          //prefixIcon: new Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                          labelText: 'Phone number',
                          hintText: 'Enter phone number',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (text){
                          setState(() {
                            phonenumber=text;
                          });
                        },
                      ),
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(top:20,left: 25,right: 25),
                    ),
                    Container(
                      child: TextField(
                        decoration: InputDecoration(
                          //prefixIcon: new Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                          labelText: 'Amount',
                          hintText: 'Enter amount',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (text){
                          setState(() {
                            amount=text;
                          });
                        },
                      ),
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(left: 25,right: 25),
                    ),
                    Container(
                      child: TextField(
                        decoration: InputDecoration(
                          //prefixIcon: new Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                          labelText: 'Comments',
                          hintText: 'Enter narration',
                        ),
                        onChanged: (text){
                          setState(() {
                            narration=text;
                          });
                        },
                      ),
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(bottom: 20,left: 25,right: 25),
                    ),
                    SizedBox(height: 20,),
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
                              borderRadius:BorderRadius.circular(14)
                          ),

                          onPressed: (){
                            if(_selectedCompany=="-select account-"){
                              setState(() {
                                errortext="Select an account!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }else if(_selectedCompany=="-select provider-"){
                              setState(() {
                                errortext="Select a provider!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }else if(amount =="" || phonenumber =="" || narration ==""){
                              setState(() {
                                errortext="Fill in all the fields!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }
                            else if(!isNumeric(amount) && amount != "0"){
                              setState(() {
                                errortext="Invalid amount!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }else{
                              setState(() {
                                loadingtext="Please wait...";
                                errortext="";
                              });

                              int rand=DateTime.now().millisecondsSinceEpoch;
                              String randomstr=rand.toString();
                              BillPayment billpayment=BillPayment(amount: amount.toString(),billno: phonenumber,billpaymentid: 0,SessionId: randomstr,
                                  comments: narration,utilityname: "TELEVISION",utilitycompany: _selectedProvider,AccountNumber: _selectedCompany,
                                  MyAccountNumber: _selectedCompany);


                              Random random = new Random();
                              int randomNumber = random.nextInt(100000000);
                              if(airtimeProvider == "TNM Airtime Topup"){

                                    Pattern tnmAirtime = "^(2658)\\d{8}";
                                    regExp = new RegExp(tnmAirtime);
                                    if (!regExp.hasMatch(phonenumber)) {
                                      setState(() {
                                        errortext="Enter Valid Phone Number";
                                      });
                                      Fluttertoast.showToast(
                                          msg: errortext,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM
                                      );
                                    }
                                    else {

                                      tnmAirtimeTopupTransactionData = TnmAirtimeTopupTransactionData(amount: amount,tnmMobileNumber: phonenumber,clientTransactionIdentifier: randomNumber.toString());
                                      utilityTransaction = UtilityTransaction(accountNumber: _selectedCompany,username: username,comments: narration, sessionId: randomNumber.toString(),billPaymentApplicationName: "TNM.Airtime.Topup.Transaction",tnmAirtimeTopupTransactionData: tnmAirtimeTopupTransactionData);

                                      if(canclick){
                                        setState(() {
                                          canclick=false;
                                        });
                                        pay(utilityTransaction);
                                      }
                                    }


                              }else if(airtimeProvider == "Airtel Airtime Topup") {

                                    Pattern tnmAirtime = "^(2659)\\d{8}";
                                    regExp = new RegExp(tnmAirtime);
                                    if (!regExp.hasMatch(phonenumber)) {
                                      setState(() {
                                        errortext = "Enter Valid Phone Number";
                                      });
                                      Fluttertoast.showToast(
                                          msg: errortext,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM
                                      );
                                    }
                                    else {
                                      airtelAirtimeTopupTransaction =
                                          AirtelAirtimeTopupTransaction(
                                              airtelMobileNumber: phonenumber,
                                              amount: amount,
                                              clientTransactionIdentifier: randomNumber .toString());
                                      utilityTransaction = UtilityTransaction(
                                          accountNumber: _selectedCompany,
                                          username: username,
                                          comments: narration,
                                          sessionId: randomNumber.toString(),
                                          billPaymentApplicationName: "Airtel.Airtime.Topup.Transaction",
                                          airtelAirtimeTopupTransaction: airtelAirtimeTopupTransaction);

                                      if (canclick) {
                                        setState(() {
                                          canclick = false;
                                        });
                                        pay(utilityTransaction);
                                      }
                                    }
                              }


                            }
                          },
                        ),
                      ),
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(bottom: 20,left: 25,right: 25),
                    )
                  ],
                ),
              )
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

  Future<void> getAccounts() async {
    print("GET");
    username=await FlutterSession().get("USERNAME");
    String P=await FlutterSession().get("PASSWORD");
    Member member=Member(username: username,password: P,OPERATION: "Accounts");

    try{
      fetchAccount(member,token:AuthToken).then((value) => {
        polulate(value.ministatement, value.Accounts,value)
      });
    }on Exception catch(_){
      print(_);
      Fluttertoast.showToast(
          msg: "Faild to fetch details! Login again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
      );
    }
  }

  Future<void> getProviders() async {
    print("GET");
    String u=await FlutterSession().get("USERNAME");
    String P=await FlutterSession().get("PASSWORD");
    Member member=Member(username: u,password: P,OPERATION: "Utility",utility: "TELEVISION",utilityname: "TELEVISION");

    try{
      newfetchProviders("TV",member,token:AuthToken).then((value) => {
        polulateProviders(value.ministatement, value.utilityProviders,value)
      });
    }on Exception catch(_){
      print(_);
      Fluttertoast.showToast(
          msg: "Faild to fetch details! Login again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
      );
    }
  }

  Future<void> pay(UtilityTransaction utilityTransaction) async {
    return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Confirm Your Details",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[

              Text(
                  "Source Account: " +_selectedCompany,
                  style: Theme.of(context).textTheme.bodyText1),
              Text(
                  "Utility Provider: " + airtimeProvider,
                  style: Theme.of(context).textTheme.bodyText1),
              Text(
                  "Phone Number: " +phonenumber,
                  style: Theme.of(context).textTheme.bodyText1),
              Text(
                  "Amount: " +  amount,
                  style: Theme.of(context).textTheme.bodyText1),
              Text(
                  "Narration: " + narration,
                  style: Theme.of(context).textTheme.bodyText1)
            ],
          ),
        ),
        actions: <Widget>[

          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
              canclick=true;
            },
          ),
          TextButton(
            child: const Text('CONFIRM'),
            onPressed: () {
              try{

                setState(() {
                  canclick=false;
                });
                payUtilityBill(utilityTransaction,token:AuthToken).then((value) => {
                  payresponse(value)
                });
                Navigator.of(context).pop();


              }on Exception catch(_){
                print(_);
                Fluttertoast.showToast(
                    msg: "Failed to fetch details! Login again.",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM
                );
              }

            },
          ),
        ],

      );
    });


  }


  void polulate(String name,List<String> accounts,AccountResponse accountResponse){
    print("POPULATE Accounts");
    try{
      if(accountResponse!=null){
        if(accountResponse.Accounts!=null){
          setState(() {
            Accounts=accountResponse.Accounts;
            //Accounts.insert(0, "-select account-");
            _dropdownMenuItems = buildDropdownMenuItems(Accounts);
          });
        }
      }
    }on Exception catch(_){
      print(_);
    }
  }

  void payresponse(BillpaymentResponse accountResponse){
    print(" AIRTIME PAY RESPONSE");
    setState(() {
      canclick=true;
    });
    try{
      if(accountResponse!=null){
        setState(() {
          canclick=true;
        });
        if(accountResponse.Status){
          setState(() {
            canclick=true;
          });
          setState(() {
            narration="";
            phonenumber="";
            amount="";
          });
          Fluttertoast.showToast(
              msg: "Payment successful!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM
          );
          Navigator.pop(context);
        }else{
          setState(() {
            canclick=true;
          });
          Fluttertoast.showToast(
              msg: accountResponse.Description,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM
          );
        }
      }else{
        setState(() {
          canclick=true;
        });
        Fluttertoast.showToast(
            msg: "Payment failed! Try again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM
        );
      }
    }on Exception catch(_){
      setState(() {
        canclick=true;
      });
      print(_);
      Fluttertoast.showToast(
          msg: "An error occured! Try again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
      );
    }
  }

  void polulateProviders(String name,List<UtilityProviders> accounts,newUtilityProvidersResponse newutilityprovidersResponse){
    print("POPULATE PROVIDERS");
    try{
      if(newutilityprovidersResponse!=null){
        if(newutilityprovidersResponse.utilityProviders!=null){
          setState(() {
            Providers=newutilityprovidersResponse.utilityProviders;
            String dataencoded = jsonEncode(Providers);
            providerName = jsonDecode(dataencoded);

            for (int i = 0; i < Providers.length; i++) {
              providerList.add(providerName[i]['PROVIDERNAME']);

              print(providerList);

            }

            _dropdownProviders = buildDropdownProviders(providerList);
          });
        }
      }
    }on Exception catch(_){
      print(_);
    }
  }


  List<DropdownMenuItem<String>> buildDropdownMenuItems(List options) {
    List<DropdownMenuItem<String>> items = List();
    items.add(
        DropdownMenuItem(
          value: "-select account-",
          child: Text("Choose From Account:"),
        )
    );
    for (String option in options) {
      items.add(
        DropdownMenuItem(
          value: option,
          child: Text(option),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildDropdownProviders(List options) {
    List<DropdownMenuItem<String>> items = List();
    items.add(
        DropdownMenuItem(
          value: "-select provider-",
          child: Text("Choose provider-"),
        )
    );
    for (String option in options) {
      items.add(
        DropdownMenuItem(
          value: option,
          child: Text(option),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(String selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
    if(selectedCompany!="-select account-"){
      //ACTION
    }
  }

  onChangeDropdownProvider(String selectedProvider) {
    setState(() {
      _selectedProvider = selectedProvider;
    });
    if(selectedProvider!="-select provider-"){
      //ACTION
    }
  }

  Widget my_dropdown_accounts(BuildContext context){
    return Container(
      height: 35,
      decoration: BoxDecoration(
          border: Border.all(width: 1,color: Colors.black54),
          borderRadius: BorderRadius.circular(4)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    hint: Text('Account'),
                    value: _selectedCompany,
                    onChanged: onChangeDropdownItem,
                    items: _dropdownMenuItems,
                    icon: Container(
                      width: 32,
                      height: 50,
                      color: Colors.indigo[900],
                      child: new IconButton(
                          icon: new Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Colors.white,),
                          onPressed: null),
                    ),
                  ),
                ),
              )
          )
        ],
      ),
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.only(bottom: 20,left: 25,right: 25),
    );
  }

  Widget my_dropdown_providerss(BuildContext context){
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1,color: Colors.black54),
          borderRadius: BorderRadius.circular(4)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    hint: Text('Provider'),
                    value: _selectedProvider,
                    onChanged: onChangeDropdownProvider,
                    items: _dropdownProviders,
                    isExpanded: true,
                  ),
                ),
              )
          )
        ],
      ),
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.only(bottom: 20,left: 25,right: 25),
    );
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }



}