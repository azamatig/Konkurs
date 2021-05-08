import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' show GlobalKey, NavigatorState;
import 'package:intl/intl.dart';

final _firestore = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final usersRef = _firestore.collection('users');
final postsRef = _firestore.collection('post');

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

String formatOnlyDate(DateTime dateTime) {
  if (dateTime == null) {
    return ' ';
  }
  return DateFormat('dd.MM.yyyy').format(dateTime);
}

String formatDate(DateTime dateTime) {
  if (dateTime == null) {
    return ' ';
  }
  return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
}

String formatHour(DateTime dateTime) {
  if (dateTime == null) {
    return ' ';
  }
  return DateFormat('HH:mm').format(dateTime);
}

String readTimeStamp(DateTime date) {
  var format = DateFormat.yMd();
  return format.format(date);
}

String numberFormat(String str) {
  var myInt = double.parse(str);
  assert(myInt is double);
  var format = NumberFormat("#.########");
  return format.format(myInt);
}

class LightColors {
  static const Color kLightYellow = Color(0xFFFFF9EC);
  static const Color kLightYellow2 = Color(0xFFFFE4C7);
  static const Color kLightYellow2Shadow = Color(0xFFFFD8AE);
  static const Color kDarkYellow = Color(0xFFF9BE7C);
  static const Color kPalePink = Color(0xFFFED4D6);
  static const Color kPalePinkShadow = Color(0xFFE1B8BA);

  static const Color kRed = Color(0xFFE46472);
  static const Color kLavender = Color(0xFFD5E4FE);
  static const Color kBlue = Color(0xFF6488E4);
  static const Color kLightGreen = Color(0xFFD9E6DC);
  static const Color kLightGreenShadow = Color(0xFFBDCAC0);
  static const Color kGreen = Color(0xFF309397);

  static const Color kDarkBlue = Color(0xFF0D253F);
  static const Color background = Color(0XFFFFFFFF);

  static const Color titleTextColor = const Color(0xff1d2635);
  static const Color subTitleTextColor = const Color(0xff797878);

  static const Color lightBlue1 = Color(0xff375efd);
  static const Color lightBlue2 = Color(0xff3554d3);
  static const Color navyBlue1 = Color(0xff15294a);
  static const Color lightNavyBlue = Color(0xff6d7f99);
  static const Color navyBlue2 = Color(0xff2c405b);

  static const Color yellow = Color(0xfffbbd5c);
  static const Color yellow2 = Color(0xffe7ad03);

  static const Color lightGrey = Color(0xfff1f1f3);
  static const Color grey = Color(0xffb9b9b9);
  static const Color darkgrey = Color(0xff625f6a);

  static const Color black = Color(0xff040405);
  static const Color lightblack = Color(0xff3E404D);
}

class InstagramApiConstants {
  static const igClientId = "180791680501065";
  static const igClientSecret = "9ae0b395f19b0d1a649339533a9633c0";
  static const igRedirectURL = "https://pegast.ru/";
}
