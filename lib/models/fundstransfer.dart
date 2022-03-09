class FundsTransfer{

  String AccountNo, TransactionType, Terminal, Currency, AccountName, AccountType, Username,
      SessionId, PostingType, RefNo, Msisdn, AccountNo2, CurrFrom, CurrTo, TransactionNarration,
      TransactionSpecificType, BeneficiaryBank;
  String Beneficiaryaccountname;
  String Beneficiaryaname ;
  String Amount, ChargeAmount;

  FundsTransfer({this.AccountNo,this.TransactionType,this.Terminal,this.Currency,this.AccountName,this.AccountType,this.Username,
    this.SessionId,this.PostingType,this.RefNo,this.Msisdn,this.AccountNo2,this.CurrFrom,this.CurrTo,this.TransactionNarration,
    this.TransactionSpecificType,this.BeneficiaryBank,this.Beneficiaryaccountname,this.Beneficiaryaname,this.Amount,this.ChargeAmount
  });

  factory FundsTransfer.fromJson(Map<String, dynamic> responseData) {
    return FundsTransfer(
        AccountNo: responseData['AccountNo'],
        TransactionType: responseData['TransactionType'],
        Terminal: responseData['Terminal'],
        Currency: responseData['Currency'],
        AccountName: responseData['AccountName'],
        AccountType: responseData['AccountType'],
        Username: responseData['Username'],
        SessionId: responseData['SessionId'],
        PostingType: responseData['PostingType'],
        RefNo: responseData['RefNo'],
        Msisdn: responseData['Msisdn'],
        AccountNo2: responseData['AccountNo2'],
        CurrFrom: responseData['CurrFrom'],
        CurrTo: responseData['CurrTo'],
        TransactionNarration: responseData['TransactionNarration'],
        TransactionSpecificType: responseData['TransactionSpecificType'],
        BeneficiaryBank: responseData['BeneficiaryBank'],
        Beneficiaryaccountname: responseData['Beneficiaryaccountname'],
        Beneficiaryaname: responseData['Beneficiaryaname'],
        Amount: responseData['Amount'],
        ChargeAmount: responseData['ChargeAmount'],
    );
  }

  Map<String, dynamic> toJson() => {
    "AccountNo": this.AccountNo,
    "TransactionType": this.TransactionType,
    "Terminal": this.Terminal,
    "Currency": this.Currency,
    "AccountName": this.AccountName,
    "AccountType": this.AccountType,
    "Username": this.Username,
    "SessionId": this.SessionId,
    "PostingType": this.PostingType,
    "RefNo": this.RefNo,
    "Msisdn": this.Msisdn,
    "AccountNo2": this.AccountNo2,
    "CurrFrom": this.CurrFrom,
    "CurrTo": this.CurrTo,
    "TransactionNarration": this.TransactionNarration,
    "TransactionSpecificType": this.TransactionSpecificType,
    "BeneficiaryBank": this.BeneficiaryBank,
    "Beneficiaryaccountname": this.Beneficiaryaccountname,
    "Beneficiaryaname": this.Beneficiaryaname,
    "Amount": this.Amount,
    "ChargeAmount": this.ChargeAmount,
  };

}