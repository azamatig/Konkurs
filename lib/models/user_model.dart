import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String profileImageUrl;
  final String email;
  final String bio;
  final String age;
  final String location;

  User({
    this.id,
    this.name,
    this.profileImageUrl,
    this.email,
    this.bio,
    this.age,
    this.location,
  });

  factory User.fromDoc(DocumentSnapshot doc) {
    return User(
        id: doc.id,
        name: doc['name'],
        profileImageUrl: doc['profileImageUrl'],
        email: doc['email'],
        bio: doc['bio'] ?? '',
        age: doc['age'] ?? '',
        location: doc['location'] ?? 'Местоположение');
  }

  factory User.fromFirestore(DocumentSnapshot snapshot) {
    var d = snapshot.data();
    return User(
      id: snapshot.id ?? '',
      name: d['name'] ?? '',
      profileImageUrl: d['profileImageUrl'] ??
          'https://www.seekpng.com/png/detail/115-1150053_avatar-png-transparent-png-royalty-free-default-user.png',
      email: d['email'] ?? '',
      bio: d['bio'] ?? '',
      age: d['age'] ?? '',
      location: d['location'] ?? '',
    );
  }
}
