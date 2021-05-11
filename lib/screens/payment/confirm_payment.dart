import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/title_wallet_text.dart';

class ConfirmPayment extends StatefulWidget {
  final userId;
  final txId;

  ConfirmPayment({Key key, this.userId, this.txId}) : super(key: key);

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
                left: -140,
                top: -300,
                child: CircleAvatar(
                  radius: 190,
                  backgroundColor: LightColors.lightBlue2,
                ),
              ),
              Positioned(
                left: -130,
                top: -330,
                child: CircleAvatar(
                  radius: 190,
                  backgroundColor: LightColors.lightBlue1,
                ),
              ),
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
                        .collection('transactions')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        Center(child: CircularProgressIndicator());
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
                      return CircularProgressIndicator();
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
                    th.data()['txHash'] ?? '',
                    maxLines: 3,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    "Сумма - " + numberFormat(th.data()['amount']) ?? '',
                    maxLines: 3,
                    style: TextStyle(color: Colors.white, fontSize: 12),
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
                        style: TextStyle(color: Colors.white, fontSize: 12),
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
                    content: th.data()['checkOutUrl'] ?? '',
                    actions: [
                      Container(
                          child: CachedNetworkImage(
                              width: 175,
                              height: 175,
                              imageUrl: th.data()['qrUrl'] ?? '')),
                    ],
                    barrierDismissible: true);
              },
              child: Icon(
                FontAwesomeIcons.infoCircle,
                color: LightColors.kLavender,
                size: 30,
              ),
            ),
          ),
          Center(child: _confirmButton(th)),
        ],
      ),
    );
  }

  Widget _confirmButton(DocumentSnapshot snap) {
    return _isLoading
        ? CircularProgressIndicator(
            backgroundColor: LightColors.kLightYellow,
            valueColor: AlwaysStoppedAnimation(LightColors.kBlue),
          )
        : GestureDetector(
            onTap: () {
              if (snap.data()['amount'] == '0.00980000' &&
                  snap.data()['is_confirmed'] == false) {
                awardPoints2000(snap.data()['txHash']);
              }
              if (snap.data()['amount'] == '0.01200000' &&
                  snap.data()['is_confirmed'] == false) {
                awardPoints2500(snap.data()['txHash']);
              }
              if (snap.data()['amount'] == '0.02400000' &&
                  snap.data()['is_confirmed'] == false) {
                awardPoints5000(snap.data()['txHash']);
              }
              if (snap.data()['amount'] == '0.09800000' &&
                  snap.data()['is_confirmed'] == false) {
                setPartner(snap.data()['txHash']);
              }
              // Tron
              if (snap.data()['amount'] == '85.00000000' &&
                  snap.data()['is_confirmed'] == false) {
                awardPoints1000(snap.data()['txHash']);
              }
              if (snap.data()['amount'] == '155.00000000' &&
                  snap.data()['is_confirmed'] == false) {
                awardPoints2000(snap.data()['txHash']);
              }
              if (snap.data()['amount'] == '230.00000000' &&
                  snap.data()['is_confirmed'] == false) {
                awardPoints3000(snap.data()['txHash']);
              }
              if (snap.data()['amount'] == '1515.00000000' &&
                  snap.data()['is_confirmed'] == false) {
                setPartner(snap.data()['txHash']);
              }
              // USDT
              if (snap.data()['amount'] == '163.02000000' &&
                  snap.data()['is_confirmed'] == false) {
                awardPoints1000(snap.data()['txHash']);
              }
              if (snap.data()['amount'] == '285.48000000' &&
                  snap.data()['is_confirmed'] == false) {
                awardPoints2000(snap.data()['txHash']);
              }
              if (snap.data()['amount'] == '405.37000000' &&
                  snap.data()['is_confirmed'] == false) {
                awardPoints3000(snap.data()['txHash']);
              }
              if (snap.data()['amount'] == '2480.37000000' &&
                  snap.data()['is_confirmed'] == false) {
                setPartner(snap.data()['txHash']);
              }
            },
            child: Container(
                width: 130,
                margin: EdgeInsets.only(bottom: 20, right: 15),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                    color: snap.data()['is_confirmed'] == true
                        ? LightColors.kGreen
                        : LightColors.yellow2,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Wrap(
                  children: <Widget>[
                    Transform.rotate(
                      angle: 70,
                      child: Icon(
                        FontAwesomeIcons.moneyBill,
                        color: LightColors.kDarkBlue,
                        size: 12,
                      ),
                    ),
                    SizedBox(width: 10),
                    TitleText(
                      text: snap.data()['is_confirmed'] == true
                          ? "Оплачено"
                          : "Подтвердить",
                      color: LightColors.kDarkBlue,
                      fontSize: 10,
                    ),
                  ],
                )),
          );
  }

  void awardPoints2000(String transId) async {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'points': FieldValue.increment(2000)});

    var confirm = db
        .collection('users')
        .doc(widget.userId)
        .collection('transactions')
        .doc(transId);
    confirm.update({'is_confirmed': true});
  }

  void awardPoints1000(String transId) async {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'points': FieldValue.increment(1000)});

    var confirm = db
        .collection('users')
        .doc(widget.userId)
        .collection('transactions')
        .doc(transId);
    confirm.update({'is_confirmed': true});
  }

  void awardPoints3000(String transId) async {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'points': FieldValue.increment(3000)});

    var confirm = db
        .collection('users')
        .doc(widget.userId)
        .collection('transactions')
        .doc(transId);
    confirm.update({'is_confirmed': true});
  }

  void awardPoints2500(String transId) async {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'points': FieldValue.increment(2500)});

    var confirm = db
        .collection('users')
        .doc(widget.userId)
        .collection('transactions')
        .doc(transId);
    confirm.update({'is_confirmed': true});
  }

  void awardPoints5000(String transId) async {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'points': FieldValue.increment(5000)});

    var confirm = db
        .collection('users')
        .doc(widget.userId)
        .collection('transactions')
        .doc(transId);
    confirm.update({'is_confirmed': true});
  }

  void setPartner(String transId) {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'partner': true});

    var confirm = db
        .collection('users')
        .doc(widget.userId)
        .collection('transactions')
        .doc(transId);
    confirm.update({'is_confirmed': true});
  }
}
