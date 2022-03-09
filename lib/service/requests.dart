import 'dart:async';
import 'dart:convert';
import 'package:cdh/models/member.dart';
import 'package:cdh/models/response.dart';
import 'package:cdh/models/utilitypricingresponse.dart';
import 'package:cdh/models/utilitytransaction.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'AppUrl.dart';

final _base = "https://home-hub-app.herokuapp.com";
final _tokenEndpoint = "/api-token-auth/";
final _tokenURL = _base + _tokenEndpoint;
//TEST URLS
final String  _url=AppUrl.api_url_test;
final String  _login_url=AppUrl.api_url_test_login;
final String  _token_url=AppUrl.api_url_test_token;
final String  _billPaymentUrl = AppUrl.api_test_utilityBillType;
final String _utilities = AppUrl.api_test_utilities;
final String _utilityTransactions = AppUrl.api_test_utilityTransactions;
final String _utilityPricing = AppUrl.api_test_utilityPricing;
//LIVE URLS
// final String  _url=AppUrl.api_url_live;
// final String  _login_url=AppUrl.api_url_live_login;
// final String  _token_url=AppUrl.api_url_live_token;
// final String  _billPaymentUrl = AppUrl.api_live_utilityBillType;
// final String _utilities = AppUrl.api_live_utilities;
// final String _utilityTransactions = AppUrl.api_live_utilityTransactions;
// final String _utilityPricing = AppUrl.api_live_utilityPricing;
//FINTECH URLS
// final String  _url=AppUrl.api_url_fintech;
// final String  _login_url=AppUrl.api_url_fintech_login;
// final String  _token_url=AppUrl.api_url_fintech_token;
var session = FlutterSession();

Future<LoginResponse> login(Member userLogin,{String token=""}) async {
  print(_login_url);
  try
  {
    final http.Response response = await http.post(
      _login_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(userLogin.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return LoginResponse(Status: false,Description: "Login failed! Invalid credentials.");
        }else{
          print("ABCD");
          return LoginResponse.fromJson(json.decode(response.body));
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return LoginResponse.fromJson(json.decode(response.body));
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return LoginResponse(Status: false,Description: "Login failed! Invalid credentials.");
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return LoginResponse(Status: false,Description: "Failed! Network error.");
    }
  }on TimeoutException catch(_){
    print(_);
    return LoginResponse(Status: false,Description: "Failed! Network error.");
  }
}

Future<LoginResponse> getToken(Member userLogin,{String token=""}) async {
  print(_login_url);
  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return LoginResponse(Status: false,Description: "Login failed! Invalid credentials.");
        }else{
          print("ABCD: "+loginResponse.token);
          return LoginResponse.fromJson(json.decode(response.body));
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return LoginResponse.fromJson(json.decode(response.body));
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return LoginResponse(Status: false,Description: "Login failed! Invalid credentials.");
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return LoginResponse(Status: false,Description: "Failed! Network error.");
    }
  }on TimeoutException catch(_){
    print(_);
    return LoginResponse(Status: false,Description: "Failed! Network error.");
  }
}

Future<LoginResponse> _security(Member userLogin,{String token=""}) async {
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
  }on Exception catch(_){

  }
  print("SEC: "+token);
  final http.Response response = await http.post(
    _url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
      //'Authorization': 'Bearer hgvjbhvbjdfbvjdfkv.ghfvedfvuvecvueqv.346gfu3gvfuqevcu'
    },
    body: jsonEncode(userLogin.toJson()),
  );
  if (response.statusCode == 200) {
    print(json.decode(response.body).toString());
    print("200");
    return LoginResponse.fromJson(json.decode(response.body));
  } else {
    print("NOT 200");
    try{
      print(json.decode(response.body).toString());
      //throw Exception(json.decode(response.body));
      print(json.decode(response.body));
    }on Exception catch(_){

    }
    return LoginResponse(Status: false,Description: "Failed! Network error.");
  }
}

Future<LoginResponse> security(Member userLogin,{String token=""}) async {
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
  }on Exception catch(_){

  }
  print("SEC: "+token);
  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");

    Member member=Member(username: u,password: p,OPERATION: "LOGIN");

    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
        }else{
          print("ABCD: "+loginResponse.token);
          token=loginResponse.token;
          //return LoginResponse.fromJson(json.decode(response.body));
          final http.Response response = await http.post(
            _url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
              //'Authorization': 'Bearer hgvjbhvbjdfbvjdfkv.ghfvedfvuvecvueqv.346gfu3gvfuqevcu'
            },
            body: jsonEncode(userLogin.toJson()),
          );
          if (response.statusCode == 200) {
            print(json.decode(response.body).toString());
            print("200");
            return LoginResponse.fromJson(json.decode(response.body));
          } else {
            print("NOT 200");
            try{
              print(json.decode(response.body).toString());
              //throw Exception(json.decode(response.body));
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return LoginResponse(Status: false,Description: "Failed! Network error.");
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
    }
  }on TimeoutException catch(_){
    print(_);
  }
}

Future<AccountResponse> _fetchAccount(Member userLogin,{String token=""}) async {
  print("TKN: "+await session.get("AUTHTOKEN"));
  try{
    userLogin.username=await session.get("USERNAME");
    token=await session.get("AUTHTOKEN");
    print(userLogin.toJson());
  }on Exception catch(_){

  }
  final http.Response response = await http.post(
    _url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(userLogin.toJson()),
  );
  if (response.statusCode == 200) {
    print(json.decode(response.body).toString());
    return AccountResponse.fromJson(json.decode(response.body));
  } else {
    try{
      print(json.decode(response.body).toString());
      print(json.decode(response.body));
    }on Exception catch(_){

    }
    return AccountResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
  }
}

Future<AccountResponse> fetchAccount(Member userLogin,{String token=""}) async {
  print("TKN A: "+await session.get("AUTHTOKEN"));
  try{
    userLogin.username=await session.get("USERNAME");
    token=await session.get("AUTHTOKEN");
    print(userLogin.toJson());
  }on Exception catch(_){

  }
  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return AccountResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
        }else{
          print("ABCD BB: "+loginResponse.token);
          token=loginResponse.token;
          final http.Response response = await http.post(
            _url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(userLogin.toJson()),
          );
          if (response.statusCode == 200) {
            print(json.decode(response.body).toString());
            return AccountResponse.fromJson(json.decode(response.body));
          } else {
            try{
              print(json.decode(response.body).toString());
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return AccountResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return AccountResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return AccountResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return AccountResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
    }
  }on TimeoutException catch(_){
    print(_);
    return AccountResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
  }
}

Future<BalanceResponse> _fetchBalance(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  final http.Response response = await http.post(
    _url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(userLogin.toJson()),
  );
  if (response.statusCode == 200) {
    print(json.decode(response.body).toString());
    return BalanceResponse.fromJson(json.decode(response.body));
  } else {
    try{
      print(json.decode(response.body).toString());
      print(json.decode(response.body));
    }on Exception catch(_){

    }
    return BalanceResponse(Status: false,Description: "Failed! Network error.");
  }
}

Future<BalanceResponse> fetchBalance(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return BalanceResponse(Status: false,Description: "Failed! Network error.");
        }else{
          print("ABCD: "+loginResponse.token);
          token=loginResponse.token;
          final http.Response response = await http.post(
            _url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(userLogin.toJson()),
          );
          if (response.statusCode == 200) {
            print(json.decode(response.body).toString());
            return BalanceResponse.fromJson(json.decode(response.body));
          } else {
            try{
              print(json.decode(response.body).toString());
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return BalanceResponse(Status: false,Description: "Failed! Network error.");
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return BalanceResponse(Status: false,Description: "Failed! Network error.");
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return BalanceResponse(Status: false,Description: "Failed! Network error.");
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return BalanceResponse(Status: false,Description: "Failed! Network error.");
    }
  }on TimeoutException catch(_){
    print(_);
    return BalanceResponse(Status: false,Description: "Failed! Network error.");
  }
}

Future<MinistatementResponse> _fetchMinistatement(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  final http.Response response = await http.post(
    _url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(userLogin.toJson()),
  );
  if (response.statusCode == 200) {
    print(json.decode(response.body).toString());
    return MinistatementResponse.fromJson(json.decode(response.body));
  } else {
    try{
      print(json.decode(response.body).toString());
      print(json.decode(response.body));
    }on Exception catch(_){

    }
    return MinistatementResponse(Status: false,Description: "Failed! Network error.");
  }
}

Future<MinistatementResponse> fetchMinistatement(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return MinistatementResponse(Status: false,Description: "Failed! Network error.");
        }else{
          print("ABCD: "+loginResponse.token);
          token=loginResponse.token;
          final http.Response response = await http.post(
            _url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(userLogin.toJson()),
          );
          if (response.statusCode == 200) {
            print(json.decode(response.body).toString());
            return MinistatementResponse.fromJson(json.decode(response.body));
          } else {
            try{
              print(json.decode(response.body).toString());
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return MinistatementResponse(Status: false,Description: "Failed! Network error.");
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return MinistatementResponse(Status: false,Description: "Failed! Network error.");
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return MinistatementResponse(Status: false,Description: "Failed! Network error.");
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return MinistatementResponse(Status: false,Description: "Failed! Network error.");
    }
  }on TimeoutException catch(_){
    print(_);
    return MinistatementResponse(Status: false,Description: "Failed! Network error.");
  }
}

Future<UtilityProvidersResponse> _fetchProviders(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  final http.Response response = await http.post(
    _url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(userLogin.toJson()),
  );
  if (response.statusCode == 200) {
    print(json.decode(response.body).toString());
    return UtilityProvidersResponse.fromJson(json.decode(response.body));
  } else {
    try{
      print(json.decode(response.body).toString());
      print(json.decode(response.body));
    }on Exception catch(_){

    }
    return UtilityProvidersResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
  }
}

Future<UtilityProvidersResponse> fetchProviders(Member userLogin,{String token=""}) async {
  print(_url);
  String electricity = "ELECTRICITY";
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return UtilityProvidersResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
        }else{
          print("ABCD: "+loginResponse.token);
          token=loginResponse.token;
          final http.Response response = await http.post(
            _url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(userLogin.toJson()),
          );
          if (response.statusCode == 200) {
            print("UTILITIES RESPONSE : ");
            print(json.decode(response.body).toString());
            print(json.decode(response.body).toString());
            return UtilityProvidersResponse.fromJson(json.decode(response.body));
          } else {
            try{
              print(json.decode(response.body).toString());
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return UtilityProvidersResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return UtilityProvidersResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return UtilityProvidersResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return UtilityProvidersResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
    }
  }on TimeoutException catch(_){
    print(_);
    return UtilityProvidersResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
  }
}

Future<newUtilityProvidersResponse> newfetchProviders(String Operation,Member userLogin,{String token=""}) async {
  print(_url);

  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return newUtilityProvidersResponse();
        }else{
          print("ABCD: "+loginResponse.token);
          token=loginResponse.token;
          final http.Response response = await http.post(
            _utilities,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(Operation),
          );
          if (response.statusCode == 200) {
            print("UTILITIES RESPONSE : ");
            print(json.decode(response.body).toString());

            return newUtilityProvidersResponse.fromJson(json.decode(response.body));
          } else {
            try{
              print(json.decode(response.body).toString());
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return newUtilityProvidersResponse();
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return newUtilityProvidersResponse();
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return newUtilityProvidersResponse();
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return newUtilityProvidersResponse();
    }
  }on TimeoutException catch(_){
    print(_);
    return newUtilityProvidersResponse();
  }
}

Future<UtilityPricingResponse> newfetchPricing(String Operation,Member userLogin,{String token=""}) async {
  print("GET PRODUCT");
  print(Operation);

  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return UtilityPricingResponse();
        }else{
          print("ABCD: "+loginResponse.token);
          token=loginResponse.token;
          final http.Response response = await http.post(
            _utilityPricing,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(Operation),
          );
          if (response.statusCode == 200) {
            print("PRODUCT RESPONSE : ");
            print(json.decode(response.body).toString());

            return UtilityPricingResponse.fromJson(json.decode(response.body));
          } else {
            try{
              print(json.decode(response.body).toString());
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return UtilityPricingResponse();
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return UtilityPricingResponse();
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return UtilityPricingResponse();
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return UtilityPricingResponse();
    }
  }on TimeoutException catch(_){
    print(_);
    return UtilityPricingResponse();
  }
}

Future<BanksResponse> _fetchBanks(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  final http.Response response = await http.post(
    _url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(userLogin.toJson()),
  );
  if (response.statusCode == 200) {
    print(json.decode(response.body).toString());
    return BanksResponse.fromJson(json.decode(response.body));
  } else {
    try{
      print(json.decode(response.body).toString());
      print(json.decode(response.body));
    }on Exception catch(_){

    }
    return BanksResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
  }
}

Future<BanksResponse> fetchBanks(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return BanksResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
        }else{
          print("ABCD: "+loginResponse.token);
          token=loginResponse.token;
          final http.Response response = await http.post(
            _url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(userLogin.toJson()),
          );
          if (response.statusCode == 200) {
            print(json.decode(response.body).toString());
            return BanksResponse.fromJson(json.decode(response.body));
          } else {
            try{
              print(json.decode(response.body).toString());
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return BanksResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return BanksResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return BanksResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return BanksResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
    }
  }on TimeoutException catch(_){
    print(_);
    return BanksResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
  }
}

Future<ColletionPointsResponse> _fetchCollectionPoints(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  final http.Response response = await http.post(
    _url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(userLogin.toJson()),
  );
  if (response.statusCode == 200) {
    print(json.decode(response.body).toString());
    return ColletionPointsResponse.fromJson(json.decode(response.body));
  } else {
    try{
      print(json.decode(response.body).toString());
      print(json.decode(response.body));
    }on Exception catch(_){

    }
    return ColletionPointsResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
  }
}

Future<ColletionPointsResponse> fetchCollectionPoints(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return ColletionPointsResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
        }else{
          print("ABCD: "+loginResponse.token);
          token=loginResponse.token;
          final http.Response response = await http.post(
            _url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(userLogin.toJson()),
          );
          if (response.statusCode == 200) {
            print(json.decode(response.body).toString());
            return ColletionPointsResponse.fromJson(json.decode(response.body));
          } else {
            try{
              print(json.decode(response.body).toString());
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return ColletionPointsResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return ColletionPointsResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return ColletionPointsResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return ColletionPointsResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
    }
  }on TimeoutException catch(_){
    print(_);
    return ColletionPointsResponse(Status: false,Description: "Failed! Network error.",Accounts: []);
  }
}

Future<StandingOrderResponse> _requestStandingOrder(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  final http.Response response = await http.post(
    _url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(userLogin.toJson()),
  );
  if (response.statusCode == 200) {
    print(json.decode(response.body).toString());
    return StandingOrderResponse.fromJson(json.decode(response.body));
  } else {
    try{
      print(json.decode(response.body).toString());
      print(json.decode(response.body));
    }on Exception catch(_){

    }
    return StandingOrderResponse(Status: false,Description: "Failed! Network error.");
  }
}

Future<StandingOrderResponse> requestStandingOrder(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return StandingOrderResponse(Status: false,Description: "Failed! Network error.");
        }else{
          print("ABCD: "+loginResponse.token);
          token=loginResponse.token;
          final http.Response response = await http.post(
            _url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(userLogin.toJson()),
          );
          if (response.statusCode == 200) {
            print(json.decode(response.body).toString());
            return StandingOrderResponse.fromJson(json.decode(response.body));
          } else {
            try{
              print(json.decode(response.body).toString());
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return StandingOrderResponse(Status: false,Description: "Failed! Network error.");
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return StandingOrderResponse(Status: false,Description: "Failed! Network error.");
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return StandingOrderResponse(Status: false,Description: "Failed! Network error.");
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return StandingOrderResponse(Status: false,Description: "Failed! Network error.");
    }
  }on TimeoutException catch(_){
    print(_);
    return StandingOrderResponse(Status: false,Description: "Failed! Network error.");
  }
}

Future<ChequeBookResponse> _requestChequeBook(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  final http.Response response = await http.post(
    _url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(userLogin.toJson()),
  );
  if (response.statusCode == 200) {
    print(json.decode(response.body).toString());
    return ChequeBookResponse.fromJson(json.decode(response.body));
  } else {
    try{
      print(json.decode(response.body).toString());
      print(json.decode(response.body));
    }on Exception catch(_){

    }
    return ChequeBookResponse(Status: false,Description: "Failed! Network error.");
  }
}

Future<ChequeBookResponse> requestChequeBook(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return ChequeBookResponse(Status: false,Description: "Failed! Network error.");
        }else{
          print("ABCD: "+loginResponse.token);
          token=loginResponse.token;
          final http.Response response = await http.post(
            _url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(userLogin.toJson()),
          );
          if (response.statusCode == 200) {
            print(json.decode(response.body).toString());
            return ChequeBookResponse.fromJson(json.decode(response.body));
          } else {
            try{
              print(json.decode(response.body).toString());
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return ChequeBookResponse(Status: false,Description: "Failed! Network error.");
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return ChequeBookResponse(Status: false,Description: "Failed! Network error.");
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return ChequeBookResponse(Status: false,Description: "Failed! Network error.");
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return ChequeBookResponse(Status: false,Description: "Failed! Network error.");
    }
  }on TimeoutException catch(_){
    print(_);
    return ChequeBookResponse(Status: false,Description: "Failed! Network error.");
  }
}

Future<BillpaymentResponse> _payBill(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  final http.Response response = await http.post(
    _url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(userLogin.toJson()),
  );
  if (response.statusCode == 200) {
    print("200");
    print(json.decode(response.body).toString());
    return BillpaymentResponse.fromJson(json.decode(response.body));
  } else {
    print("!=200");
    try{
      print(json.decode(response.body).toString());
      print(json.decode(response.body));
    }on Exception catch(_){

    }
    return BillpaymentResponse(Status: false,Description: "Failed! Network error.");
  }
}

Future<BillpaymentResponse> payBill(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return BillpaymentResponse(Status: false,Description: "Failed! Network error.");
        }else{
          print("ABCD: "+loginResponse.token);
          token=loginResponse.token;
          final http.Response response = await http.post(
            _utilityTransactions,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(userLogin.toJson()),
          );
          if (response.statusCode == 200) {
            print("200");
            print(json.decode(response.body).toString());
            return BillpaymentResponse.fromJson(json.decode(response.body));
          } else {
            print("!=200");
            try{
              print(json.decode(response.body).toString());
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return BillpaymentResponse(Status: false,Description: "Failed! Network error.");
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return BillpaymentResponse(Status: false,Description: "Failed! Network error.");
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return BillpaymentResponse(Status: false,Description: "Failed! Network error.");
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return BillpaymentResponse(Status: false,Description: "Failed! Network error.");
    }
  }on TimeoutException catch(_){
    print(_);
    return BillpaymentResponse(Status: false,Description: "Failed! Network error.");
  }
}


Future<BillpaymentResponse> payUtilityBill(UtilityTransaction utilityTransaction,{String token=""}) async {
  print("PAY BILL FDH");
  print(jsonEncode(utilityTransaction.toJson()));
  try{
    utilityTransaction.username=await session.get("USERNAME");
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }

  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return BillpaymentResponse(Status: false,Description: "Failed! Network error.");
        }else{
          print("ABCD: "+loginResponse.token);
          token=loginResponse.token;
          final http.Response response = await http.post(
            _utilityTransactions,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(utilityTransaction.toJson()),
          );


          if (response.statusCode == 200) {
           print(json.decode(response.body).toString());
            return BillpaymentResponse.fromJson(json.decode(response.body));
          } else {
            print("!=200");
            try{
              print(json.decode(response.body).toString());
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return BillpaymentResponse(Status: false,Description: "Failed! Network error.");
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return BillpaymentResponse(Status: false,Description: "Failed! Network error.");
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return BillpaymentResponse(Status: false,Description: "Failed! Network error.");
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return BillpaymentResponse(Status: false,Description: "Failed! Network error.");
    }
  }on TimeoutException catch(_){
    print(_);
    return BillpaymentResponse(Status: false,Description: "Failed! Network error.");
  }
}

Future<FundsTransferResponse> _transferFunds(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  final http.Response response = await http.post(
    _url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(userLogin.toJson()),
  );
  if (response.statusCode == 200) {
    print("200");
    print(json.decode(response.body).toString());
    return FundsTransferResponse.fromJson(json.decode(response.body));
  } else {
    print("!=200");
    try{
      print(json.decode(response.body).toString());
      print(json.decode(response.body));
    }on Exception catch(_){

    }
    return FundsTransferResponse(Status: false,Description: "Failed! Network error.");
  }
}

Future<FundsTransferResponse> transferFunds(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return FundsTransferResponse(Status: false,Description: "Failed! Network error.");
        }else{
          print("ABCD: "+loginResponse.token);
          token=loginResponse.token;
          final http.Response response = await http.post(
            _url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(userLogin.toJson()),
          );
          if (response.statusCode == 200) {
            print("200");
            print(json.decode(response.body).toString());
            return FundsTransferResponse.fromJson(json.decode(response.body));
          } else {
            print("!=200");
            try{
              print(json.decode(response.body).toString());
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return FundsTransferResponse(Status: false,Description: "Failed! Network error.");
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return FundsTransferResponse(Status: false,Description: "Failed! Network error.");
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return FundsTransferResponse(Status: false,Description: "Failed! Network error.");
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return FundsTransferResponse(Status: false,Description: "Failed! Network error.");
    }
  }on TimeoutException catch(_){
    print(_);
    return FundsTransferResponse(Status: false,Description: "Failed! Network error.");
  }
}

Future<PRNVerifyResponse> _verifyTaxPRN(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  try{
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(userLogin.toJson()),
    ).timeout(Duration(seconds: 30));
    if (response.statusCode == 200) {
      print("verifyTaxPRN");
      print(json.decode(response.body).toString());
      return PRNVerifyResponse.fromJson(json.decode(response.body));
    } else {
      print("!=200--verifyTaxPRN");
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return PRNVerifyResponse(Status: false,Description: "Failed! Network error.",ministatement: "Failed! Network error.");
    }
  }on Exception catch(_){
    return PRNVerifyResponse(Status: false,Description: "Failed! Network error.",ministatement: "Failed! Network error.");
  }
}

Future<PRNVerifyResponse> verifyTaxPRN(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return PRNVerifyResponse(Status: false,Description: "Failed! Network error.",ministatement: "Failed! Network error.");
        }else{
          print("ABCD: "+loginResponse.token);
          token=loginResponse.token;
          final http.Response response = await http.post(
            _url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(userLogin.toJson()),
          ).timeout(Duration(seconds: 30));
          if (response.statusCode == 200) {
            print("verifyTaxPRN");
            print(json.decode(response.body).toString());
            return PRNVerifyResponse.fromJson(json.decode(response.body));
          } else {
            print("!=200--verifyTaxPRN");
            try{
              print(json.decode(response.body).toString());
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return PRNVerifyResponse(Status: false,Description: "Failed! Network error.",ministatement: "Failed! Network error.");
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return PRNVerifyResponse(Status: false,Description: "Failed! Network error.",ministatement: "Failed! Network error.");
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return PRNVerifyResponse(Status: false,Description: "Failed! Network error.",ministatement: "Failed! Network error.");
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return PRNVerifyResponse(Status: false,Description: "Failed! Network error.",ministatement: "Failed! Network error.");
    }
  }on TimeoutException catch(_){
    print(_);
    return PRNVerifyResponse(Status: false,Description: "Failed! Network error.",ministatement: "Failed! Network error.");
  }
}

Future<TaxPaymentResponse> _payTax(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  try{
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(userLogin.toJson()),
    ).timeout(Duration(seconds: 30));
    if (response.statusCode == 200) {
      print("payTax");
      print(json.decode(response.body).toString());
      return TaxPaymentResponse.fromJson(json.decode(response.body));
    } else {
      print("!=200--payTax");
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return TaxPaymentResponse(Status: false,Description: "Failed! Network error.",ministatement: "Failed! Network error.");
    }
  }on Exception catch(_){
    return TaxPaymentResponse(Status: false,Description: "Failed! Network error.",ministatement: "Failed! Network error.");
  }
}

Future<TaxPaymentResponse> payTax(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return TaxPaymentResponse(Status: false,Description: "Failed! Network error.",ministatement: "Failed! Network error.");
        }else{
          print("ABCD: "+loginResponse.token);
          token=loginResponse.token;
          final http.Response response = await http.post(
            _url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(userLogin.toJson()),
          ).timeout(Duration(seconds: 30));
          if (response.statusCode == 200) {
            print("payTax");
            print(json.decode(response.body).toString());
            return TaxPaymentResponse.fromJson(json.decode(response.body));
          } else {
            print("!=200--payTax");
            try{
              print(json.decode(response.body).toString());
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return TaxPaymentResponse(Status: false,Description: "Failed! Network error.",ministatement: "Failed! Network error.");
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return TaxPaymentResponse(Status: false,Description: "Failed! Network error.",ministatement: "Failed! Network error.");
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return TaxPaymentResponse(Status: false,Description: "Failed! Network error.",ministatement: "Failed! Network error.");
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return TaxPaymentResponse(Status: false,Description: "Failed! Network error.",ministatement: "Failed! Network error.");
    }
  }on TimeoutException catch(_){
    print(_);
    return TaxPaymentResponse(Status: false,Description: "Failed! Network error.",ministatement: "Failed! Network error.");
  }
}

Future<WalletTransferResponse> _bankToWalletTransfer(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  try{
    final http.Response response = await http.post(
      _url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(userLogin.toJson()),
    ).timeout(Duration(seconds: 30));
    if (response.statusCode == 200) {
      print("bankToWalletTransfer");
      print(json.decode(response.body).toString());
      return WalletTransferResponse.fromJson(json.decode(response.body));
    } else {
      print("!=200--bankToWalletTransfer");
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return WalletTransferResponse(Status: false,Description: "Failed! Network error.",ministatement:" Failed.");
    }
  }on Exception catch(_){
    return WalletTransferResponse(Status: false,Description: "Failed! Network error.",ministatement:" Failed.");
  }
}

Future<WalletTransferResponse> bankToWalletTransfer(Member userLogin,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }
  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return WalletTransferResponse(Status: false,Description: "Failed! Network error.",ministatement:" Failed.");
        }else{
          print("ABCD: "+loginResponse.token);
          final http.Response response = await http.post(
            _url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(userLogin.toJson()),
          ).timeout(Duration(seconds: 30));
          if (response.statusCode == 200) {
            print("bankToWalletTransfer");
            print(json.decode(response.body).toString());
            return WalletTransferResponse.fromJson(json.decode(response.body));
          } else {
            print("!=200--bankToWalletTransfer");
            try{
              print(json.decode(response.body).toString());
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return WalletTransferResponse(Status: false,Description: "Failed! Network error.",ministatement:" Failed.");
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return WalletTransferResponse(Status: false,Description: "Failed! Network error.",ministatement:" Failed.");
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return WalletTransferResponse(Status: false,Description: "Failed! Network error.",ministatement:" Failed.");
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return WalletTransferResponse(Status: false,Description: "Failed! Network error.",ministatement:" Failed.");
    }
  }on TimeoutException catch(_){
    print(_);
    return WalletTransferResponse(Status: false,Description: "Failed! Network error.",ministatement:" Failed.");
  }
}

Future<LoginResponse> login_2(Member userLogin,{String token=""}) async {
  print(_url);
  token=await session.get("AUTHTOKEN");
  final http.Response response = await http.post(
    _url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode(userLogin.toJson()),
  );
  if (response.statusCode == 200) {
    //print(json.decode(response.body).toString());
    return LoginResponse.fromJson(json.decode(response.body));
  } else {
    try{
      print(json.decode(response.body).toString());
      print(json.decode(response.body));
    }on Exception catch(_){

    }
    throw Exception(json.decode(response.body));
    //return LoginResponse.fromJson("");
  }
}

Future<UtilityBillTypeResponse> fetchUtilityBillType(Member userLogin,requestItem,{String token=""}) async {
  print(_url);
  try{
    userLogin.username=await session.get("USERNAME");
    print(userLogin.toJson());
    token=await session.get("AUTHTOKEN");
  }on Exception catch(_){

  }

  try
  {
    String u=await session.get("USERNAME");
    String p=await session.get("PASSWORD");
    Member member=Member(username: u,password: p,OPERATION: "LOGIN"
    );
    final http.Response response = await http.post(
      _token_url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(member.toJson()),
    ).timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
      print(json.decode(response.body).toString());
      try{
        LoginResponse loginResponse=LoginResponse.fromJson(json.decode(response.body));
        if(loginResponse==null){
          print("NOT ABCD");
          return UtilityBillTypeResponse();
        }else{
          print("ABCD: "+loginResponse.token);
          String billTypeToken = loginResponse.token;
          final http.Response response = await http.post(
            _billPaymentUrl,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $billTypeToken'
            },
            body: requestItem,
          ).timeout(Duration(seconds: 30));
          if (response.statusCode == 200) {
            print("UtilityBillTypeResponse");
            print(json.decode(response.body).toString());
            return UtilityBillTypeResponse.fromJson(json.decode(response.body));
          } else {
            print("!=200--UtilityBillTypeResponse");
            try{
              print(json.decode(response.body).toString());
              print(json.decode(response.body));
            }on Exception catch(_){

            }
            return UtilityBillTypeResponse();
          }
        }
      }on Exception catch(_){
        print("ABCD EXC: "+_.toString());
      }
      return UtilityBillTypeResponse();
    }else if (response.statusCode == 401) {
      try{
        print(json.decode(response.body).toString());
      }on Exception catch(_){

      }
      return UtilityBillTypeResponse();
    } else {
      try{
        print(json.decode(response.body).toString());
        print(json.decode(response.body));
      }on Exception catch(_){

      }
      return UtilityBillTypeResponse();
    }
  }on TimeoutException catch(_){
    print(_);
    return UtilityBillTypeResponse();
  }
}