import 'package:flutter/material.dart';

class AppConfig {
  static const appName = "Heart String";
  static const appTagline = "Find your perfect match";
}

class AvailableFonts {
  static const primaryFont = "Quicksand";
}

class AvailableImages {
  static const man1 = {
    'assetImage': AssetImage('assets/images/man1.jpg'),
    'assetPath': 'assets/images/man1.jpg',
  };

  static const man2 = {
    'assetImage': AssetImage('assets/images/man2.jpg'),
    'assetPath': 'assets/images/man2.jpg',
  };

  static const man3 = {
    'assetImage': AssetImage('assets/images/man3.jpg'),
    'assetPath': 'assets/images/man3.jpg',
  };

  static const man4 = {
    'assetImage': AssetImage('assets/images/man4.jpg'),
    'assetPath': 'assets/images/man4.jpg',
  };

  static const man5 = {
    'assetImage': AssetImage('assets/images/man5.jpg'),
    'assetPath': 'assets/images/man5.jpg',
  };

  static const woman1 = {
    'assetImage': AssetImage('assets/images/woman1.jpg'),
    'assetPath': 'assets/images/woman1.jpg',
  };

  static const woman2 = {
    'assetImage': AssetImage('assets/images/woman2.jpg'),
    'assetPath': 'assets/images/woman2.jpg',
  };

  static const woman3 = {
    'assetImage': AssetImage('assets/images/woman3.jpg'),
    'assetPath': 'assets/images/woman3.jpg',
  };

  static const woman4 = {
    'assetImage': AssetImage('assets/images/woman4.jpg'),
    'assetPath': 'assets/images/woman4.jpg',
  };

  static const woman5 = {
    'assetImage': AssetImage('assets/images/woman5.jpg'),
    'assetPath': 'assets/images/woman5.jpg',
  };

  static const postBanner = {
    'assetImage': AssetImage('assets/images/post_banner.jpg'),
    'assetPath': 'assets/images/post_banner.jpg',
  };

  static const emptyState = {
    'assetImage': AssetImage('assets/images/empty.png'),
    'assetPath': 'assets/images/empty.png',
  };

  static const homePage = const AssetImage('assets/images/home_page.png');
  static const appLogo = const AssetImage('assets/images/logo.png');
}

double baseHeight = 640.0;

double screenAwareSize(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.height / baseHeight;
}

class PaypalColors {
  static const LightBlue = Color.fromRGBO(0, 154, 224, 1);
  static const DarkBlue = Color.fromRGBO(18, 106, 175, 1);
  static const LightGrey19 = Color.fromRGBO(112, 112, 112, 0.19);
  static const LightGrey = Color.fromRGBO(242, 242, 242, 1);
  static const Grey = Color.fromRGBO(157, 157, 157, 1);
  static const Black50 = Color.fromRGBO(0, 0, 0, 0.5);
  static const Green = Color.fromRGBO(61, 179, 158, 1);
  static const Teal = Color.fromARGB(255, 58, 204, 225);
  static const Turquois = Color.fromARGB(255, 52, 151, 253);
  static const Win = Color.fromARGB(255, 53, 58, 80);
  static const Violet = Color.fromARGB(255, 102, 94, 255);
}
