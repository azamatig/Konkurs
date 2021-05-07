import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

bool pushIsOn = true;

void showAchievementView1(BuildContext context) {
  if (pushIsOn)
    Flushbar(
        title: "Ура!",
        message: "Вы теперь участник конкурса!",
        flushbarStyle: FlushbarStyle.FLOATING,
        flushbarPosition: FlushbarPosition.TOP,
        icon: Icon(
          FontAwesomeIcons.checkCircle,
          color: Colors.green[300],
        ),
        leftBarIndicatorColor: Colors.green[300],
        duration: Duration(seconds: 3))
      ..show(context);
}

void paymentSuccess(BuildContext context) {
  if (pushIsOn)
    Flushbar(
        title: "Спасибо!",
        message: "Оплата прошла успешно!",
        flushbarStyle: FlushbarStyle.FLOATING,
        flushbarPosition: FlushbarPosition.TOP,
        icon: Icon(
          FontAwesomeIcons.checkCircle,
          color: Colors.green[300],
        ),
        leftBarIndicatorColor: Colors.green[300],
        duration: Duration(seconds: 3))
      ..show(context);
}

void showAchievementView2(BuildContext context, var title, var message) {
  if (pushIsOn)
    Flushbar(
        maxWidth: 250,
        icon: Icon(
          FontAwesomeIcons.infoCircle,
          size: 28.0,
          color: Colors.blue[300],
        ),
        flushbarStyle: FlushbarStyle.FLOATING,
        leftBarIndicatorColor: Colors.blue[300],
        flushbarPosition: FlushbarPosition.TOP,
        title: title,
        message: message,
        duration: Duration(seconds: 3))
      ..show(context);
}

void showError(BuildContext context, var title, var message) {
  if (pushIsOn)
    Flushbar(
        maxWidth: 250,
        icon: Icon(
          FontAwesomeIcons.times,
          size: 28.0,
          color: Colors.red[300],
        ),
        flushbarStyle: FlushbarStyle.FLOATING,
        leftBarIndicatorColor: Colors.red[300],
        flushbarPosition: FlushbarPosition.TOP,
        title: title,
        message: message,
        duration: Duration(seconds: 3))
      ..show(context);
}
