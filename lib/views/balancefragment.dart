import 'package:cdh/models/changepassword.dart';
import 'package:cdh/models/member.dart';
import 'package:cdh/models/ministatement.dart';
import 'package:cdh/models/response.dart';
import 'package:cdh/views/loaders.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'home.dart';
import 'login.dart';

class BalanceFragment extends StatefulWidget {
  @override
  _BalanceFragment createState() => _BalanceFragment();
}

/// This is the private State class that goes with MyStatefulWidget.
class _BalanceFragment extends State<BalanceFragment> {
  int _selectedIndex = 0;

  List data;
  Future<List<String>> ministatementlist=Future.value(List<String>());
  bool loadingministatement=false;
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
  var session = FlutterSession();
  final oCcy = new NumberFormat("#,##0.00", "en_US");
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
      AuthToken="";
      loadingministatement=false;
      ministatementlist=Future.value(List<String>());
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
      appBar:AppBar(

          backgroundColor: const Color.fromARGB(255, 33, 29, 112),
        title: Text('Account Balance',
          style: TextStyle(
            fontFamily: 'CalibriBold',
              fontSize: 20
        ),
      ),
        leading:GestureDetector(
          child:IconButton(
            icon:Image.asset('images/logout1.png'

            ),
            onPressed: (){
              setState(() {
                _selectedIndex = 0;
              });
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen(selectedFragment:_selectedIndex),
                ),
                    (route) => false,
              );
            },
          ),
        ),
          actions: <Widget>[
      Padding(
      padding: EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.menu,
            size: 30,
          ),
        ),
      ),

    ]


    ),
      
      body: Stack(
        children: <Widget>[

          // Image(
          //   image: AssetImage("images/Background-images-1.png"),
          //   width: MediaQuery.of(context).size.width,
          //   height: 510,
          //   fit: BoxFit.cover,
          // ),
          ListView(
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: 75, right: 5, top: 20, bottom:20
                ),
                child: Text('copyright @ 2021 CDH Investment Bank Limited',
                  style: new TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      fontFamily: 'CalibriRegular',
                      color: Colors.black
                  ),

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
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  children: <Widget>[

                    Container(
                      height: 60,
                      child: Center(

                        child: Text("Choose Account",
                        style: TextStyle(
                            fontFamily: 'CalibriBold',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,

                        ),),
                      ),
                      margin: EdgeInsets.only(bottom: 12),

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
                                    Text("Current Balance: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontFamily: 'CalibriBold',
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(currentbalance,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontFamily: 'CalibriBold',
                                        fontSize: 14,
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
                                    Text("Available Balance: ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontFamily: 'CalibriBold',
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(availablebalance,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontFamily: 'CalibriBold',
                                        fontSize: 14,
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
                    ),

                  ],
                ),

              ),
              if(!loadingministatement)
                Container(
                  child: SimpleTextPlaceholder(),
                  margin: EdgeInsets.only(top: 20,left: 20,right: 20),
                )
              else
                Container(
                  child: Column(
                    children: <Widget>[
                      new ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: data == null ? 0 : data.length,
                        itemBuilder: (BuildContext context, int index){
                          return new Container(
                            child: Column(
                              children: <Widget>[
                                Text(data[index],
                                  style: TextStyle(
                                    fontFamily: 'CalibriRegular',
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),),
                                Divider()
                              ],
                            ),
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 10,right: 10),
                          );
                        },
                      )
                    ],
                  ),
                  /*child: Center(
                    child: FutureBuilder(
                      future: ministatementlist,
                      builder: (context, snapshot) {
                        // operation for completed state
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                var item = snapshot.data[index];
                                //return ArticleTile(item);
                                return Text('${snapshot.data[index]}');
                              });
                        }

                        // spinner for uncompleted state
                        return Container();
                      },
                    ),
                  ),*/
                  margin: EdgeInsets.only(top: 20,left: 20,right: 20),
                )
            ],

            scrollDirection: Axis.vertical,
          )
        ],
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
          child: Text("Select Account"),

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
    currentbalance="MWK "+oCcy.format(0);
    availablebalance="MWK "+oCcy.format(0);
    setState(() {
      loadingministatement=false;
      _selectedCompany = selectedCompany;
    });
    if(selectedCompany!="-select account-"){
      getBalance(selectedCompany);
      getMinistatement(selectedCompany);
    }
  }

  Future<void> getBalance(String Account) async {
    String u=await FlutterSession().get("USERNAME");
    String P=await FlutterSession().get("PASSWORD");
    Ministatement ministatement=Ministatement(AccountNo: Account);
    Member member=Member(username: u,password: P,OPERATION: "BALANCE",ministatement: ministatement);
    try{
      fetchBalance(member).then((value) => {
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
      height: 35,
      decoration: BoxDecoration(
          border: Border.all(width: 1,color: Colors.black54),
          borderRadius: BorderRadius.circular(12)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
                child:DropdownButtonHideUnderline(

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
                  ),
          )
        ],
      ),
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.only(bottom: 20,left: 25,right: 25),
    );


  }

  void populateMinistatement(MinistatementResponse ministatementResponse){
    print("POPULATE Ministatement");
    if(ministatementResponse!=null){
      if(ministatementResponse.Status){
        setState(() {
          loadingministatement=true;
        });
      }else{
        setState(() {
          loadingministatement=false;
        });
      }
    }else{
      setState(() {
        loadingministatement=false;
      });
    }
    this.setState(() {
      data = ministatementResponse.ministatement.split("\n");
    });
    print(ministatementResponse.ministatement.split("\n"));
    print(data.runtimeType);
    try{
      setState(() {
        ministatementlist=Future.value(ministatementResponse.ministatement.split("\n"));
      });
    }on Exception catch(_){
      print(_);
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
}