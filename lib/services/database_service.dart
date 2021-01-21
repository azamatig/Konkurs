import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:konkurs_app/models/message.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/utilities/constants.dart';

class DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StorageReference _storageReference;
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Message _message;

  static void updateUser(User user) {
    usersRef.doc(user.id).update({
      'name': user.name,
      'profileImageUrl': user.profileImageUrl,
      'insta': user.insta,
      'phone': user.phone,
      'location': user.location,
    });
  }

  static Future<QuerySnapshot> searchUsers(String name) {
    Future<QuerySnapshot> users =
        usersRef.where('name', isGreaterThanOrEqualTo: name).get();
    return users;
  }

  static Future<QuerySnapshot> isFinished() {
    Future<QuerySnapshot> post =
        postsRef.where('isFinished', isEqualTo: true).get();
    return post;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<void> addMessageToDb(Message message, String receiverUid) async {
    var map = message.toMap();

    await _firestore
        .collection("messages")
        .doc(message.senderUid)
        .collection(receiverUid)
        .add(map);

    return _firestore
        .collection("messages")
        .doc(receiverUid)
        .collection(message.senderUid)
        .add(map);
  }

  Future<List<User>> fetchAllUsers(FirebaseUser user) async {
    List<User> userList = List<User>();
    QuerySnapshot querySnapshot = await _firestore.collection("users").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        userList.add(User.fromMap(querySnapshot.docs[i].data()));
        //userList.add(querySnapshot.documents[i].data[User.fromMap(mapData)]);
      }
    }
    print("USERSLIST : ${userList.length}");
    return userList;
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    return url;
  }

  Future<void> getUserInfo() async {
    User currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc((await FirebaseAuth.instance.currentUser()).uid)
        .get();
    return currentUser;
  }

  void uploadImageMsgToDb(String url, String receiverUid, String senderuid) {
    _message = Message.withoutMessage(
        receiverUid: receiverUid,
        senderUid: senderuid,
        photoUrl: url,
        timestamp: FieldValue.serverTimestamp(),
        type: 'image');
    var map = Map<String, dynamic>();
    map['senderUid'] = _message.senderUid;
    map['receiverUid'] = _message.receiverUid;
    map['type'] = _message.type;
    map['timestamp'] = _message.timestamp;
    map['photoUrl'] = _message.photoUrl;

    _firestore
        .collection("messages")
        .doc(_message.senderUid)
        .collection(receiverUid)
        .add(map)
        .whenComplete(() {});

    _firestore
        .collection("messages")
        .doc(receiverUid)
        .collection(_message.senderUid)
        .add(map)
        .whenComplete(() {});
  }

  Future<User> fetchUserDetailsById(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection("users").doc(uid).get();
    return User.fromFirestore(documentSnapshot);
  }

  static Future<QuerySnapshot> getData() async {
    QuerySnapshot data;
    data = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('name', descending: false)
        .get();
    return data;
  }
}
