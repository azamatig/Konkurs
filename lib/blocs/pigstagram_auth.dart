import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_auth/simple_auth.dart' as simpleAuth;

class InstagramStuff extends ChangeNotifier {
  String instaName;
  Map _userData;
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  String errorMsg;

  Future setSignIn(String data) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed_in', true);
    sp.setString('instaName', data);
    _isSignedIn = true;
  }

  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    instaName = sp.getString('instaName');
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

  Future<void> loginAndGetData() async {
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
        _userData = igUserResponse.data;
        var instaName = _userData['username'];
        errorMsg = null;
        setSignIn(instaName);
      },
    ).catchError(
      (Object e) {
        errorMsg = e.toString();
      },
    );
  }
}
