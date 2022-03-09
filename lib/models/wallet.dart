class Wallet{
  String AccountNo,TransactionType,Terminal/*MOBILE*/,Currency;
  String AccountName,AccountType,Amount,Username,SessionId,PostingType/*A2W*/;
  String RefNo,Msisdn,CurrFrom,TransactionNarration/*Account to wallet*/;
  String TransactionSpecificType/*A2W*/,BeneficiaryBank/*MOBILE*/,PhoneNumber;

  Wallet({this.AccountNo,this.TransactionType,this.Terminal,this.Currency,this.AccountName,this.AccountType,this.Amount,
    this.Username,this.SessionId,this.PostingType,this.RefNo,this.Msisdn,this.CurrFrom,this.TransactionNarration,this.TransactionSpecificType,
    this.BeneficiaryBank,this.PhoneNumber});

  factory Wallet.fromJson(Map<String, dynamic> responseData) {
    return Wallet(
        AccountNo: responseData['AccountNo'],
        TransactionType: responseData['TransactionType'],
        Terminal: responseData['Terminal'],
        Currency: responseData['Currency'],
        AccountName: responseData['AccountName'],
        AccountType: responseData['AccountType'],
        Amount: responseData['Amount'],
        Username: responseData['Username'],
        SessionId: responseData['SessionId'],
        PostingType: responseData['PostingType'],
        RefNo: responseData['RefNo'],
        Msisdn: responseData['Msisdn'],
        CurrFrom: responseData['CurrFrom'],
        TransactionNarration: responseData['TransactionNarration'],
        TransactionSpecificType: responseData['TransactionSpecificType'],
        BeneficiaryBank: responseData['BeneficiaryBank'],
        PhoneNumber: responseData['PhoneNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
    "AccountNo": this.AccountNo,
    "TransactionType": this.TransactionType,
    "Terminal": this.Terminal,
    "Currency": this.Currency,
    "AccountName": this.AccountName,
    "AccountType": this.AccountType,
    "Amount": this.Amount,
    "Username": this.Username,
    "SessionId": this.SessionId,
    "PostingType": this.PostingType,
    "RefNo": this.RefNo,
    "Msisdn": this.Msisdn,
    "CurrFrom": this.CurrFrom,
    "TransactionNarration": this.TransactionNarration,
    "TransactionSpecificType": this.TransactionSpecificType,
    "BeneficiaryBank": this.BeneficiaryBank,
    "PhoneNumber": this.PhoneNumber,
  };
}