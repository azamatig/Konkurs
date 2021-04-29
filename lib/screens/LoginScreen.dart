import 'package:flutter/material.dart';
import 'package:konkurs_app/screens/SplashScreen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  final inviterId;

  const LoginScreen({Key key, this.inviterId}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      inviterId: widget.inviterId,
    );
  }
}
