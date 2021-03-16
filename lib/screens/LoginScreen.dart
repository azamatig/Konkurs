import 'package:flutter/material.dart';
import 'package:konkurs_app/screens/SplashScreen.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';
  String inviterId;
  LoginScreen([this.inviterId]);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(widget.inviterId);
  }
}
