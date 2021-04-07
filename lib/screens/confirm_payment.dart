import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                        CircularProgressIndicator();
                      }
                      var _data = snapshot.data;
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 30, bottom: 20),
                        controller: controller,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: _data.docs.length,
                        itemBuilder: (_, int index) {
                          if (index < _data.docs.length) {
                            return dataList(_data.docs[index]);
                          }
                          return Center(
                            child: new Opacity(
                              opacity: _isLoading ? 1.0 : 0.0,
                              child: new SizedBox(
                                  width: 32.0,
                                  height: 32.0,
                                  child: new CircularProgressIndicator()),
                            ),
                          );
                        },
                      );
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
                    th.data()['txHash'],
                    maxLines: 3,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Сумма - " + numberFormat(th.data()['amount']) + ' ETH',
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
                        formatOnlyDate(th.data()['time'].toDate()),
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
              if (snap.data()['amount'] == '0.0098') {
                awardPoints2000();
              }
              if (snap.data()['amount'] == '0.012') {
                awardPoints2500();
              }
              if (snap.data()['amount'] == '0.024') {
                awardPoints5000();
              }
              if (snap.data()['amount'] == '0.098') {
                setPartner();
              }
            },
            child: Container(
                width: 130,
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
                        color: LightColors.kDarkBlue,
                        size: 15,
                      ),
                    ),
                    SizedBox(width: 5),
                    TitleText(
                      text: "Подтвердить",
                      color: LightColors.kDarkBlue,
                      fontSize: 10,
                    ),
                  ],
                )),
          );
  }

  void awardPoints2000() async {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'points': FieldValue.increment(2000)});
  }

  void awardPoints2500() async {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'points': FieldValue.increment(2500)});
  }

  void awardPoints5000() async {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'points': FieldValue.increment(5000)});
  }

  void setPartner() {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'partner': true});
  }
}
