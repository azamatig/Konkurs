import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konkurs_app/screens/wallet_transfer.dart';
import 'package:konkurs_app/utilities/balance_card.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/title_wallet_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:konkurs_app/models/user_data.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WalletPage extends StatefulWidget {
  WalletPage({Key key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  Widget _appBar(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            FontAwesomeIcons.chevronLeft,
            size: 25,
            color: LightColors.kLightYellow,
          ),
        ),
        Spacer(),
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(user.profileImageUrl),
        ),
      ],
    );
  }

  Widget _operationsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _icon(Icons.transfer_within_a_station, "Оплата"),
      ],
    );
  }

  Widget _icon(IconData icon, String text) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => MoneyTransferPage()));
          },
          child: Container(
            height: 80,
            width: 80,
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Color(0xfff3f3f3),
                      offset: Offset(3, 3),
                      blurRadius: 10)
                ]),
            child: Icon(icon),
          ),
        ),
        Text(text,
            style: GoogleFonts.muli(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xff76797e))),
      ],
    );
  }

  Widget _transectionList() {
    return Column(
      children: <Widget>[
        _transection("Flight Ticket", "23 Feb 2020"),
        _transection("Electricity Bill", "25 Feb 2020"),
        _transection("Flight Ticket", "03 Mar 2020"),
      ],
    );
  }

  Widget _transection(String text, String time) {
    return ListTile(
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: LightColors.navyBlue1,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Icon(Icons.hd, color: Colors.white),
      ),
      contentPadding: EdgeInsets.symmetric(),
      title: TitleText(
        text: text,
        fontSize: 14,
      ),
      subtitle: Text(time),
      trailing: Container(
          height: 30,
          width: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: LightColors.lightGrey,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Text('-20 MLR',
              style: GoogleFonts.muli(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: LightColors.navyBlue2))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    var u = Provider.of<UserData>(context).currentUserId;
    return StreamBuilder(
        stream: db.collection('users').doc(u).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(
              backgroundColor: LightColors.kLightYellow,
              valueColor: AlwaysStoppedAnimation(LightColors.kBlue),
            );
          }
          User user = User.fromDoc(snapshot.data);
          return Scaffold(
              backgroundColor: Color(0xff102733),
              body: SafeArea(
                  child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 17,
                        ),
                        _appBar(user),
                        SizedBox(
                          height: 40,
                        ),
                        TitleText(text: "Мой кошелёк"),
                        SizedBox(
                          height: 20,
                        ),
                        BalanceCard(),
                        SizedBox(
                          height: 50,
                        ),
                        TitleText(
                          text: "Операции",
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _operationsWidget(),
                        SizedBox(
                          height: 40,
                        ),
                        TitleText(
                          text: "Транзакции",
                        ),
                        _transectionList(),
                      ],
                    )),
              )));
        });
  }
}
