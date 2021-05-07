import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/title_wallet_text.dart';

class ConfirmPayemnt extends StatefulWidget {
  final userId;
  final txId;

  ConfirmPayemnt({Key key, this.userId, this.txId}) : super(key: key);

  @override
  _ConfirmPayemntState createState() => _ConfirmPayemntState();
}

class _ConfirmPayemntState extends State<ConfirmPayemnt> {
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
              width: MediaQuery.of(context).size.width - 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    th.data()['txHash'] ?? '',
                    maxLines: 3,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Сумма - " + numberFormat(th.data()['amount']) + ' ETH' ??
                        '',
                    maxLines: 3,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/calender.png",
                        height: 12,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        formatOnlyDate(th.data()['time'].toDate() ?? ''),
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
          Center(child: _transferButton(th)),
        ],
      ),
    );
  }

  Widget _transferButton(DocumentSnapshot snap) {
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
    print('1232131');

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
