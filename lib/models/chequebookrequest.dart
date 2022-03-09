class ChequebookRequest{
  String MyAccountNum, MyAccountName, MyAccounttype, MyAccountcurrency, MyComments, MyCollectionPoint, MyCompanyID;
  int MyPages, MyNumberofBooks;


  ChequebookRequest({
    this.MyAccountNum,this.MyAccountName,this.MyAccounttype,this.MyAccountcurrency,this.MyComments,this.MyCollectionPoint,
    this.MyCompanyID,this.MyNumberofBooks,this.MyPages
  });

  factory ChequebookRequest.fromJson(Map<String, dynamic> responseData) {
    return ChequebookRequest(
        MyCompanyID: responseData['MyCompanyID'],
        MyPages: responseData['MyPages'],
        MyNumberofBooks: responseData['MyNumberofBooks'],
        MyCollectionPoint: responseData['MyCollectionPoint'],
        MyAccountcurrency: responseData['MyAccountcurrency'],
        MyAccounttype: responseData['MyAccounttype'],
        MyAccountName: responseData['MyAccountName'],
        MyComments: responseData['MyComments'],
        MyAccountNum: responseData['MyAccountNum']
    );
  }

  Map<String, dynamic> toJson() => {
    "MyCompanyID": this.MyCompanyID,
    "MyPages": this.MyPages,
    "MyNumberofBooks": this.MyNumberofBooks,
    "MyCollectionPoint": this.MyCollectionPoint,
    "MyAccountcurrency": this.MyAccountcurrency,
    "MyAccounttype": this.MyAccounttype ,
    "MyAccountName": this.MyAccountName,
    "MyComments": this.MyComments,
    "MyAccountNum": this.MyAccountNum
  };
}