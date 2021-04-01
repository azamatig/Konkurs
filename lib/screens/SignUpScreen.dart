import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/services/auth_service.dart';
import 'package:konkurs_app/utilities/constants.dart';

class SignupScreen extends StatefulWidget {
  static final String id = 'SignupScreen';
  String inviterId;
  SignupScreen([this.inviterId]);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _phone, _name, _email, _password;
  bool _isLoading = false;

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      // Logging in the user w/ Firebase
      AuthService.signUpUser(
          context, _phone, _name, _email, _password, widget.inviterId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/background.png"))),
          ),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'GIVE',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'APP',
                        style: TextStyle(
                            color: Color(0xffFCCD00),
                            fontSize: 32,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  Form(
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
                                labelText: 'Имя',
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
                            validator: (input) =>
                                input.trim().isEmpty ? 'Введите имя' : null,
                            onSaved: (input) => _name = input,
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
                                labelText: 'Телефон',
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
                            validator: (input) =>
                                input.trim().isEmpty ? 'Телефон' : null,
                            onSaved: (input) => _phone = input,
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
                            validator: (input) => !input.contains('@')
                                ? 'Введите действительный email'
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
                                labelText: 'Пароль',
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
                            validator: (input) => input.length < 6
                                ? 'Не меньше 6 символов'
                                : null,
                            onSaved: (input) => _password = input,
                            obscureText: true,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            _submit();
                            Future.delayed(Duration(seconds: 2));
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    backgroundColor: LightColors.kLightYellow,
                                    valueColor: AlwaysStoppedAnimation(
                                        LightColors.kBlue),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Регистрация",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.arrowCircleRight,
                                        color: Colors.orangeAccent,
                                      )
                                    ],
                                  ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.arrowCircleLeft,
                                  color: Colors.orangeAccent,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Назад",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
