import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String profileImageUrl;
  String email;
  String insta;
  String phone;
  String location;
  int points;
  List eventDays;
  bool partner;
  String parent;

  User(
      {this.id,
      this.name,
      this.profileImageUrl,
      this.email,
      this.insta,
      this.phone,
      this.location,
      this.points,
      this.eventDays,
      this.partner,
      this.parent});

  factory User.fromDoc(DocumentSnapshot d) {
    return User(
      id: d.id,
      name: d['name'],
      profileImageUrl: d['profileImageUrl'] ?? '',
      email: d['email'],
      insta: d['insta'] ?? '',
      phone: d['phone'] ?? '',
      location: d['location'] ?? 'Местоположение',
      points: d['points'] ?? 0,
      eventDays: d['eventDays'],
      partner: d['partner'],
      parent: d['parent'],
    );
  }

  factory User.fromFirestore(DocumentSnapshot snapshot) {
    var d = snapshot.data();
    return User(
      id: snapshot.id,
      name: d['name'],
      profileImageUrl: d['profileImageUrl'] ??
          'https://www.seekpng.com/png/detail/115-1150053_avatar-png-transparent-png-royalty-free-default-user.png',
      email: d['email'],
      insta: d['insta'],
      phone: d['phone'],
      location: d['location'],
      points: d['points'],
      eventDays: d['eventDays'],
      partner: d['partner'],
      parent: d['parent'],
    );
  }

  User.fromMap(Map<String, dynamic> m) {
    this.id = m['id'];
    this.email = m['email'];
    this.profileImageUrl = m['profileImageUrl'];
    this.name = m['name'];
    this.location = m['location'];
    this.insta = m['insta'];
    this.phone = m['phone'];
    this.points = m['points'];
    this.eventDays = m['eventDays'];
    this.partner = m['partner'];
    this.parent = m['parent'];
  }
}
