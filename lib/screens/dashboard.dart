import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/models/user_data.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/screens/pp_screen.dart';
import 'package:konkurs_app/screens/task_profile.dart';
import 'package:konkurs_app/screens/wallet_transfer.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/widgets/hand_cursor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_auth/simple_auth.dart' as simpleAuth;
import 'package:simple_auth_flutter/simple_auth_flutter.dart';

import 'my_wins.dart';
import 'settings.dart';

// ignore: must_be_immutable
class DashBoardPage extends StatefulWidget {
  final String userId;
  final String userPhoto;
  DynamicLinkParameters parameters;

  DashBoardPage(this.userId, this.userPhoto) {
    parameters = DynamicLinkParameters(
        uriPrefix: 'https://giveapp.page.link',
        link: Uri.parse(
            'https://giveapp.page.link/lib/screens/SignUpScreen/?invitedby=$userId'),
        androidParameters: AndroidParameters(
          packageName: 'konkurs.aza.com.konkurs_app',
          minimumVersion: 25,
        ),
        iosParameters: IosParameters(
          bundleId: 'com.example',
          minimumVersion: '1.0.1',
          appStoreId: '1405860595',
        ));
  }

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
  String _errorMsg;
  String _instaName;
  Map _userData;
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  List<dynamic> children;

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
          LightColors.kLightYellow,
          LightColors.kLightYellow,
          LightColors.kLightYellow,
          LightColors.kLightYellow,
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

  Future setSignIn(String data) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed_in', true);
    sp.setString('instaName', data);
    _isSignedIn = true;
  }

  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _instaName = sp.getString('instaName');
    _isSignedIn = sp.getBool('signed_in') ?? false;
  }

  final simpleAuth.InstagramApi _igApi = simpleAuth.InstagramApi(
    "instagram",
    InstagramApiConstants.igClientId,
    InstagramApiConstants.igClientSecret,
    InstagramApiConstants.igRedirectURL,
    scopes: [
      'user_profile', // For getting username, account type, etc.
      'user_media', // For accessing media count & data like posts, videos etc.
    ],
  );

  Future<void> _loginAndGetData() async {
    _igApi.authenticate().then(
      (simpleAuth.Account _user) async {
        simpleAuth.OAuthAccount user = _user;

        var igUserResponse =
            await Dio(BaseOptions(baseUrl: 'https://graph.instagram.com')).get(
          '/me',
          queryParameters: {
            // Get the fields you need.
            // https://developers.facebook.com/docs/instagram-basic-display-api/reference/user
            "fields": "username",
            "access_token": user.token,
          },
        );
        setState(() {
          _userData = igUserResponse.data;
          var instaName = _userData['username'];
          _errorMsg = null;
          setSignIn(instaName);
        });
      },
    ).catchError(
      (Object e) {
        setState(() => _errorMsg = e.toString());
      },
    );
  }

  @override
  void initState() {
    changeTheme();
    checkSignIn();
    SimpleAuthFlutter.init(context);
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
                          Spacer(),
                          Visibility(
                            visible: true,
                            child: _buildBuyingButton(),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          CircleAvatar(
                              radius: 60,
                              backgroundImage: CachedNetworkImageProvider(
                                user.profileImageUrl,
                              )),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Привет!',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          Text(
                            user.name,
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          _buildConnectiongInstagramButton(),
                        ],
                      ),
                      Container(
                        height: 350.0,
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
                                _buildGettingCoinButton(user),
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
                                      HandCursor(
                                          child: GestureDetector(
                                        onTap: _showRefUrlDialog,
                                        child: _actionList(
                                            'assets/images/ic_send.png',
                                            'Пригласить друга'),
                                      )),
                                      HandCursor(
                                          child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => MyWins(
                                                      widget.userId,
                                                      widget.userPhoto)));
                                        },
                                        child: _actionList(
                                            'assets/images/ic_money.png',
                                            'Выйгрыши'),
                                      )),
                                    ]),
                                    TableRow(children: [
                                      HandCursor(
                                          child: GestureDetector(
                                              child: _actionList(
                                                  'assets/images/ic_transact.png',
                                                  'Настройки'),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Settings(user)));
                                              })),
                                      HandCursor(
                                          child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      TaskProfileList(
                                                        userId: user.id,
                                                      )));
                                        },
                                        child: _actionList(
                                            'assets/images/ic_reward.png',
                                            'Задания'),
                                      )),
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

  Widget _buildGettingCoinButton(User user) {
    return HandCursor(
        child: GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => PartnerProgramScreen(
                      userId: widget.userId,
                    )));
      },
      child: Container(
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
                style: TextStyle(
                    color: _textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              Text(
                'Доступных койнов',
                textAlign: TextAlign.center,
                style: TextStyle(color: _iconColor, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildConnectiongInstagramButton() {
    return HandCursor(
        child: GestureDetector(
      onTap: () => {_isSignedIn == false ? _loginAndGetData() : null},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.instagram,
            size: 25,
          ),
          SizedBox(
            width: 5,
          ),
          _isSignedIn == false && _instaName == null
              ? Text('Подключить instagram')
              : Text('@' + _instaName),
        ],
      ),
    ));
  }

  Widget _buildBuyingButton() {
    return HandCursor(
        child: GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => MoneyTransferPage(
                      userId: widget.userId,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, right: 15),
        child: Column(
          children: [
            Text(
              'Купить',
              textAlign: TextAlign.center,
              style: TextStyle(color: _iconColor, fontSize: 12),
            ),
            SizedBox(
              height: 5,
            ),
            Icon(FontAwesomeIcons.wallet, size: 22, color: _iconColor),
          ],
        ),
      ),
    ));
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

  Future<dynamic> _showRefUrlDialog() async {
    final refUrl = '${Uri.base.origin}?invitedby=${widget.userId}';

    final width = MediaQuery.of(context).size.width;
    final dialogWidth = width < 550 ? 250.0 : 500.0;

    return showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            child: Container(
                width: dialogWidth,
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Row(children: [
                  HandCursor(
                      child: IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () => Clipboard.setData(
                              new ClipboardData(text: refUrl)))),
                  Flexible(
                      child: Text(
                    refUrl,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                  )),
                ])),
          );
        });
  }
}
