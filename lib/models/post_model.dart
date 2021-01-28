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
  final String task1Type;
  final dynamic task1TypeShared;
  final dynamic task2TypeShared;
  final dynamic task3TypeShared;
  final String task2;
  final String task2Type;
  final String task3;
  final String task3Type;
  final bool isFinished;
  final String winner;
  final int winnerId;
  final String winnerUid;
  final Timestamp endDate;
  final int likesCount;

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
      this.task1Type,
      this.task1TypeShared,
      this.task2,
      this.task2Type,
      this.task2TypeShared,
      this.task3,
      this.task3Type,
      this.task3TypeShared,
      this.winner,
      this.winnerId,
      this.winnerUid,
      this.isFinished,
      this.endDate,
      this.likesCount});

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
      task1Type: doc.data()['task1Type'],
      task1TypeShared: doc.data()['task1TypeShared'],
      task2: doc.data()['task2'],
      task2Type: doc.data()['task2Type'],
      task2TypeShared: doc.data()['task2TypeShared'],
      task3: doc.data()['task3'],
      task3Type: doc.data()['task3Type'],
      task3TypeShared: doc.data()['task3TypeShared'],
      description: doc.data()['description'],
      winner: doc.data()['winner'],
      endDate: doc.data()['endDate'],
      winnerId: doc.data()['winnerId'],
      winnerUid: doc.data()['winnerUid'],
      isFinished: doc.data()['isFinished'],
      likesCount: doc.data()['likesCount'],
    );
  }
}
