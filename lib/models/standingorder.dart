class StandingOrder{

  int MyCompanyID;
  String MySourceAccountNumber, MySourceAccountName, MySourceAccountType, MySourceCurrency, MyBeneficiarybank, MyBranchName,
      MyBeneficiaryAccountNumber;
  String MyBeneficiaryAccountName, myTransferAmount, myTransferCurrency, MyFrequency, MyComments, MyTransfertype;
  String MyRecurdate,MyEndDate;

  StandingOrder({this.MyCompanyID, this.MySourceAccountNumber, this.MySourceAccountName,this.MySourceAccountType,this.myTransferCurrency,
    this.MySourceCurrency,this.MyBeneficiarybank,this.MyBranchName,this.MyBeneficiaryAccountNumber,this.MyRecurdate,this.MyEndDate,
    this.myTransferAmount,this.MyBeneficiaryAccountName,this.MyFrequency,this.MyComments,this.MyTransfertype
  });

  factory StandingOrder.fromJson(Map<String, dynamic> responseData) {
    return StandingOrder(
        MyCompanyID: responseData['MyCompanyID'],
        MySourceAccountName: responseData['MySourceAccountName'],
        MySourceAccountNumber: responseData['MySourceAccountNumber'],
        MySourceAccountType: responseData['MySourceAccountType'],
        MySourceCurrency: responseData['MySourceCurrency'],
        MyBeneficiarybank: responseData['MyBeneficiarybank'],
        MyBranchName: responseData['MyBranchName'],
        MyBeneficiaryAccountNumber: responseData['MyBeneficiaryAccountNumber'],
        MyBeneficiaryAccountName: responseData['MyBeneficiaryAccountName'],
        myTransferAmount: responseData['myTransferAmount'],
        myTransferCurrency: responseData['myTransferCurrency'],
        MyComments: responseData['MyComments'],
        MyFrequency: responseData['MyFrequency'],
        MyRecurdate: responseData['MyRecurDate'],
        MyEndDate: responseData['MyEndDate'],
        MyTransfertype: responseData['MyTransfertype']
    );
  }

  Map<String, dynamic> toJson() => {
    "MyCompanyID": this.MyCompanyID,
    "MySourceAccountName": this.MySourceAccountName,
    "MySourceAccountNumber": this.MySourceAccountNumber,
    "MySourceAccountType": this.MySourceAccountType,
    "MySourceCurrency": this.MySourceCurrency,
    "MyBeneficiarybank": this.MyBeneficiarybank ,
    "MyBranchName": this.MyBranchName,
    "MyBeneficiaryAccountNumber": this.MyBeneficiaryAccountNumber,
    "MyBeneficiaryAccountName": this.MyBeneficiaryAccountName,
    "myTransferAmount": this.myTransferAmount,
    "myTransferCurrency": this.myTransferCurrency,
    "MyComments": this.MyComments,
    "MyFrequency": this.MyFrequency,
    "MyRecurDate": this.MyRecurdate,
    "MyEndDate": this.MyEndDate,
    "MyTransfertype": this.MyTransfertype
  };
}