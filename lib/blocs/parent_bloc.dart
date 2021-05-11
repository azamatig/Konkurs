import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/services/auth_service.dart';
import 'package:konkurs_app/services/database_service.dart';

class ParentBloc extends ChangeNotifier {
  DatabaseService service = DatabaseService();
  AuthService authService = AuthService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String _uid;
  String get uid => _uid;

  String _name;
  String get name => _name;

  String _email;
  String get email => _email;

  String _imageUrl;
  String get imageUrl => _imageUrl;

  String _parentId;
  String get parentId => _parentId;

  String _grandParentId;
  String get grandParentId => _grandParentId;

  String _greatGrandParentId;
  String get greatGrandParentId => _greatGrandParentId;

  DocumentSnapshot myParentData;
  DocumentSnapshot grandParentData;
  DocumentSnapshot greatGrandParentData;

  Future getUserDatafromFirebase(uid) async {
    await firestore
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot snap) {
      this._uid = snap.data()['id'];
      this._name = snap.data()['name'];
      this._email = snap.data()['email'];
      this._imageUrl = snap.data()['profileImageUrl'];
      this._parentId = snap.data()['parent'];
    });
    notifyListeners();
  }

  Future getPartnerSetup(String uid) async {
    getUserDatafromFirebase(uid).whenComplete(() => {
          if (parentId != null)
            {
              setPartnerDepth(),
            }
        });
  }

  Future setPartnerDepth() async {
    if (parentId != null && parentId != '') {
      myParentData = await firestore.collection('users').doc(parentId).get();
      User u = User.fromFirestore(myParentData);
      _grandParentId = u.parent;
      if (u.parent != null && u.parent != '') {
        grandParentData =
            await firestore.collection('users').doc(u.parent).get();
        User gp = User.fromFirestoreLevel2(grandParentData);
        _greatGrandParentId = gp.parent;
        if (gp.parent != null && gp.parent != '') {
          greatGrandParentData =
              await firestore.collection('users').doc(gp.parent).get();
          User ggp = User.fromFirestoreLevel3(greatGrandParentData);
          if (ggp.parent != null && ggp.parent != '') {
            authService.setLevel3(greatGrandParentId, uid);
            authService.setLevel2(grandParentId, uid);
            authService.setLevel1(parentId, uid);
          }
        } else {
          authService.setLevel2(grandParentId, uid);
          authService.setLevel1(parentId, uid);
        }
      } else {
        authService.setLevel1(parentId, uid);
      }
    } else {}
  }
}
