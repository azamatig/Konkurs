import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/models/post_model.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/screens/all_users_giveaways.dart';
import 'package:konkurs_app/screens/tasks_list.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/prize_widget.dart';
import 'package:konkurs_app/utilities/task_column.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:nanoid/nanoid.dart';

import 'AchievementView.dart';
import 'comments_screen.dart';

class DetailsScreen extends StatefulWidget {
  final String userId;
  final String instaLink1;
  final String instaLink2;
  final String instaLink3;
  final String userPhoto;
  final Timestamp date;
  final String docId;
  final DocumentReference docRef;
  final User currentUser, user;
  final Timestamp endDate;
  int likesCount;

  DetailsScreen({
    this.userId,
    this.docId,
    this.docRef,
    this.currentUser,
    this.user,
    this.date,
    this.endDate,
    this.likesCount,
    this.instaLink1,
    this.instaLink2,
    this.instaLink3,
    this.userPhoto,
  });

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final db = FirebaseFirestore.instance;
  List<dynamic> participants;
  String uid;
  bool postIsLiked = false;
  String task1Type;
  String task2Type;
  String task3Type;
  List<dynamic> shares;
  List<dynamic> shares2;
  List<dynamic> shares3;

  DocumentSnapshot nanoUid;

  getParticipants() async {
    DocumentSnapshot document =
        await db.collection('post').doc(widget.docId).get();
    participants = document['people'];
  }

  setGiveUid() async {
    var nanoUid = nanoid(5);
    db
        .collection('post')
        .doc(widget.docId)
        .collection('uids')
        .doc(widget.userId)
        .set({'nanoUid': nanoUid});
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

  void getTask1Type() async {
    DocumentSnapshot document =
        await db.collection('post').doc(widget.docId).get();
    task1Type = document['task1Type'];
    task2Type = document['task2Type'];
    task3Type = document['task3Type'];
  }

  void setShared() async {
    await db.collection('post').doc(widget.docId).update({'shared': true});
  }

  getShared() async {
    DocumentSnapshot document =
        await db.collection('post').doc(widget.docId).get();
    shares = document['task1TypeShared'];
    shares2 = document['task2TypeShared'];
    shares3 = document['task3TypeShared'];
  }

  @override
  void initState() {
    super.initState();
    final templates = [
      TemplateBlueRocket,
    ];
    getParticipants();
    ifPostIsLiked(widget.userId);
    getTask1Type();
    getShared();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: StreamBuilder(
          stream: postsRef.doc(widget.docId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              Post post = Post.fromDoc(snapshot.data);
              return mainInfo(context, post);
            }
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: LightColors.kLightYellow,
                valueColor: AlwaysStoppedAnimation(LightColors.kLavender),
              ),
            );
          }),
    );
  }

  Widget mainInfo(BuildContext context, Post post) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Column(
          children: [
            _postImage(post),
            SizedBox(
              height: 5,
            ),
            _buildUserButtons(post),
            SizedBox(
              height: 15,
            ),
            _buildContent(post),
            Spacer(),
            Container(
              height: 75,
              decoration: BoxDecoration(color: LightColors.kGreen),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        var response = await FlutterShareMe().shareToSystem(
                            msg: 'ссылка на приложение будет здесь');
                        if (response == 'success') {}
                      },
                      child: Container(
                          width: 40,
                          height: 50,
                          child: Icon(
                            FontAwesomeIcons.shareAlt,
                            size: 20,
                            color: LightColors.kLightYellow2,
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          postIsLiked = !postIsLiked;
                        });
                        if (postIsLiked) {
                          db
                              .collection('post/${widget.docId}/likes')
                              .doc(widget.userId)
                              .set({
                            'userUid': widget.userId,
                          });
                          var doc = db.collection('post').doc(widget.docId);
                          doc.update({'likesCount': FieldValue.increment(1)});
                          setState(() {
                            widget.likesCount++;
                          });
                        } else {
                          db
                              .collection('post/${widget.docId}/likes')
                              .doc(widget.userId)
                              .delete();

                          var doc = db.collection('post').doc(widget.docId);
                          doc.update({'likesCount': FieldValue.increment(-1)});
                          setState(() {
                            widget.likesCount--;
                          });
                        }
                      },
                      child: Container(
                          width: 40,
                          height: 20,
                          child: Icon(
                            postIsLiked
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart,
                            size: 20,
                            color: postIsLiked
                                ? Colors.pinkAccent
                                : LightColors.kLightYellow2,
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Понравилоcь: ",
                          style: TextStyle(
                            color: LightColors.kLightYellow2,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        postIsLiked
                            ? Row(
                                children: [
                                  Text('Вам ',
                                      style: TextStyle(
                                          color: LightColors.kLightYellow2)),
                                  CircleAvatar(
                                    radius: 10,
                                    backgroundImage: CachedNetworkImageProvider(
                                        widget.userPhoto),
                                  ),
                                  Text(
                                    " и " +
                                        (post.likesCount - 1).toString() +
                                        " людям",
                                    style: TextStyle(
                                      color: LightColors.kLightYellow2,
                                    ),
                                  )
                                ],
                              )
                            : Text(
                                post.likesCount.toString() + " людям",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: LightColors.kLightYellow2,
                                ),
                              )
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, right: 20),
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
                            color: LightColors.kLightYellow2,
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
      ),
    );
  }

  Container _postImage(Post post) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        color: LightColors.kLightYellow2,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(post.imagepost),
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
                          color: LightColors.kLightYellow,
                          height: 40,
                          width: 40,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                FontAwesomeIcons.chevronLeft,
                                size: 25,
                                color: LightColors.kDarkBlue,
                              ),
                            ),
                          )),
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

  Widget _buildUserButtons(Post post) {
    return Container(
      color: LightColors.kLightYellow,
      padding: EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 3,
                  ),
                  Container(
                      child: Text(
                    post.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  )),
                  SizedBox(
                    height: 3,
                  ),
                  post.winner.isNotEmpty
                      ? Text("Победитель - " + post.winner)
                      : Text("ПОбедитель еще не определен"),
                  SizedBox(
                    height: 3,
                  ),
                  Text("Дата начала " + formatOnlyDate(post.date.toDate())),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        CachedNetworkImageProvider(widget.userPhoto),
                  ),
                  SizedBox(
                    width: 10,
                  )
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
                        Text(
                          "Дата окончания " +
                              formatOnlyDate(post.endDate.toDate()),
                          style: TextStyle(color: LightColors.kRed),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AllGivesUsers(
                                          doc: post,
                                        )));
                          },
                          child: post.people.contains(widget.userId)
                              ? Row(
                                  children: [
                                    Text('Вы '),
                                    CircleAvatar(
                                        radius: 10,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                widget.userPhoto)),
                                    Text(" и " +
                                        post.people.length.toString() +
                                        " участников")
                                  ],
                                )
                              : Text(
                                  "Участников " + post.people.length.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              StreamBuilder(
                  stream: widget.docRef
                      .collection('uids')
                      .doc(widget.userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      var id = snapshot.data;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: post.isFinished == true ? false : true,
                              child: Container(
                                width: 180.0,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  onPressed: () => {
                                    if (post.people.contains(widget.userId))
                                      {}
                                    else
                                      {
                                        setParticipate(),
                                        showAchievementView1(context),
                                        getParticipants(),
                                        setGiveUid(),
                                      }
                                  },
                                  color: post.people.contains(widget.userId)
                                      ? LightColors.kBlue
                                      : LightColors.kGreen,
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    post.people.contains(widget.userId)
                                        ? 'id участия ' + id['nanoUid']
                                        : 'Участвовать',
                                    style: TextStyle(
                                      color: post.people.contains(widget.userId)
                                          ? LightColors.kLightYellow
                                          : LightColors.kLightYellow,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return CircularProgressIndicator(
                      backgroundColor: LightColors.kLightYellow,
                      valueColor: AlwaysStoppedAnimation(LightColors.kBlue),
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Post post) {
    final popup =
        BeautifulPopup(context: context, template: TemplateBlueRocket);
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 15),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                if (participants.contains(widget.userId) &&
                    post.isFinished == false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskList(
                              userId: widget.userId,
                              docId: widget.docId,
                              task1type: task1Type,
                              task2type: task2Type,
                              task3type: task3Type,
                              shares: shares,
                              shares2: shares2,
                              shares3: shares3,
                              customLink1: post.task1CustomTypeLink,
                              customLink2: post.task2CustomTypeLink,
                              customLink3: post.task3CustomTypeLink,
                              instaLink1: widget.instaLink1,
                              instaLink2: widget.instaLink2,
                              instaLink3: widget.instaLink3,
                              dates: post.date,
                              task1: post.task1,
                              task2: post.task2,
                              task3: post.task3,
                              currentUser: widget.currentUser,
                              docRef: widget.docRef,
                            )),
                  );
                } else if (post.isFinished == true) {
                  popup.show(
                    title: 'Данный конкурс завершен!',
                    content:
                        'К сожалению этот конкурс уже завершен, и доступ к нему закрыт!',
                    barrierDismissible: true,
                  );
                } else {
                  popup.show(
                    title: 'Вы не участник!',
                    content:
                        'Для доступа к заданиям, нажмите кнопку участвовать, для начала!',
                    barrierDismissible: true,
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: LightColors.kPalePink,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TaskColumn(
                      icon: FontAwesomeIcons.tasks,
                      iconBackgroundColor: LightColors.kGreen,
                      title: 'Список задач, ',
                      subtitle: 'Нажмите сюда чтобы узнать про задания!'),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                popup.show(
                  title: 'Инфо по конкурсу',
                  content: post.description,
                  barrierDismissible: true,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: LightColors.kDarkYellow,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TaskColumn(
                    icon: FontAwesomeIcons.question,
                    iconBackgroundColor: LightColors.kDarkBlue,
                    title: 'Описание',
                    subtitle: 'Информация по конкурсу!',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PrizeWidget(
                              postImage: post.prize,
                            )));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: LightColors.kLightGreen,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TaskColumn(
                    icon: FontAwesomeIcons.gift,
                    iconBackgroundColor: LightColors.kRed,
                    title: 'Приз',
                    subtitle: 'Информация о призе!',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
