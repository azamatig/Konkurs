import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

final _firestore = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final usersRef = _firestore.collection('users');
final postsRef = _firestore.collection('post');

String formatOnlyDate(DateTime dateTime) {
  if (dateTime == null) {
    return ' ';
  }
  return DateFormat('dd.MM.yyyy').format(dateTime);
}

String formatDate(DateTime dateTime) {
  if (dateTime == null) {
    return ' ';
  }
  return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
}

String formatHour(DateTime dateTime) {
  if (dateTime == null) {
    return ' ';
  }
  return DateFormat('HH:mm').format(dateTime);
}

String readTimeStamp(DateTime date) {
  var format = DateFormat.yMd();
  return format.format(date);
}
