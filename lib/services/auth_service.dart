import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:konkurs_app/models/user_data.dart';
import 'package:konkurs_app/screens/main_screens/login_screen.dart';
import 'package:konkurs_app/utilities/achievements_view.dart';
import 'package:provider/provider.dart';

class AuthService {
  static final _auth = auth.FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static void signUpUser(BuildContext context, String phone, String name,
      String email, String password, String inviterId) async {
    var placeholder =
        'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';
    try {
      auth.UserCredential authResult =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      auth.User signedInUser = authResult.user;
      if (signedInUser != null) {
        _firestore.collection('/users').doc(signedInUser.uid).set({
          'name': name,
          'email': email,
          'id': signedInUser.uid,
          'profileImageUrl': placeholder,
          'phone': phone,
          'insta': '@',
          'location': 'Местонахождение',
          'points': 0,
          'eventDays': [],
          'parent': inviterId ?? '',
          'partner': false,
        });
        if (inviterId != null) {
          _firestore
              .collection('/users')
              .doc(signedInUser.uid)
              .update({'parent': inviterId});
        }
        _firestore
            .collection('/users')
            .doc(signedInUser.uid)
            .collection('transactions')
            .doc()
            .set({});
        _firestore
            .collection('/users')
            .doc(signedInUser.uid)
            .collection('notifications')
            .doc()
            .set({
          'is_Unread': true,
          'message': 'Добро пожаловать в приложени GIVEAPP, ',
          'title': 'Добро пожаловать, $name!',
          'ts': FieldValue.serverTimestamp(),
          'type': 1,
        });
        _firestore
            .collection('/users')
            .doc(signedInUser.uid)
            .collection('children')
            .doc('level1')
            .set({
          'children': [],
        });
        _firestore
            .collection('/users')
            .doc(signedInUser.uid)
            .collection('children')
            .doc('level2')
            .set({
          'children': [],
        });
        _firestore
            .collection('/users')
            .doc(signedInUser.uid)
            .collection('children')
            .doc('level3')
            .set({
          'children': [],
        });
        Provider.of<UserData>(context).currentUserId = signedInUser.uid;
      }
    } catch (e) {
      print(e);
    }
  }

  void setLevel1(String inviter, String id) {
    var userId = [id];
    _firestore
        .collection('/users')
        .doc(inviter)
        .collection('children')
        .doc('level1')
        .update({'children': FieldValue.arrayUnion(userId)});
  }

  void setLevel2(String inviter, String id) {
    var userId = [id];
    _firestore
        .collection('/users')
        .doc(inviter)
        .collection('children')
        .doc('level2')
        .update({'children': FieldValue.arrayUnion(userId)});
  }

  void setLevel3(String inviter, String id) {
    var userId = [id];
    _firestore
        .collection('/users')
        .doc(inviter)
        .collection('children')
        .doc('level3')
        .update({'children': FieldValue.arrayUnion(userId)});
  }

  static void logout() {
    _auth.signOut();
  }

  static void login(BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Navigator.pushReplacementNamed(context, LoginScreen.id);
      showError(context, 'Ошибка', 'Проверьте правильность введённых данных');
    }
  }
}
