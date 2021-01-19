import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String profileImageUrl;
  String email;
  String insta;
  String phone;
  String location;
  String q1;
  String q2;
  String q3;
  String q4;
  String q5;
  String q6;
  String q7;
  String q8;
  String q9;
  String q10;
  String q11;
  String q12;
  String q13;

  User({
    this.id,
    this.name,
    this.profileImageUrl,
    this.email,
    this.insta,
    this.phone,
    this.location,
    this.q1,
    this.q2,
    this.q3,
    this.q4,
    this.q5,
    this.q6,
    this.q7,
    this.q8,
    this.q9,
    this.q10,
    this.q11,
    this.q12,
    this.q13,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      name: doc['name'],
      profileImageUrl: doc['profileImageUrl'],
      email: doc['email'],
      insta: doc['bio'] ?? '',
      phone: doc['age'] ?? '',
      location: doc['location'] ?? 'Местоположение',
      q1: doc['q1'],
      q2: doc['q2'],
      q3: doc['q3'],
      q4: doc['q4'],
      q5: doc['q5'],
      q6: doc['q6'],
      q7: doc['q7'],
      q8: doc['q8'],
      q9: doc['q9'],
      q10: doc['q10'],
      q11: doc['q11'],
      q12: doc['q12'],
      q13: doc['q13'],
    );
  }

  factory User.fromFirestore(DocumentSnapshot snapshot) {
    var d = snapshot.data();
    return User(
      id: snapshot.id ?? '',
      name: d['name'] ?? '',
      profileImageUrl: d['profileImageUrl'] ??
          'https://www.seekpng.com/png/detail/115-1150053_avatar-png-transparent-png-royalty-free-default-user.png',
      email: d['email'] ?? '',
      insta: d['bio'] ?? '',
      phone: d['age'] ?? '',
      location: d['location'] ?? '',
      q1: d['q1'],
      q2: d['q2'],
      q3: d['q3'],
      q4: d['q4'],
      q5: d['q5'],
      q6: d['q6'],
      q7: d['q7'],
      q8: d['q8'],
      q9: d['q9'],
      q10: d['q10'],
      q11: d['q11'],
      q12: d['q12'],
      q13: d['q13'],
    );
  }

  User.fromMap(Map<String, dynamic> mapData) {
    this.id = mapData['id'];
    this.email = mapData['email'];
    this.profileImageUrl = mapData['profileImageUrl'];
    this.name = mapData['name'];
    this.location = mapData['location'];
    this.insta = mapData['insta'];
    this.phone = mapData['phone'];
    this.q1 = mapData['q1'];
    this.q2 = mapData['q2'];
    this.q3 = mapData['q3'];
    this.q4 = mapData['q4'];
    this.q5 = mapData['q5'];
    this.q6 = mapData['q6'];
    this.q7 = mapData['q7'];
    this.q8 = mapData['q8'];
    this.q9 = mapData['q9'];
    this.q10 = mapData['q10'];
    this.q11 = mapData['q11'];
    this.q12 = mapData['q12'];
    this.q13 = mapData['q13'];
  }
}
