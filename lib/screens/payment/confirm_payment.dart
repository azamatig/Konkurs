import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/title_wallet_text.dart';

class ConfirmPayment extends StatefulWidget {
  final userId;
  final qrUrl;

  ConfirmPayment({Key key, this.userId, this.qrUrl}) : super(key: key);

  @override
  _ConfirmPaymentState createState() => _ConfirmPaymentState();
}

class _ConfirmPaymentState extends State<ConfirmPayment> {
  final db = FirebaseFirestore.instance;
  ScrollController controller;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: LightColors.navyBlue1,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                  left: 0,
                  top: 30,
                  child: Row(
                    children: <Widget>[
                      BackButton(
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      TitleText(
                        text: "Назад",
                        color: Colors.white,
                      )
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 75.0),
                child: StreamBuilder(
                    stream: db
                        .collection('users')
                        .doc(widget.userId)
                        .collection('web-transactions')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return ListView.builder(
                          padding: EdgeInsets.only(top: 30, bottom: 20),
                          controller: controller,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: snapshot.data.docs.length ?? 0,
                          itemBuilder: (_, int index) {
                            if (index < snapshot.data.docs.length) {
                              return dataList(snapshot.data.docs[index]);
                            }
                            return Center(
                              child: Opacity(
                                opacity: _isLoading ? 1.0 : 0.0,
                                child: SizedBox(
                                    width: 32.0,
                                    height: 32.0,
                                    child: new CircularProgressIndicator()),
                              ),
                            );
                          },
                        );
                      }
                    }),
              ),
            ],
          ),
        ));
  }

  Widget dataList(DocumentSnapshot th) {
    final popup =
        BeautifulPopup(context: context, template: TemplateBlueRocket);
    return Container(
      height: 75,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: LightColors.navyBlue1, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    th.data()['qrUrl'] ?? '',
                    maxLines: 3,
                    style:
                        GoogleFonts.roboto(color: Colors.white, fontSize: 12),
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/calender.png",
                        height: 11,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        formatOnlyDate(th.data()['time'].toDate() ?? ''),
                        style: GoogleFonts.roboto(
                            color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, left: 5, right: 5),
            child: GestureDetector(
              onTap: () {
                popup.show(
                    title: 'Инфо платежа',
                    content: th.data()['qrUrl'],
                    barrierDismissible: true);
              },
              child: Icon(
                FontAwesomeIcons.infoCircle,
                color: LightColors.kLavender,
                size: 30,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Center(child: _confirmButton(th)),
        ],
      ),
    );
  }

  Widget _confirmButton(DocumentSnapshot snap) {
    return Container(
        width: 130,
        height: 75,
        child: Center(
          child: Row(
            children: [
              Text(
                snap.data()['is_confirmed'] == true
                    ? 'Оплачено'
                    : 'Не оплачено',
                style: GoogleFonts.roboto(color: LightColors.kLavender),
              ),
              Icon(
                snap.data()['is_confirmed'] == true
                    ? FontAwesomeIcons.check
                    : FontAwesomeIcons.times,
                color: snap.data()['is_confirmed'] == true
                    ? LightColors.kGreen
                    : LightColors.kRed,
              ),
            ],
          ),
        ));
  }

  void awardPoints2000(DocumentSnapshot snap) async {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'points': FieldValue.increment(2000)});

    var confirm = db
        .collection('users')
        .doc(widget.userId)
        .collection('web-transactions')
        .doc(snap.id);
    confirm.update({'is_confirmed': true});
  }
}
