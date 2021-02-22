// To parse this JSON data, do
//
//     final balance = balanceFromMap(jsonString);

import 'dart:convert';

class Balance {
  Balance({
    this.balance,
    this.delegated,
    this.total,
    this.transactionCount,
    this.bipValue,
  });

  List<BalanceElement> balance;
  List<Delegated> delegated;
  List<Total> total;
  String transactionCount;
  String bipValue;

  factory Balance.fromJson(String str) => Balance.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Balance.fromMap(Map<String, dynamic> json) => Balance(
        balance: List<BalanceElement>.from(
            json["balance"].map((x) => BalanceElement.fromMap(x))),
        delegated: List<Delegated>.from(
            json["delegated"].map((x) => Delegated.fromMap(x))),
        total: List<Total>.from(json["total"].map((x) => Total.fromMap(x))),
        transactionCount: json["transaction_count"],
        bipValue: json["bip_value"],
      );

  Map<String, dynamic> toMap() => {
        "balance": List<dynamic>.from(balance.map((x) => x.toMap())),
        "delegated": List<dynamic>.from(delegated.map((x) => x.toMap())),
        "total": List<dynamic>.from(total.map((x) => x.toMap())),
        "transaction_count": transactionCount,
        "bip_value": bipValue,
      };
}

class BalanceElement {
  BalanceElement({
    this.coin,
    this.value,
    this.bipValue,
  });

  Coin coin;
  String value;
  String bipValue;

  factory BalanceElement.fromJson(String str) =>
      BalanceElement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BalanceElement.fromMap(Map<String, dynamic> json) => BalanceElement(
        coin: Coin.fromMap(json["coin"]),
        value: json["value"],
        bipValue: json["bip_value"],
      );

  Map<String, dynamic> toMap() => {
        "coin": coin.toMap(),
        "value": value,
        "bip_value": bipValue,
      };
}

class Coin {
  Coin({
    this.id,
    this.symbol,
  });

  String id;
  String symbol;

  factory Coin.fromJson(String str) => Coin.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Coin.fromMap(Map<String, dynamic> json) => Coin(
        id: json["id"],
        symbol: json["symbol"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "symbol": symbol,
      };
}

class Delegated {
  Delegated({
    this.coin,
    this.value,
    this.bipValue,
    this.delegateBipValue,
  });

  Coin coin;
  String value;
  String bipValue;
  String delegateBipValue;

  factory Delegated.fromJson(String str) => Delegated.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Delegated.fromMap(Map<String, dynamic> json) => Delegated(
        coin: Coin.fromMap(json["coin"]),
        value: json["value"],
        bipValue: json["bip_value"],
        delegateBipValue: json["delegate_bip_value"],
      );

  Map<String, dynamic> toMap() => {
        "coin": coin.toMap(),
        "value": value,
        "bip_value": bipValue,
        "delegate_bip_value": delegateBipValue,
      };
}

class Total {
  Total({
    this.coin,
    this.value,
    this.bipValue,
  });

  Coin coin;
  String value;
  String bipValue;

  factory Total.fromJson(String str) => Total.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Total.fromMap(Map<String, dynamic> json) => Total(
        coin: Coin.fromMap(json["coin"]),
        value: json["value"],
        bipValue: json["bip_value"],
      );

  Map<String, dynamic> toMap() => {
        "coin": coin.toMap(),
        "value": value,
        "bip_value": bipValue,
      };
}
