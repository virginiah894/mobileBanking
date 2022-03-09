import 'package:cdh/models/changepassword.dart';
import 'package:cdh/models/member.dart';
import 'package:cdh/models/ministatement.dart';
import 'package:cdh/models/response.dart';
import 'package:cdh/models/taxpayment.dart';
import 'package:cdh/models/wallet.dart';
import 'package:cdh/views/dropdownbtn.dart';
import 'package:cdh/views/wallettransfers.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:intl/intl.dart';

import 'home.dart';
import 'login.dart';

class BankToWalletScreen extends StatefulWidget {
  @override
  _BankToWalletScreen createState() => _BankToWalletScreen();
}

/// This is the private State class that goes with MyStatefulWidget.
class _BankToWalletScreen extends State<BankToWalletScreen> {
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
  String loadingtext="Send Money";
  String paytaxtext="Pay tax";

  bool DisplayResult=false;
  bool DisplaySearch=true;
  bool canclick=true;
  String prnnumber="";
  String AmountToSend="";
  String PhoneNumber="";
  String errortext="";
  String mystatus="";
  double Amount=0;
  String expirydate="";
  String username="";
  String password="";
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
      getAccounts();
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
      password="";
      AuthToken="";
      errortext="";
      AmountToSend="";
      PhoneNumber="";
      Amount=0;
      canclick=true;
      loadingtext="Send Money";
      mystatus="";
      expirydate="";
      paytaxtext="Pay tax";
      getUserTokenData();
      getLoginTime();
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
              MaterialPageRoute(builder: (context) => WalletTransfersScreen()),)
            ;

          },
          icon:Icon(
            Icons.arrow_back,
            size: 30,),),
        title: Row(
          children: <Widget>[

            Spacer(),
            Text("Bank to Wallet",
            style: TextStyle(
              fontWeight: FontWeight.bold,
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
                margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
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
                            ),*/
                            SizedBox(height: 3,),
                            Container(
                              padding: EdgeInsets.all(0),
                              margin: EdgeInsets.only(bottom: 20,left: 25,right: 25),
                            ),
                            my_dropdown(context),
                            SizedBox(height: 20,),
                            Container(
                              child: TextField(
                                decoration: InputDecoration(
                                  //prefixIcon: new Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7)
                                  ),
                                  labelText: 'Amount ',
                                  hintText: 'Enter amount to send',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (text){
                                  setState(() {
                                    AmountToSend=text;
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
                                  labelText: 'Phone Number',
                                  hintText: 'Enter Phone Number',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (text){
                                  setState(() {
                                    PhoneNumber=text;
                                  });
                                },
                              ),
                              padding: EdgeInsets.all(0),
                              margin: EdgeInsets.only(bottom: 20,left: 25,right: 25),

                            ),
                            SizedBox(height: 15,),
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
                                  ),),
                                  color: Colors.orange[700],
                                  shape: RoundedRectangleBorder(
                                      borderRadius:BorderRadius.circular(14)
                                  ),

                                  onPressed: (){
                                    if(_selectedCompany=="Choose From Account"){
                                      setState(() {
                                        errortext="Choose From Account!";
                                      });
                                      Fluttertoast.showToast(
                                          msg: errortext,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM
                                      );
                                    }
                                    else if(AmountToSend==""){
                                      setState(() {
                                        errortext="Enter amount to send!";
                                      });
                                      Fluttertoast.showToast(
                                          msg: errortext,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM
                                      );
                                    }
                                    else if(!isNumeric(AmountToSend)){
                                      setState(() {
                                        errortext="Invalid amount!";
                                      });
                                      Fluttertoast.showToast(
                                          msg: errortext,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM
                                      );
                                    }else if(PhoneNumber==""){
                                      setState(() {
                                        errortext="Enter Phone Number!";
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
                                      Wallet wallet=Wallet(AccountNo: _selectedCompany,TransactionSpecificType: "A2W",
                                        PostingType: "A2W",CurrFrom: "MWK",Username: username,Amount: AmountToSend,PhoneNumber: PhoneNumber,
                                        SessionId: randomstr,Msisdn: "",RefNo: "MIN"+randomstr,Terminal: "MOBILE",Currency: "MWK",
                                        TransactionType: "A2W",BeneficiaryBank: "MOBILE",AccountType: "NA",AccountName: "",TransactionNarration: "A2W"
                                      );

                                      print(wallet.toJson());

                                      Member member=Member(OPERATION: "WALLET",wallet: wallet,username: username,password: password);
                                      if(canclick){
                                        setState(() {
                                          canclick=false;
                                        });
                                        transfer(member);
                                      }
                                    }
                                  },
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                          ],
                        ),
                      ),
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
      password=P;
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

  Future<void> transfer(Member member) async{
    try{
      bankToWalletTransfer(member,token:AuthToken).then((value) => {
        afterTransfer(value)
      });
    }catch(_){
      setState(() {
        canclick=true;
      });
      setState(() {
        loadingtext="Send Money";
      });
      Fluttertoast.showToast(
          msg: "Failed! Network failure.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM
      );
    }
  }

  void afterTransfer(WalletTransferResponse verifyResponse){
    setState(() {
      canclick=true;
    });
    setState(() {
      loadingtext="Send Money";
    });
    try{
      if(verifyResponse!=null){
        setState(() {
          canclick=true;
        });
        print(verifyResponse.toJson());
        if(verifyResponse.Status){
          setState(() {
            canclick=true;
          });
          setState(() {
            loadingtext="Send Money";
          });
          Fluttertoast.showToast(
              msg: "Transfer request submitted successfully!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM
          );
          Navigator.pop(context);
        }else{
          setState(() {
            canclick=true;
          });
          setState(() {
            loadingtext="Send Money";
          });
          Fluttertoast.showToast(
              msg: "Transfer not successful! "+verifyResponse.ministatement,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM
          );
        }
      }else{
        setState(() {
          canclick=true;
        });
        setState(() {
          loadingtext="Send Money";
        });
        Fluttertoast.showToast(
            msg: "Transfer not successful!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM
        );
      }
    }catch(_){
      setState(() {
        canclick=true;
      });
      setState(() {
        loadingtext="Send Money";
      });
      Fluttertoast.showToast(
          msg: "Failed! Network failure.",
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
            DisplayResult=true;
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
        DisplayResult=false;
        DisplaySearch=true;
      });
      Fluttertoast.showToast(
          msg: "Network failure!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM
      );
    }
  }

  Widget my_image(BuildContext context) {
    return Image(image: AssetImage('graphics/background.png'));
  }

  Widget my_dropdown(BuildContext context){
    return Container(
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(width: 1,color: Colors.black45),
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
                            color: Colors.white,
                          ),
                          onPressed: null),

                    ),

                  ),

                ),

              ),

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