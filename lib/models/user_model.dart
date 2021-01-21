import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String profileImageUrl;
  String email;
  String insta;
  String phone;
  String location;

  User({
    this.id,
    this.name,
    this.profileImageUrl,
    this.email,
    this.insta,
    this.phone,
    this.location,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      name: doc['name'],
      profileImageUrl: doc['profileImageUrl'] ?? '',
      email: doc['email'],
      insta: doc['bio'] ?? '',
      phone: doc['age'] ?? '',
      location: doc['location'] ?? 'Местоположение',
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
  }
}
