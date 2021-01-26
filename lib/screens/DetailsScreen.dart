import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/screens/alert_dialog_screen.dart';
import 'package:konkurs_app/screens/tasks_list.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/prize_widget.dart';
import 'package:konkurs_app/utilities/task_column.dart';
import 'package:flutter_beautiful_popup/main.dart';

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
  Dialogs dialogs = Dialogs();
  String task1Type;
  String task2Type;
  String task3Type;
  List<dynamic> shares;
  List<dynamic> shares2;
  List<dynamic> shares3;

  getParticipants() async {
    DocumentSnapshot document =
        await db.collection('post').doc(widget.docId).get();
    participants = document['people'];
  }

  void setParticipate() async {
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

  /* void getTask2Type() async {
    DocumentSnapshot document =
    await db.collection('post').doc(widget.docId).get();
    task2Type = document['task2Type'];
  }

  void getTask3Type() async {
    DocumentSnapshot document =
    await db.collection('post').doc(widget.docId).get();
    task3Type = document['task3Type'];
  }
*/
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
    getTask1Type();
    getShared();
    // getTask2Type();
    // getTask3Type();
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
            return Column(
              children: [
                _postImage(),
                SizedBox(
                  height: 5,
                ),
                _buildUserButtons(user),
                SizedBox(
                  height: 20,
                ),
                _buildContent(),
                Spacer(),
                Container(
                  decoration: BoxDecoration(color: LightColors.kGreen),
                  height: 75,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                              width: 40,
                              height: 20,
                              child: Icon(
                                FontAwesomeIcons.heart,
                                size: 20,
                                color: Colors.white70,
                              )),
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
                                  color: Colors.white70,
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
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  SingleChildScrollView _postImage() {
    return SingleChildScrollView(
        child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        color: LightColors.kLightYellow2,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(widget.postImage),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
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
          ],
        ),
      ),
    ));
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
                        color: LightColors.kGreen,
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
    );
  }

  Widget _buildContent() {
    final popup =
        BeautifulPopup(context: context, template: TemplateBlueRocket);
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 15),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
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
                            dates: widget.date,
                            task1: widget.task1,
                            task2: widget.task2,
                            task3: widget.task3,
                            currentUser: widget.currentUser,
                            docRef: widget.docRef,
                          )),
                );
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
                      title: 'Список задач',
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
                  content: widget.postDesc,
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
                              postImage: widget.prize,
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
