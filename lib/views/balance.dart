import 'package:cdh/models/changepassword.dart';
import 'package:cdh/models/member.dart';
import 'package:cdh/models/ministatement.dart';
import 'package:cdh/models/response.dart';
import 'package:cdh/views/accountinfo.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'home.dart';
import 'login.dart';

class BalanceScreen extends StatefulWidget {
  @override
  _BalanceScreen createState() => _BalanceScreen();
}

/// This is the private State class that goes with MyStatefulWidget.
class _BalanceScreen extends State<BalanceScreen> {
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
  String currentbalance="MWK 0.0";
  String availablebalance="MWK 0.0";
  String AuthToken="";

  List<String> Accounts=[];
  List<String> Numbers=['First', 'Second', 'Third', 'Fourth'];
  List<DropdownMenuItem<String>> _dropdownMenuItems;
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
  var session = FlutterSession();
  final oCcy = new NumberFormat("#,##0.00", "en_US");
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
    super.initState();
    _dropdownMenuItems = buildDropdownMenuItems(Accounts);
    _selectedCompany = _dropdownMenuItems[0].value;
    setState(() {
      getAccounts();
      //Accounts=["-select account-"];
      _dropdownMenuItems = buildDropdownMenuItems(Accounts);
      currentbalance="MWK 0.0";
      availablebalance="MWK 0.0";
      AuthToken="";
      getUserTokenData();
      getLoginTime();
    });

    getLoginTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        leading:IconButton(
          onPressed: (){
            Navigator.pop(context,
              MaterialPageRoute(builder: (context) => AccountInfoScreen()),)
            ;

          },
          icon:Icon(
            Icons.arrow_back,
            size: 40,),),
        title: Row(
          children: <Widget>[
            // Image(
            //   image: AssetImage("images/cdhlogo.png"),
            //   width: 50,
            // ),
            Spacer(),
            Text("Balance Enquiry",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'CalibriBold',
                fontSize: 24,

              ),
            ),
            Spacer(),
            Icon(Icons.menu,
              size: 30,),
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
          // Container(
          //   margin: EdgeInsets.only(top: 20),
          //   child: DropdownButton<String>(
          //     value: dropdownValue,
          //     onChanged: (String newValue) {
          //       setState(() {
          //         dropdownValue = newValue;
          //       });
          //     },
          //     items: <String>['First', 'Second', 'Third', 'Fourth']
          //         .map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value),
          //       );
          //     }).toList(),
          //   ),
          // ),
          ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 40),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Icon(
                        Icons.account_balance,
                        color: Colors.black,
                        size: 50,
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Text("Choose account",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'CalibriBold',
                            fontSize: 18,
                          ),),
                      ),
                      margin: EdgeInsets.only(bottom: 20),
                    ),
                    /*Container(
                      child: Center(
                        child: DropdownButton(
                          value: _selectedCompany,
                          items: _dropdownMenuItems,
                          onChanged: onChangeDropdownItem,
                        ),
                      ),
                    ),*/
                    my_dropdown_accounts(context),
                    Container(
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Spacer(),
                                    Text("Current balance: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'CalibriBold'
                                      ),
                                    ),
                                    Text(currentbalance,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                          fontFamily: 'CalibriRegular'
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 4,bottom: 6),
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Spacer(),
                                    Text("Available balance: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'CalibriBold'
                                      ),
                                    ),
                                    Text(availablebalance,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                          fontFamily: 'CalibriRegular'
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
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

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List options) {
    List<DropdownMenuItem<String>> items = List();
    items.add(
        DropdownMenuItem(
          value: "-select account-",
          child: Text("Choose account from"),
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
    currentbalance="MWK "+oCcy.format(0);
    availablebalance="MWK "+oCcy.format(0);
    setState(() {
      _selectedCompany = selectedCompany;
    });
    if(selectedCompany!="-select account-"){
      getBalance(selectedCompany);
    }
  }

  Future<void> getBalance(String Account) async {
    String u=await FlutterSession().get("USERNAME");
    String P=await FlutterSession().get("PASSWORD");
    Ministatement ministatement=Ministatement(AccountNo: Account);
    Member member=Member(username: u,password: P,OPERATION: "BALANCE",ministatement: ministatement);
    try{
      fetchBalance(member,token:AuthToken).then((value) => {
        populateBalance(value)
      });
    }on Exception catch(_){
      print(_);
      Fluttertoast.showToast(
          msg: "Faild to fetch balance! Login again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
      );
      setState(() {
        currentbalance="0.0";
        availablebalance="0.0";
      });
    }
  }

  void populateBalance(BalanceResponse balanceResponse){
    try{
      setState(() {
        currentbalance="MWK "+oCcy.format(balanceResponse.CurrentBal);
        availablebalance="MWK "+oCcy.format(balanceResponse.AvailableBal);
      });
    }on Exception catch(_){
      print(_);
    }
  }

  Widget my_dropdown_accounts(BuildContext context){
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

}