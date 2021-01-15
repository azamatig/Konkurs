import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/utilities/constants.dart';

class DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  static Future<QuerySnapshot> getData() async {
    QuerySnapshot data;
    data = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('name', descending: false)
        .get();
    return data;
  }
}
