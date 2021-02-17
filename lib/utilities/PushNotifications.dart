import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:konkurs_app/screens/AchievementView.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:konkurs_app/screens/notifications.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:overlay_support/overlay_support.dart';

class PushNotifications {
  static final PushNotifications _push = PushNotifications._internal();
  static final _firestore = FirebaseFirestore.instance;

  factory PushNotifications() {
    return _push;
  }

  var userId;

  PushNotifications._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        var notificationData = message['data'];
        if((notificationData['type'] == '1' && notificationData['to'] == userId.toString()) || notificationData['type'] == '0') {
          _firestore
              .collection('/users')
              .doc(userId)
              .collection('notifications')
              .doc()
              .set({
            'is_Unread': true,
            'message': notificationData['message'],
            'title': notificationData['title'],
            'ts': FieldValue.serverTimestamp(),
            'type': 1,
          });
          showSimpleNotification(
            Text(notificationData['title'], style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),),
            position: NotificationPosition.top,
            background: Colors.white,
            leading: Image.asset(
              "assets/images/logo.png",
              //height: 20,
            ),
            subtitle: Text(notificationData['message'],
                style: TextStyle(color: Colors.black)),
            //trailing: Text(notificationData['title']),
          );
        }
        //notificationNavigation(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        var notificationData = message['data'];

        _firestore
            .collection('/users')
            .doc(userId)
            .collection('notifications')
            .doc()
            .set({
          'is_Unread': true,
          'message': notificationData['message'],
          'title': notificationData['title'],
          'ts': FieldValue.serverTimestamp(),
          'type': 1,
        });
        notificationNavigation(message);
      },
      onResume: (Map<String, dynamic> message) async {
        var notificationData = message['data'];

        _firestore
            .collection('/users')
            .doc(userId)
            .collection('notifications')
            .doc()
            .set({
          'is_Unread': true,
          'message': notificationData['message'],
          'title': notificationData['title'],
          'ts': FieldValue.serverTimestamp(),
          'type': 1,
        });
        notificationNavigation(message);
      },
    );
  }

  notificationNavigation(Map<String, dynamic> message){
    navigatorKey.currentState.pushNamed(Notifications.id);
  }
}