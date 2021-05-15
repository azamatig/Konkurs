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

class PaymentBloc extends ChangeNotifier {
  String txId;
  String address;
  final db = f.FirebaseFirestore.instance;
  bool button1 = false;
  bool button2 = false;

  HttpsCallable get10ETHCall =
      FirebaseFunctions.instanceFor(region: "europe-west3").httpsCallable(
          'create10ETH',
          options: HttpsCallableOptions(timeout: Duration(seconds: 10)));

  HttpsCallable getPartnerETHCall =
      FirebaseFunctions.instanceFor(region: "europe-west3").httpsCallable(
          'createPartnerETH',
          options: HttpsCallableOptions(timeout: Duration(seconds: 10)));

  Future get10ETH() async {
    try {
      final HttpsCallableResult result = await get10ETHCall.call(
        <String, dynamic>{
          'message': '1',
        },
      );
      address = result.data['address'];
      txId = result.data['tx'];
    } on FirebaseFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }
  }

  Future getPartnerETH() async {
    try {
      final HttpsCallableResult result = await getPartnerETHCall.call(
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
      'is_confirmed': false,
      'type': type,
      'time': f.FieldValue.serverTimestamp(),
    });
  }

  Widget buyButtons(BuildContext context, String userId) {
    final popup =
        BeautifulPopup(context: context, template: TemplateBlueRocket);
    return GestureDetector(
      onTap: () {
        button1 = true;
        get10ETH().whenComplete(() => {
              if (address != null)
                {
                  setTransid(userId, address, txId, 0).whenComplete(() => {
                        nextScreen(
                            context,
                            PaymentInfoPage(
                              userId: userId,
                              address: address,
                            )),
                        button1 = false,
                        notifyListeners(),
                      })
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
                text: "100\$ - 10000 gc",
                color: LightColors.kDarkBlue,
              ),
            ],
          )),
    );
  }

  Widget partnerButton(BuildContext context, String userId) {
    final popup =
        BeautifulPopup(context: context, template: TemplateBlueRocket);
    return GestureDetector(
      onTap: () {
        button2 = true;
        getPartnerETH().whenComplete(() => {
              if (address != null)
                {
                  setTransid(userId, address, txId, 4).whenComplete(() => {
                        nextScreen(
                            context,
                            PaymentInfoPage(
                              userId: userId,
                              address: address,
                            )),
                        button2 = false,
                        notifyListeners(),
                      }),
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
                angle: 50,
                child: Icon(
                  FontAwesomeIcons.handshake,
                  color: LightColors.kDarkBlue,
                ),
              ),
              SizedBox(width: 10),
              TitleText(
                text: "Партнерская программа 200\$",
                color: LightColors.kDarkBlue,
              ),
            ],
          )),
    );
  }

  Widget transferButton(BuildContext context, String userId) {
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
