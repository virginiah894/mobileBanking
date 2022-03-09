// To parse this JSON data, do
//
//     final utilityTransaction = utilityTransactionFromJson(jsonString);

import 'dart:convert';

class UtilityTransaction {
   UtilityTransaction({
      this.accountNumber,
      this.username,
      this.billPaymentApplicationName,
      this.utilityCompany,
      this.sessionId,
      this.comments,
      this.utilityBillerId,
      this.dstvTransactionData,
      this.dstvBoxOfficeTransactionData,
      this.gotvTransactionData,
      this.lwbPrepaidTransactionData,
      this.lwbPostpaidTransactionData,
      this.airtelAirtimeTopupTransaction,
      this.tnmAirtimeTopupTransactionData,
      this.escomPrepaidTransactionData,
      this.escomPostpaidTransactionData,
      this.bwbPostpaidTransactionData,
      this.srwbPostpaidTransactionData,
      this.crwbPostpaidTransactionData,
      this.bwbPrepaidTransactionData,
      this.srwbPrepaidEnquiryData,
      this.nrwbPostpaidTransactionData,
      this.nrwbPrepaidTransactionData,
   });

   String accountNumber;
   String username;
   String billPaymentApplicationName;
   String utilityCompany;
   String sessionId;
   String comments;
   int utilityBillerId;
   DstvTransactionData dstvTransactionData;
   TransactionData dstvBoxOfficeTransactionData;
   TransactionData gotvTransactionData;
   PaidTransactionData lwbPrepaidTransactionData;
   PaidTransactionData lwbPostpaidTransactionData;
   AirtelAirtimeTopupTransaction airtelAirtimeTopupTransaction;
   TnmAirtimeTopupTransactionData tnmAirtimeTopupTransactionData;
   PaidTransactionData escomPrepaidTransactionData;
   PaidTransactionData escomPostpaidTransactionData;
   PaidTransactionData bwbPostpaidTransactionData;
   PaidTransactionData srwbPostpaidTransactionData;
   PaidTransactionData crwbPostpaidTransactionData;
   PaidTransactionData bwbPrepaidTransactionData;
   SrwbPrepaidEnquiryData srwbPrepaidEnquiryData;
   PaidTransactionData nrwbPostpaidTransactionData;
   PaidTransactionData nrwbPrepaidTransactionData;

   factory UtilityTransaction.fromRawJson(String str) => UtilityTransaction.fromJson(json.decode(str));

   String toRawJson() => json.encode(toJson());

   factory UtilityTransaction.fromJson(Map<String, dynamic> json) => UtilityTransaction(
      accountNumber: json["AccountNumber"],
      username: json["Username"],
      billPaymentApplicationName: json["BillPaymentApplicationName"],
      utilityCompany: json["UtilityCompany"],
      sessionId: json["SessionId"],
      comments: json["Comments"],
      utilityBillerId: json["UtilityBillerId"],
      dstvTransactionData: DstvTransactionData.fromJson(json["DSTVTransactionData"]),
      dstvBoxOfficeTransactionData: TransactionData.fromJson(json["DSTVBoxOfficeTransactionData"]),
      gotvTransactionData: TransactionData.fromJson(json["GOTVTransactionData"]),
      lwbPrepaidTransactionData: PaidTransactionData.fromJson(json["LWBPrepaidTransactionData"]),
      airtelAirtimeTopupTransaction: AirtelAirtimeTopupTransaction.fromJson(json["AirtelAirtimeTopupTransaction"]),
      tnmAirtimeTopupTransactionData: TnmAirtimeTopupTransactionData.fromJson(json["TnmAirtimeTopupTransactionData"]),
      escomPrepaidTransactionData: PaidTransactionData.fromJson(json["EscomPrepaidTransactionData"]),
      escomPostpaidTransactionData: PaidTransactionData.fromJson(json["EscomPostpaidTransactionData"]),
      bwbPostpaidTransactionData: PaidTransactionData.fromJson(json["BWBPostpaidTransactionData"]),
      srwbPostpaidTransactionData: PaidTransactionData.fromJson(json["SRWBPostpaidTransactionData"]),
      crwbPostpaidTransactionData: PaidTransactionData.fromJson(json["CRWBPostpaidTransactionData"]),
      bwbPrepaidTransactionData: PaidTransactionData.fromJson(json["BWBPrepaidTransactionData"]),
      srwbPrepaidEnquiryData: SrwbPrepaidEnquiryData.fromJson(json["SRWBPrepaidEnquiryData"]),
      nrwbPostpaidTransactionData: PaidTransactionData.fromJson(json["NRWBPostpaidTransactionData"]),
      nrwbPrepaidTransactionData: PaidTransactionData.fromJson(json["NRWBPrepaidTransactionData"]),
   );

   Map<String, dynamic> toJson() => {
      "AccountNumber": accountNumber,
      "Username": username,
      "BillPaymentApplicationName": billPaymentApplicationName,
      "UtilityCompany": utilityCompany,
      "SessionId": sessionId,
      "Comments": comments,
      "UtilityBillerId": utilityBillerId,
      "DSTVTransactionData": dstvTransactionData,
      "DSTVBoxOfficeTransactionData": dstvBoxOfficeTransactionData,
      "GOTVTransactionData": gotvTransactionData,
      "LWBPrepaidTransactionData": lwbPrepaidTransactionData,
      "LWBPostpaidTransactionData": lwbPostpaidTransactionData,
      "AirtelAirtimeTopupTransaction": airtelAirtimeTopupTransaction,
      "TnmAirtimeTopupTransactionData": tnmAirtimeTopupTransactionData,
      "EscomPrepaidTransactionData": escomPrepaidTransactionData,
      "EscomPostpaidTransactionData": escomPostpaidTransactionData,
      "BWBPostpaidTransactionData": bwbPostpaidTransactionData,
      "SRWBPostpaidTransactionData": srwbPostpaidTransactionData,
      "CRWBPostpaidTransactionData": crwbPostpaidTransactionData,
      "BWBPrepaidTransactionData": bwbPrepaidTransactionData,
      "SRWBPrepaidEnquiryData": srwbPrepaidEnquiryData,
      "NRWBPostpaidTransactionData": nrwbPostpaidTransactionData,
      "NRWBPrepaidTransactionData": nrwbPrepaidTransactionData,
   };
}

class AirtelAirtimeTopupTransaction {
   AirtelAirtimeTopupTransaction({
      this.airtelMobileNumber,
      this.amount,
      this.clientTransactionIdentifier,
   });

   String airtelMobileNumber;
   String amount;
   String clientTransactionIdentifier;

   factory AirtelAirtimeTopupTransaction.fromRawJson(String str) => AirtelAirtimeTopupTransaction.fromJson(json.decode(str));

   String toRawJson() => json.encode(toJson());

   factory AirtelAirtimeTopupTransaction.fromJson(Map<String, dynamic> json) => AirtelAirtimeTopupTransaction(
      airtelMobileNumber: json["AirtelMobileNumber"],
      amount: json["Amount"],
      clientTransactionIdentifier: json["ClientTransactionIdentifier"],
   );

   Map<String, dynamic> toJson() => {
      "AirtelMobileNumber": airtelMobileNumber,
      "Amount": amount,
      "ClientTransactionIdentifier": clientTransactionIdentifier,
   };
}

class PaidTransactionData {
   PaidTransactionData({
      this.amount,
      this.clientTransactionIdentifier,
      this.meterNumber,
      this.customerName,
   });

   String amount;
   String clientTransactionIdentifier;
   String meterNumber;
   String customerName;

   factory PaidTransactionData.fromRawJson(String str) => PaidTransactionData.fromJson(json.decode(str));

   String toRawJson() => json.encode(toJson());

   factory PaidTransactionData.fromJson(Map<String, dynamic> json) => PaidTransactionData(
      amount: json["Amount"],
      clientTransactionIdentifier: json["ClientTransactionIdentifier"],
      meterNumber: json["MeterNumber"],
      customerName: json["CustomerName"] == null ? null : json["CustomerName"],
   );

   Map<String, dynamic> toJson() => {
      "Amount": amount,
      "ClientTransactionIdentifier": clientTransactionIdentifier,
      "MeterNumber": meterNumber,
      "CustomerName": customerName == null ? null : customerName,
   };
}

class TransactionData {
   TransactionData({
      this.amount,
      this.clientTransactionIdentifier,
      this.paymentDetails,
      this.smartCardNumber,
      this.dstvProduct,
   });

   String amount;
   String clientTransactionIdentifier;
   String paymentDetails;
   String smartCardNumber;
   String dstvProduct;

   factory TransactionData.fromRawJson(String str) => TransactionData.fromJson(json.decode(str));

   String toRawJson() => json.encode(toJson());

   factory TransactionData.fromJson(Map<String, dynamic> json) => TransactionData(
      amount: json["Amount"],
      clientTransactionIdentifier: json["ClientTransactionIdentifier"],
      paymentDetails: json["PaymentDetails"],
      smartCardNumber: json["SmartCardNumber"],
      dstvProduct: json["DSTVProduct"] == null ? null : json["DSTVProduct"],
   );

   Map<String, dynamic> toJson() => {
      "Amount": amount,
      "ClientTransactionIdentifier": clientTransactionIdentifier,
      "PaymentDetails": paymentDetails,
      "SmartCardNumber": smartCardNumber,
      "DSTVProduct": dstvProduct == null ? null : dstvProduct,
   };
}

class DstvTransactionData {
   DstvTransactionData({
      this.addOn,
      this.amount,
      this.clientTransactionIdentifier,
      this.dstvProduct,
      this.months,
      this.paymentDetails,
      this.smartCardNumber,
      this.viewType,
   });

   String addOn;
   String amount;
   String clientTransactionIdentifier;
   String dstvProduct;
   String months;
   String paymentDetails;
   String smartCardNumber;
   String viewType;

   factory DstvTransactionData.fromRawJson(String str) => DstvTransactionData.fromJson(json.decode(str));

   String toRawJson() => json.encode(toJson());

   factory DstvTransactionData.fromJson(Map<String, dynamic> json) => DstvTransactionData(
      addOn: json["AddOn"],
      amount: json["Amount"],
      clientTransactionIdentifier: json["ClientTransactionIdentifier"],
      dstvProduct: json["DSTVProduct"],
      months: json["Months"],
      paymentDetails: json["PaymentDetails"],
      smartCardNumber: json["SmartCardNumber"],
      viewType: json["ViewType"],
   );

   Map<String, dynamic> toJson() => {
      "AddOn": addOn,
      "Amount": amount,
      "ClientTransactionIdentifier": clientTransactionIdentifier,
      "DSTVProduct": dstvProduct,
      "Months": months,
      "PaymentDetails": paymentDetails,
      "SmartCardNumber": smartCardNumber,
      "ViewType": viewType,
   };
}

class SrwbPrepaidEnquiryData {
   SrwbPrepaidEnquiryData({
      this.meterNumber,
   });

   String meterNumber;

   factory SrwbPrepaidEnquiryData.fromRawJson(String str) => SrwbPrepaidEnquiryData.fromJson(json.decode(str));

   String toRawJson() => json.encode(toJson());

   factory SrwbPrepaidEnquiryData.fromJson(Map<String, dynamic> json) => SrwbPrepaidEnquiryData(
      meterNumber: json["MeterNumber"],
   );

   Map<String, dynamic> toJson() => {
      "MeterNumber": meterNumber,
   };
}

class TnmAirtimeTopupTransactionData {
   TnmAirtimeTopupTransactionData({
      this.tnmMobileNumber,
      this.amount,
      this.clientTransactionIdentifier,
   });

   String tnmMobileNumber;
   String amount;
   String clientTransactionIdentifier;

   factory TnmAirtimeTopupTransactionData.fromRawJson(String str) => TnmAirtimeTopupTransactionData.fromJson(json.decode(str));

   String toRawJson() => json.encode(toJson());

   factory TnmAirtimeTopupTransactionData.fromJson(Map<String, dynamic> json) => TnmAirtimeTopupTransactionData(
      tnmMobileNumber: json["TNMMobileNumber"],
      amount: json["Amount"],
      clientTransactionIdentifier: json["ClientTransactionIdentifier"],
   );

   Map<String, dynamic> toJson() => {
      "TNMMobileNumber": tnmMobileNumber,
      "Amount": amount,
      "ClientTransactionIdentifier": clientTransactionIdentifier,
   };
}
