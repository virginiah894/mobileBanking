import 'dart:convert';
import 'dart:math';

import 'package:cdh/models/billpayment.dart';
import 'package:cdh/models/member.dart';
import 'package:cdh/models/response.dart';
import 'package:cdh/models/utilitypricingresponse.dart';
import 'package:cdh/models/utilitytransaction.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../home.dart';
import '../login.dart';

class BillTvScreen extends StatefulWidget{
  @override
  _BillTvScreen createState() => _BillTvScreen();
}

class _BillTvScreen extends State<BillTvScreen> {
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
  String _selectedProvider="-select provider-";
  String _selectedPricing="-select product-";
  String _selectedViewTypes="-select view type-";
  String _selectedAddon="-select addon-";
  String currentbalance="MWK 0.0";
  String availablebalance="MWK 0.0";
  String billnumber="";
  String months="";
  String narration="";
  bool isloggedin=false;
  String AuthToken="";
  bool loading=false;
  bool canclick=true;
  String loadingtext="Pay";
  String errortext="";

  List<String> Accounts=[];
  List Providers=[];
  List Pricing=[];
  List ViewTypes=[];
  List Addons=[];
  List providerName;
  List pricingName;
  List viewTypesName;
  List addonName;
  String tvProviderName = "";
  List<String> providerList=['GOTV', 'DSTV'];
  List<String> pricingList=[];
  List<String> viewtypesList=[];
  List<String> addonList=[];
  List<String> Numbers=['First', 'Second', 'Third', 'Fourth'];
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  List<DropdownMenuItem<String>> _dropdownProviders;
  List<DropdownMenuItem<String>> _dropdownPricing;
  List<DropdownMenuItem<String>> _dropdownViewTypes;
  List<DropdownMenuItem<String>> _dropdownAddon;
  var session = FlutterSession();
  String username;
  int productprice1,viewtypeprice, addonPrice;
  TransactionData transactionData;
  DstvTransactionData dstvTransactionData;
  UtilityTransaction utilityTransaction;

  Products productsModel;
  List<Products> productsModelList;
  List<dynamic> parsedListJson;
  Viewtypes viewtypesModel;
  AddonMode addonModel;



  String ProviderCode="";
  bool _selected = false;
  double amount = 0.0;


  bool isFdh=false;
  bool isNitel=false;
  int randomNumberDrop;

  List<UtilityProviders> utilityProviders;
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
    _dropdownPricing = buildDropdownPricing(Pricing);
    _dropdownViewTypes= buildDropdownViewTypes(ViewTypes);
    _dropdownAddon= buildDropdownAddon(Addons);
    _selectedCompany = _dropdownMenuItems[0].value;
    _selectedProvider = _dropdownProviders[0].value;
    _selectedPricing = _dropdownPricing[0].value;
    _selectedViewTypes = _dropdownViewTypes[0].value;
    _selectedAddon = _dropdownAddon[0].value;
    setState(() {
      billnumber="";
      months="";
      narration="";
      AuthToken="";
      canclick=true;
      getAccounts();
      getProviders();
     // getPricing("DSTV.Transaction");



      currentbalance="MWK 0.0";
      availablebalance="MWK 0.0";
      getLoginTime();
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
              MaterialPageRoute(builder: (context) => HomeScreen()),)
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
            Text("TV Subscriptions",
            style: TextStyle(
              fontWeight: FontWeight.bold,
                fontFamily: 'CalibriBold',
                fontSize: 20
            ),),
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
          // Image(
          //   image: AssetImage("images/blue_background.jpg"),
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height,
          //   fit: BoxFit.cover,
          // ),
          ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Column(
                  children: <Widget>[

                    my_dropdown_accounts(context),
                    my_dropdown_providerss(context),
                    my_dropdown_pricing(context),
                    my_dropdown_viewtype(context),
                    my_dropdown_addon(context),
                    Container(
                      child: TextField(
                        decoration: InputDecoration(
                          //prefixIcon: new Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                          labelText: 'Smart Card No.',
                          hintText: 'Enter smart card number',
                        ),
                        onChanged: (text){
                          setState(() {
                            billnumber=text;
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
                          labelText: 'No. of Months',
                          hintText: 'Enter No. of months',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (text){
                          setState(() {
                            months=text;
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
                          labelText: ' Payment Narration',
                          hintText: 'Enter narration',
                        ),
                        onChanged: (text){
                          setState(() {
                            narration=text;
                          });
                        },
                      ),
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(bottom: 10,left: 25,right: 25),
                    ),
                    Container(
                      child: SizedBox(
                        width:170,
                        height: 50,
                        child: RaisedButton(

                          textColor: Colors.white,
                          child: Text(loadingtext,
                          style: TextStyle(
                              fontFamily: 'CalibriBold',
                            fontSize: 18,
                          ),),
                          color: Colors.orange[700],
                          shape:RoundedRectangleBorder(
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
                            }else if(_selectedPricing=="-select product-"){
                              setState(() {
                                errortext="Select a product!";
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
                            }else if(months=="" || billnumber=="" || narration=="" ){
                              setState(() {
                                errortext="Fill in all the fields!";
                              });
                              Fluttertoast.showToast(
                                  msg: errortext,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM
                              );
                            }
                            else if(!isNumeric(months)){
                              setState(() {
                                errortext="Invalid month!";
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
                              BillPayment billpayment=BillPayment(amount: months.toString(),billno: billnumber,billpaymentid: 0,SessionId: randomstr,
                                  comments: narration,utilityname: "TELEVISION",utilitycompany: _selectedProvider,AccountNumber: _selectedCompany,
                                  MyAccountNumber: _selectedCompany);

                              Random random = new Random();
                              int randomNumber = random.nextInt(100000000);

                              String selectedpricing = _selectedPricing.substring(0, _selectedPricing.indexOf('-'));
                              String selectedviewtypes = _selectedViewTypes.substring(0, _selectedViewTypes.indexOf('-'));
                              String selectedaddons = _selectedAddon.substring(0, _selectedAddon.indexOf('-'));
                              if(_selectedProvider == "GOTV"){

                                amount = double.parse(selectedpricing) *  int.parse(months);
                                transactionData = TransactionData(dstvProduct: _selectedProvider,amount: amount.toString(),clientTransactionIdentifier: randomNumber.toString(),smartCardNumber: billnumber,paymentDetails: narration);
                                utilityTransaction = UtilityTransaction(accountNumber: _selectedCompany,username: username,sessionId: randomNumber.toString(),billPaymentApplicationName: tvProviderName,gotvTransactionData: transactionData,);

                              }else if(_selectedProvider == "DSTV"){

                                  amount = (double.parse(selectedpricing) * int.parse(months)) + (double.parse(selectedviewtypes) * int.parse(months)) + (double.parse(selectedaddons) * int.parse(months));

                                  dstvTransactionData = DstvTransactionData(dstvProduct: _selectedProvider,amount: amount.toString(),clientTransactionIdentifier: randomNumber.toString(),smartCardNumber: billnumber,paymentDetails: narration,months: months);
                                  utilityTransaction = UtilityTransaction(accountNumber: _selectedCompany,username: username,sessionId: randomNumber.toString(),billPaymentApplicationName: tvProviderName,dstvTransactionData: dstvTransactionData);





                              }
                              Member member=Member(billpayments: billpayment,OPERATION: "BILLPAYMENTS");
                              if(canclick){
                                setState(() {
                                  canclick=false;
                                });
                                //print("GET TV DATA");
                                //print(viewtypesModel.productPrice);

                                pay(utilityTransaction);
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

  Future<void> getProviders() async {
    print("GET");
    String username=await FlutterSession().get("USERNAME");
    String P=await FlutterSession().get("PASSWORD");
    Member member=Member(username: username,password: P,OPERATION: "Utility",utility: "TELEVISION",utilityname: "TELEVISION");

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

  Future<void> getPricing(String productName) async {

    print("GET");
    print(productName);
    String u=await FlutterSession().get("USERNAME");
    String P=await FlutterSession().get("PASSWORD");
    Member member=Member(username: u,password: P,OPERATION: "Utility",utility: "TELEVISION",utilityname: "TELEVISION");

    try{
      if(productName == "") {

      }else{
        newfetchPricing(productName, member, token: AuthToken).then((value) =>
        {
          polulatePricing(value.utilityPricing, value)
        });
      }
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
                      "Bill Number: " + billnumber,
                      style: Theme.of(context).textTheme.bodyText1),
                  Text(
                      "Amount: " +  amount.toString(),
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
                    payUtilityBill(utilityTransaction,token:AuthToken).then((value) => {
                      payresponse(value)
                    });
                    Navigator.of(context).pop();
                  }on Exception catch(_){
                    setState(() {
                      canclick=true;
                    });
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
    print("POPULATE Accounts");
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
            billnumber="";
            months="";
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

            _dropdownProviders = buildDropdownProviders(providerList);
          });
        }
      }
    }on Exception catch(_){
      print(_);
    }
  }

  void polulatePricing(UtilityPricing utilityPricing,UtilityPricingResponse utilityPricingResponse){
    print("POPULATE PRICING");
    try{
      print(utilityPricing.toString());
      if(utilityPricing!=null){
        if(utilityPricing.products!=null){
          setState(() {
            Pricing=utilityPricing.products;
            String dataencoded = jsonEncode(Pricing);
            pricingName = jsonDecode(dataencoded);

            for (var i = 0; i < Pricing.length; i++) {

              //pricingList.add(pricingName[i]['DESCRIPTION'] + " -MWK. " + pricingName[i]['ProductPrice'].toString() );

              productsModel = Products(iD:pricingName[i]['ID'],productcode: pricingName[i]['Productcode'],dESCRIPTION: pricingName[i]['DESCRIPTION'] ,productPrice: pricingName[i]['ProductPrice'],serviceproviderID: pricingName[i]['serviceproviderID']);

              pricingList.add(productsModel.dESCRIPTION + " -MWK. " + productsModel.productPrice.toString());


            }


            print("PRICING LIST");
            print(pricingName.runtimeType);


            _dropdownPricing = buildDropdownPricing(pricingName);
          });

        }
        if(utilityPricing.viewtypes!=null){
          setState(() {
            ViewTypes=utilityPricing.viewtypes;
            String dataencoded = jsonEncode(ViewTypes);
            viewTypesName = jsonDecode(dataencoded);

            for (var j = 0; j < ViewTypes.length; j++) {

              //viewtypesList.add(viewTypesName[i]['DESCRIPTION'] );
              viewtypesModel = Viewtypes(iD: viewTypesName[j]['ID'],productcode: viewTypesName[j]['productcode'],productPrice: viewTypesName[j]['ProductPrice'],dESCRIPTION: viewTypesName[j]['DESCRIPTION']);

              viewtypesList.add(viewtypesModel.dESCRIPTION + " -MWK. " + viewtypesModel.productPrice.toString() );
            }
            print("VIEW TYPES LIST");
            print(viewtypesList);



            _dropdownViewTypes = buildDropdownViewTypes(viewTypesName);
          });

        }
        if(utilityPricing.addons!=null){
          setState(() {
            Addons=utilityPricing.addons;
            String dataencoded = jsonEncode(Addons);
            addonName = jsonDecode(dataencoded);

            for (int i = 0; i < Addons.length; i++) {


              //addonList.add(addonName[i]['DESCRIPTION']+ " -MWK. " + addonName[i]['ProductPrice'].toString() );

              addonModel = AddonMode(iD: addonName[i]['ID'],productcode: addonName[i]['productcode'],dESCRIPTION: addonName[i]['DESCRIPTION'],productPrice: addonName[i]['ProductPrice']);

              addonList.add(addonModel.dESCRIPTION + " -MWK+ " + addonModel.productPrice.toString());
            }
            print("VIEW TYPES LIST");
            print(addonList);



            _dropdownAddon = buildDropdownAddon(addonName);
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
          child: Text("Choose TV Provider:"),
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
  List<DropdownMenuItem<String>> buildDropdownPricing(List options) {
    List<DropdownMenuItem<String>> items = List();
    items.add(
        DropdownMenuItem(
          value: "-select product-",
          child: Text("Select product-"),
        )
    );

      for (var i = 0; i < options.length; i++) {
        //adding a random number to each value so that it can be unique
        //this prevents throwing an error in case if finds similar values in the list
        //this is just a workaround,
        //error being evaded is
        //Either zero or 2 or more [DropdownMenuItem]s were detected
        //
        //
        //
        // with the same value I/flutter (18363): 'package:flutter/src/material/dropdown.dart':
        Random random = new Random();
        randomNumberDrop = random.nextInt(100000000);
        items.add(
          DropdownMenuItem(
            value: options[i]['ProductPrice'].toString()+"-"+randomNumberDrop.toString(),
          child: Text(options[i]['DESCRIPTION']+ " -MWK+ " + options[i]['ProductPrice'].toString()),
        ),
      );
    }
    return items;
  }
  List<DropdownMenuItem<String>> buildDropdownViewTypes(List options) {
    List<DropdownMenuItem<String>> items = List();
    items.add(
        DropdownMenuItem(
          value: "-select view type-",
          child: Text("select view type-"),
        )
    );
    for (var i = 0; i < options.length; i++) {
      //adding a random number to each value so that it can be unique
      //this prevents throwing an error in case if finds similar values in the list
      //this is just a workaround,
      //error being evaded is
          //Either zero or 2 or more [DropdownMenuItem]s were detected
          //
          //
          //
          // with the same value I/flutter (18363): 'package:flutter/src/material/dropdown.dart':
      Random random = new Random();
     randomNumberDrop = random.nextInt(100000000);
      items.add(
        DropdownMenuItem(
          value: options[i]['ProductPrice'].toString()+"-"+randomNumberDrop.toString(),
          child: Text(options[i]['DESCRIPTION']+ " -MWK+ " + options[i]['ProductPrice'].toString()),
        ),
      );
    }
    return items;
  }
  List<DropdownMenuItem<String>> buildDropdownAddon(List options) {
    List<DropdownMenuItem<String>> items = List();
    items.add(
        DropdownMenuItem(
          value: "-select addon-",
          child: Text("select addon-"),
        )
    );
    for (var i = 0; i < options.length; i++) {
      //adding a random number to each value so that it can be unique
      //this prevents throwing an error in case if finds similar values in the list
      //this is just a workaround,
      //error being evaded is
      //Either zero or 2 or more [DropdownMenuItem]s were detected
      //
      //
      //
      // with the same value I/flutter (18363): 'package:flutter/src/material/dropdown.dart':
      Random random = new Random();
      randomNumberDrop = random.nextInt(100000000);
      items.add(
        DropdownMenuItem(
          value: options[i]['ProductPrice'].toString()+"-"+randomNumberDrop.toString(),
          child: Text(options[i]['DESCRIPTION']+ " -MWK+ " + options[i]['ProductPrice'].toString()),
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

      _selectedPricing = null;
      _dropdownPricing.clear();
       pricingList.clear();

      _selectedViewTypes = null;
      _dropdownViewTypes.clear();
      viewtypesList.clear();

      _selectedAddon = null;
      _dropdownAddon.clear();
      addonList.clear();

      _selectedProvider = selectedProvider;


    });


    print(selectedProvider);
    if(selectedProvider!="-select provider-"){
      //ACTION

      if(selectedProvider == "GOTV"){

        tvProviderName ="GOTV.Transaction";


        //ACTION
      }else if(selectedProvider == "DSTV"){

        tvProviderName ="DSTV.Transaction";


        //ACTION
      }

      getPricing(tvProviderName);

    }





  }


  onChangeDropdownPricing(String selectedPricing) {
    setState(() {
      _selectedPricing = selectedPricing;
    });
    if(_selectedPricing!="-select product-"){
      //ACTION
    }
  }
  onChangeDropdownViewType(String selectedView) {
    setState(() {
      _selectedViewTypes = selectedView;
    });
    if(selectedView!="-select view type -"){
      //ACTION
    }
  }
  onChangeDropdownAddon(String selectedAddon) {
    setState(() {
      _selectedAddon = selectedAddon;
    });
    if(selectedAddon!="-select addon-"){
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
      margin: EdgeInsets.only(bottom: 10,left: 25,right: 25),
    );
  }

  Widget my_dropdown_providerss(BuildContext context){
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
                    hint: Text('-select provider-'),
                    value:_selectedProvider ,
                    onChanged: onChangeDropdownProvider,
                    items: _dropdownProviders,
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
                    isExpanded: true,
                  ),
                ),
              )
          )
        ],
      ),
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.only(bottom: 10,left: 25,right: 25),
    );
  }

  Widget my_dropdown_pricing(BuildContext context){
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
                    hint: Text('-select product-'),
                    value:  _selectedPricing,
                    onChanged: onChangeDropdownPricing,
                    items: _dropdownPricing,
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
                    isExpanded: true,
                  ),
                ),
              )
          )
        ],
      ),
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.only(bottom: 10,left: 25,right: 25),
    );
  }
  Widget my_dropdown_viewtype(BuildContext context){
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
                    hint: Text('-select view type -'),
                    value:  _selectedViewTypes,
                    onChanged: onChangeDropdownViewType,
                    items: _dropdownViewTypes,
                    icon: Container(
                      width: 30,

                      color: Colors.indigo[900],
                      child: new IconButton(
                          icon: new Icon(
                            Icons.arrow_drop_down_sharp,
                            color: Colors.white,),
                          onPressed: null),
                    ),
                    isExpanded: true,
                  ),
                ),
              )
          )
        ],
      ),
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.only(bottom: 10,left: 25,right: 25),
    );
  }
  Widget my_dropdown_addon(BuildContext context){
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
                    hint: Text('-select addon-'),
                    value:  _selectedAddon,
                    onChanged: onChangeDropdownAddon,
                    items: _dropdownAddon,
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
                    isExpanded: true,
                  ),
                ),
              )
          )
        ],
      ),
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.only(bottom: 10,left: 25,right: 25),
    );
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

}