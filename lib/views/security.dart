import 'package:cdh/models/member.dart';
import 'package:cdh/models/response.dart';
import 'package:cdh/views/forcechangepassword.dart';
import 'package:cdh/views/home.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'login.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:pinput/pin_put/pin_put_state.dart';

class SecurityScreen extends StatefulWidget{
  @override
  _SecurityScreen createState() => _SecurityScreen();
}

class _SecurityScreen extends State<SecurityScreen> {

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: const Color.fromARGB(255, 33, 29, 112)),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  String username="";
  String password="";
  String AuthToken="";
  String otp="";
  bool isloggedin=false;
  bool loading=false;
  bool canclick=true;
  String loadingtext="Login";
  String errortext="";
  LoginResponse loginResponse;
  int logincode=0;
  TextEditingController _usernamecontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

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
    // TODO: implement initState
    super.initState();
    //username = await FlutterSession().get("USERNAME");
    //password = await FlutterSession().get("PASSWORD");
    setState(() {
      loadingtext="Login";
      errortext="";
      loginResponse=null;
      logincode=0;
      otp="";
      username="";
      AuthToken="";
      canclick=true;
       getLoginTime();
      getUserSessionData();
    });
     getLoginTime();
    getUserSessionData();
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
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage("images/Background-images-0.png"),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          ListView(
            children: <Widget>[
              SizedBox(height: 30,),
              Center(
                child: Image(
                  image: AssetImage("images/cdhlogo.png"),
                  width: 200,
                ),
              ),
              SizedBox(height: 40,),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 50,right: 30,left: 30),
                          child: Text(" Enter your One Time Password",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: 20,
                                  fontFamily: 'CalibriBold'
                              )
                          ),
                        )
                    ),

                    Container(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(

                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.all(15.0),
                                child: PinPut(

                                  fieldsCount: 6,
                                  onSubmit: (String pin) => _showSnackBar(pin, context),
                                  focusNode: _pinPutFocusNode,
                                  controller: _pinPutController,
                                  submittedFieldDecoration: _pinPutDecoration.copyWith(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  selectedFieldDecoration: _pinPutDecoration,
                                  followingFieldDecoration: _pinPutDecoration.copyWith(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                      color: Colors.black54.withOpacity(.5),
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //   children: <Widget>[
                              //     FlatButton(
                              //       onPressed: () => _pinPutFocusNode.requestFocus(),
                              //       child: const Text('Focus'),
                              //     ),
                              //     FlatButton(
                              //       onPressed: () => _pinPutFocusNode.unfocus(),
                              //       child: const Text('Unfocus'),
                              //     ),
                              //     FlatButton(
                              //       onPressed: () => _pinPutController.text = '',
                              //       child: const Text('Clear All'),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 60),
                    ),
                    // SizedBox(height: 20,),

                    // Container(
                    //
                    //   child: SizedBox(
                    //     width: 220,
                    //     height: 60,
                    //     child: RaisedButton(
                    //       textColor: Colors.white,
                    //       child: Text(loadingtext,
                    //       style: TextStyle(
                    //           fontFamily: 'CalibriBold',
                    //         fontSize: 24,
                    //       ),),
                    //       color: Colors.orange[700],
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius:BorderRadius.circular(12)
                    //       ),
                    //       onPressed: (){
                    //
                    //
                    //       },
                    //     ),
                    //   ),
                    //   padding: EdgeInsets.all(10),
                    // ),

                  ],
                ),
              ),




            ],

          ),

          Container(
            margin: EdgeInsets.only(top:20,bottom: 40),
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
    );
  }

  Future<void> getUserSessionData() async {
    print("UsernameStoredSec: "+(await session.get("USERNAME")));
    String u=await FlutterSession().get("USERNAME");
    String p=await FlutterSession().get("PASSWORD");
    try{
      String at=await FlutterSession().get("AUTHTOKEN");
      print("AUTH TOKEN: "+at);
      setState(() {
        AuthToken=at;
      });
    }on Exception catch(_){

    }
    setState(() {
    username=u;
       password=p;
     });
  }

  void updateValues(int code,bool isloggedin,String message,LoginResponse loginResponse)  {
    setState(() {
      canclick=true;
    });
    try{
      print("Security Response");
      print(loginResponse);
      setState(() {
        logincode=code;
        loadingtext="Login";
        errortext="";

        _usernamecontroller.text="";
        _passwordcontroller.text="";
        _pinPutController.text="";
      });

      if(isloggedin){
        setState(() {
          canclick=true;
        });
        if(code==25){
          setState(() {
            canclick=true;
          });
          Fluttertoast.showToast(
              msg: "You must change your password!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForceChangePasswordScreen()),
          );
        }else{
          setState(() {
            canclick=true;
          });
          Fluttertoast.showToast(
              msg: "Success!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(selectedFragment:0)),
          );

          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //     builder: (BuildContext context) => HomeScreen(selectedFragment:_selectedIndex),
          //   ),
          //       (route) => false,
          // );
        }
      }else{
        setState(() {
          canclick=true;
        });
        Fluttertoast.showToast(
            msg: "Invalid credentials! Try again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM
        );
      }
    }on Exception catch(_){
      setState(() {
        canclick=true;
      });
      setState(() {
        logincode=code;
        loadingtext="Login";
        errortext="";
      });
    }

    print("Update");
  }

  void updateError(){
    setState(() {
      canclick=true;
    });
    setState(() {
      logincode=0;
      loadingtext="Login";
      errortext="";
    });
    Fluttertoast.showToast(
        msg: "Network failure!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM
    );
  }

  void _showSnackBar(String pin, BuildContext context) {
    //username="cchimpweya";
    setState(() {
      otp=pin;
    });
    // Fluttertoast.showToast(
    //     msg: "Enter the OTP! "+otp,
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.BOTTOM
    // );
    print("Username:-"+username);
    print("otp:-"+otp);
    if(username==null){
      Navigator.pop(context);
    }
    if(username==""){
      Navigator.pop(context);
    }
    if(otp==""){
      Fluttertoast.showToast(
          msg: "Enter the OTP!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM
      );
    }else {
      Member member=Member(username: username,password: otp,OPERATION: "SECURITYCODE");
      try{
        print(member.toJson());
      }on Exception catch(_){

      }
      /*Fluttertoast.showToast(
                                  msg: "Success!",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => HomeScreen()),
                              );*/
      //COMMENTED FOR APPLE TEST
      try {
        if(canclick){
          setState(() {
            canclick=false;
          });
          Future<LoginResponse> loginResponse=security(member,token:AuthToken);
          print(loginResponse);
          LoginResponse l;
          var order = loginResponse.then((value) => {
            updateValues(value.code,value.Status,"Success!",value)
          });
        }
      } on Exception catch (_) {
        updateError();
        print('never reached');
      }
    }


    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Container(
        height: 80.0,
        child: Center(
          child: Text(
            'Pin Submitted. Value: $pin',
            style: const TextStyle(fontSize: 25.0),
          ),
        ),
      ),
      backgroundColor: Colors.black54,
    );
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}