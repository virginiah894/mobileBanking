class UtilityPricingResponse {
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
  UtilityPricing utilityPricing;
  Null utilityProviders;
  Null lWBPrepaidEnquiryResponse;
  Null utilities;

  UtilityPricingResponse(
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
        this.lWBPrepaidEnquiryResponse,
        this.utilities});

  UtilityPricingResponse.fromJson(Map<String, dynamic> json) {
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
    utilityPricing = json['UtilityPricing'] != null
        ? new UtilityPricing.fromJson(json['UtilityPricing'])
        : null;
    utilityProviders = json['UtilityProviders'];
    lWBPrepaidEnquiryResponse = json['LWBPrepaidEnquiryResponse'];
    utilities = json['Utilities'];
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
    if (this.utilityPricing != null) {
      data['UtilityPricing'] = this.utilityPricing.toJson();
    }
    data['UtilityProviders'] = this.utilityProviders;
    data['LWBPrepaidEnquiryResponse'] = this.lWBPrepaidEnquiryResponse;
    data['Utilities'] = this.utilities;
    return data;
  }
}

class UtilityPricing {
  
  List<AddonMode> addons;
  List<Products> products;
  List<Viewtypes> viewtypes;

  UtilityPricing({this.addons, this.products, this.viewtypes});

  UtilityPricing.fromJson(Map<String, dynamic> json) {
    if (json['Addons'] != null) {
      addons = new List<AddonMode>();
      json['Addons'].forEach((v) {
        addons.add(new AddonMode.fromJson(v));
      });
    }
    if (json['Products'] != null) {
      products = new List<Products>();
      json['Products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
    if (json['Viewtypes'] != null) {
      viewtypes = new List<Viewtypes>();
      json['Viewtypes'].forEach((v) {
        viewtypes.add(new Viewtypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addons != null) {
      data['Addons'] = this.addons.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['Products'] = this.products.map((v) => v.toJson()).toList();
    }
    if (this.viewtypes != null) {
      data['Viewtypes'] = this.viewtypes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddonMode {
  int iD;
  String productcode;
  String dESCRIPTION;
  double productPrice;

  AddonMode({this.iD, this.productcode, this.dESCRIPTION, this.productPrice});

  AddonMode.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    productcode = json['Productcode'];
    dESCRIPTION = json['DESCRIPTION'];
    productPrice = json['ProductPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Productcode'] = this.productcode;
    data['DESCRIPTION'] = this.dESCRIPTION;
    data['ProductPrice'] = this.productPrice;
    return data;
  }
}

class Products {
  int iD;
  String productcode;
  String dESCRIPTION;
  double productPrice;
  int serviceproviderID;

  Products(
      {this.iD,
        this.productcode,
        this.dESCRIPTION,
        this.productPrice,
        this.serviceproviderID});

  Products.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    productcode = json['Productcode'];
    dESCRIPTION = json['DESCRIPTION'];
    productPrice = json['ProductPrice'];
    serviceproviderID = json['serviceproviderID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Productcode'] = this.productcode;
    data['DESCRIPTION'] = this.dESCRIPTION;
    data['ProductPrice'] = this.productPrice;
    data['serviceproviderID'] = this.serviceproviderID;
    return data;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
  bool operator ==(o) => o is Products && o.dESCRIPTION == dESCRIPTION && o.iD == iD;

}
class Viewtypes {
  int iD;
  String productcode;
  String dESCRIPTION;
  double productPrice;


  Viewtypes(
      {this.iD,
        this.productcode,
        this.dESCRIPTION,
        this.productPrice
        });

  Viewtypes.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    productcode = json['Productcode'];
    dESCRIPTION = json['DESCRIPTION'];
    productPrice = json['ProductPrice'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Productcode'] = this.productcode;
    data['DESCRIPTION'] = this.dESCRIPTION;
    data['ProductPrice'] = this.productPrice;
    return data;
  }
}