import 'package:cdh/models/appletestervalues.dart';
import 'package:cdh/models/member.dart';
import 'package:cdh/models/response.dart';
import 'package:cdh/views/home.dart';
import 'package:cdh/views/security.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cdh/service/requests.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {

  String username="";
  String password="";
  bool isloggedin=false;
  bool loading=false;
  bool canclick=true;
  String loadingtext="Login";
  String errortext="";
  LoginResponse loginResponse;
  int logincode=0;
  var session = FlutterSession();
  TextEditingController _usernamecontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loadingtext="Login";
      errortext="";
      loginResponse=null;
      logincode=0;
      canclick=true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,

        body: Stack(

          children: <Widget>[

            Image(
              image: AssetImage("images/Background-images-0.png"),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            Column(

              children: [
SizedBox(height: 20,),

                Center(
                  child: Image(
                    image: AssetImage("images/cdhlogo.png"),
                    width: 200,

                  ),
                ),

                Spacer(),
                Padding(
                    padding: EdgeInsets.all(5),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: TextField(
                          controller: _usernamecontroller,
                          style:TextStyle(
                            fontSize: 20,
                          ) ,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(1),
                            border: UnderlineInputBorder(
                            ),
                            labelText: ' Enter Username',
                            hintText: 'Enter username',
                            suffixIcon: new Icon(FontAwesomeIcons.solidUser,
                              color: Colors.grey[700],
                              size: 20,),
                          ),
                          onChanged: (text){
                            setState(() {
                              username=text;
                            });
                          },
                        ),
                        padding: EdgeInsets.all(5),
                      ),

                      Container(
                        child: TextField(
                          controller: _passwordcontroller,
                          style:TextStyle(
                            fontSize: 20,
                          ) ,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: ' Enter Password',
                            hintText: 'Enter Password',


                            suffixIcon: new Icon(

                              Icons.lock_outline_rounded,
                              //
                              size: 30,
                            color: Colors.grey[700],),

                          ),
                          onChanged: (text){
                            setState(() {
                              password=text;
                            });
                          },
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        child: SizedBox(
                          width: 220,
                          height: 50,
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
                                borderRadius:BorderRadius.circular(12)
                            ),

                            onPressed: (){
                              if(username=="" || password==""){
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
                                String appletester="";
                                bool isappletester=false;
                                if(TesterValues.isAppleTester){
                                  if(username==TesterValues.AppleTester){
                                    appletester=username;
                                    isappletester=true;
                                  }
                                }

                                Member member=Member(username: username,password: password,OPERATION: "LOGIN",isAppleTester: isappletester,
                                  AppleTester: appletester
                                );
                                try {
                                  if(canclick){
                                    setState(() {
                                      canclick=false;
                                    });
                                    if(username=="appletester" && password=="pass"){
                                      setState(() {
                                        canclick=true;
                                      });

                                      updateValuesTime();

                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) => HomeScreen()),
                                      // );
                                    }
                                    Future<LoginResponse> loginResponse=login(member);
                                    print(loginResponse);
                                    LoginResponse l;
                                    var order = loginResponse.then((value) => {
                                      updateValues(value.code,value.Status,"Login successful!",value)
                                    });
                                  }
                                } on Exception catch (_) {
                                  updateError();
                                  print('never reached');
                                }
                              }
                            },
                          ),
                        ),
                        padding: EdgeInsets.all(5),
                      )
                    ],
                  ),
                ),

                Container(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: MaterialButton(
                      onPressed: () => {},
                      child: Text('copyright @ 2021 CDH Investment Bank Limited' ,
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

    );
  }

  Future<void> updateValues(int code,bool isloggedin,String message,LoginResponse loginResponse,{String AuthToken=""}) async {
    setState(() {
      canclick=true;
    });
    try{
      try{
        //print("AUTH TOKEN A: "+loginResponse.token);
      }on Exception catch(_){}
      print(loginResponse.IsAppleTester);
      print(loginResponse.toJson());
      setState(() {
        logincode=code;
        loadingtext="Login";
        errortext="";
        _usernamecontroller.text="";
        _passwordcontroller.text="";
      });

      if(loginResponse!=null){
        setState(() {
          canclick=true;
        });
        if(loginResponse.Status){
          print("Username: "+username);
          print("Password: "+password);

          await session.set("USERNAME", username);
          await session.set("PASSWORD", password);
          var loginTime = DateTime.now();
          try{
            await session.set("AUTHTOKEN", loginResponse.token);
            final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
            final String formattedDate = formatter.format(loginTime);
            await session.set("LOGINTIME", formattedDate);
            await session.set("DISPLAYLOGINTIME", formattedDate);
            print("AUTH AUTHTOKEN: "+loginResponse.token);
          }on Exception catch(_){
            print("AUTH EXC: "+_.toString());
          }
          setState(() {
            username="";
            password="";
          });
          if(loginResponse.IsAppleTester){
            setState(() {
              canclick=true;
            });
            Navigator.push(
              context,
              // MaterialPageRoute(builder: (context) => HomeScreen(selectedFragment: 0)),
                MaterialPageRoute(builder: (context) => SecurityScreen())
            );
          }else{
            setState(() {
              canclick=true;
            });
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecurityScreen())
            );
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

      /*if(isloggedin){
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM
        );



        print("UsernameStored: "+(await session.get("USERNAME")));
        
        // STORE OBJECTS IN SESSION (MUST HAVE toJson() METHOD)
        // Data mappedData = Data(id: 1, data: "Lorem ipsum something, something...");
        // await FlutterSession().set('mappedData', mappedData);

      }else{
        Fluttertoast.showToast(
            msg: "Invalid credentials! Try again.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM
        );
      }*/
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


  Future<void> updateValuesTime() async {
    setState(() {
      canclick=true;
    });
    try{
      setState(() {
        loadingtext="Login";
        errortext="";
        _usernamecontroller.text="";
        _passwordcontroller.text="";
      });

      await session.set("USERNAME", username);
      await session.set("PASSWORD", password);
      var loginTime = DateTime.now();
      try{
        final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
        final String formattedDate = formatter.format(loginTime);
        await session.set("LOGINTIME", formattedDate);
      }on Exception catch(_){
        print("AUTH EXC: "+_.toString());
      }
      setState(() {
        username="";
        password="";
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(selectedFragment: 0)),
      );
    }on Exception catch(_){

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

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Added to favourite'),
        action: SnackBarAction(
          label: 'Close',
          onPressed:scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }

}