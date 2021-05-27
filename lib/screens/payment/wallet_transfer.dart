import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konkurs_app/blocs/payment_bloc.dart';
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
              _buttonWidget(),
            ],
          ),
        ));
  }

  Widget _buttonWidget() {
    final pb = context.watch<PaymentBloc>();
    return Column(
      children: <Widget>[
        Column(
          children: [
            pb.button1 == true ||
                    pb.button2 == true ||
                    pb.button3 == true ||
                    pb.button4 == true
                ? CircularProgressIndicator()
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Оплата с coinbase',
                            style: GoogleFonts.roboto(
                                fontSize: 12, color: LightColors.kLightYellow),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            "assets/images/coinbase.png",
                            height: 30,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      pb.buyButtons(context, widget.userId),
                      pb.buyButtons20(context, widget.userId),
                      pb.buyButtons30(context, widget.userId),
                      pb.partnerButton(context, widget.userId),
                      pb.transferButton(context, widget.userId),
                    ],
                  ),
          ],
        )
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
            style: GoogleFonts.roboto(
                fontSize: 16, color: LightColors.kLightYellow),
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
