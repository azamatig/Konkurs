import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/models/user_data.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'my_wins.dart';

class DashBoardPage extends StatefulWidget {
  final userId;
  DashBoardPage(this.userId);

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  List<Color> _backgroundColor;
  Color _iconColor;
  Color _textColor;
  List<Color> _actionContainerColor;
  Color _borderContainer;
  bool colorSwitched = false;
  var logoImage;

  void changeTheme() async {
    if (colorSwitched) {
      setState(() {
        logoImage = 'assets/images/wallet_dark_logo.png';
        _backgroundColor = [
          Color.fromRGBO(252, 214, 0, 1),
          Color.fromRGBO(251, 207, 6, 1),
          Color.fromRGBO(250, 197, 16, 1),
          Color.fromRGBO(249, 161, 28, 1),
        ];
        _iconColor = Colors.white;
        _textColor = Color.fromRGBO(253, 211, 4, 1);
        _borderContainer = Color.fromRGBO(34, 58, 90, 0.2);
        _actionContainerColor = [
          Color.fromRGBO(47, 75, 110, 1),
          Color.fromRGBO(43, 71, 105, 1),
          Color.fromRGBO(39, 64, 97, 1),
          Color.fromRGBO(34, 58, 90, 1),
        ];
      });
    } else {
      setState(() {
        logoImage = 'assets/images/wallet_logo.png';
        _borderContainer = Color.fromRGBO(252, 233, 187, 1);
        _backgroundColor = [
          Color.fromRGBO(249, 249, 249, 1),
          Color.fromRGBO(241, 241, 241, 1),
          Color.fromRGBO(233, 233, 233, 1),
          Color.fromRGBO(222, 222, 222, 1),
        ];
        _iconColor = Colors.black;
        _textColor = Colors.black;
        _actionContainerColor = [
          Color.fromRGBO(255, 212, 61, 1),
          Color.fromRGBO(255, 212, 55, 1),
          Color.fromRGBO(255, 211, 48, 1),
          Color.fromRGBO(255, 211, 43, 1),
        ];
      });
    }
  }

  @override
  void initState() {
    changeTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var uid = Provider.of<UserData>(context).currentUserId;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: usersRef.doc(uid).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              User user = User.fromDoc(snapshot.data);
              return GestureDetector(
                onLongPress: () {
                  if (colorSwitched) {
                    colorSwitched = false;
                  } else {
                    colorSwitched = true;
                  }
                  changeTheme();
                },
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
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0, top: 0),
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Icon(
                                FontAwesomeIcons.arrowLeft,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      CircleAvatar(
                          radius: 60,
                          backgroundImage: CachedNetworkImageProvider(
                            user.profileImageUrl,
                          )),
                      Column(
                        children: <Widget>[
                          Text(
                            'Привет!',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          Text(
                            user.name,
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Container(
                        height: 350.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: _borderContainer,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
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
                                  height: 70,
                                  child: Center(
                                    child: ListView(
                                      children: <Widget>[
                                        Text(
                                          '790',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: _textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30),
                                        ),
                                        Text(
                                          'Доступных койнов',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
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
                                      GestureDetector(
                                        onTap: () async {
                                          var response = await FlutterShareMe()
                                              .shareToSystem(
                                                  msg:
                                                      'ссылка на приложение будет здесь');
                                          if (response == 'success') {
                                            print('navigate success');
                                          }
                                        },
                                        child: _actionList(
                                            'assets/images/ic_send.png',
                                            'Пригласить друга'),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyWins(widget.userId)));
                                        },
                                        child: _actionList(
                                            'assets/images/ic_money.png',
                                            'Выйгрыши'),
                                      ),
                                    ]),
                                    TableRow(children: [
                                      _actionList(
                                          'assets/images/ic_transact.png',
                                          'Настройки'),
                                      _actionList('assets/images/ic_reward.png',
                                          'Задания'),
                                    ])
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
  Widget _actionList(String iconPath, String desc) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            iconPath,
            fit: BoxFit.contain,
            height: 45.0,
            width: 45.0,
            color: _iconColor,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            desc,
            style: TextStyle(color: _iconColor),
          )
        ],
      ),
    );
  }
}
