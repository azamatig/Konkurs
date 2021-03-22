import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/title_wallet_text.dart';
import 'package:web3dart/web3dart.dart';

class MoneyTransferPage extends StatefulWidget {
  MoneyTransferPage({Key key}) : super(key: key);

  @override
  _MoneyTransferPageState createState() => _MoneyTransferPageState();
}

final _formKey = GlobalKey<FormState>();
const String privateKey =
    '6af6926e2b72410c9587d14ba7d8db82dbf5ac7bf138d204fdd9de8e5d8d0804';
const String rpcUrl =
    'https://rinkeby.infura.io/v3/bbecc41e903242fea4b45ca0ab089c8e';
var httpClient = Client();
String _address;

class _MoneyTransferPageState extends State<MoneyTransferPage> {
  Future<void> eth1() async {
    // start a client we can use to send transactions
    final client = Web3Client(rpcUrl, httpClient);

    final credentials = await client.credentialsFromPrivateKey(privateKey);
    final address = await credentials.extractAddress();

    print(address.hexEip55);
    print(await client.getBalance(address));

    var nonce = await client.getTransactionCount(address);
    print('nonce: $nonce');

    var blockNumber = await client.getBlockNumber();
    print('blockNumber: $blockNumber');

    var networkId = await client.getNetworkId();
    print('networkId: $networkId');

    var transaction = new Transaction(
        to: EthereumAddress.fromHex(
            '0x1E40b7962B6a7492235F49860e665251b01b304f'),
        // gasPrice: gasPrice,
        // maxGas: 21000,
        // nonce: nonce,
        value: EtherAmount.fromUnitAndValue(
            EtherUnit.wei, BigInt.from(50000000000000000)));
    var txHash =
        await client.sendTransaction(credentials, transaction, chainId: 4);
    print('transaction hash: $txHash');

    await Future.delayed(const Duration(seconds: 5));

    var receipt = await client.getTransactionReceipt(txHash);
    print('transaction receipt: $receipt');

    blockNumber = await client.getBlockNumber();
    print('blockNumber: $blockNumber');

    // get native balance again
    var balance = await client.getBalance(address);
    print(
        'balance after transaction: ${balance.getInWei} wei (${balance.getValueInUnit(EtherUnit.ether)} ether)');
  }

  @override
  void initState() {
    super.initState();
  }

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
    return GestureDetector(
      onTap: () {
        eth1();
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
