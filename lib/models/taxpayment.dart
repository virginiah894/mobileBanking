class TaxPayment{
  String prnnumber;
  String username;
  String mysourceaccountnumber;
  String mytransferamount;

  TaxPayment({this.prnnumber,this.username,this.mysourceaccountnumber,this.mytransferamount});

  factory TaxPayment.fromJson(Map<String, dynamic> responseData) {
    return TaxPayment(
        prnnumber: responseData['prnnumber'],
        mysourceaccountnumber: responseData['mysourceaccountnumber'],
        username: responseData['username'],
        mytransferamount: responseData['mytransferamount']
    );
  }

  Map<String, dynamic> toJson() => {
    "prnnumber": this.prnnumber,
    "mysourceaccountnumber": this.mysourceaccountnumber,
    "username": this.username,
    "mytransferamount": this.mytransferamount
  };
}