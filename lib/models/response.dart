
class LoginResponse{
  double AvailableBal;
  double CurrentBal;
  String Description;
  String token;
  bool Status;
  bool IsAppleTester;
  int code;

  LoginResponse({this.Status, this.code, this.IsAppleTester, this.AvailableBal, this.CurrentBal,this.Description,this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
        Description: json['Description'],
        AvailableBal: json['AvailableBal'],
        CurrentBal: json['CurrentBal'],
        Status: json['Status'],
        token: json['token'],
        IsAppleTester: json['IsAppleTester'],
        code: json['code']
    );
  }

  Map<String, dynamic> toJson() => {
    "IsAppleTester": this.IsAppleTester,
    "Status": this.Status,
    "token": this.token,
    "Description": this.Description,
    "CurrentBal": this.CurrentBal,
    "AvailableBal": this.AvailableBal
  };

}

class AccountResponse{
  double AvailableBal;
  double CurrentBal;
  String Description;
  String ministatement;
  bool Status;
  int code;
  List<String> Accounts;

  AccountResponse({this.Status, this.code, this.AvailableBal, this.CurrentBal,this.Description,this.ministatement,this.Accounts});

  factory AccountResponse.fromJson(Map<String, dynamic> json) {
    return AccountResponse(
        Description: json['Description'],
        AvailableBal: json['AvailableBal'],
        CurrentBal: json['CurrentBal'],
        Status: json['Status'],
        code: json['code'],
        ministatement: json['ministatement'],
        //Accounts: json['Accounts'],
        Accounts: List<String>.from(json["Accounts"].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "ministatement": ministatement,
    "Accounts": List<dynamic>.from(Accounts.map((x) => x)),
  };
}

class BalanceResponse{
  double AvailableBal;
  double CurrentBal;
  String Description;
  bool Status;
  int code;

  BalanceResponse({this.Status, this.code, this.AvailableBal, this.CurrentBal,this.Description,});

  factory BalanceResponse.fromJson(Map<String, dynamic> json) {
    return BalanceResponse(
        Description: json['Description'],
        AvailableBal: json['AvailableBal'],
        CurrentBal: json['CurrentBal'],
        Status: json['Status'],
        code: json['code']
    );
  }
}

class MinistatementResponse{
  double AvailableBal;
  double CurrentBal;
  String Description;
  String ministatement;
  bool Status;
  int code;

  MinistatementResponse({this.Status, this.code, this.AvailableBal, this.CurrentBal,this.Description,this.ministatement});

  factory MinistatementResponse.fromJson(Map<String, dynamic> json) {
    return MinistatementResponse(
        Description: json['Description'],
        AvailableBal: json['AvailableBal'],
        CurrentBal: json['CurrentBal'],
        Status: json['Status'],
        code: json['code'],
        ministatement: json['ministatement']
    );
  }
}

class UtilityProvidersResponse{
  double AvailableBal;
  double CurrentBal;
  String Description;
  String ministatement;
  bool Status;
  int code;
  List<String> Accounts;

  UtilityProvidersResponse({this.Status, this.code, this.AvailableBal, this.CurrentBal,this.Description,this.ministatement,this.Accounts});

  factory UtilityProvidersResponse.fromJson(Map<String, dynamic> json) {
    return UtilityProvidersResponse(
      Description: json['Description'],
      AvailableBal: json['AvailableBal'],
      CurrentBal: json['CurrentBal'],
      Status: json['Status'],
      code: json['code'],
      ministatement: json['ministatement'],
      //Accounts: json['Accounts'],
      Accounts: List<String>.from(json["Accounts"].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "ministatement": ministatement,
    "Accounts": List<dynamic>.from(Accounts.map((x) => x)),
  };
}

class BanksResponse{
  double AvailableBal;
  double CurrentBal;
  String Description;
  String ministatement;
  bool Status;
  int code;
  List<String> Accounts;

  BanksResponse({this.Status, this.code, this.AvailableBal, this.CurrentBal,this.Description,this.ministatement,this.Accounts});

  factory BanksResponse.fromJson(Map<String, dynamic> json) {
    return BanksResponse(
      Description: json['Description'],
      AvailableBal: json['AvailableBal'],
      CurrentBal: json['CurrentBal'],
      Status: json['Status'],
      code: json['code'],
      ministatement: json['ministatement'],
      //Accounts: json['Accounts'],
      Accounts: List<String>.from(json["Accounts"].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "ministatement": ministatement,
    "Accounts": List<dynamic>.from(Accounts.map((x) => x)),
  };
}

class ColletionPointsResponse{
  double AvailableBal;
  double CurrentBal;
  String Description;
  bool Status;
  int code;
  List<String> Accounts;

  ColletionPointsResponse({this.Status, this.code, this.AvailableBal, this.CurrentBal,this.Description,this.Accounts});

  factory ColletionPointsResponse.fromJson(Map<String, dynamic> json) {
    return ColletionPointsResponse(
      Description: json['Description'],
      AvailableBal: json['AvailableBal'],
      CurrentBal: json['CurrentBal'],
      Status: json['Status'],
      code: json['code'],
      //Accounts: json['Accounts'],
      Accounts: List<String>.from(json["Accounts"].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "Accounts": List<dynamic>.from(Accounts.map((x) => x)),
  };
}

class BillpaymentResponse{
  String Description;
  bool Status;
  int code;

  BillpaymentResponse({this.Status, this.code, this.Description});

  factory BillpaymentResponse.fromJson(Map<String, dynamic> json) {
    return BillpaymentResponse(
      Description: json['Description'],
      Status: json['Status'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() => {
    "Description": Description,
    "Status": Status,
    "code": code
  };
}

class StandingOrderResponse{
  String Description;
  bool Status;
  int code;

  StandingOrderResponse({this.Status, this.code, this.Description});

  factory StandingOrderResponse.fromJson(Map<String, dynamic> json) {
    return StandingOrderResponse(
      Description: json['Description'],
      Status: json['Status'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() => {
    "Description": Description,
    "Status": Status,
    "code": code
  };
}

class ChequeBookResponse{
  String Description;
  bool Status;
  int code;

  ChequeBookResponse({this.Status, this.code, this.Description});

  factory ChequeBookResponse.fromJson(Map<String, dynamic> json) {
    return ChequeBookResponse(
      Description: json['Description'],
      Status: json['Status'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() => {
    "Description": Description,
    "Status": Status,
    "code": code
  };
}

class FundsTransferResponse{
  String Description;
  bool Status;
  int code;

  FundsTransferResponse({this.Status, this.code, this.Description});

  factory FundsTransferResponse.fromJson(Map<String, dynamic> json) {
    return FundsTransferResponse(
      Description: json['Description'],
      Status: json['Status'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() => {
    "Description": Description,
    "Status": Status,
    "code": code
  };
}

class PRNVerifyResponse{
  String Description;
  String ministatement;
  bool Status;
  int code;
  double CurrentBal;
  double AvailableBal;
  List<String> Accounts;

  PRNVerifyResponse({this.Status, this.code, this.Description,this.CurrentBal,this.Accounts,this.AvailableBal,this.ministatement});

  factory PRNVerifyResponse.fromJson(Map<String, dynamic> json) {
    return PRNVerifyResponse(
      Description: json['Description'],
      Status: json['Status'],
      code: json['code'],
      CurrentBal: json['CurrentBal'],
      AvailableBal: json['AvailableBal'],
      ministatement: json['ministatement'],
      //Accounts: json['ministatement']!=null ? List<String>.from(json["Accounts"].map((x) => x)):null,
    );
  }

  Map<String, dynamic> toJson() => {
    "Description": Description,
    "Status": Status,
    "CurrentBal": CurrentBal,
    "AvailableBal": AvailableBal,
    "ministatement": ministatement,
    "Accounts": List<dynamic>.from(Accounts.map((x) => x)),
    "code": code
  };
}

class TaxPaymentResponse{
  String Description;
  String ministatement;
  bool Status;
  int code;
  double CurrentBal;
  double AvailableBal;
  List<String> Accounts;

  TaxPaymentResponse({this.Status, this.code, this.Description,this.CurrentBal,this.Accounts,this.AvailableBal,this.ministatement});

  factory TaxPaymentResponse.fromJson(Map<String, dynamic> json) {
    return TaxPaymentResponse(
      Description: json['Description'],
      Status: json['Status'],
      code: json['code'],
      CurrentBal: json['CurrentBal'],
      AvailableBal: json['AvailableBal'],
      ministatement: json['ministatement'],
      //Accounts: json['ministatement']!=null ? List<String>.from(json["Accounts"].map((x) => x)):null,
    );
  }

  Map<String, dynamic> toJson() => {
    "Description": Description,
    "Status": Status,
    "CurrentBal": CurrentBal,
    "AvailableBal": AvailableBal,
    "ministatement": ministatement,
    "Accounts": List<dynamic>.from(Accounts.map((x) => x)),
    "code": code
  };
}

class WalletTransferResponse{
  String Description;
  String ministatement;
  bool Status;
  int code;

  WalletTransferResponse({this.Status, this.code, this.Description,this.ministatement});

  factory WalletTransferResponse.fromJson(Map<String, dynamic> json) {
    return WalletTransferResponse(
      Description: json['Description'],
      Status: json['Status'],
      code: json['code'],
      ministatement: json['ministatement'],
    );
  }

  Map<String, dynamic> toJson() => {
    "Description": Description,
    "Status": Status,
    "code": code,
    "ministatement": ministatement,
  };
}
class UtilityBillTypeResponse {
  bool status;
  String description;
  int code;

  List<Utilities> utilities;

  UtilityBillTypeResponse(
      {this.status,
        this.code,
        this.utilities});

  UtilityBillTypeResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    description = json['Description'];
    code = json['code'];
    if (json['Utilities'] != null) {
      utilities = new List<Utilities>();
      json['Utilities'].forEach((v) {
        utilities.add(new Utilities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Description'] = this.description;
    data['code'] = this.code;
    if (this.utilities != null) {
      data['Utilities'] = this.utilities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Utilities {
  int UTILITYID;
  String UTILITYNAME;
  String UTILITYCODE;
  String REMARKS;

  Utilities(
      {this.UTILITYID,
        this.UTILITYNAME,
        this.UTILITYCODE,
        this.REMARKS,
       });

  Utilities.fromJson(Map<String, dynamic> json) {
    UTILITYID = json['UTILITYID'];
    UTILITYNAME = json['UTILITYNAME'];
    UTILITYCODE = json['UTILITYCODE'];
    REMARKS = json['REMARKS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UTILITYID'] = this.UTILITYID;
    data['UTILITYNAME'] = this.UTILITYNAME;
    data['UTILITYCODE'] = this.UTILITYCODE;
    data['REMARKS'] = this.REMARKS;
    return data;
  }
}
class newUtilityProvidersResponse {
  bool status;
  bool isAppleTester;
  String description;
  double availableBal;
  double currentBal;
  Null token;
  Null balance;
  Null billEnquiryResponse;
  Null ministatement;
  Null accounts;
  Null loanRefs;
  Null loanDetail;
  int code;
  Null utilityPricing;
  List<UtilityProviders> utilityProviders;
  Null lWBPrepaidEnquiryResponse;

  newUtilityProvidersResponse(
      {this.status,
        this.isAppleTester,
        this.description,
        this.availableBal,
        this.currentBal,
        this.token,
        this.balance,
        this.billEnquiryResponse,
        this.ministatement,
        this.accounts,
        this.loanRefs,
        this.loanDetail,
        this.code,
        this.utilityPricing,
        this.utilityProviders,
        this.lWBPrepaidEnquiryResponse});

  newUtilityProvidersResponse.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    isAppleTester = json['IsAppleTester'];
    description = json['Description'];
    availableBal = json['AvailableBal'];
    currentBal = json['CurrentBal'];
    token = json['token'];
    balance = json['Balance'];
    billEnquiryResponse = json['billEnquiryResponse'];
    ministatement = json['ministatement'];
    accounts = json['Accounts'];
    loanRefs = json['LoanRefs'];
    loanDetail = json['loanDetail'];
    code = json['code'];
    utilityPricing = json['UtilityPricing'];
    if (json['UtilityProviders'] != null) {
      utilityProviders = new List<UtilityProviders>();
      json['UtilityProviders'].forEach((v) {
        utilityProviders.add(new UtilityProviders.fromJson(v));
      });
    }
    lWBPrepaidEnquiryResponse = json['LWBPrepaidEnquiryResponse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['IsAppleTester'] = this.isAppleTester;
    data['Description'] = this.description;
    data['AvailableBal'] = this.availableBal;
    data['CurrentBal'] = this.currentBal;
    data['token'] = this.token;
    data['Balance'] = this.balance;
    data['billEnquiryResponse'] = this.billEnquiryResponse;
    data['ministatement'] = this.ministatement;
    data['Accounts'] = this.accounts;
    data['LoanRefs'] = this.loanRefs;
    data['loanDetail'] = this.loanDetail;
    data['code'] = this.code;
    data['UtilityPricing'] = this.utilityPricing;
    if (this.utilityProviders != null) {
      data['UtilityProviders'] =
          this.utilityProviders.map((v) => v.toJson()).toList();
    }
    data['LWBPrepaidEnquiryResponse'] = this.lWBPrepaidEnquiryResponse;
    return data;
  }
}

class UtilityProviders {
  int uTILITYPROVDERID;
  int uTILITYID;
  String pROVIDERNAME;
  String pROVIDERACCOUNT;
  String cONTACTPERSON;
  String pOSTALADDRESS;
  String pHYSICALADDRESS;
  String rEMARKS;
  String dATEADDED;
  String lASTUPDATED;
  int uTILITYBILLERID;
  bool aCTIVE;

  UtilityProviders(
      {this.uTILITYPROVDERID,
        this.uTILITYID,
        this.pROVIDERNAME,
        this.pROVIDERACCOUNT,
        this.cONTACTPERSON,
        this.pOSTALADDRESS,
        this.pHYSICALADDRESS,
        this.rEMARKS,
        this.dATEADDED,
        this.lASTUPDATED,
        this.uTILITYBILLERID,
        this.aCTIVE});

  UtilityProviders.fromJson(Map<String, dynamic> json) {
    uTILITYPROVDERID = json['UTILITYPROVDERID'];
    uTILITYID = json['UTILITYID'];
    pROVIDERNAME = json['PROVIDERNAME'];
    pROVIDERACCOUNT = json['PROVIDERACCOUNT'];
    cONTACTPERSON = json['CONTACTPERSON'];
    pOSTALADDRESS = json['POSTALADDRESS'];
    pHYSICALADDRESS = json['PHYSICALADDRESS'];
    rEMARKS = json['REMARKS'];
    dATEADDED = json['DATEADDED'];
    lASTUPDATED = json['LASTUPDATED'];
    uTILITYBILLERID = json['UTILITYBILLERID'];
    aCTIVE = json['ACTIVE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UTILITYPROVDERID'] = this.uTILITYPROVDERID;
    data['UTILITYID'] = this.uTILITYID;
    data['PROVIDERNAME'] = this.pROVIDERNAME;
    data['PROVIDERACCOUNT'] = this.pROVIDERACCOUNT;
    data['CONTACTPERSON'] = this.cONTACTPERSON;
    data['POSTALADDRESS'] = this.pOSTALADDRESS;
    data['PHYSICALADDRESS'] = this.pHYSICALADDRESS;
    data['REMARKS'] = this.rEMARKS;
    data['DATEADDED'] = this.dATEADDED;
    data['LASTUPDATED'] = this.lASTUPDATED;
    data['UTILITYBILLERID'] = this.uTILITYBILLERID;
    data['ACTIVE'] = this.aCTIVE;
    return data;
  }
}
class BottomSheets{

  String NAME;


  BottomSheets(
      {
        this.NAME

      });

  BottomSheets.fromJson(Map<String, dynamic> json) {

    NAME = json['NAME'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['NAME'] = this.NAME;

    return data;
  }
}
