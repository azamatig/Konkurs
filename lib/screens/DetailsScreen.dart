import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/screens/alert_dialog_screen.dart';
import 'package:konkurs_app/utilities/constants.dart';

import 'comments_screen.dart';

class DetailsScreen extends StatefulWidget {
  final String userId;
  final String postImage;
  final String postName;
  final String postDesc;
  final String task1;
  final String task2;
  final String task3;
  final String prize;
  final Timestamp date;
  final bool isShared;
  final String docId;
  final bool isFinished;
  final DocumentReference docRef;
  final User currentUser, user;

  DetailsScreen({
    this.userId,
    this.postImage,
    this.postName,
    this.postDesc,
    this.task1,
    this.task2,
    this.task3,
    this.prize,
    this.isShared,
    this.isFinished,
    this.docId,
    this.docRef,
    this.currentUser,
    this.user,
    this.date,
  });

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final db = FirebaseFirestore.instance;
  List<dynamic> participants;
  Dialogs dialogs = new Dialogs();

  getParticipants() async {
    DocumentSnapshot document =
        await db.collection('post').doc(widget.docId).get();
    participants = document['people'];
  }

  void setParticipate() {
    var list = [widget.userId];
    db
        .collection('post')
        .doc(widget.docId)
        .update({'people': FieldValue.arrayUnion(list)});
  }

  void setShared() {
    db.collection('post').doc(widget.docId).update({'shared': true});
  }

  @override
  void initState() {
    super.initState();
    getParticipants();
  }

  Widget _details() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _postDetails(),
          Spacer(),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            height: 65,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                        width: 40,
                        height: 35,
                        child: Icon(FontAwesomeIcons.heart)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                        width: 40,
                        height: 35,
                        child: Icon(FontAwesomeIcons.shareAlt)),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, right: 20),
                    child: Container(
                      alignment: Alignment.centerRight,
                      width: 75,
                      height: 35,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CommentsScreen(
                                        userId: widget.userId,
                                        documentReference: widget.docRef,
                                        user: widget.currentUser,
                                      )));
                        },
                        icon: Icon(FontAwesomeIcons.commentAlt),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder _postDetails() {
    return FutureBuilder(
        future: usersRef.doc(widget.userId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User user = User.fromDoc(snapshot.data);
          return SingleChildScrollView(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 700,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(widget.postImage),
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: 275,
                                    child: Text(
                                      widget.postName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    )),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Дата " +
                                    formatOnlyDate(widget.date.toDate())),
                                Divider(
                                  thickness: 0.5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  CircleAvatar(
                                                    radius: 10,
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                      user.profileImageUrl,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text("Участников " +
                                                  participants.length
                                                      .toString())
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 160.0,
                                            child: FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              onPressed: () => {},
                                              color: Colors.pinkAccent,
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                'Участвовать',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
