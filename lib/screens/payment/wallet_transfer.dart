import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/blocs/payment_bloc.dart';
import 'package:konkurs_app/blocs/tron_payment_bloc.dart';
import 'package:konkurs_app/blocs/usdt_paymeny_bloc.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:provider/provider.dart';

class MoneyTransferPage extends StatefulWidget {
  final userId;

  MoneyTransferPage({Key key, this.userId}) : super(key: key);

  @override
  _MoneyTransferPageState createState() => _MoneyTransferPageState();
}

bool eth;
bool tron;
bool usdt;
String qrUrl;

class _MoneyTransferPageState extends State<MoneyTransferPage> {
  String address;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: LightColors.navyBlue1,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: backButton(),
              ),
              SizedBox(
                height: 10,
              ),
              iconsRow(),
              SizedBox(
                height: 50,
              ),
              _buttonWidget(),
            ],
          ),
        ));
  }

  Widget _buttonWidget() {
    final pb = context.watch<PaymentBloc>();
    final tb = context.watch<TRXPaymentBloc>();
    final ub = context.watch<USDTPaymentBloc>();
    return Column(
      children: <Widget>[
        eth == true
            ? Column(
                children: [
                  pb.buyButtons(context, widget.userId),
                  pb.partnerButton(context, widget.userId),
                  pb.transferButton(context, widget.userId),
                ],
              )
            : SizedBox(),
        tron == true
            ? Column(
                children: [
                  tb.buyTRX1(context, widget.userId),
                  tb.buyTRX2(context, widget.userId),
                  tb.buyTRX3(context, widget.userId),
                  tb.partnerTRXButton(context, widget.userId),
                  tb.transferTRXButton(context, widget.userId),
                ],
              )
            : SizedBox(),
        usdt == true
            ? Column(
                children: [
                  ub.buyUSDT1(context, widget.userId),
                  ub.buyUSDT2(context, widget.userId),
                  ub.buyUSDT3(context, widget.userId),
                  ub.partnerUSDTButton(context, widget.userId),
                  ub.transferUSDTButton(context, widget.userId),
                ],
              )
            : SizedBox(),
      ],
    );
  }

  Row iconsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              eth = true;
              tron = false;
              usdt = false;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: LightColors.kLavender,
                child: Icon(
                  FontAwesomeIcons.ethereum,
                  color: LightColors.yellow2,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Etherium',
                style: TextStyle(
                    color: LightColors.kLightYellow,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              eth = false;
              tron = true;
              usdt = false;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: LightColors.kLavender,
                child: Image.network(
                  'https://cdn0.iconfinder.com/data/icons/blockchain-classic/256/TRON-512.png',
                  width: 30,
                  height: 30,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'TRON',
                style: TextStyle(
                    color: LightColors.kLightYellow,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              eth = false;
              tron = false;
              usdt = true;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: LightColors.kLavender,
                child: Image.network(
                  'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency-flat/1024/Tether-USDT-icon.png',
                  width: 30,
                  height: 30,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Tether',
                style: TextStyle(
                    color: LightColors.kLightYellow,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget backButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              FontAwesomeIcons.chevronLeft,
              size: 25,
              color: LightColors.kLightYellow,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Назад',
            style: TextStyle(fontSize: 16, color: LightColors.kLightYellow),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
