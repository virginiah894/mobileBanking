class BillPayment{
  String AccountNumber;
  String MyAccountNumber;
  String utilityname;
  String billno;
  String utilitycompany;
  String amount;
  String valuedate;
  String comments;
  String SessionId;
  int billpaymentid;
//this.AccountNumber,
  BillPayment({this.AccountNumber,this.utilityname,this.billno,this.utilitycompany,this.amount,this.valuedate,
    this.comments,this.SessionId,this.billpaymentid,this.MyAccountNumber});

  factory BillPayment.fromJson(Map<String, dynamic> responseData) {
    return BillPayment(
        AccountNumber: responseData['AccountNumber'],
        MyAccountNumber: responseData['MyAccountNumber'],
        utilityname: responseData['utilityname'],
        billno: responseData['billno'],
        utilitycompany: responseData['utilitycompany'],
        amount: responseData['amount'],
        valuedate: responseData['valuedate'],
        comments: responseData['comments'],
        SessionId: responseData['SessionId'],
        billpaymentid: responseData['billpaymentid']
    );
  }

  Map<String, dynamic> toJson() => {
    "AccountNumber": this.AccountNumber,
    "MyAccountNumber": this.MyAccountNumber,
    "utilityname": this.utilityname,
    "billno": this.billno,
    "utilitycompany": this.utilitycompany,
    "amount": this.amount,
    "valuedate": this.valuedate,
    "comments": this.comments,
    "SessionId": this.SessionId,
    "billpaymentid": this.billpaymentid
  };

}
