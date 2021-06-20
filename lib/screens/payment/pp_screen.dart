import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/utilities/constants.dart';

// ignore: must_be_immutable
class PartnerProgramScreen extends StatefulWidget {
  final String userId;
  final String userPhoto;

  const PartnerProgramScreen({Key key, this.userId, this.userPhoto})
      : super(key: key);

  @override
  _PartnerProgramScreenState createState() => _PartnerProgramScreenState();
}

class _PartnerProgramScreenState extends State<PartnerProgramScreen> {
  List<Color> _backgroundColor;
  Color _iconColor;
  Color _textColor;
  List<Color> _actionContainerColor;
  Color _borderContainer;
  bool colorSwitched = false;
  List<dynamic> children;
  List<dynamic> children1;
  List<dynamic> children2;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _isLoading = true;

  Future getParticipants() async {
    DocumentSnapshot level1 = await firestore
        .collection('users')
        .doc(widget.userId)
        .collection('children')
        .doc('level1')
        .get();
    children = level1['children'];

    DocumentSnapshot level2 = await firestore
        .collection('users')
        .doc(widget.userId)
        .collection('children')
        .doc('level2')
        .get();
    setState(() {
      children1 = level2['children'];
    });

    DocumentSnapshot level3 = await firestore
        .collection('users')
        .doc(widget.userId)
        .collection('children')
        .doc('level3')
        .get();
    setState(() {
      children2 = level3['children'];
    });
  }

  @override
  void initState() {
    getParticipants().whenComplete(() => {
          if (children != null && children1 != null && children2 != null)
            {
              setState(() {
                _isLoading = false;
              })
            }
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _backgroundColor = [
      LightColors.kLightYellow,
      LightColors.kLightYellow,
      LightColors.kLightYellow,
      LightColors.kLightYellow,
    ];
    _actionContainerColor = [
      Color.fromRGBO(255, 212, 61, 1),
      Color.fromRGBO(255, 212, 55, 1),
      Color.fromRGBO(255, 211, 48, 1),
      Color.fromRGBO(255, 211, 43, 1),
    ];
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: usersRef.doc(widget.userId).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              User user = User.fromDoc(snapshot.data);
              return GestureDetector(
                onLongPress: () {},
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [0.2, 0.3, 0.5, 0.8],
                          colors: _backgroundColor)),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, top: 15),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  child: Container(
                                      color: LightColors.kLightYellow,
                                      height: 40,
                                      width: 40,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Icon(
                                            FontAwesomeIcons.chevronLeft,
                                            size: 25,
                                            color: LightColors.kDarkBlue,
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          user.partner == true
                              ? Icon(
                                  FontAwesomeIcons.checkCircle,
                                  color: LightColors.kGreen,
                                  size: 100,
                                )
                              : Icon(
                                  FontAwesomeIcons.timesCircle,
                                  color: LightColors.kRed,
                                  size: 30,
                                ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Ваш статус!',
                            style: GoogleFonts.roboto(
                                fontSize: 18, color: Colors.black),
                          ),
                          Text(
                            user.partner == true
                                ? 'Вы партнер'
                                : 'Вы не партнер',
                            style: GoogleFonts.roboto(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        height: 270.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: _borderContainer,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25))),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25)),
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    stops: [0.2, 0.4, 0.6, 0.8],
                                    colors: _actionContainerColor)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          FontAwesomeIcons.coins,
                                          size: 30,
                                          color: _iconColor,
                                        ),
                                        Text(
                                          user.points.toString(),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
                                              color: _textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30),
                                        ),
                                        Text(
                                          'Доступных койнов',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.roboto(
                                              color: _iconColor, fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 0.5,
                                  color: Colors.grey,
                                ),
                                Table(
                                  border: TableBorder.symmetric(
                                    inside: BorderSide(
                                        color: Colors.grey,
                                        style: BorderStyle.solid,
                                        width: 0.5),
                                  ),
                                  children: [
                                    TableRow(children: [
                                      _isLoading == true
                                          ? Center(
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    LightColors.kDarkBlue,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : children.length != null
                                              ? _actionList(
                                                  children.length.toString() ??
                                                      'Нет данных',
                                                  "Уровень 1")
                                              : _actionList(
                                                  'Нет данных', 'Уровень 1'),
                                      _isLoading == true
                                          ? Center(
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    LightColors.kDarkBlue,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : children1.length != null
                                              ? _actionList(
                                                  children1.length.toString(),
                                                  "Уровень 2")
                                              : _actionList(
                                                  'Нет данных', 'Уровень 2'),
                                      _isLoading == true
                                          ? Center(
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    LightColors.kDarkBlue,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : children2.length != null
                                              ? _actionList(
                                                  children2.length.toString(),
                                                  "Уровень 3")
                                              : _actionList(
                                                  'Нет данных', 'Уровень 3'),
                                    ]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

// custom action widget
  Widget _actionList(String desc, String level) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            level,
            style: GoogleFonts.roboto(color: _iconColor),
          ),
          SizedBox(
            height: 8,
          ),
          Icon(FontAwesomeIcons.userFriends),
          SizedBox(
            height: 8,
          ),
          Text(
            desc,
            style: GoogleFonts.roboto(color: _iconColor),
          )
        ],
      ),
    );
  }
}
