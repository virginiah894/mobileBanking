import 'package:cdh/models/changepassword.dart';
import 'package:cdh/models/member.dart';
import 'package:cdh/models/ministatement.dart';
import 'package:cdh/models/response.dart';
import 'package:cdh/models/taxpayment.dart';
import 'package:cdh/views/taxpayment.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'home.dart';
import 'login.dart';

class PRNNumberScreen extends StatefulWidget {
  @override
  _PRNNumberScreen createState() => _PRNNumberScreen();
}

/// This is the private State class that goes with MyStatefulWidget.
class _PRNNumberScreen extends State<PRNNumberScreen> {
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
  String AuthToken="";
  String availablebalance="MWK 0.0";
  Future<List<String>> ministatementlist=Future.value(List<String>());
  List<String> Accounts=[];
  List<String> Numbers=['First', 'Second', 'Third', 'Fourth'];
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  var session = FlutterSession();
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  String loadingtext="Search";
  String paytaxtext="Pay tax";

  bool DisplayResult=false;
  bool DisplaySearch=true;
  String prnnumber="";
  String errortext="";
  String mystatus="";
  double Amount=0;
  String expirydate="";
  String username="";
  TextEditingController _amountcontroller = TextEditingController();
  TextEditingController _remarkcontroller = TextEditingController();
  TextEditingController _expirycontroller = TextEditingController();
  List data;
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
    setState(() {
      getLoginTime();
      getAccounts();
      AuthToken="";
      //Accounts=["-select account-"];
      _dropdownMenuItems = buildDropdownMenuItems(Accounts);
      currentbalance="MWK 0.0";
      availablebalance="MWK 0.0";
      //ministatementlist=List<String>() as Future<List<String>>;
      ministatementlist=Future.value(List<String>());
      DisplayResult=false;
      DisplaySearch=true;
      prnnumber="";
      username="";
      errortext="";
      Amount=0;
      loadingtext="Search";
      mystatus="";
      expirydate="";
      paytaxtext="Pay tax";
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
    return new Scaffold(
      appBar: AppBar(
        leading:IconButton(
          onPressed: (){
            Navigator.pop(context,
              MaterialPageRoute(builder: (context) => TaxPaymentScreen()),)
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

            Text("Tax Payment",
            style: TextStyle(
                fontFamily: 'CalibriBold',
                fontSize: 20,
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
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      if(DisplaySearch)Container(
                        child: Column(
                          children: <Widget>[

                            Container(
                              padding: EdgeInsets.all(20),
                            ),
                            my_dropdown(context),
                            Container(
                              child: TextField(
                                decoration: InputDecoration(
                                  //prefixIcon: new Icon(Icons.number),
                                  border: OutlineInputBorder(
                                      borderRadius:BorderRadius.circular(12),

                                  ),
                                  labelText: 'PRN Number',
                                  hintText: 'Enter PRN Number to search',
                                ),
                                onChanged: (text){
                                  setState(() {
                                    prnnumber=text;
                                  });
                                },
                              ),
                              padding: EdgeInsets.all(10),
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
                                    fontWeight: FontWeight.bold,
                                  ),
                                  ),
                                  color: Colors.orange[700],
                                  shape: RoundedRectangleBorder(
                                      borderRadius:BorderRadius.circular(12)
                                  ),
                                  onPressed: (){
                                    if(prnnumber==""){
                                      setState(() {
                                        errortext="Enter PRN Number to search!";
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
                                      TaxPayment taxpayment=TaxPayment(prnnumber: prnnumber,mysourceaccountnumber: _selectedCompany,username: username);
                                      Member member=Member(OPERATION: "ETAXPAYMENT_VALIDATION",taxpayments: taxpayment);
                                      verify(member);
                                    }
                                  },
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                          ],
                        ),
                      ),
                      if(DisplayResult)Container(
                        margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: TextField(
                                  controller: _amountcontroller,
                                  decoration: InputDecoration(
                                    //prefixIcon: new Icon(Icons.person_outline),
                                    border: OutlineInputBorder(),
                                    labelText: 'Amount to pay',
                                    hintText: 'Enter amount to pay',
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (text){
                                    setState(() {
                                      Amount=double.parse(text);
                                    });
                                  },
                                ),
                                padding: EdgeInsets.all(10),
                              ),
                              Container(
                                child: TextField(
                                  controller: _remarkcontroller,
                                  decoration: InputDecoration(
                                    //prefixIcon: new Icon(Icons.person_outline),
                                    border: OutlineInputBorder(),
                                    labelText: 'Remark from MRA',
                                    hintText: 'Remark from MRA',
                                  ),
                                  onChanged: (text){
                                    setState(() {
                                      mystatus=text;
                                    });
                                  },
                                ),
                                padding: EdgeInsets.all(10),
                              ),
                              Container(
                                child: TextField(
                                  controller: _expirycontroller,
                                  decoration: InputDecoration(
                                    //prefixIcon: new Icon(Icons.person_outline),
                                    border: OutlineInputBorder(),
                                    labelText: 'Expiry Date',
                                    hintText: 'Expiry Date',
                                  ),
                                  onChanged: (text){
                                    setState(() {
                                      expirydate=text;
                                    });
                                  },
                                ),
                                padding: EdgeInsets.all(10),
                              ),
                              Container(
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: RaisedButton(

                                    textColor: Colors.white,
                                    child: Text(paytaxtext,
                                    style: TextStyle(
                                        fontFamily: 'CalibriBold'
                                    ),),
                                    color: Colors.indigoAccent[700],
                                    onPressed: (){
                                      if(prnnumber==""){
                                        setState(() {
                                          errortext="Enter PRN Number to search!";
                                        });
                                        Fluttertoast.showToast(
                                            msg: errortext,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM
                                        );
                                      }else{
                                        setState(() {
                                          paytaxtext="Please wait...";
                                          errortext="";
                                        });
                                        TaxPayment taxpayment=TaxPayment(mysourceaccountnumber: _selectedCompany,prnnumber: prnnumber,
                                            mytransferamount: Amount.toString(),username: username);
                                        Member member=Member(OPERATION: "ETAXPAYMENT_POSTING",taxpayments: taxpayment,username: username);
                                        pay(member);
                                      }
                                    },
                                  ),
                                ),
                                padding: EdgeInsets.all(10),
                              )
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
    setState(() {
      username=u;
    });
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
    print("POPULATE");
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

  onChangeDropdownItem(String selectedCompany) {
    data=null;
    setState(() {
      _selectedCompany = selectedCompany;
    });
    if(selectedCompany!="-select account-"){
      //getMinistatement(selectedCompany);
    }
  }

  Future<void> getMinistatement(String Account) async {
    String u=await FlutterSession().get("USERNAME");
    String P=await FlutterSession().get("PASSWORD");
    int rand=DateTime.now().millisecondsSinceEpoch;
    String randomstr=rand.toString();
    Ministatement ministatement=Ministatement(AccountNo: Account,TransactionType: "MIN", Terminal: "MOB", Currency: "MWK",
        SessionId: randomstr, AccountName: "", AccountType: "", Username: "",
        PostingType: "MIN", RefNo: randomstr, Msisdn: "");

    Member member=Member(username: u,password: P,OPERATION: "MINISTATEMENT",ministatement: ministatement);
    try{
      fetchMinistatement(member,token:AuthToken).then((value) => {
        populateMinistatement(value)
      });
    }on Exception catch(_){
      print(_);
      Fluttertoast.showToast(
          msg: "Faild to fetch ministatement! Login again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
      );
      setState(() {
        currentbalance="0.0";
        availablebalance="0.0";
      });
    }
  }

  void populateMinistatement(MinistatementResponse ministatementResponse){
    print("POPULATE Ministatement");
    this.setState(() {
      data = ministatementResponse.ministatement.split("\n");
    });
    print(ministatementResponse.ministatement.split("\n"));
    try{
      setState(() {
        ministatementlist=Future.value(ministatementResponse.ministatement.split("\n"));
      });
    }on Exception catch(_){
      print(_);
    }
  }

  Future<void> verify(Member member) async{
    try{
      verifyTaxPRN(member,token:AuthToken).then((value) => {
        afterVerify(value)
      });
    }catch(_){
      setState(() {
        DisplayResult=false;
        DisplaySearch=true;
        loadingtext="Search";
      });
      Fluttertoast.showToast(
          msg: "Network failure!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM
      );
    }
  }

  Future<void> pay(Member member) async{
    try{
      verifyTaxPRN(member,token:AuthToken).then((value) => {
        afterVerify(value)
      });
    }catch(_){
      setState(() {
        paytaxtext="Pay tax";
      });
      Fluttertoast.showToast(
          msg: "Tax payment failed!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM
      );
    }
  }

  void afterPayment(TaxPaymentResponse verifyResponse){
    setState(() {
      paytaxtext="Pay tax";
    });
    try{
      if(verifyResponse!=null){
        if(verifyResponse.Status){
          setState(() {
            paytaxtext="Pay tax";
          });
          Fluttertoast.showToast(
              msg: "Tax payment successful. Message from MRA is: "+verifyResponse.ministatement,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM
          );
          Navigator.pop(context);
        }else{
          setState(() {
            paytaxtext="Pay tax";
          });
          Fluttertoast.showToast(
              msg: "Tax payment failed. Message from MRA is: "+verifyResponse.ministatement,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM
          );
        }
      }else{
        setState(() {
          paytaxtext="Pay tax";
        });
        Fluttertoast.showToast(
            msg: "Tax payment failed!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM
        );
      }
    }catch(_){
      setState(() {
        paytaxtext="Pay tax";
      });
      Fluttertoast.showToast(
          msg: "Tax payment failed!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM
      );
    }
  }

  void afterVerify(PRNVerifyResponse verifyResponse){
    setState(() {
      loadingtext="Search";
    });
    try{
      if(verifyResponse!=null){
        if(verifyResponse.Status){
          setState(() {
            DisplaySearch=false;
            DisplayResult=true;
            mystatus=verifyResponse.ministatement;
            Amount=verifyResponse.CurrentBal;
            expirydate=verifyResponse.Description;

            _remarkcontroller.text=mystatus;
            _expirycontroller.text=expirydate;
            _amountcontroller.text=Amount.toString();
          });
        }else{
          setState(() {
            DisplayResult=false;
            DisplaySearch=true;
          });
          Fluttertoast.showToast(
              msg: verifyResponse.Description+" "+verifyResponse.ministatement,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM
          );
        }
      }else{
        setState(() {
          loadingtext="Search";
        });
        Fluttertoast.showToast(
            msg: "Tax payment failed!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM
        );
      }
    }catch(_){
      setState(() {
        DisplayResult=false;
        DisplaySearch=true;
        loadingtext="Search";
      });
      Fluttertoast.showToast(
          msg: "Network failure!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM
      );
    }
  }

  Widget my_dropdown(BuildContext context){
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
      margin: EdgeInsets.only(bottom: 10,left: 10,right: 10),

    );
  }
}