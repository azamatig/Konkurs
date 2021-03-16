import 'package:bch_wallet/bch_wallet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/title_wallet_text.dart';

class MoneyTransferPage extends StatefulWidget {
  MoneyTransferPage({Key key}) : super(key: key);

  @override
  _MoneyTransferPageState createState() => _MoneyTransferPageState();
}

final _formKey = GlobalKey<FormState>();

String _address;

class _MoneyTransferPageState extends State<MoneyTransferPage> {
  Align _buttonWidget() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            height: 100,
            child: Column(
              children: <Widget>[_transferButton()],
            )));
  }

  Widget _transferButton() {
    return Container(
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
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            TitleText(
              text: "Оплата",
              color: Colors.white,
            ),
          ],
        ));
  }

  Widget _walletButton() {
    return GestureDetector(
      onTap: () {
        createWallet();
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
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              TitleText(
                text: "Create Wallet",
                color: Colors.white,
              ),
            ],
          )),
    );
  }

  void createWallet() async {
    await BchWallet.createWallet(
        defaultAccountName: "wallet's first account",
        name: "new wallet",
        password: "q7PWSLDQduXEvBE");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      height: 3,
                    ),
                    Text(
                      'Оплата коинов',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: 130,
                        height: 50,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: LightColors.lightBlue1,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: LightColors.lightBlue1),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: LightColors.lightBlue1),
                                ),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: LightColors.lightBlue1))))),
                    Text(
                      'Оплата временно не работает!',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
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
                top: MediaQuery.of(context).size.height * .4,
                right: -150,
                child: CircleAvatar(
                  radius: 130,
                  backgroundColor: LightColors.yellow2,
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * .4,
                right: -180,
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
                      SizedBox(width: 20),
                      TitleText(
                        text: "Оплата",
                        color: Colors.white,
                      )
                    ],
                  )),
              _buttonWidget(),
            ],
          ),
        ));
  }
}
