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
  String qrUrl;
  final db = f.FirebaseFirestore.instance;

  HttpsCallable get10USDTCall = FirebaseFunctions.instance.httpsCallable(
      'create10USDT',
      options: HttpsCallableOptions(timeout: Duration(seconds: 7)));

  HttpsCallable get20USDTCall = FirebaseFunctions.instance.httpsCallable(
      'create20USDT',
      options: HttpsCallableOptions(timeout: Duration(seconds: 7)));

  HttpsCallable get30USDTCall = FirebaseFunctions.instance.httpsCallable(
      'create30USDT',
      options: HttpsCallableOptions(timeout: Duration(seconds: 7)));

  HttpsCallable getPartnerUSDTCall = FirebaseFunctions.instance.httpsCallable(
      'createpartnerUSDT',
      options: HttpsCallableOptions(timeout: Duration(seconds: 7)));

  Future get10USDT() async {
    try {
      final HttpsCallableResult result = await get10USDTCall.call(
        <String, dynamic>{
          'message': '1',
        },
      );
      qrUrl = result.data['qrcode'];
    } on FirebaseFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }
  }

  Future get20USDT() async {
    try {
      final HttpsCallableResult result = await get20USDTCall.call(
        <String, dynamic>{
          'message': '1',
        },
      );
      qrUrl = result.data['qrcode'];
    } on FirebaseFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }
  }

  Future get30USDT() async {
    try {
      final HttpsCallableResult result = await get30USDTCall.call(
        <String, dynamic>{
          'message': '1',
        },
      );
      qrUrl = result.data['qrcode'];
    } on FirebaseFunctionsException catch (e) {
      print('caught firebase functions exception');
    } catch (e) {
      print('caught generic exception');
      print(e);
    }
  }

  Future getPartnerUSDT() async {
    try {
      final HttpsCallableResult result = await getPartnerUSDTCall.call(
        <String, dynamic>{
          'message': '1',
        },
      );
      qrUrl = result.data['qrcode'];
    } on FirebaseFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }
  }

  setTransid(String userId, String qrUrl) async {
    db
        .collection('users')
        .doc(userId)
        .collection('web-transactions')
        .doc()
        .set({
      'qrUrl': qrUrl,
      'is_confirmed': false,
      'time': f.FieldValue.serverTimestamp(),
    });
  }

  Widget buyUSDT1(BuildContext context, String userId) {
    final popup =
        BeautifulPopup(context: context, template: TemplateBlueRocket);
    return GestureDetector(
      onTap: () {
        get10USDT().then((value) => {
              if (value != null)
                {
                  setTransid(userId, value).whenComplete(() => nextScreen(
                      context,
                      PaymentInfoPage(
                        userId: userId,
                        qrUrl: qrUrl,
                      ))),
                  notifyListeners(),
                }
              else
                {
                  popup.show(
                    title: 'Извините...',
                    content: 'Что-то пошло не так, попробуйте позже' ?? '',
                  )
                }
            });
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
        get20USDT().then((value) => {
              if (value != null)
                {
                  setTransid(userId, value).whenComplete(() => nextScreen(
                      context,
                      PaymentInfoPage(
                        userId: userId,
                        qrUrl: qrUrl,
                      ))),
                  notifyListeners(),
                }
              else
                {
                  popup.show(
                    title: 'Извините...',
                    content: 'Что-то пошло не так, попробуйте позже' ?? '',
                  )
                }
            });
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
        get30USDT().then((value) => {
              if (value != null)
                {
                  setTransid(userId, value).whenComplete(() => nextScreen(
                      context,
                      PaymentInfoPage(
                        userId: userId,
                        qrUrl: qrUrl,
                      ))),
                  notifyListeners(),
                }
              else
                {
                  popup.show(
                    title: 'Извините...',
                    content: 'Что-то пошло не так, попробуйте позже' ?? '',
                  )
                }
            });
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
        getPartnerUSDT().then((value) => {
              if (value != null)
                {
                  setTransid(userId, value).whenComplete(() => nextScreen(
                      context,
                      PaymentInfoPage(
                        userId: userId,
                        qrUrl: qrUrl,
                      ))),
                  notifyListeners(),
                }
              else
                {
                  popup.show(
                    title: 'Извините...',
                    content: 'Что-то пошло не так, попробуйте позже' ?? '',
                  )
                }
            });
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
              qrUrl: qrUrl,
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
