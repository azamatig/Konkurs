import 'package:cloud_firestore/cloud_firestore.dart' as f;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/screens/payment/confirm_payment.dart';
import 'package:konkurs_app/screens/payment/payment_info.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/next_screen.dart';
import 'package:konkurs_app/utilities/title_wallet_text.dart';

class USDTPaymentBloc extends ChangeNotifier {
  final db = f.FirebaseFirestore.instance;
  bool button1 = false;
  bool button2 = false;
  bool button3 = false;
  bool button4 = false;

  HttpsCallable get10USDTCall =
      FirebaseFunctions.instanceFor(region: "europe-west3").httpsCallable(
          'create10USDT',
          options: HttpsCallableOptions(timeout: Duration(seconds: 10)));

  HttpsCallable get20USDTCall =
      FirebaseFunctions.instanceFor(region: "europe-west3").httpsCallable(
          'create20USDT',
          options: HttpsCallableOptions(timeout: Duration(seconds: 10)));

  HttpsCallable get30USDTCall =
      FirebaseFunctions.instanceFor(region: "europe-west3").httpsCallable(
          'create30USDT',
          options: HttpsCallableOptions(timeout: Duration(seconds: 10)));

  HttpsCallable getPartnerUSDTCall =
      FirebaseFunctions.instanceFor(region: "europe-west3").httpsCallable(
          'createpartnerUSDT',
          options: HttpsCallableOptions(timeout: Duration(seconds: 10)));

  String address;

  String txId;

  Future get10USDT() async {
    try {
      final HttpsCallableResult result = await get10USDTCall.call(
        <String, dynamic>{
          'message': '1',
        },
      );
      address = result.data['address'];
      txId = result.data['tx'];
    } on FirebaseFunctionsException catch (e) {} catch (e) {}
  }

  Future get20USDT() async {
    try {
      final HttpsCallableResult result = await get20USDTCall.call(
        <String, dynamic>{
          'message': '1',
        },
      );
      address = result.data['address'];
      txId = result.data['tx'];
    } on FirebaseFunctionsException catch (e) {} catch (e) {}
  }

  Future get30USDT() async {
    try {
      final HttpsCallableResult result = await get30USDTCall.call(
        <String, dynamic>{
          'message': '1',
        },
      );
      address = result.data['address'];
      txId = result.data['tx'];
    } on FirebaseFunctionsException catch (e) {} catch (e) {}
  }

  Future getPartnerUSDT() async {
    try {
      final HttpsCallableResult result = await getPartnerUSDTCall.call(
        <String, dynamic>{
          'message': '1',
        },
      );
      address = result.data['address'];
      txId = result.data['tx'];
    } on FirebaseFunctionsException catch (e) {} catch (e) {}
  }

  setTransid(String userId, String address, String tx, int type) async {
    db
        .collection('users')
        .doc(userId)
        .collection('web-transactions')
        .doc()
        .set({
      'qrUrl': address,
      'tx': tx,
      'type': type,
      'is_confirmed': false,
      'time': f.FieldValue.serverTimestamp(),
    });
  }

  Widget buyUSDT1(BuildContext context, String userId) {
    final popup =
        BeautifulPopup(context: context, template: TemplateBlueRocket);
    return GestureDetector(
      onTap: () {
        button1 = true;
        get10USDT().whenComplete(() => {
              if (address != null)
                {
                  setTransid(userId, address, txId, 1).whenComplete(
                    () => {
                      nextScreen(
                          context,
                          PaymentInfoPage(
                            userId: userId,
                            address: address,
                          )),
                      button1 = false,
                      notifyListeners(),
                    },
                  ),
                }
              else
                {
                  popup.show(
                    title: 'Извините...',
                    content: 'Что-то пошло не так, попробуйте позже' ?? '',
                  ),
                  button1 = false,
                  notifyListeners(),
                }
            });
        notifyListeners();
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
        button2 = true;
        get20USDT().whenComplete(() => {
              if (address != null)
                {
                  setTransid(userId, address, txId, 2).whenComplete(
                    () => {
                      nextScreen(
                          context,
                          PaymentInfoPage(
                            userId: userId,
                            address: address,
                          )),
                      button2 = false,
                      notifyListeners(),
                    },
                  ),
                }
              else
                {
                  popup.show(
                    title: 'Извините...',
                    content: 'Что-то пошло не так, попробуйте позже' ?? '',
                  ),
                  button2 = false,
                  notifyListeners(),
                }
            });
        notifyListeners();
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
        button3 = true;
        get30USDT().whenComplete(() => {
              if (address != null)
                {
                  setTransid(userId, address, txId, 3).whenComplete(() => {
                        nextScreen(
                            context,
                            PaymentInfoPage(
                              userId: userId,
                              address: address,
                            )),
                        button3 = false,
                        notifyListeners(),
                      })
                }
              else
                {
                  popup.show(
                    title: 'Извините...',
                    content: 'Что-то пошло не так, попробуйте позже' ?? '',
                  ),
                  button3 = false,
                  notifyListeners(),
                }
            });
        notifyListeners();
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
        button4 = true;
        getPartnerUSDT().whenComplete(() => {
              if (address != null)
                {
                  setTransid(userId, address, txId, 4).whenComplete(() => {
                        nextScreen(
                            context,
                            PaymentInfoPage(
                              userId: userId,
                              address: address,
                            )),
                        button4 = false,
                        notifyListeners(),
                      }),
                }
              else
                {
                  popup.show(
                    title: 'Извините...',
                    content: 'Что-то пошло не так, попробуйте позже' ?? '',
                  ),
                  button4 = false,
                  notifyListeners(),
                }
            });
        notifyListeners();
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
            ConfirmPayment(
              userId: userId,
              qrUrl: address,
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
