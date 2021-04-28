// To parse this JSON data, do
//
//     final transactionHistory = transactionHistoryFromMap(jsonString);

import 'dart:convert';

class TransactionHistory {
  TransactionHistory({
    this.address,
    this.amount,
    this.checkOutUrl,
    this.status,
    this.txHash,
  });

  String address;
  String amount;
  String checkOutUrl;
  String status;
  String txHash;

  factory TransactionHistory.fromJson(String str) =>
      TransactionHistory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransactionHistory.fromMap(Map<String, dynamic> json) =>
      TransactionHistory(
        address: json["address"],
        amount: json["amount"],
        checkOutUrl: json["checkOutUrl"],
        status: json["status"],
        txHash: json["txHash"],
      );

  Map<String, dynamic> toMap() => {
        "address": address,
        "amount": amount,
        "checkOutUrl": checkOutUrl,
        "status": status,
        "txHash": txHash,
      };
}
