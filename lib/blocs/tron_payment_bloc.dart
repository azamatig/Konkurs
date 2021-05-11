import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart' as f;
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:konkurs_app/models/cp_transaction.dart';
import 'package:konkurs_app/screens/payment/confirm_payment.dart';
import 'package:konkurs_app/screens/payment/payment_info.dart';
import 'package:konkurs_app/utilities/achievements_view.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/next_screen.dart';
import 'package:konkurs_app/utilities/title_wallet_text.dart';

class TRXPaymentBloc extends ChangeNotifier {
  var httpClient = Client();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String price10;
  String price20;
  String price30;
  String partnerPrice;
  var hmac;
  var results;
  CpTransaction result;
  String qrUrl;
  String txId;
  String address;
  String checkOut;
  String statusUrl;
  String amount;
  final db = f.FirebaseFirestore.instance;

  Future<Response> getTRX(String price) async {
    const String baseUrl = 'https://www.coinpayments.net/api.php';
    Map<String, String> headers = new Map();
    headers["Content-Type"] =
        "application/x-www-form-urlencoded; charset=UTF-8";
    headers["HMAC"] = "$hmac";
    var data = {
      "version": "1",
      "key": "bc9b1b3dcd5e2bc7aaf27fcb23f73569006ecf6e559eeecc912071774f66f380",
      "cmd": "create_transaction",
      "amount": price,
      "currency1": "TRX",
      "currency2": "TRX",
      "buyer_email": "azerbaev87@gmail.com"
    };
    var parts = [];
    data.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(value)}');
    });
    var formData = parts.join('&');

    return await httpClient.post('$baseUrl', headers: headers, body: formData);
  }

  Future<void> createTransaction10TRX() async {
    var secret = utf8.encode(
        '1D2C758ca29B26f3c4541eDeC03eCdF5ee8cc0163b0107d2A4704534367b57CB');
    var bytes = utf8.encode(
        'version=1&key=bc9b1b3dcd5e2bc7aaf27fcb23f73569006ecf6e559eeecc912071774f66f380&cmd=create_transaction&amount=85&currency1=TRX&currency2=TRX&buyer_email=azerbaev87%40gmail.com');

    price10 = '85';

    Hmac hmacSha256 = Hmac(sha512, secret); // HMAC-SHA256
    Digest digest = hmacSha256.convert(bytes);

    hmac = digest.toString();
    notifyListeners();
  }

  Future<void> createTransaction25USD() async {
    var secret = utf8.encode(
        '1D2C758ca29B26f3c4541eDeC03eCdF5ee8cc0163b0107d2A4704534367b57CB');
    var bytes = utf8.encode(
        'version=1&key=bc9b1b3dcd5e2bc7aaf27fcb23f73569006ecf6e559eeecc912071774f66f380&cmd=create_transaction&amount=155&currency1=TRX&currency2=TRX&buyer_email=azerbaev87%40gmail.com');
    price20 = '155';

    var hmacSha256 = Hmac(sha512, secret); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    hmac = digest;
    notifyListeners();
  }

  Future<void> createTransaction50USD() async {
    var secret = utf8.encode(
        '1D2C758ca29B26f3c4541eDeC03eCdF5ee8cc0163b0107d2A4704534367b57CB');
    var bytes = utf8.encode(
        'version=1&key=bc9b1b3dcd5e2bc7aaf27fcb23f73569006ecf6e559eeecc912071774f66f380&cmd=create_transaction&amount=230&currency1=TRX&currency2=TRX&buyer_email=azerbaev87%40gmail.com');
    price30 = '230';

    var hmacSha256 = Hmac(sha512, secret); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    hmac = digest;
    notifyListeners();
  }

  Future<void> createTransactionPartner() async {
    var secret = utf8.encode(
        '1D2C758ca29B26f3c4541eDeC03eCdF5ee8cc0163b0107d2A4704534367b57CB');
    var bytes = utf8.encode(
        'version=1&key=bc9b1b3dcd5e2bc7aaf27fcb23f73569006ecf6e559eeecc912071774f66f380&cmd=create_transaction&amount=1515&currency1=TRX&currency2=TRX&buyer_email=azerbaev87%40gmail.com');
    partnerPrice = '1515';

    var hmacSha256 = Hmac(sha512, secret); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    hmac = digest;
    notifyListeners();
  }

  setTransid(String txid, String address, String amount, String checkout,
      String status, String userId, String qrUrl) async {
    db
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc(txid)
        .set({
      'txHash': txid,
      'address': address,
      'qrUrl': qrUrl,
      'amount': amount,
      'checkOutUrl': checkout,
      'status': status,
      'is_confirmed': false,
      'time': f.FieldValue.serverTimestamp(),
    });
  }

  Widget buyTRX1(
    BuildContext context,
    String userId,
  ) {
    return GestureDetector(
      onTap: () {
        createTransaction10TRX().whenComplete(() => {
              getTRX(price10)
                  .then((value) => {
                        results = value.body,
                        result = CpTransaction.fromJson(results),
                        qrUrl = result.result.qrcodeUrl,
                        txId = result.result.txnId,
                        address = result.result.address,
                        checkOut = result.result.checkoutUrl,
                        statusUrl = result.result.statusUrl,
                        amount = result.result.amount,
                      })
                  .whenComplete(() => setTransid(txId, address, amount,
                      checkOut, statusUrl, userId, qrUrl))
                  .whenComplete(() => nextScreen(
                      context,
                      PaymentInfoPage(
                        userId: userId,
                        qrUrl: qrUrl,
                        address: address,
                        checkOutUrl: checkOut,
                      )))
            });
        notifyListeners();
        showAchievementView2(
            context, 'Оплата формируется', 'Дождитесь открытия экарана оплаты');
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: LightColors.yellow2,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Wrap(
            children: <Widget>[
              Transform.rotate(
                angle: 70,
                child: Icon(
                  FontAwesomeIcons.coins,
                  color: LightColors.kDarkBlue,
                ),
              ),
              SizedBox(width: 5),
              TitleText(
                text: "85 TRX\\10 \$ - 1000 gc",
                color: LightColors.kDarkBlue,
              ),
            ],
          )),
    );
  }

  Widget buyTRX2(BuildContext context, String userId) {
    return GestureDetector(
      onTap: () {
        createTransaction25USD().whenComplete(() => {
              getTRX(price20)
                  .then((value) => {
                        results = value.body,
                        result = CpTransaction.fromJson(results),
                        qrUrl = result.result.qrcodeUrl,
                        txId = result.result.txnId,
                        address = result.result.address,
                        checkOut = result.result.checkoutUrl,
                        statusUrl = result.result.statusUrl,
                        amount = result.result.amount,
                      })
                  .whenComplete(() => setTransid(txId, address, amount,
                      checkOut, statusUrl, userId, qrUrl))
                  .whenComplete(() => nextScreen(
                      context,
                      PaymentInfoPage(
                        userId: userId,
                        qrUrl: qrUrl,
                        address: address,
                        checkOutUrl: checkOut,
                      )))
            });
        notifyListeners();
        showAchievementView2(
            context, 'Оплата формируется', 'Дождитесь открытия экарана оплаты');
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: LightColors.yellow2,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Wrap(
            children: <Widget>[
              Transform.rotate(
                angle: 70,
                child: Icon(
                  FontAwesomeIcons.coins,
                  color: LightColors.kDarkBlue,
                ),
              ),
              SizedBox(width: 5),
              TitleText(
                text: "155 TRX\\20 \$ - 2000 gc",
                color: LightColors.kDarkBlue,
              ),
            ],
          )),
    );
  }

  Widget buyTRX3(BuildContext context, String userId) {
    return GestureDetector(
      onTap: () {
        createTransaction50USD().whenComplete(() => {
              getTRX(price30)
                  .then((value) => {
                        results = value.body,
                        result = CpTransaction.fromJson(results),
                        qrUrl = result.result.qrcodeUrl,
                        txId = result.result.txnId,
                        address = result.result.address,
                        checkOut = result.result.checkoutUrl,
                        statusUrl = result.result.statusUrl,
                        amount = result.result.amount,
                      })
                  .whenComplete(() => setTransid(txId, address, amount,
                      checkOut, statusUrl, userId, qrUrl))
                  .whenComplete(() => nextScreen(
                      context,
                      PaymentInfoPage(
                        userId: userId,
                        qrUrl: qrUrl,
                        address: address,
                        checkOutUrl: checkOut,
                      )))
            });
        notifyListeners();
        showAchievementView2(
            context, 'Оплата формируется', 'Дождитесь открытия экарана оплаты');
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: LightColors.yellow2,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Wrap(
            children: <Widget>[
              Transform.rotate(
                angle: 70,
                child: Icon(
                  FontAwesomeIcons.coins,
                  color: LightColors.kDarkBlue,
                ),
              ),
              SizedBox(width: 5),
              TitleText(
                text: "230 TRX\\30 \$ - 3000 gc",
                color: LightColors.kDarkBlue,
              ),
            ],
          )),
    );
  }

  Widget partnerTRXButton(BuildContext context, String userId) {
    return GestureDetector(
      onTap: () {
        createTransactionPartner().whenComplete(() => {
              getTRX(partnerPrice)
                  .then((value) => {
                        results = value.body,
                        result = CpTransaction.fromJson(results),
                        qrUrl = result.result.qrcodeUrl,
                        txId = result.result.txnId,
                        address = result.result.address,
                        checkOut = result.result.checkoutUrl,
                        statusUrl = result.result.statusUrl,
                        amount = result.result.amount,
                      })
                  .whenComplete(() => setTransid(txId, address, amount,
                      checkOut, statusUrl, userId, qrUrl))
                  .whenComplete(() => nextScreen(
                      context,
                      PaymentInfoPage(
                        userId: userId,
                        qrUrl: qrUrl,
                        address: address,
                        checkOutUrl: checkOut,
                      )))
            });
        notifyListeners();
        showAchievementView2(
            context, 'Оплата формируется', 'Дождитесь открытия экарана оплаты');
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: LightColors.yellow2,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Wrap(
            children: <Widget>[
              Transform.rotate(
                angle: 50,
                child: Icon(
                  FontAwesomeIcons.handshake,
                  color: LightColors.kDarkBlue,
                ),
              ),
              SizedBox(width: 10),
              TitleText(
                text: "Партнерская программа",
                color: LightColors.kDarkBlue,
              ),
            ],
          )),
    );
  }

  Widget transferTRXButton(BuildContext context, String userId) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ConfirmPayment(
              userId: userId,
              txId: txId,
            ));
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: LightColors.yellow2,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Wrap(
            children: <Widget>[
              Transform.rotate(
                angle: 70,
                child: Icon(
                  Icons.swap_calls,
                  color: LightColors.kDarkBlue,
                ),
              ),
              SizedBox(width: 10),
              TitleText(
                text: "История оплат",
                color: LightColors.kDarkBlue,
              ),
            ],
          )),
    );
  }
}
