import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String imageUrl;
  final String caption;
  final dynamic likes;
  final String authorId;
  final Timestamp timestamp;
  final String description;
  final String name;

  Post({
    this.id,
    this.imageUrl,
    this.caption,
    this.likes,
    this.authorId,
    this.timestamp,
    this.description,
    this.name,
  });

  factory Post.fromDoc(DocumentSnapshot doc) {
    return Post(
        id: doc.id,
        imageUrl: doc['imagepost'],
        caption: doc['caption'],
        likes: doc['likes'],
        authorId: doc['authorId'],
        timestamp: doc['timestamp'],
        name: doc['name'],
        description: doc['description']);
  }
}
