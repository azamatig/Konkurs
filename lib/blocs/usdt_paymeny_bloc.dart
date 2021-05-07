import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart' as f;
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:konkurs_app/models/cp_transaction.dart';
import 'package:konkurs_app/screens/payment/confirm_payment.dart';
import 'package:konkurs_app/screens/payment/payment_info.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/next_screen.dart';
import 'package:konkurs_app/utilities/title_wallet_text.dart';

class USDTPaymentBloc extends ChangeNotifier {
  var httpClient = Client();

  String price;
  String price25;
  String price50;
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

  Future<Response> getUSDT(String price) async {
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
      "currency1": "USDT.ERC20",
      "currency2": "USDT.ERC20",
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

  Future<void> createTransaction10USDT() async {
    var secret = utf8.encode(
        '1D2C758ca29B26f3c4541eDeC03eCdF5ee8cc0163b0107d2A4704534367b57CB');
    var bytes = utf8.encode(
        'version=1&key=bc9b1b3dcd5e2bc7aaf27fcb23f73569006ecf6e559eeecc912071774f66f380&cmd=create_transaction&amount=10&currency1=USDT.ERC20&currency2=USDT.ERC20&buyer_email=azerbaev87%40gmail.com');

    price = '10';

    Hmac hmacSha256 = Hmac(sha512, secret); // HMAC-SHA256
    Digest digest = hmacSha256.convert(bytes);

    hmac = digest.toString();
    print(digest);
  }

  Future<void> createTransaction20USDT() async {
    var secret = utf8.encode(
        '1D2C758ca29B26f3c4541eDeC03eCdF5ee8cc0163b0107d2A4704534367b57CB');
    var bytes = utf8.encode(
        'version=1&key=bc9b1b3dcd5e2bc7aaf27fcb23f73569006ecf6e559eeecc912071774f66f380&cmd=create_transaction&amount=20&currency1=ETH&currency2=ETH&buyer_email=azerbaev87%40gmail.com');
    price25 = '20';

    var hmacSha256 = Hmac(sha512, secret); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    hmac = digest;
  }

  Future<void> createTransaction30USDT() async {
    var secret = utf8.encode(
        '1D2C758ca29B26f3c4541eDeC03eCdF5ee8cc0163b0107d2A4704534367b57CB');
    var bytes = utf8.encode(
        'version=1&key=bc9b1b3dcd5e2bc7aaf27fcb23f73569006ecf6e559eeecc912071774f66f380&cmd=create_transaction&amount=30&currency1=TRX&currency2=TRX&buyer_email=azerbaev87%40gmail.com');
    price50 = '30';

    var hmacSha256 = Hmac(sha512, secret); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    hmac = digest;
  }

  Future<void> createTransactionPartner() async {
    var secret = utf8.encode(
        '1D2C758ca29B26f3c4541eDeC03eCdF5ee8cc0163b0107d2A4704534367b57CB');
    var bytes = utf8.encode(
        'version=1&key=bc9b1b3dcd5e2bc7aaf27fcb23f73569006ecf6e559eeecc912071774f66f380&cmd=create_transaction&amount=200&currency1=TRX&currency2=TRX&buyer_email=azerbaev87%40gmail.com');
    partnerPrice = '200';

    var hmacSha256 = Hmac(sha512, secret); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);
    print(digest);

    hmac = digest;
  }

  setTransid(String txid, String address, String amount, String checkout,
      String status, String userId) async {
    db
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc(txid)
        .set({
      'txHash': txid,
      'address': address,
      'amount': amount,
      'checkOutUrl': checkout,
      'status': status,
      'is_confirmed': false,
      'time': f.FieldValue.serverTimestamp(),
    });
  }

  Widget buyUSDT1(BuildContext context, String userId) {
    final popup =
        BeautifulPopup(context: context, template: TemplateBlueRocket);
    return GestureDetector(
      onTap: () {
        createTransaction10USDT().whenComplete(() => {
              getUSDT(price)
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
                  .whenComplete(() => setTransid(
                      txId, address, amount, checkOut, statusUrl, userId))
                  .whenComplete(() => nextScreen(
                      context,
                      PaymentInfoPage(
                        userId: userId,
                        qrUrl: qrUrl,
                        address: address,
                        checkOutUrl: checkOut,
                      )))
            });
        print(txId);
        print(statusUrl);
        popup.show(
          title: 'Спасибо!',
          content:
              'Ваш QR код и ссылка на оплату сформирована, перейдите по ссылкам и оплатите покупку, удобным Вам способом! \n Потом вернитесь сюда и нажмите Подтвердить оплату! \n'
              'Средства будут начислены после подтверждения',
          barrierDismissible: true,
        );
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
                text: "10\$ - 1000 gc",
                color: LightColors.kDarkBlue,
              ),
            ],
          )),
    );
  }

  Widget buyUSDT2(BuildContext context, String userId) {
    final popup =
        BeautifulPopup(context: context, template: TemplateBlueRocket);
    return GestureDetector(
      onTap: () {
        createTransaction20USDT().whenComplete(() => {
              getUSDT(price25)
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
                  .whenComplete(() => setTransid(
                      txId, address, amount, checkOut, statusUrl, userId))
                  .whenComplete(() => nextScreen(
                      context,
                      PaymentInfoPage(
                        userId: userId,
                        qrUrl: qrUrl,
                        address: address,
                        checkOutUrl: checkOut,
                      )))
            });
        popup.show(
          title: 'Спасибо!',
          content:
              'Ваш QR код и ссылка на оплату сформирована, перейдите по ссылкам и оплатите покупку, удобным Вам способом! \n Потом вернитесь сюда и в Истории оплат подтвердите что вы оплатили счет, \n'
              'Средства будут начислены после подтверждения',
          barrierDismissible: true,
        );
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
                text: "20\$ - 2000 gc",
                color: LightColors.kDarkBlue,
              ),
            ],
          )),
    );
  }

  Widget buyUSDT3(BuildContext context, String userId) {
    final popup =
        BeautifulPopup(context: context, template: TemplateBlueRocket);
    return GestureDetector(
      onTap: () {
        createTransaction30USDT().whenComplete(() => {
              getUSDT(price50)
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
                  .whenComplete(() => setTransid(
                      txId, address, amount, checkOut, statusUrl, userId))
                  .whenComplete(() => nextScreen(
                      context,
                      PaymentInfoPage(
                        userId: userId,
                        qrUrl: qrUrl,
                        address: address,
                        checkOutUrl: checkOut,
                      )))
            });
        popup.show(
          title: 'Спасибо!',
          content:
              'Ваш QR код и ссылка на оплату сформирована, перейдите по ссылкам и оплатите покупку, удобным Вам способом! \n Потом вернитесь сюда и нажмите Подтвердить оплату! \n'
              'Средства будут начислены после подтверждения',
          barrierDismissible: true,
        );
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
                text: "30\$ - 3000 gc",
                color: LightColors.kDarkBlue,
              ),
            ],
          )),
    );
  }

  Widget partnerUSDTButton(BuildContext context, String userId) {
    final popup =
        BeautifulPopup(context: context, template: TemplateBlueRocket);
    return GestureDetector(
      onTap: () {
        createTransactionPartner().whenComplete(() => {
              getUSDT(partnerPrice)
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
                  .whenComplete(() => setTransid(
                      txId, address, amount, checkOut, statusUrl, userId))
                  .whenComplete(() => nextScreen(
                      context,
                      PaymentInfoPage(
                        userId: userId,
                        qrUrl: qrUrl,
                        address: address,
                        checkOutUrl: checkOut,
                      )))
            });
        popup.show(
          title: 'Спасибо!',
          content:
              'Ваш QR код и ссылка на оплату сформирована, перейдите по ссылкам и оплатите покупку, удобным Вам способом! \n Потом вернитесь сюда и нажмите Подтвердить оплату! \n'
              'Средства будут начислены после подтверждения',
          barrierDismissible: true,
        );
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

  Widget transferUSDTButton(BuildContext context, String userId) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ConfirmPayemnt(
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
