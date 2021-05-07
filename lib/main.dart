import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:konkurs_app/blocs/parent_bloc.dart';
import 'package:konkurs_app/blocs/payment_bloc.dart';
import 'package:konkurs_app/blocs/pigstagram_auth.dart';
import 'package:konkurs_app/blocs/tron_payment_bloc.dart';
import 'package:konkurs_app/blocs/usdt_paymeny_bloc.dart';
import 'package:konkurs_app/models/user_data.dart';
import 'package:konkurs_app/screens/auxillary/notifications.dart';
import 'package:konkurs_app/screens/main_screens/home.dart';
import 'package:konkurs_app/screens/main_screens/login_screen.dart';
import 'package:konkurs_app/screens/main_screens/sign_up_screen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'utilities/constants.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

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
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await retrieveDynamicLink().whenComplete(() => runApp(MyApp(inviterId)));
}

String inviterId;

Future<void> retrieveDynamicLink() async {
  final PendingDynamicLinkData data =
      await FirebaseDynamicLinks.instance.getInitialLink();
  final Uri deepLink = data?.link;
  if (deepLink != null) {
    deepLink.queryParameters.forEach((k, v) async {
      if (k == "invitedby") {
        var firestore = FirebaseFirestore.instance;
        inviterId = v;
        var timestamp = FieldValue.serverTimestamp();
        final DocumentReference ref =
            firestore.collection('users/$inviterId/notifications').doc();
        var _postData = {
          'message': "Вы пригласили нового пользователя!",
          'type': 1,
          'title': "Реферал!",
          'is_Unread': true,
          'ts': timestamp,
        };
        await ref.set(_postData);
      }
    });
    return deepLink.toString();
  }
}

class MyApp extends StatelessWidget {
  String inviterId;
  MyApp([this.inviterId]);

  Widget _getScreenId(String id) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Provider.of<UserData>(context).currentUserId = snapshot.data.uid;
          return HomeScreen(
            currentUserId:
                Provider.of<UserData>(context, listen: false).currentUserId,
          );
        } else {
          return LoginScreen(
            inviterId: id,
          );
        }
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ParentBloc()),
        ChangeNotifierProvider(create: (context) => USDTPaymentBloc()),
        ChangeNotifierProvider(create: (context) => TRXPaymentBloc()),
        ChangeNotifierProvider(create: (context) => PaymentBloc()),
        ChangeNotifierProvider(create: (context) => InstagramStuff()),
        ChangeNotifierProvider(
          create: (context) => UserData(),
        )
      ],
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
          home: _getScreenId(inviterId),
          routes: {
            LoginScreen.id: (context) => LoginScreen(),
            SignupScreen.id: (context) => SignupScreen(),
            HomeScreen.id: (context) => HomeScreen(),
            Notifications.id: (context) => Notifications(),
          },
        ),
      ),
    );
  }
}
