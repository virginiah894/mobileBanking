
class Ministatement{
  String AccountNo,TransactionType,Terminal,Currency,AccountName,AccountType,chargeAmount,Username,SessionId,PostingType,RefNo,Msisdn;

  Ministatement({this.AccountNo, this.TransactionType, this.Terminal, this.Currency,this.AccountName,this.AccountType,this.chargeAmount,this.Username,this.SessionId,this.PostingType,this.RefNo,this.Msisdn});

  Map<String, dynamic> toJson() => {
    'AccountNo': this.AccountNo!=null?this.AccountNo:'',
    'TransactionType': this.TransactionType!=null?this.TransactionType:'',
    'Terminal': this.Terminal!=null?this.Terminal:'',
    'Currency': this.Currency!=null?this.Currency:'',
    'AccountName': this.AccountName!=null?this.AccountName:'',
    'AccountType': this.AccountType!=null?this.AccountType:'',
    'chargeAmount': this.chargeAmount!=null?this.chargeAmount:'',
    'Username': this.Username!=null?this.Username:'',
    'SessionId': this.SessionId!=null?this.SessionId:'',
    'PostingType': this.PostingType!=null?this.PostingType:'',
    'RefNo': this.RefNo!=null?this.RefNo:'',
    'Msisdn': this.Msisdn!=null?this.Msisdn:''
  };

  factory Ministatement.fromJson(Map<String, dynamic> json) {
    return Ministatement(
        AccountNo: json['AccountNo'],
        TransactionType: json['TransactionType'],
        Terminal: json['Terminal'],
        Currency: json['Currency'],
        AccountName: json['AccountName'],
        AccountType: json['AccountType'],
        chargeAmount: json['chargeAmount'],
        Username: json['Username'],
        SessionId: json['SessionId'],
        PostingType: json['PostingType'],
        RefNo: json['RefNo'],
        Msisdn: json['Msisdn']
    );
  }
}