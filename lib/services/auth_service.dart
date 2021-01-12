import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:konkurs_app/models/user_data.dart';
import 'package:provider/provider.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static void signUpUser(
      BuildContext context, String name, String email, String password) async {
    var placeholder =
        'https://lh3.googleusercontent.com/proxy/keRqNlAaDt-yVRvFlc9RTITCilT5T7mep3tmcELK67d0dG1eEcKbGttr0TV6Zhrd3eGZ71ndBBkPt5FekS5qyQn9eqPIb4xuo6cHEL5PC-o0S5i2OmuddBK_wEMepSiB13-VMLSqLYjyW_IdONAhE4wb-723MeifJzyklZlUaZlLgrBfIxifvTbpV10UEnc09GP4r463OodDujkISbKJvh-F0ZE';
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser signedInUser = authResult.user;
      if (signedInUser != null) {
        _firestore.collection('/users').doc(signedInUser.uid).set({
          'name': name,
          'email': email,
          'profileImageUrl': placeholder,
          'bio': 'Напишите о себе',
          'age': 'Возраст',
          'location': 'Местонахождение'
        });
        Provider.of<UserData>(context).currentUserId = signedInUser.uid;
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  static void logout() {
    _auth.signOut();
  }

  static void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
  }
}
