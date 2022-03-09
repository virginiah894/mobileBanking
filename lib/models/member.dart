import 'package:cdh/models/billpayment.dart';
import 'package:cdh/models/chequebookrequest.dart';
import 'package:cdh/models/fundstransfer.dart';
import 'package:cdh/models/standingorder.dart';
import 'package:cdh/models/taxpayment.dart';
import 'package:cdh/models/wallet.dart';
import 'package:flutter/material.dart';
import 'changepassword.dart';
import 'ministatement.dart';
class Member{
  String username;
  String password;
  String utilityname;
  String OPERATION;
  String utility;
  bool isAppleTester;
  String AppleTester;

  ChangePassword changepassword;
  Ministatement ministatement;
  BillPayment billpayments;
  StandingOrder standingorder;
  ChequebookRequest chequebookrequest;
  FundsTransfer fundstransfer;
  TaxPayment taxpayments;
  Wallet wallet;

  //Member({this.username, this.password, this.OPERATION});
  Member({this.username, this.password,this.isAppleTester,this.AppleTester, this.OPERATION,this.changepassword,this.ministatement,this.utility,
    this.utilityname,this.billpayments,this.standingorder,this.chequebookrequest,this.fundstransfer,this.taxpayments,this.wallet});

  factory Member.fromJson(Map<String, dynamic> responseData) {
    return Member(
        username: responseData['username'],
        password: responseData['password'],
        AppleTester: responseData['AppleTester'],
        OPERATION: responseData['OPERATION'],
        isAppleTester: responseData['isAppleTester'],
        ministatement: responseData['ministatement'],
        utilityname: responseData['utilityname'],
        utility: responseData['utility'],
        billpayments: responseData['billpayments'],
        chequebookrequest: responseData['chequebookrequest'],
        standingorder: responseData['standingorder'],
        taxpayments: responseData['taxpayments'],
        fundstransfer: responseData['fundstransfer'],
        wallet: responseData['wallet'],
    );
  }

  Map<String, dynamic> toJson() => {
    "username": this.username,
    "password": this.password,
    "OPERATION": this.OPERATION,
    "isAppleTester": this.isAppleTester,
    "utilityname": this.utilityname,
    "AppleTester": this.AppleTester,
    "utility": this.utility,
    "changepassword": this.changepassword != null ? this.changepassword.toJson() : null,
    "billpayments": this.billpayments != null ? this.billpayments.toJson() : null,
    "standingorder": this.standingorder != null ? this.standingorder.toJson() : null,
    "chequebookrequest": this.chequebookrequest != null ? this.chequebookrequest.toJson() : null,
    "fundstransfer": this.fundstransfer != null ? this.fundstransfer.toJson() : null,
    "taxpayments": this.taxpayments != null ? this.taxpayments.toJson() : null,
    "ministatement": this.ministatement != null ? this.ministatement.toJson() : null,
    "ministatement": this.ministatement != null ? this.ministatement.toJson() : null,
    "wallet": this.wallet != null ? this.wallet.toJson() : null,
  };
}