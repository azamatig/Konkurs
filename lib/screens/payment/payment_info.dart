import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konkurs_app/blocs/payment_bloc.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentInfoPage extends StatefulWidget {
  final String userId;
  final String address;
  final bool isLoading;

  PaymentInfoPage({Key key, this.userId, this.address, this.isLoading})
      : super(key: key);

  @override
  _PaymentInfoPageState createState() => _PaymentInfoPageState();
}

class _PaymentInfoPageState extends State<PaymentInfoPage> {
  bool copied = false;

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
                height: 25,
              ),
              infoText(),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  qrPicture(),
                  SizedBox(
                    width: 10,
                  ),
                  copyText(),
                ],
              ),
              SizedBox(
                height: 25,
              ),
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

  Widget qrPicture() {
    return Container(
      child: Text(
        widget.address == null
            ? 'Ошибка данных...попробуйте снова'
            : widget.address,
        style: GoogleFonts.roboto(fontSize: 14, color: LightColors.yellow),
      ),
    );
  }

  Widget copyText() {
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: LightColors.yellow2),
      onPressed: () => {
        Clipboard.setData(ClipboardData(text: widget.address)),
        setState(() {
          copied = true;
        }),
      },
      child: copied == true
          ? Icon(
              FontAwesomeIcons.checkCircle,
              color: LightColors.kGreen,
            )
          : Icon(
              FontAwesomeIcons.copy,
              color: LightColors.kDarkBlue,
            ),
    );
  }

  Widget infoText() {
    return Container(
      width: 350,
      child: Text(
        'Ваш QR код и ссылка на оплату сформирована, перейдите по ссылкам и оплатите покупку, удобным Вам способом! \n Потом вернитесь в историю оплат и нажмите Подтвердить оплату! \n'
        'Средства будут начислены после подтверждения',
        style: TextStyle(fontSize: 14, color: LightColors.kPalePink),
      ),
    );
  }

  Widget _buttonWidget() {
    final pb = context.watch<PaymentBloc>();
    return Column(
      children: <Widget>[
        Column(
          children: [
            pb.transferButton(context, widget.userId),
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
            style: TextStyle(fontSize: 16, color: LightColors.kLightYellow),
          )
        ],
      ),
    );
  }
}
