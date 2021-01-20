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
  final bool isShared;
  final String docId;
  final bool isFinished;
  final DocumentReference docRef;
  final DocumentSnapshot docSnap;
  final User currentUser, user;

  DetailsScreen(
      {this.userId,
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
      this.docSnap});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final db = FirebaseFirestore.instance;
  Dialogs dialogs = new Dialogs();
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

  void setPending() {
    setState(() {
      // widget.isPending = true;
    });
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
                            child: ListView(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              primary: false,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 15,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: user.profileImageUrl,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      // Текст имя
                                      '- Вы',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: 200,
                                            child: Text(
                                              widget.postName,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 5,
                                            )),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(formatOnlyDate(widget.docSnap
                                            .data()['date']
                                            .toDate())),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 160.0,
                                      child: FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
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
                                SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),
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
