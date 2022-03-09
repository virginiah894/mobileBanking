import 'package:cdh/models/billpayment.dart';
import 'package:cdh/models/member.dart';
import 'package:cdh/models/response.dart';
import 'package:cdh/models/standingorder.dart';
import 'package:cdh/views/forcechangepassword.dart';
import 'package:cdh/views/home.dart';
import 'package:cdh/views/requestsoptions.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'login.dart';


class StandingOrdersScreen extends StatefulWidget{
  @override
  _StandingOrdersScreen createState() => _StandingOrdersScreen();
}

class _StandingOrdersScreen extends State<StandingOrdersScreen> {
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
  String dropdownValue="First";
  String _selectedCompany="First";
  String _selectedProvider="First";
  String _selectedBank="-select bank-";
  String _selectedCurrency="-select currency-";
  String _selectedFrequency="-select frequency-";
  String currentbalance="MWK 0.0";
  String AuthToken="";
  String availablebalance="MWK 0.0";
  String receivingaccount="";
  String amount="";
  DateTime startdate=null;
  DateTime enddate=null;
  String narration="";
  bool isloggedin=false;
  bool loading=false;
  String loadingtext="Save";
  String errortext="";

  List<String> Accounts=[];
  List<String> Providers=[];
  List<String> Banks=[];
  List<String> Currency=['Malawi Kwacha (MWK)','South African Rands (ZAR)','United States Dollar (USD)','Great British Pounds (GBP)','Euro (EUR)'];
  List<String> Frequency=['Weekly','Fortnightly','Monthly','Quarterly','Half yearly','Annually'];
  List<String> Numbers=['First', 'Second', 'Third', 'Fourth'];
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  List<DropdownMenuItem<String>> _dropdownProviders;
  List<DropdownMenuItem<String>> _dropdownBanks;
  List<DropdownMenuItem<String>> _dropdownCurrency;
  List<DropdownMenuItem<String>> _dropdownFrequency;
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
    _dropdownMenuItems = buildDropdownMenuItems(Accounts);
    _selectedCompany = _dropdownMenuItems[0].value;
    _dropdownFrequency = buildDropdownFrequency(Frequency);
    _dropdownCurrency = buildDropdownCurrency(Currency);
    //_selectedProvider = _dropdownProviders[0].value;
    _selectedFrequency=_dropdownFrequency[0].value;
    _selectedCurrency=_dropdownCurrency[0].value;
    setState(() {
      receivingaccount="";
      loadingtext="Save";
      AuthToken="";
      amount="";
      narration="";
      Frequency=['Weekly','Fortnightly','Monthly','Quarterly','Half yearly','Annually'];
      getLoginTime();
      getAccounts();
      getBanks();
      _dropdownMenuItems = buildDropdownMenuItems(Accounts);
      _dropdownBanks = buildDropdownBanks(Banks);
      _dropdownFrequency = buildDropdownFrequency(Frequency);
      _dropdownCurrency = buildDropdownCurrency(Currency);
      currentbalance="MWK 0.0";
      availablebalance="MWK 0.0";
      startdate=DateTime.now();
      enddate=DateTime.now();
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading:IconButton(
          onPressed: (){
            Navigator.pop(context,
              MaterialPageRoute(builder: (context) => RequestsScreen()),)
            ;

          },
          icon:Icon(
            Icons.arrow_back,
            size: 30,),),
        title: Row(
          children: <Widget>[
            Spacer(),
            Text("Standing Order",
            style: TextStyle(
                fontFamily: 'CalibriBold',
                fontSize: 20
            ),
            ),

            Spacer(),
            Icon(
              Icons.menu,
              size: 30,
            ),
          ],

        ),

        backgroundColor: const Color.fromARGB(255, 33, 29, 112),
      ),
      body: Stack(
          children: <Widget>[
            ListView(

              shrinkWrap: true,
              //physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(),
              children: <Widget>[
                Column(
                  children: <Widget>[

                    Container(
                      padding: EdgeInsets.all(0),
                    ),
                    my_dropdown_accounts(context),
                    my_dropdown_banks(context),
                    my_dropdown_currency(context),
                    my_dropdown_frequency(context),

                    Container(
                      height: 45,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          labelText: 'Receiving Account',
                          hintText: 'Enter Receiving Account',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (text){
                          setState(() {
                            receivingaccount=text;
                          });
                        },
                      ),
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(left: 25,right: 25,top:20),
                    ),
                    Container(
                      height: 45,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          labelText: 'Amount to Send',
                          hintText: 'Enter amount to send',
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
                      height: 45,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(7)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Spacer(),
                          Text(
                            "${startdate.toLocal()}".split(' ')[0],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal,fontFamily: 'CalibriRegular'),
                          ),
                          Spacer(),
                          RaisedButton(
                            onPressed: () => _selectStartDate(context),
                            child: Text(
                              'Select Start Date',
                              style:
                              TextStyle(color: Colors.white, fontWeight: FontWeight.normal,fontFamily: 'CalibriRegular'),
                            ),
                            color: Colors.indigo[900],
                          ),
                          Spacer(),
                        ],
                      ),
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(left: 25,right: 25),
                    ),
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(7)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Spacer(),
                          Text(
                            "${enddate.toLocal()}".split(' ')[0],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal,
                                fontFamily: 'CalibriRegular'),
                          ),
                          Spacer(),
                          RaisedButton(
                            onPressed: () => _selectEndDate(context),
                            child: Text(
                              'Select End Date',
                              style:
                              TextStyle(color: Colors.white, fontWeight: FontWeight.normal,fontFamily: 'CalibriRegular'),
                            ),
                            color: Colors.indigo[900],
                          ),
                          Spacer(),
                        ],
                      ),
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(left: 25,right: 25),
                    ),
                    Container(
                      height: 45,
                      child: TextField(
                        decoration: InputDecoration(
                          //prefixIcon: new Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),

                          labelText: 'Standing Order',
                          hintText: 'Enter Narration',
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
                    Container(
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: RaisedButton(

                          textColor: Colors.white,
                          child: Text(loadingtext,
                            style: TextStyle(
                                fontFamily: 'CalibriBold',
                              fontSize: 20,
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
                            }
                            else if(_selectedBank=="-select bank-"){
                              setState(() {
                                errortext="Select beneficiary bank!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }
                            else if(_selectedCurrency=="-select currency-"){
                              setState(() {
                                errortext="Select currency!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }
                            else if(_selectedFrequency.toLowerCase()=="-select frequency-"){
                              setState(() {
                                errortext="Select frequency!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }
                            else if(amount=="" || receivingaccount=="" || narration==""){
                              setState(() {
                                errortext="Fill in all the fields!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }else if(!isNumeric(amount)){
                              setState(() {
                                errortext="Invalid amount!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }
                            else{
                              setState(() {
                                loadingtext="Please wait...";
                                errortext="";
                              });

                              int rand=DateTime.now().millisecondsSinceEpoch;
                              String randomstr=rand.toString();

                              StandingOrder standingOrder=StandingOrder(myTransferAmount: amount, MyBeneficiaryAccountName: "",
                                  MyBeneficiaryAccountNumber: receivingaccount, MyBeneficiarybank: _selectedBank, MyBranchName: "",
                                  MyComments: narration, MyCompanyID: 0, MyEndDate: DateFormat('yyyy-MM-dd').format(enddate),
                                  MyRecurdate: DateFormat('yyyy-MM-dd').format(startdate), MySourceAccountName: "",
                                  MySourceAccountType: "", MySourceAccountNumber: _selectedCompany, MyTransfertype: "StandingOrder",
                                  MySourceCurrency: _selectedCurrency, MyFrequency: _selectedFrequency,myTransferCurrency: _selectedCurrency);

                              Member member=Member(standingorder: standingOrder,OPERATION: "STANDINGORDER");
                              makeRequest(member);
                            }
                          },
                        ),
                      ),
                      padding: EdgeInsets.only(top: 0,left: 0,right: 0,bottom: 0),
                      margin: EdgeInsets.only(bottom: 5,left: 0,right: 25),

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
    String u=await FlutterSession().get("USERNAME");
    String P=await FlutterSession().get("PASSWORD");
    Member member=Member(username: u,password: P,OPERATION: "Accounts");

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

  Future<void> getBanks() async {
    print("GET");
    String u=await FlutterSession().get("USERNAME");
    String P=await FlutterSession().get("PASSWORD");
    Member member=Member(username: u,password: P,OPERATION: "BANKS");

    try{
      fetchBanks(member,token:AuthToken).then((value) => {
        polulateBanks(value.ministatement, value.Accounts,value)
      });
    }on Exception catch(_){
      print(_);
      Fluttertoast.showToast(
          msg: "Faild to fetch banks! Login again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
      );
    }
  }

  Future<void> makeRequest(Member member) async {
    print("GET");

    try{
      requestStandingOrder(member,token:AuthToken).then((value) => {
        payresponse(value)
      });
    }on Exception catch(_){
      print(_);
      Fluttertoast.showToast(
          msg: "Failed to save! Login again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
      );
    }
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

  void payresponse(StandingOrderResponse accountResponse){
    print("payresponse");
    print(accountResponse.toJson());
    setState(() {
      loading=false;
      loadingtext="Save";
    });
    try{
      if(accountResponse!=null){
        if(accountResponse.Status){
          setState(() {
            narration="";
            receivingaccount="";
            amount="";
          });
          Fluttertoast.showToast(
              msg: "Success!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM
          );

          Navigator.pop(context);
        }else{
          Fluttertoast.showToast(
              msg: "Failed! Try again.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM
          );
        }
      }else{
        Fluttertoast.showToast(
            msg: "Failed! Try again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM
        );
      }
    }on Exception catch(_){
      print(_);
      Fluttertoast.showToast(
          msg: "An error occured! Try again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
      );
    }
  }

  void polulateBanks(String name,List<String> accounts,BanksResponse accountResponse){
    print("POPULATE Banks");
    try{
      if(accountResponse!=null){
        if(accountResponse.Accounts!=null){
          setState(() {
            Banks=accountResponse.Accounts;
            _dropdownBanks = buildDropdownBanks(Banks);
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
          child: Text("Choose Account From"),
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

  List<DropdownMenuItem<String>> buildDropdownBanks(List options) {
    List<DropdownMenuItem<String>> items = List();
    items.add(
        DropdownMenuItem(
          value: "-select bank-",
          child: Text("Choose Bank"),
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

  List<DropdownMenuItem<String>> buildDropdownFrequency(List options) {
    List<DropdownMenuItem<String>> items = List();
    items.add(
        DropdownMenuItem(
          value: "-select frequency-",
          child: Text("Choose Frequency"),
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

  List<DropdownMenuItem<String>> buildDropdownCurrency(List options) {
    List<DropdownMenuItem<String>> items = List();
    items.add(
        DropdownMenuItem(
          value: "-select currency-",
          child: Text("Choose Currency"),
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
    if(selectedCompany.toLowerCase()!="-select account-"){
      //ACTION
    }
  }

  onChangeDropdownBank(String selectedBank) {
    setState(() {
      _selectedBank = selectedBank;
    });
    if(selectedBank.toLowerCase()!="-select provider-"){
      //ACTION
    }
  }

  onChangeDropdownFrequency(String selectedFrequency) {
    setState(() {
      _selectedFrequency = selectedFrequency;
    });
    if(selectedFrequency.toLowerCase()!="-select frequency-"){
      //ACTION
    }
  }

  onChangeDropdownCurrency(String selectedCurrency) {
    setState(() {
      _selectedCurrency = selectedCurrency;
    });
    if(selectedCurrency.toLowerCase()!="-select frequency-"){
      //ACTION
    }
  }

  _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: startdate, // Refer step 1
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365*10)),
    );
    if (picked != null )
      setState(() {
        startdate = picked;
      });
  }

  _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: startdate, // Refer step 1
      firstDate: startdate,
      lastDate: startdate.add(Duration(days: 365*10)),
    );
    if (picked != null && picked != startdate)
      setState(() {
        enddate = picked;
      });
  }

  Widget my_dropdown_accounts(BuildContext context){
    return Container(
      height: 35,
      decoration: BoxDecoration(
          border: Border.all(width: 1,color: Colors.black54),
          borderRadius: BorderRadius.circular(7)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
                 child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton(
                        // iconSize: 40,
                        hint: Text('Account'),
                        value: _selectedCompany,
                        onChanged: onChangeDropdownItem,
                        items: _dropdownMenuItems,
                        icon: Container(
                          width: 32,

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
          ),


        ],

      ),

      margin: EdgeInsets.only(bottom: 15, top:15,left: 20,right: 20),
    );
  }

  Widget my_dropdown_banks(BuildContext context){
    return Container(
      height: 35,

      decoration: BoxDecoration(
          border: Border.all(width: 1,color: Colors.black54),
          borderRadius: BorderRadius.circular(7)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    hint: Text('Bank'),
                    value: _selectedBank,
                    onChanged: onChangeDropdownBank,
                    items: _dropdownBanks,

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
      margin: EdgeInsets.only(bottom: 15,left: 20,right: 20),
    );
  }

  Widget my_dropdown_currency(BuildContext context){
    return Container(
      height: 35,
      decoration: BoxDecoration(
          border: Border.all(width: 1,color: Colors.black54),
          borderRadius: BorderRadius.circular(7)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    hint: Text('Currency'),
                    value: _selectedCurrency,
                    onChanged: onChangeDropdownCurrency,
                    items: _dropdownCurrency,
                    icon: Container(
                      width: 32,

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
      margin: EdgeInsets.only(bottom: 15,left: 20,right: 20),
    );
  }

  Widget my_dropdown_frequency(BuildContext context){
    return Container(
      height: 35,
      decoration: BoxDecoration(
          border: Border.all(width: 1,color: Colors.black54),
          borderRadius: BorderRadius.circular(7)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,


                  child: DropdownButton(
                    hint: Text('Frequency'),
                    value: _selectedFrequency,
                    onChanged: onChangeDropdownFrequency,
                    items: _dropdownFrequency,
                    icon: Container(
                      width: 32,

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
      margin: EdgeInsets.only(bottom: 10,left: 20,right: 20),

    );


  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }



}