import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String name;
  final String imagepost;
  final String prize;
  final dynamic people;
  final bool shared;
  final Timestamp date;
  final String description;
  final String task1;
  final String task2;
  final String task3;

  Post(
      {this.name,
      this.id,
      this.imagepost,
      this.prize,
      this.people,
      this.shared,
      this.date,
      this.description,
      this.task1,
      this.task2,
      this.task3});

  factory Post.fromDoc(DocumentSnapshot doc) {
    return Post(
        id: doc.id,
        name: doc['name'],
        imagepost: doc['imagepost'],
        prize: doc['prize'],
        people: doc['people'],
        shared: doc['shared'],
        date: doc['date'],
        task1: doc['task1'],
        task2: doc['task2'],
        task3: doc['task3'],
        description: doc['description']);
  }
}
