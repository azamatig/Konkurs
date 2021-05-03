import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/foundation.dart';

import 'package:konkurs_app/models/user_data.dart';
import 'package:konkurs_app/screens/splash_screen.dart';
import 'package:konkurs_app/screens/login_screen.dart';
import 'package:konkurs_app/screens/SignUpScreen.dart';
import 'package:konkurs_app/screens/home/home.dart';
import 'package:konkurs_app/screens/notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'utilities/constants.dart';

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting();
  setUrlStrategy(PathUrlStrategy());

  final Uri url = await retrieveDynamicLink();

  if (url != null) {
    final inviterId = url.queryParameters['invitedby'];
    if (inviterId != null) {
      InviterStorage(inviterId)
        ..addPoints()
        ..saveNotification()
            .whenComplete(() => runApp(MyApp(inviterId: inviterId)));
    } else {
      runApp(MyApp());
    }
  }
}

Future<Uri> retrieveDynamicLink() async {
  if (kIsWeb) {
    return Uri.base;
  }
  final PendingDynamicLinkData data =
      await FirebaseDynamicLinks.instance.getInitialLink();
  return data?.link;
}

class MyApp extends StatelessWidget {
  MyApp({Key key, this.inviterId}) : super(key: key);
  final String inviterId;

  Widget _getScreenId(String id) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
          return HomeScreen1(
            currentUserId:
                Provider.of<UserData>(context, listen: false).currentUserId,
            invitedId: id,
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
      create: (context) => UserData(),
      child: OverlaySupport(
        child: MaterialApp(
            title: 'GiveApp',
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(
                    color: Colors.black,
                  ),
            ),
            onGenerateRoute: (RouteSettings settings) {
              final routeName =
                  settings.name.replaceAll(RegExp(r'(\?|\&).+'), '');

              switch (routeName) {
                case HomeScreen1.routeName:
                  {
                    return _getPageRoute(_getScreenId(inviterId), settings);
                  }
                case LoginScreen.routeName:
                  {
                    return _getPageRoute(
                      LoginScreen(
                        inviterId: inviterId,
                      ),
                      settings,
                    );
                  }
                case SignupScreen.routeName:
                  {
                    return _getPageRoute(
                        SignupScreen(
                          inviterId: inviterId,
                        ),
                        settings);
                  }

                case Notifications.routeName:
                  {
                    return _getPageRoute(Notifications(), settings);
                  }
                default:
                  {
                    return _getPageRoute(
                        Container(
                            alignment: Alignment.center,
                            child: Text('404: Not Page')),
                        settings);
                  }
              }
            }),
      ),
    );
  }

  MaterialPageRoute _getPageRoute(Widget screen, RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => screen, settings: settings);
  }
}

class InviterStorage {
  final FirebaseFirestore _firestore;
  final String inviterId;

  InviterStorage(this.inviterId) : _firestore = FirebaseFirestore.instance;

  addPoints() {
    _firestore
        .collection('users')
        .doc(inviterId)
        .update({'points': FieldValue.increment(15)});
  }

  Future<void> saveNotification() async {
    var timestamp = FieldValue.serverTimestamp();
    final DocumentReference ref = FirebaseFirestore.instance
        .collection('users/$inviterId/notifications')
        .doc();

    var _postData = {
      'message': "+15! Вы пригласили нового пользователя!",
      'type': 1,
      'title': "Реферал!",
      'is_Unread': true,
      'ts': timestamp,
    };
    await ref.set(_postData);
  }
}
