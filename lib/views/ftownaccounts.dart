import 'package:cdh/models/billpayment.dart';
import 'package:cdh/models/fundstransfer.dart';
import 'package:cdh/models/member.dart';
import 'package:cdh/models/response.dart';
import 'package:cdh/models/standingorder.dart';
import 'package:cdh/views/forcechangepassword.dart';
import 'package:cdh/views/home.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'fundstransfers.dart';
import 'login.dart';


class FtOwnAccountsScreen extends StatefulWidget{
  @override
  _FtOwnAccountsScreen createState() => _FtOwnAccountsScreen();
}

class _FtOwnAccountsScreen extends State<FtOwnAccountsScreen> {
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
  String _selectedToAccount="Choose Account To";
  String _selectedProvider="First";
  String AuthToken="";
  String _selectedBank="-select bank-";
  String _selectedCurrency="-select currency-";
  String _selectedFrequency="-select frequency-";
  String currentbalance="MWK 0.0";
  String availablebalance="MWK 0.0";
  String receivingaccount="";
  String amount="";
  DateTime startdate=null;
  DateTime enddate=null;
  String narration="";
  bool isloggedin=false;
  bool loading=false;
  bool canclick=true;
  String loadingtext="Send Money";
  String errortext="";
  String username="";

  List<String> Accounts=[];
  List<String> ToAccounts=[];
  List<String> Providers=[];
  List<String> Banks=[];
  List<String> Currency=['Malawi Kwacha (MWK)','South African Rands (ZAR)','United States Dollar (USD)','Great British Pounds (GBP)','Euro (EUR)'];
  List<String> Frequency=['Weekly','Fortnightly','Weekly','Monthly','Quarterly','Half yearly','Annually'];
  List<String> Numbers=['First', 'Second', 'Third', 'Fourth'];
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  List<DropdownMenuItem<String>> _dropdownToAccounts;
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
    _dropdownToAccounts = buildDropdownToAccounts(ToAccounts);
    _selectedCompany = _dropdownMenuItems[0].value;
    _selectedToAccount = _dropdownToAccounts[0].value;
    //_selectedProvider = _dropdownProviders[0].value;
    //_selectedFrequency=_dropdownFrequency[0].value;
    //_selectedCurrency=_dropdownCurrency[0].value;
    setState(() {
      receivingaccount="";
      loadingtext="Send Money";
      amount="";
      username="";
      AuthToken="";
      canclick=true;
      narration="";
      getLoginTime();
      getAccounts();
      getToAccounts();
      getBanks();
      _dropdownMenuItems = buildDropdownMenuItems(Accounts);
      _dropdownToAccounts = buildDropdownToAccounts(ToAccounts);
      _dropdownBanks = buildDropdownBanks(Banks);
      _dropdownFrequency = buildDropdownFrequency(Frequency);
      _dropdownCurrency = buildDropdownCurrency(Frequency);
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
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          onPressed: (){
            Navigator.pop(context,
              MaterialPageRoute(builder: (context) => FundsTransfersScreen()),)
            ;

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
            Text("Own Accounts",
            style: TextStyle(
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
          // Image(
          //   image: AssetImage("images/blue_background.jpg"),
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height,
          //   fit: BoxFit.cover,
          // ),
          ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 40),
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
                      value: _selectedToAccount,
                      items: _dropdownToAccounts,
                      onChanged: onChangeDropdownToAccount,
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                ),*/
                    my_dropdown_accounts(context),
                    my_dropdown_accounts_to(context),
                    // Container(
                    //   child: Center(
                    //     child: DropdownButton(
                    //       value: _selectedToAccount,
                    //       items: _dropdownToAccounts,
                    //       onChanged: onChangeDropdownToAccount,
                    //     ),
                    //   ),
                    //   padding: EdgeInsets.all(10),
                    // ),
                    Container(
                      child: TextField(
                        decoration: InputDecoration(
                          //prefixIcon: new Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7)
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
                      child: TextField(
                        decoration: InputDecoration(
                          //prefixIcon: new Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7)

                          ),
                          labelText: 'Payment Narration',
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
                            }else if(_selectedToAccount=="-to account-"){
                              setState(() {
                                errortext="Select to account!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }else if(_selectedToAccount==_selectedCompany){
                              setState(() {
                                errortext="Select to a different account to send to!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }else if(amount=="" || narration==""){
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
                            }else{
                              setState(() {
                                loadingtext="Please wait...";
                                errortext="";
                              });

                              int rand=DateTime.now().millisecondsSinceEpoch;
                              String randomstr=rand.toString();

                              FundsTransfer fundsTransfer=FundsTransfer(AccountNo: _selectedCompany,Terminal: "MOB",Currency: "MWK",AccountName: " ",
                                  AccountType: "NA",ChargeAmount: "0",Username: username,SessionId: randomstr,PostingType: "FTLOCAL",
                                  RefNo: "MIN"+randomstr,Msisdn: "",AccountNo2: _selectedToAccount,CurrFrom: "MWK",CurrTo: "MWK",
                                  BeneficiaryBank: "NA",TransactionType: "FTLOCAL",TransactionNarration: narration,
                                  TransactionSpecificType: narration,Amount: amount);

                              Member member=Member(fundstransfer: fundsTransfer,OPERATION: "FUNDSTRANSFER");
                              if(canclick){
                                setState(() {
                                  canclick=false;
                                });
                                sendMoney(member);
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
    String u=await FlutterSession().get("USERNAME");
    String P=await FlutterSession().get("PASSWORD");
    Member member=Member(username: u,password: P,OPERATION: "Accounts");

    try{
      setState(() {
        username=u;
      });
    }on Exception catch(_){

    }

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
  Future<void> getToAccounts() async {
    print("GET");
    String u=await FlutterSession().get("USERNAME");
    String P=await FlutterSession().get("PASSWORD");
    Member member=Member(username: u,password: P,OPERATION: "Accounts");

    try{
      setState(() {
        username=u;
      });
    }on Exception catch(_){

    }

    try{
      fetchAccount(member,token:AuthToken).then((value) => {
        polulateToAccs(value.ministatement, value.Accounts,value)
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

  Future<void> sendMoney(Member member) async {
    print("GET");

    try{
      transferFunds(member,token:AuthToken).then((value) => {
        payresponse(value)
      });
    }on Exception catch(_){
      setState(() {
        canclick=true;
      });
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
    print("--POPULATE Accounts");
    print(accountResponse);
    try{
      if(accountResponse!=null){
        if(accountResponse.Accounts!=null){
          setState(() {
            Accounts=accountResponse.Accounts;
            ToAccounts=accountResponse.Accounts;
            //Accounts.insert(0, "-select account-");
            _dropdownMenuItems = buildDropdownMenuItems(Accounts);
            _dropdownToAccounts = buildDropdownToAccounts(ToAccounts);
          });
        }
      }
    }on Exception catch(_){
      print(_);
    }
  }

  void polulateToAccs(String name,List<String> accounts,AccountResponse accountResponse){
    print("POPULATE Accounts");
    print("--POPULATE Accounts");
    print(accountResponse);
    try{
      if(accountResponse!=null){
        if(accountResponse.Accounts!=null){
          setState(() {
            ToAccounts=accountResponse.Accounts;
            _dropdownToAccounts = buildDropdownToAccounts(ToAccounts);
          });
        }
      }
    }on Exception catch(_){
      print(_);
    }
  }

  void payresponse(FundsTransferResponse accountResponse){
    setState(() {
      canclick=true;
    });
    print("payresponse");
    print(accountResponse.toJson());
    setState(() {
      loading=false;
      loadingtext="Send Money";
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
          setState(() {
            canclick=true;
          });
          Fluttertoast.showToast(
              msg: "Failed! Try again.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM
          );
        }
      }else{
        setState(() {
          canclick=true;
        });
        Fluttertoast.showToast(
            msg: "Failed! Try again.",
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

  void polulateBanks(String name,List<String> accounts,BanksResponse accountResponse){
    print("POPULATE Banks");
    try{
      if(accountResponse!=null){
        if(accountResponse.Accounts!=null){
          setState(() {
            Banks=accountResponse.Accounts;
            _dropdownBanks = buildDropdownBanks(Providers);
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
          child: Text("Choose From Account"),
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

  List<DropdownMenuItem<String>> buildDropdownToAccounts(List options) {
    List<DropdownMenuItem<String>> items = List();
    items.add(
        DropdownMenuItem(
          value: "-to account-",
          child: Text("Receiving Account"),
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
          child: Text("-select bank-"),
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
          child: Text("-select frequency-"),
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
          child: Text("-select currency-"),
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

  onChangeDropdownToAccount(String selectedToAccount) {
    setState(() {
      _selectedToAccount = selectedToAccount;
    });
    if(selectedToAccount!="-to account-"){
      //ACTION
    }
  }

  onChangeDropdownBank(String selectedBank) {
    setState(() {
      _selectedBank = selectedBank;
    });
    if(selectedBank!="-select provider-"){
      //ACTION
    }
  }

  onChangeDropdownFrequency(String selectedFrequency) {
    setState(() {
      _selectedFrequency = selectedFrequency;
    });
    if(selectedFrequency!="-select frequency-"){
      //ACTION
    }
  }

  onChangeDropdownCurrency(String selectedCurrency) {
    setState(() {
      _selectedCurrency = selectedCurrency;
    });
    if(selectedCurrency!="-select frequency-"){
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

  Widget my_dropdown_accounts_to(BuildContext context){
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
                    hint: Text('Account to'),
                    value: _selectedToAccount,
                    onChanged: onChangeDropdownToAccount,
                    items: _dropdownToAccounts,
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

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

}