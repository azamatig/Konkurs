import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/screens/alert_dialog_screen.dart';
import 'package:konkurs_app/screens/home.dart';
import 'package:konkurs_app/utilities/active_card.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/task_column.dart';

import 'AchievementView.dart';
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
  final int likesCount;

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
    this.likesCount,
  });

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final db = FirebaseFirestore.instance;
  List<dynamic> participants;
  Dialogs dialogs = new Dialogs();
  bool postIsLiked = false;

  getParticipants() async {
    DocumentSnapshot document =
        await db.collection('post').doc(widget.docId).get();
    participants = document['people'];
  }

  ifPostIsLiked(String docId) async {
      try {
        var collectionRef = db.collection('post/${widget.docId}/likes');

        var doc = await collectionRef.doc(docId).get();
        setState(() {
          postIsLiked = doc.exists;
        });
      } catch (e) {
        throw e;
      }
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
    ifPostIsLiked(userId);
  }

  Widget _details() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: FutureBuilder(
          future: usersRef.doc(widget.userId).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            User user = User.fromDoc(snapshot.data);
            return SingleChildScrollView(
              child: Column(
                children: [
                  _postImage(),
                  SizedBox(
                    height: 5,
                  ),
                  _buildUserButtons(user),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  _buildContent(),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    decoration: BoxDecoration(color: LightColors.kLightGreen),
                    height: 75,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                postIsLiked = !postIsLiked;
                              });
                                if(postIsLiked) {
                                  db.collection('post/${widget.docId}/likes')
                                      .doc(userId)
                                      .set({
                                    'userUid': userId,
                                  });
                                  var doc = db.collection('post')
                                      .doc(widget.docId);
                                  doc.update({
                                    'likesCount': FieldValue.increment(1)
                                  });
                                }
                                else {
                                  db.collection('post/${widget.docId}/likes')
                                      .doc(userId)
                                      .delete();

                                  var doc = db.collection('post')
                                      .doc(widget.docId);
                                  doc.update({
                                    'likesCount': FieldValue.increment(-1)
                                  });
                                }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                  width: 40,
                                  height: 20,
                                  child: Icon(
                                    postIsLiked
                                        ? FontAwesomeIcons.solidHeart
                                        : FontAwesomeIcons.heart,
                                    size: 20,
                                    color: postIsLiked ? Colors.pinkAccent : null,
                                  )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              var response = await FlutterShareMe().shareToSystem(
                                  msg: 'ссылка на приложение будет здесь');
                              if (response == 'success') {
                                print('navigate success');
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                  width: 40,
                                  height: 50,
                                  child: Icon(
                                    FontAwesomeIcons.shareAlt,
                                    size: 20,
                                  )),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 20.0, right: 20),
                            child: Container(
                              width: 40,
                              height: 20,
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
                                icon: Icon(
                                  FontAwesomeIcons.commentAlt,
                                  size: 20,
                                ),
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
          }),
    );
  }

  Container _postImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        color: LightColors.kLightYellow2,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(widget.postImage),
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: Container(
              height: 165,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      child: Container(
                        color: Colors.white,
                        height: 40,
                        width: 40,
                        child: Icon(
                          FontAwesomeIcons.arrowLeft,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserButtons(User user) {
    return Container(
      color: LightColors.kLightYellow,
      padding: EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
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
                            fontSize: 15, fontWeight: FontWeight.w600),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Дата " + formatOnlyDate(widget.date.toDate())),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: CachedNetworkImageProvider(
                      user.profileImageUrl,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ],
          ),
          Divider(
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Дата окончания " +
                            formatOnlyDate(widget.date.toDate())),
                        SizedBox(
                          height: 5,
                        ),
                        participants.contains(widget.userId)
                            ? Row(
                                children: [
                                  Text('Вы '),
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundImage: CachedNetworkImageProvider(
                                      user.profileImageUrl,
                                    ),
                                  ),
                                  Text(" и " +
                                      participants.length.toString() +
                                      " участников")
                                ],
                              )
                            : Text(
                                "Участников " + participants.length.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 15),
                              )
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 160.0,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        onPressed: () => {
                          setParticipate(),
                          showAchievementView(context),
                        },
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
          Divider(
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Понравилоcь: "),
                    SizedBox(
                      height: 5,
                    ),
                    postIsLiked
                        ? Row(
                            children: [
                              Text('Вам '),
                              CircleAvatar(
                                radius: 10,
                                backgroundImage: CachedNetworkImageProvider(
                                  user.profileImageUrl,
                                ),
                              ),
                              Text(" и " + (widget.likesCount - 1).toString() + " людям")
                            ],
                          )
                        : Text(
                      widget.likesCount.toString() + " людям",
                            style: TextStyle(fontSize: 15),
                          )
                  ],
                ),
              ),
              //Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 15),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: LightColors.kLightYellow2,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TaskColumn(
                    icon: FontAwesomeIcons.clock,
                    iconBackgroundColor: LightColors.kRed,
                    title: 'Зачада 1',
                    subtitle: 'Вы можете сделать это таким то образом'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: LightColors.kPalePink,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TaskColumn(
                  icon: Icons.alarm,
                  iconBackgroundColor: LightColors.kRed,
                  title: 'Задача 2',
                  subtitle: 'Вы можете сделать это таким то образом',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  color: LightColors.kLavender,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TaskColumn(
                  icon: Icons.alarm,
                  iconBackgroundColor: LightColors.kRed,
                  title: 'Задача 3',
                  subtitle: 'Вы можете сделать это таким то образом',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
