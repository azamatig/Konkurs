import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:konkurs_app/models/user_data.dart';
import 'package:konkurs_app/screens/LoginScreen.dart';
import 'package:konkurs_app/screens/SignUpScreen.dart';
import 'package:konkurs_app/screens/home.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'utilities/PushNotifications.dart';
import 'package:konkurs_app/screens/notifications.dart';
import 'utilities/constants.dart';
import 'screens/AchievementView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget _getScreenId() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
          return HomeScreen1(
            currentUserId: Provider.of<UserData>(context).currentUserId,
          );
        } else {
          return LoginScreen();
        }
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => UserData(),
      child: OverlaySupport(
        child: MaterialApp(
          title: 'GivrApp',
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
                  color: Colors.black,
                ),
          ),
          home: _getScreenId(),
          routes: {
            LoginScreen.id: (context) => LoginScreen(),
            SignupScreen.id: (context) => SignupScreen(),
            HomeScreen1.id: (context) => HomeScreen1(),
            Notifications.id: (context) => Notifications(),
          },
        ),
      ),
    );
  }
}
