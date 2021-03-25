import 'package:cloud_firestore/cloud_firestore.dart' as f;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:konkurs_app/screens/AchievementView.dart';
import 'package:konkurs_app/screens/home.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/title_wallet_text.dart';
import 'package:web3dart/web3dart.dart';

class MoneyTransferPage extends StatefulWidget {
  MoneyTransferPage({Key key}) : super(key: key);

  @override
  _MoneyTransferPageState createState() => _MoneyTransferPageState();
}

final _formKey = GlobalKey<FormState>();
const String rpcUrl =
    'https://rinkeby.infura.io/v3/bbecc41e903242fea4b45ca0ab089c8e';
var httpClient = Client();
String _address;
String _txHash;
bool _isLoading = false;
final db = f.FirebaseFirestore.instance;

class _MoneyTransferPageState extends State<MoneyTransferPage> {
  Future<void> eth1() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      final client = Web3Client(rpcUrl, httpClient);
      final credentials = await client.credentialsFromPrivateKey(_address);

      var transaction = Transaction(
          to: EthereumAddress.fromHex(
              '0x1C84c95b5001372c5106F04638BF7503a80Fd64C'),
          value: EtherAmount.fromUnitAndValue(
              EtherUnit.wei, BigInt.from(100000000000000000)));
      var txHash =
          await client.sendTransaction(credentials, transaction, chainId: 4);
      _txHash = '$txHash';
    }
  }

  setTransid() async {
    db
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc(_txHash)
        .set({'txHash': _txHash});
  }

  @override
  void initState() {
    _txHash = null;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Align _buttonWidget() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            height: 150,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 125,
                      child: Text(
                        _txHash == null
                            ? 'Здесь отобразится ID транзакции'
                            : 'id транзакции: $_txHash',
                        style: TextStyle(
                            fontSize: 5,
                            fontWeight: FontWeight.w700,
                            color: LightColors.kLavender),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_txHash != null) {
                          Clipboard.setData(ClipboardData(text: _txHash)).then(
                              (value) => showAchievementView2(
                                  context, 'Скопировано', 'ID был скопирован'));
                        }
                      },
                      child: Icon(
                        FontAwesomeIcons.copy,
                        color: LightColors.kLavender,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                _transferButton()
              ],
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
              eth1().whenComplete(() => [
                    paymentSuccess(context),
                    setState(() {
                      _isLoading = false;
                    }),
                    setTransid()
                  ]);
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
                      text: "Оплата",
                      color: Colors.white,
                    ),
                  ],
                )),
          );
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
                      'Введите ваш private key от etherium кошелька',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: LightColors.kLavender),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Container(
                          width: 200,
                          height: 70,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
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
                                        color: LightColors.lightBlue1))),
                            validator: (input) =>
                                input.trim().isEmpty ? 'Введите число' : null,
                            onSaved: (input) => _address = input,
                          )),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Мы не храним данные о вашем кошельке',
                      style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: LightColors.kLavender),
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
