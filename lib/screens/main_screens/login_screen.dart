import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/screens/main_screens/sign_up_screen.dart';
import 'package:konkurs_app/services/auth_service.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/next_screen.dart';

class LoginScreen extends StatefulWidget {
  final String inviterId;
  static final String id = 'login_screen';

  const LoginScreen({Key key, this.inviterId}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      AuthService.login(context, _email, _password);
    }
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
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        color: LightColors.yellow2,
                        fontSize: 25,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Любите участвовать в Конкурсах и Выигрывать Призы? Выполняйте условия Конкурсов - ставьте Лайки, делайте Репосты и Подписки!",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 5,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25.0,
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
                                borderSide: BorderSide(color: Colors.white))),
                        cursorColor: Colors.white,
                        validator: (input) => !input.contains('@')
                            ? 'Please enter a valid email'
                            : null,
                        onSaved: (input) => _email = input,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25.0,
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
                    SizedBox(height: 15.0),
                    _isLoading
                        ? LinearProgressIndicator(
                            backgroundColor: LightColors.kLightYellow2,
                            valueColor:
                                AlwaysStoppedAnimation(LightColors.kBlue),
                          )
                        : TextButton(
                            style: TextButton.styleFrom(
                              primary: LightColors.kDarkBlue,
                              backgroundColor: LightColors.yellow2,
                              onSurface: Colors.grey,
                            ),
                            onPressed: () {
                              _submit();
                            },
                            child: Container(
                              height: 45,
                              width: 265,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Войти",
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 15,
                                  )
                                ],
                              ),
                            ),
                          ),
                    SizedBox(height: 15.0),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          nextScreen(
                              context,
                              SignupScreen(
                                inviterId: widget.inviterId,
                              ));
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
                                    color: LightColors.yellow2, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
