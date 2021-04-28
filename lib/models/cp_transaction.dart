// To parse this JSON data, do
//
//     final cpTransaction = cpTransactionFromMap(jsonString);

import 'dart:convert';

class CpTransaction {
  CpTransaction({
    this.error,
    this.result,
  });

  String error;
  Result result;

  factory CpTransaction.fromJson(String str) =>
      CpTransaction.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CpTransaction.fromMap(Map<String, dynamic> json) => CpTransaction(
        error: json["error"],
        result: Result.fromMap(json["result"]),
      );

  Map<String, dynamic> toMap() => {
        "error": error,
        "result": result.toMap(),
      };
}

class Result {
  Result({
    this.amount,
    this.txnId,
    this.address,
    this.confirmsNeeded,
    this.timeout,
    this.checkoutUrl,
    this.statusUrl,
    this.qrcodeUrl,
  });

  String amount;
  String txnId;
  String address;
  String confirmsNeeded;
  int timeout;
  String checkoutUrl;
  String statusUrl;
  String qrcodeUrl;

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        amount: json["amount"],
        txnId: json["txn_id"],
        address: json["address"],
        confirmsNeeded: json["confirms_needed"],
        timeout: json["timeout"],
        checkoutUrl: json["checkout_url"],
        statusUrl: json["status_url"],
        qrcodeUrl: json["qrcode_url"],
      );

  Map<String, dynamic> toMap() => {
        "amount": amount,
        "txn_id": txnId,
        "address": address,
        "confirms_needed": confirmsNeeded,
        "timeout": timeout,
        "checkout_url": checkoutUrl,
        "status_url": statusUrl,
        "qrcode_url": qrcodeUrl,
      };
}
