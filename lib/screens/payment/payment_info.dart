import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/blocs/payment_bloc.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentInfoPage extends StatefulWidget {
  final String userId;
  final String address;
  final String checkOutUrl;
  final String qrUrl;

  PaymentInfoPage(
      {Key key, this.userId, this.address, this.checkOutUrl, this.qrUrl})
      : super(key: key);

  @override
  _PaymentInfoPageState createState() => _PaymentInfoPageState();
}

class _PaymentInfoPageState extends State<PaymentInfoPage> {
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
              qrPicture(),
              SizedBox(
                height: 50,
              ),
              addressWidget(),
              SizedBox(
                height: 50,
              ),
              _buttonWidget(),
              SizedBox(
                height: 50,
              ),
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
      child: CachedNetworkImage(
        imageUrl: widget.qrUrl,
      ),
    );
  }

  Widget addressWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 320,
          child: Text(
            'Адрес кошелька \n ' + widget.address,
            style: TextStyle(fontSize: 12, color: LightColors.kLightYellow),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          width: 320,
          child: Text('Ссылка на оплату \n ' + widget.checkOutUrl,
              style: TextStyle(fontSize: 12, color: LightColors.kLightYellow)),
        )
      ],
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
