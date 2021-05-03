import 'package:flutter/material.dart';

import 'package:konkurs_app/screens/SignUpScreen.dart';
import 'package:konkurs_app/services/auth_service.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/widgets/hand_cursor.dart';

class LoginScreen extends StatefulWidget {
  final String inviterId;

  static const String routeName = '/login';

  const LoginScreen({Key key, this.inviterId}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email, _password;
  bool _isLoading = false;
  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // Logging in the user w/ Firebase
      setState(() {
        _isLoading = true;
      });

      AuthService.login(_email, _password);
    }
  }

  double get formSize {
    final size = MediaQuery.of(context).size.width;
    return size > 550 ? 400.0 : double.maxFinite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/background.png"))),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/logo.png",
                height: 50,
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "GIVE",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    "APP",
                    style: TextStyle(
                        color: Color(0xffFFA700),
                        fontSize: 25,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                "Любите участвовать в Конкурсах и Выигрывать Призы? Выполняйте условия Конкурсов - ставьте Лайки, делайте Репосты и Подписки!",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                  width: formSize,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 10.0,
                          ),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                            cursorColor: Colors.white,
                            validator: (input) => !input.contains('@')
                                ? 'Please enter a valid email'
                                : null,
                            onSaved: (input) => _email = input,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 10.0,
                          ),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                )),
                            cursorColor: LightColors.kLavender,
                            validator: (input) => input.length < 6
                                ? 'Must be at least 6 characters'
                                : null,
                            onSaved: (input) => _password = input,
                            obscureText: true,
                          ),
                        ),
                        SizedBox(
                            height: 48,
                            width: double.maxFinite,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent),
                              onPressed: () {
                                _submit();
                              },
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      backgroundColor: Colors.orangeAccent,
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                          Icon(Icons.login,
                                              color: Colors.white),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Войти",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17),
                                          )
                                        ]),
                            )),
                        SizedBox(height: 50.0),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SignupScreen(
                                            inviterId: widget.inviterId,
                                          )));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Нет аккаунта?",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  Text(
                                    " Зарегистрируйтесь здесь",
                                    style: TextStyle(
                                        color: Colors.orangeAccent,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    ));
  }
}
