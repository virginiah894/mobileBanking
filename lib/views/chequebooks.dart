import 'package:cdh/models/billpayment.dart';
import 'package:cdh/models/chequebookrequest.dart';
import 'package:cdh/models/member.dart';
import 'package:cdh/models/response.dart';
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


class ChequebooksScreen extends StatefulWidget{
  @override
  _ChequebooksScreen createState() => _ChequebooksScreen();
}

class _ChequebooksScreen extends State<ChequebooksScreen> {
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
  String AuthToken="";
  String _selectedBank="-select bank-";
  String _selectedNoOfBooks="Number of Cheque Books:";
  String _selectedNoOfPages="Number of Pages:";
  String _selectedCollectionPoint="Collection Point:";
  String _selectedFrequency="-select frequency-";
  String currentbalance="MWK 0.0";
  String availablebalance="MWK 0.0";
  String receivingaccount="";
  double amount=0;
  String narration="";
  bool isloggedin=false;
  bool loading=false;
  bool canclick=true;
  String loadingtext="Save";
  String errortext="";

  List<String> Accounts=[];
  List<String> Providers=[];
  List<String> Banks=[];
  List<String> Currency=[];
  List<String> Frequency=[];
  List<String> Books=["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  List<String> Pages=["25", "50", "100"];
  List<String> CollectionPoint=[];
  List<String> Numbers=['First', 'Second', 'Third', 'Fourth'];
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  List<DropdownMenuItem<String>> _dropdownProviders;
  List<DropdownMenuItem<String>> _dropdownPages;
  List<DropdownMenuItem<String>> _dropdownBooks;
  List<DropdownMenuItem<String>> _dropdownCollectionPoint;
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
    _dropdownProviders = buildDropdownProviders(Providers);
    _dropdownCollectionPoint=buildDropdownCollectionPoint(CollectionPoint);
    _selectedCompany = _dropdownMenuItems[0].value;
    _selectedProvider = _dropdownProviders[0].value;
    setState(() {
      receivingaccount="";
      amount=0;
      narration="";
      canclick=true;
      _dropdownMenuItems = buildDropdownMenuItems(Accounts);
      getLoginTime();
      getAccounts();
      getProviders();
      getCollectionPoints();
      _dropdownBooks = buildDropdownBooks(Books);
      _dropdownPages = buildDropdownPages(Pages);
      _dropdownCollectionPoint=buildDropdownCollectionPoint(CollectionPoint);
      currentbalance="MWK 0.0";
      availablebalance="MWK 0.0";
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
      appBar: AppBar(
        // automaticallyImplyLeading: true,
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
            Text("Cheque Book",
            style: TextStyle(
                fontFamily: 'CalibriBold',
                fontSize: 24
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

                    my_dropdown_accounts(context),
                    my_dropdown_books(context),
                    my_dropdown_pages(context),
                    my_dropdown_collectionpoints(context),
                    Container(
                      width: 380,
                      height: 45,


                      child: TextField(
                        decoration: InputDecoration(
                          //prefixIcon: new Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          labelText: 'Receiving Account',
                          hintText: ' Receiving Account',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (text){
                          setState(() {
                            receivingaccount=text;
                          });
                        },
                      ),
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(left: 25,right: 25),

                    ),
                    Container(
                      width: 380,
                      height: 45,
                      child: TextField(
                        decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                          labelText: 'Comment',
                          hintText: 'Enter narration',
                          ),

                        onChanged: (text){
                          setState(() {
                            narration=text;
                          });
                        },
                      ),
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(bottom: 15,left: 25,right: 25),

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
                            fontWeight: FontWeight.bold,
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
                            }else if(_selectedNoOfBooks=="Number of Cheque Books:"){
                              setState(() {
                                errortext="Choose Number of Cheque Books!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }else if(_selectedNoOfPages=="Number of Pages:"){
                              setState(() {
                                errortext="Choose Number of Pages!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }else if(_selectedCollectionPoint=="Collection Point:"){
                              setState(() {
                                errortext="Choose Collection Point!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }else if(receivingaccount=="" || narration==""){
                              setState(() {
                                errortext="Fill in all the fields!";
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
                              ChequebookRequest chequebookRequest=ChequebookRequest(MyAccountcurrency: "Malawi Kwacha",
                                  MyAccountName: "",MyAccountNum: _selectedCompany,MyAccounttype: "",MyCollectionPoint: _selectedCollectionPoint,
                                  MyComments: narration,MyCompanyID: "",MyNumberofBooks: int.parse(_selectedNoOfBooks),MyPages: int.parse(_selectedNoOfPages));

                              Member member=Member(chequebookrequest: chequebookRequest,OPERATION: "CHEQUEBOOKREQ");
                              if(canclick){
                                setState(() {
                                  canclick=false;
                                });
                                makeRequest(member);
                              }
                            }
                          },
                        ),
                      ),
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(bottom: 20,left: 25,right: 25),
                    ),

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

  Future<void> getCollectionPoints() async {
    print("GET");
    String u=await FlutterSession().get("USERNAME");
    String P=await FlutterSession().get("PASSWORD");
    Member member=Member(username: u,password: P,OPERATION: "BRANCHES");

    try{
      fetchCollectionPoints(member,token:AuthToken).then((value) => {
        polulateCollectionPoints(value)
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
    Member member=Member(username: u,password: P,OPERATION: "Utility",utility: "WATER",utilityname: "WATER");

    try{
      fetchProviders(member,token:AuthToken).then((value) => {
        polulateProviders(value.ministatement, value.Accounts,value)
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

  Future<void> makeRequest(Member member) async {
    print("GET");

    try{
      requestChequeBook(member,token:AuthToken).then((value) => {
        payresponse(value)
      });
    }on Exception catch(_){
      setState(() {
        canclick=true;
      });
      print(_);
      Fluttertoast.showToast(
          msg: "Failed to save! Try again.",
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

  void polulateCollectionPoints(ColletionPointsResponse colletionPointsResponse){
    print("polulateCollectionPoints");
    try{
      if(colletionPointsResponse!=null){
        if(colletionPointsResponse.Accounts!=null){
          setState(() {
            CollectionPoint=colletionPointsResponse.Accounts;
            _dropdownCollectionPoint = buildDropdownCollectionPoint(CollectionPoint);
          });

          print(CollectionPoint);
        }
      }
    }on Exception catch(_){
      print(_);
    }
  }

  void payresponse(ChequeBookResponse accountResponse){
    setState(() {
      canclick=true;
    });
    print("payresponse");
    print(accountResponse.toJson());
    setState(() {
      loading=false;
      loadingtext="Save";
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
            amount=0;
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
              msg: "Request failed! Try again.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM
          );
        }
      }else{
        setState(() {
          canclick=true;
        });
        Fluttertoast.showToast(
            msg: "Request failed! Try again.",
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

  void polulateProviders(String name,List<String> accounts,UtilityProvidersResponse accountResponse){
    print("POPULATE Accounts");
    try{
      if(accountResponse!=null){
        if(accountResponse.Accounts!=null){
          setState(() {
            Providers=accountResponse.Accounts;
            _dropdownProviders = buildDropdownProviders(Providers);
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

  List<DropdownMenuItem<String>> buildDropdownProviders(List options) {
    List<DropdownMenuItem<String>> items = List();
    items.add(
        DropdownMenuItem(
          value: "-select provider-",
          child: Text("-select provider-"),
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

  List<DropdownMenuItem<String>> buildDropdownPages(List options) {
    List<DropdownMenuItem<String>> items = List();
    items.add(
        DropdownMenuItem(
          value: "Number of Pages:",
          child: Text("Number of Pages:"),
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

  List<DropdownMenuItem<String>> buildDropdownBooks(List options) {
    List<DropdownMenuItem<String>> items = List();
    items.add(
        DropdownMenuItem(
          value: "Number of Cheque Books:",
          child: Text("Number of Cheque Books:"),
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

  List<DropdownMenuItem<String>> buildDropdownCollectionPoint(List options) {
    List<DropdownMenuItem<String>> items = List();
    items.add(
        DropdownMenuItem(
          value: "Collection Point:",
          child: Text("Collection Point:"),
        )
    );
    for (String option in options) {
      print("Option");
      print(option);
      print("\n");
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

  onChangeDropdownPages(String selectedPages) {
    setState(() {
      _selectedNoOfPages = selectedPages;
    });
    if(selectedPages!="-select provider-"){
      //ACTION
    }
  }

  onChangeDropdownBooks(String selectedBooks) {
    setState(() {
      _selectedNoOfBooks = selectedBooks;
    });
    if(selectedBooks!="-select provider-"){
      //ACTION
    }
  }

  onChangeDropdownCollectionPoint(String selectedCollectionPoint) {
    setState(() {
      _selectedCollectionPoint = selectedCollectionPoint;
    });
    if(_selectedCollectionPoint!="-select provider-"){
      //ACTION
    }
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
                      width: 25,

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

  Widget my_dropdown_books(BuildContext context){
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
                    hint: Text('No. of books'),
                    value: _selectedNoOfBooks,
                    onChanged: onChangeDropdownBooks,
                    items: _dropdownBooks,
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

  Widget my_dropdown_pages(BuildContext context){
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
                    hint: Text('No. of pages'),
                    value: _selectedNoOfPages,
                    onChanged: onChangeDropdownPages,
                    items: _dropdownPages,
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

  Widget my_dropdown_collectionpoints(BuildContext context){
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
                    hint: Text('Collection points'),
                    value: _selectedCollectionPoint,
                    onChanged: onChangeDropdownCollectionPoint,
                    items: _dropdownCollectionPoint,
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
          ),


        ],

      ),

      padding: EdgeInsets.all(0),
      margin: EdgeInsets.only(bottom: 30,left: 20,right: 20),

    );
  }
}