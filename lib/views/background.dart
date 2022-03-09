
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  const Background({key}) : super(key: key);

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    return  new Scaffold(
      body:Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              image: new DecorationImage(
                fit: BoxFit.cover,
                image: new AssetImage(
                    'images/Background-images-1.png'),
              ),

            ),


            margin: EdgeInsets.only(
                left: 25, right: 25, top: 05, bottom: 10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment
                          .center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              left:150),
                          child: Icon(
                            Icons.account_balance_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child:Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(),
                          child: Text("Account",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Calibri'
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 10),
                          child: Text('Helooooo',
                            style: TextStyle(
                              fontWeight: FontWeight
                                  .bold,
                              color: Colors.white,
                              fontFamily: 'CalibriRegular',
                              fontSize: 22,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: FractionalOffset
                                .center,
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .center,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: <Widget>[
                                  Text("Available Balance ",
                                    style: TextStyle(
                                      // fontWeight: FontWeight
                                      //     .bold,
                                        color: Colors.white,
                                        fontFamily: 'Calibri',
                                        fontSize: 18
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width:MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                top: 4, bottom: 6),
                            alignment: FractionalOffset
                                .center,
                            child: Center(

                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 4,
                          bottom: 4,
                          left: 5,
                          right: 5),
                      alignment: FractionalOffset.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly,
                        children: <Widget>[
                          // Expanded(
                          //   flex: 6,
                          //   child: Container(
                          //     margin: EdgeInsets.only(right: 1),
                          //     child: RaisedButton(
                          //       onPressed: () {
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) =>
                          //               // BalanceScreen()
                          //               AccountInfoScreen()
                          //           ),
                          //         );
                          //       },
                          //       textColor: Colors
                          //           .indigo[900],
                          //       color: Colors.white,
                          //       // child: Text("BALANCE ENQUIRY",
                          //       child: Text("ACCOUNT INFO",
                          //         style: TextStyle(
                          //             fontWeight: FontWeight
                          //                 .bold,
                          //             color: Colors
                          //                 .indigo[900],
                          //             fontFamily: 'CalibriBold'
                          //         ),),
                          //     ),
                          //   ),
                          // )
                        ],
                        crossAxisAlignment: CrossAxisAlignment
                            .center,
                      ),
                    ),
                  )
                ],
              ),
            ),
            //color: Colors.blue,

          ),
        ],
      ) ,

    );
  }
}
