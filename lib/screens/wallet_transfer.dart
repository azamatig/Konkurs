import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as f;
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:konkurs_app/models/cp_transaction.dart';
import 'package:konkurs_app/screens/AchievementView.dart';
import 'package:konkurs_app/screens/confirm_payment.dart';
import 'package:konkurs_app/screens/home.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/title_wallet_text.dart';
import 'package:url_launcher/url_launcher.dart';

class MoneyTransferPage extends StatefulWidget {
  final userId;

  MoneyTransferPage({Key key, this.userId}) : super(key: key);

  @override
  _MoneyTransferPageState createState() => _MoneyTransferPageState();
}

var httpClient = Client();
const String baseUrl = 'https://www.coinpayments.net/api.php';
bool _isLoading = false;
final db = f.FirebaseFirestore.instance;
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

class _MoneyTransferPageState extends State<MoneyTransferPage> {
  Future<Response> getTransaction(String price) async {
    Map<String, String> headers = new Map();
    headers["Content-Type"] =
        "application/x-www-form-urlencoded; charset=UTF-8";
    headers["HMAC"] = "$hmac";
    var data = {
      "version": "1",
      "key": "bc9b1b3dcd5e2bc7aaf27fcb23f73569006ecf6e559eeecc912071774f66f380",
      "cmd": "create_transaction",
      "amount": price,
      "currency1": "ETH",
      "currency2": "ETH",
      "buyer_email": "azerbaev87@gmail.com"
    };
    var parts = [];
    data.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(value)}');
    });
    var formData = parts.join('&');
    print(formData);
    return await httpClient.post('$baseUrl', headers: headers, body: formData);
  }

  Future<void> createTransaction20USD() async {
    var secret = utf8.encode(
        '1D2C758ca29B26f3c4541eDeC03eCdF5ee8cc0163b0107d2A4704534367b57CB');
    var bytes = utf8.encode(
        'version=1&key=bc9b1b3dcd5e2bc7aaf27fcb23f73569006ecf6e559eeecc912071774f66f380&cmd=create_transaction&amount=0.0098&currency1=ETH&currency2=ETH&buyer_email=azerbaev87%40gmail.com');
    setState(() {
      price = '0.0098';
    });
    Hmac hmacSha256 = Hmac(sha512, secret); // HMAC-SHA256
    Digest digest = hmacSha256.convert(bytes);

    hmac = digest.toString();
  }

  Future<void> createTransaction25USD() async {
    var secret = utf8.encode(
        '1D2C758ca29B26f3c4541eDeC03eCdF5ee8cc0163b0107d2A4704534367b57CB');
    var bytes = utf8.encode(
        'version=1&key=bc9b1b3dcd5e2bc7aaf27fcb23f73569006ecf6e559eeecc912071774f66f380&cmd=create_transaction&amount=0.012&currency1=ETH&currency2=ETH&buyer_email=azerbaev87%40gmail.com');
    setState(() {
      price25 = '0.012';
    });

    var hmacSha256 = Hmac(sha512, secret); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    hmac = digest;
  }

  Future<void> createTransaction50USD() async {
    var secret = utf8.encode(
        '1D2C758ca29B26f3c4541eDeC03eCdF5ee8cc0163b0107d2A4704534367b57CB');
    var bytes = utf8.encode(
        'version=1&key=bc9b1b3dcd5e2bc7aaf27fcb23f73569006ecf6e559eeecc912071774f66f380&cmd=create_transaction&amount=0.024&currency1=ETH&currency2=ETH&buyer_email=azerbaev87%40gmail.com');
    setState(() {
      price50 = '0.024';
    });

    var hmacSha256 = Hmac(sha512, secret); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    hmac = digest;
  }

  Future<void> createTransactionPartner() async {
    var secret = utf8.encode(
        '1D2C758ca29B26f3c4541eDeC03eCdF5ee8cc0163b0107d2A4704534367b57CB');
    var bytes = utf8.encode(
        'version=1&key=bc9b1b3dcd5e2bc7aaf27fcb23f73569006ecf6e559eeecc912071774f66f380&cmd=create_transaction&amount=0.098&currency1=ETH&currency2=ETH&buyer_email=azerbaev87%40gmail.com');
    setState(() {
      partnerPrice = '0.098';
    });
    var hmacSha256 = Hmac(sha512, secret); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);

    hmac = digest;
  }

  setTransid(String txid, String address, String amount, String checkout,
      String status) async {
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
      'time': f.FieldValue.serverTimestamp(),
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Align _buttonWidget() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            height: 110,
            child: Column(
              children: <Widget>[_transferButton()],
            )));
  }

  Widget _transferButton() {
    return _isLoading
        ? CircularProgressIndicator(
            backgroundColor: LightColors.kLightYellow,
            valueColor: AlwaysStoppedAnimation(LightColors.kBlue),
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ConfirmPayemnt(
                            userId: widget.userId,
                            txId: txId,
                          )));
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

  Widget _buyButtons() {
    final popup =
        BeautifulPopup(context: context, template: TemplateBlueRocket);
    return GestureDetector(
      onTap: () {
        createTransaction20USD().whenComplete(() => {
              getTransaction(price).then((value) => {
                    results = value.body,
                    result = CpTransaction.fromJson(results),
                    setState(() {
                      qrUrl = result.result.qrcodeUrl;
                      txId = result.result.txnId;
                      address = result.result.address;
                      checkOut = result.result.checkoutUrl;
                      statusUrl = result.result.statusUrl;
                      amount = result.result.amount;
                    }),
                  })
            });
        setTransid(txId, address, amount, checkOut, statusUrl);
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
                text: "20\$ - 2000 gc",
                color: LightColors.kDarkBlue,
              ),
            ],
          )),
    );
  }

  Widget _buyButtons2() {
    final popup =
        BeautifulPopup(context: context, template: TemplateBlueRocket);
    return GestureDetector(
      onTap: () {
        createTransaction25USD().whenComplete(() => {
              getTransaction(price25).then((value) => {
                    results = value.body,
                    result = CpTransaction.fromJson(results),
                    setState(() {
                      qrUrl = result.result.qrcodeUrl;
                      txId = result.result.txnId;
                      address = result.result.address;
                      checkOut = result.result.checkoutUrl;
                      statusUrl = result.result.statusUrl;
                      amount = result.result.amount;
                    }),
                  })
            });
        setTransid(txId, address, amount, checkOut, statusUrl);
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
                text: "25\$ - 2500 gc",
                color: LightColors.kDarkBlue,
              ),
            ],
          )),
    );
  }

  Widget _buyButtons3() {
    final popup =
        BeautifulPopup(context: context, template: TemplateBlueRocket);
    return GestureDetector(
      onTap: () {
        createTransaction50USD().whenComplete(() => {
              getTransaction(price50).then((value) => {
                    results = value.body,
                    result = CpTransaction.fromJson(results),
                    setState(() {
                      qrUrl = result.result.qrcodeUrl;
                      txId = result.result.txnId;
                      address = result.result.address;
                      checkOut = result.result.checkoutUrl;
                      statusUrl = result.result.statusUrl;
                      amount = result.result.amount;
                    }),
                  })
            });
        setTransid(txId, address, amount, checkOut, statusUrl);
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
                text: "50\$ - 5000 gc",
                color: LightColors.kDarkBlue,
              ),
            ],
          )),
    );
  }

  Widget _partnerButton() {
    final popup =
        BeautifulPopup(context: context, template: TemplateBlueRocket);
    return GestureDetector(
      onTap: () {
        createTransactionPartner().whenComplete(() => {
              getTransaction(partnerPrice).then((value) => {
                    results = value.body,
                    result = CpTransaction.fromJson(results),
                    setState(() {
                      qrUrl = result.result.qrcodeUrl;
                      txId = result.result.txnId;
                      address = result.result.address;
                      checkOut = result.result.checkoutUrl;
                      statusUrl = result.result.statusUrl;
                      amount = result.result.amount;
                    }),
                  })
            });
        setTransid(txId, address, amount, checkOut, statusUrl);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: LightColors.navyBlue1,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Container(
                      height: 55,
                      width: 60,
                      child: Icon(
                        FontAwesomeIcons.coins,
                        color: LightColors.yellow2,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        'Все покупки производятся в криптовалюте Ethereum',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: LightColors.kRed, fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    qrUrl != null
                        ? Container(
                            width: 125,
                            height: 125,
                            decoration: BoxDecoration(
                              color: LightColors.kLightYellow2,
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: CachedNetworkImageProvider(
                                    result.result.qrcodeUrl),
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                        child: Text(
                      txId,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: LightColors.kDarkYellow, fontSize: 12),
                    )),
                    SizedBox(
                      height: 5,
                    ),
                    address != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  'Адрес кошелька оплаты с ETH \n' + address,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (result.result.address != null) {
                                    Clipboard.setData(ClipboardData(
                                            text: result.result.address))
                                        .then((value) => showAchievementView2(
                                            context,
                                            'Скопировано',
                                            'Адрес был скопирован'));
                                  }
                                },
                                child: Icon(
                                  FontAwesomeIcons.copy,
                                  size: 25,
                                  color: LightColors.kLightYellow2,
                                ),
                              )
                            ],
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 5,
                    ),
                    checkOut != null
                        ? GestureDetector(
                            onTap: () {
                              setUrl(checkOut);
                            },
                            child: Center(
                              child: Text(
                                'Ссылка оплаты \n' + checkOut,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: LightColors.kDarkYellow,
                                    fontSize: 12),
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 15,
                    ),
                    _buyButtons(),
                    _buyButtons2(),
                    _buyButtons3(),
                    _partnerButton(),
                    Expanded(
                      flex: 2,
                      child: SizedBox(),
                    )
                  ],
                ),
              ),
              Positioned(
                left: -140,
                top: -270,
                child: CircleAvatar(
                  radius: 190,
                  backgroundColor: LightColors.lightBlue2,
                ),
              ),
              Positioned(
                left: -130,
                top: -300,
                child: CircleAvatar(
                  radius: 190,
                  backgroundColor: LightColors.lightBlue1,
                ),
              ),
              Positioned(
                top: -100,
                right: -180,
                child: CircleAvatar(
                  radius: 130,
                  backgroundColor: LightColors.yellow2,
                ),
              ),
              Positioned(
                top: -100,
                right: -210,
                child: CircleAvatar(
                  radius: 130,
                  backgroundColor: LightColors.yellow,
                ),
              ),
              Positioned(
                  left: 0,
                  top: 40,
                  child: Row(
                    children: <Widget>[
                      BackButton(
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      TitleText(
                        text: "Назад",
                        color: Colors.white,
                      )
                    ],
                  )),
              _buttonWidget(),
            ],
          ),
        ));
  }

  void setUrl(String urlString) async {
    var url = urlString;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
