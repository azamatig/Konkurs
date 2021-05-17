import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
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

  var status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: LightColors.navyBlue1,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: LightColors.kLightYellow,
                  valueColor: AlwaysStoppedAnimation(LightColors.kBlue),
                ),
              )
            : Container(
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
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                          child:
                                              new CircularProgressIndicator()),
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
    final popup = BeautifulPopup(context: context, template: TemplateCoin);
    return GestureDetector(
      onTap: () {
        setState(() {
          _isLoading = true;
        });
        getTxId(snap.data()['tx']).whenComplete(() => {
              if (snap.data()['type'] == 0 &&
                  snap.data()['is_confirmed'] == false &&
                  status >= 100)
                {
                  awardPoints10000(snap),
                },
              if (snap.data()['type'] == 4 &&
                  snap.data()['is_confirmed'] == false &&
                  status >= 100)
                {
                  setPartner(snap),
                },
              // Tron
              if (snap.data()['type'] == 1 &&
                  snap.data()['is_confirmed'] == false &&
                  status >= 100)
                {
                  awardPoints1000(snap),
                },
              if (snap.data()['type'] == 2 &&
                  snap.data()['is_confirmed'] == false &&
                  status >= 100)
                {
                  awardPoints2000(snap),
                },
              if (snap.data()['type'] == 3 &&
                  snap.data()['is_confirmed'] == false &&
                  status >= 100)
                {
                  awardPoints3000(snap),
                },
              if (snap.data()['type'] == 4 &&
                  snap.data()['is_confirmed'] == false &&
                  status >= 100)
                {
                  setPartner(snap),
                },
              // USDT
              if (snap.data()['type'] == 1 &&
                  snap.data()['is_confirmed'] == false &&
                  status >= 100)
                {
                  awardPoints1000(snap),
                },
              if (snap.data()['type'] == 2 &&
                  snap.data()['is_confirmed'] == false &&
                  status >= 100)
                {
                  awardPoints2000(snap),
                },
              if (snap.data()['type'] == 3 &&
                  snap.data()['is_confirmed'] == false &&
                  status >= 100)
                {
                  awardPoints3000(snap),
                },
              if (snap.data()['type'] == 4 &&
                  snap.data()['is_confirmed'] == false &&
                  status >= 100)
                {
                  setPartner(snap),
                },
              if (status != 100)
                {
                  popup.show(
                      title: 'Инфо платежа',
                      content:
                          "Вы не можете подтвердить на данный момент, так как процесс оплаты еще не завершен в системе, попробуйте еще раз через некоторое время!",
                      barrierDismissible: true),
                },
              if (status == -1)
                {
                  popup.show(
                      title: 'Инфо платежа',
                      content: "Ваш платеж был отменен, или просрочен",
                      barrierDismissible: true),
                },

              setState(() {
                _isLoading = false;
              }),
            });
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
              SizedBox(width: 5),
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

  HttpsCallable getTx = FirebaseFunctions.instanceFor(region: "europe-west3")
      .httpsCallable('getTx',
          options: HttpsCallableOptions(timeout: Duration(seconds: 10)));

  Future getTxId(String txId) async {
    try {
      final HttpsCallableResult result = await getTx.call(
        <String, dynamic>{
          'txId': txId,
        },
      );
      status = result.data['status'];
    } on FirebaseFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }
  }

  void awardPoints10000(DocumentSnapshot snap) async {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'points': FieldValue.increment(10000)});

    var confirm = db
        .collection('users')
        .doc(widget.userId)
        .collection('web-transactions')
        .doc(snap.id);
    confirm.update({'is_confirmed': true});
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

  void awardPoints3000(DocumentSnapshot snap) async {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'points': FieldValue.increment(3000)});

    var confirm = db
        .collection('users')
        .doc(widget.userId)
        .collection('web-transactions')
        .doc(snap.id);
    confirm.update({'is_confirmed': true});
  }

  void awardPoints1000(DocumentSnapshot snap) async {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'points': FieldValue.increment(1000)});

    var confirm = db
        .collection('users')
        .doc(widget.userId)
        .collection('web-transactions')
        .doc(snap.id);
    confirm.update({'is_confirmed': true});
  }

  void setPartner(DocumentSnapshot snap) async {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'partner': true});

    var confirm = db
        .collection('users')
        .doc(widget.userId)
        .collection('web-transactions')
        .doc(snap.id);
    confirm.update({'is_confirmed': true});
  }
}
