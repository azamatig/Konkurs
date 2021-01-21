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
  final bool isFinished;

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
      this.task3,
      this.isFinished});

  factory Post.fromDoc(DocumentSnapshot doc) {
    return Post(
        id: doc.id,
        name: doc.data()['name'],
        imagepost: doc.data()['imagepost'],
        prize: doc.data()['prize'],
        people: doc.data()['people'],
        shared: doc.data()['shared'],
        date: doc.data()['date'],
        task1: doc.data()['task1'],
        task2: doc.data()['task2'],
        task3: doc.data()['task3'],
        description: doc.data()['description'],
      isFinished: doc.data()['isFinished'],
    );
  }
}
