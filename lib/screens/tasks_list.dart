import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/models/post_model.dart';
import 'package:konkurs_app/models/user_data.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/screens/AchievementView.dart';
import 'package:konkurs_app/utilities/back_button.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/task_container.dart';
import 'package:konkurs_app/utilities/task_type.dart';
import 'package:provider/provider.dart';

class TaskList extends StatefulWidget {
  final Timestamp dates;
  final String userId;
  final String docId;
  final DocumentReference docRef;
  final User currentUser, user;
  final bool postIsLiked;

  const TaskList(
      {Key key,
      this.dates,
      this.userId,
      this.docId,
      this.docRef,
      this.currentUser,
      this.postIsLiked,
      this.user})
      : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

GlobalKey<ScaffoldMessengerState> scaffoldState =
    GlobalKey<ScaffoldMessengerState>();
final db = FirebaseFirestore.instance;
TaskType tasks = TaskType();
AnimationController _animationController;
Animation _animation;
Animation _animation2;
File file;
String urlString;
int _coins = 0;

Future<void> sharing(BuildContext context, String type, String url,
    String instaUrl, String userId, DocumentReference ref, User user) async {
  switch (type) {
    case ('сторис в instagram'):
      return tasks.setInsta();
    case ('репост в twitter'):
      return tasks.setTweet();
    case ('задание в GiveApp'):
      return tasks.setSystem();
    case ('сторис в facebook'):
      return tasks.setFacebook();
    case ('произвольное задание'):
      return tasks.setUrl(url);
    case ('подписаться на instagram'):
      return tasks.setUrl(instaUrl);
    case ('комментарий под конкурсом'):
      return tasks.setGiveComment(context, userId, ref, user);
  }
}

class _TaskListState extends State<TaskList> with TickerProviderStateMixin {
  void setShared() async {
    var list = [widget.userId];
    db
        .collection('post')
        .doc(widget.docId)
        .update({'task1TypeShared': FieldValue.arrayUnion(list)});
  }

  void awardPoints() async {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'points': FieldValue.increment(5)});
  }

  void awardAdPoints(int award) async {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'points': FieldValue.increment(award)});
  }

  void setShared2() async {
    var list = [widget.userId];
    db
        .collection('post')
        .doc(widget.docId)
        .update({'task2TypeShared': FieldValue.arrayUnion(list)});
  }

  void setShared3() async {
    var list = [widget.userId];
    db
        .collection('post')
        .doc(widget.docId)
        .update({'task3TypeShared': FieldValue.arrayUnion(list)});
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 3.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animation2 = Tween(begin: 0.0, end: 0.0).animate(_animationController)
      ..addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _dashedText() {
    return Container(
      child: Text(
        '------------------------------------------',
        maxLines: 1,
        style:
            TextStyle(fontSize: 20.0, color: Colors.black12, letterSpacing: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      backgroundColor: LightColors.kLightYellow,
      body: StreamBuilder(
          stream: widget.docRef.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            Post p = Post.fromDoc(snapshot.data);
            var user = Provider.of<UserData>(context).currentUserId;
            var task1 = p.task1TypeShared.contains(user);
            var task2 = p.task2TypeShared.contains(user);
            var task3 = p.task3TypeShared.contains(user);
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MyBackButton(),
                    SizedBox(height: 30.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Задания',
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Задания для конкурса',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 80.0,
                            width: 120,
                            child: Image.asset(
                              'assets/images/gift.png',
                              height: 50,
                              width: 60,
                            ),
                          ),
                        ]),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Дата ' + formatOnlyDate(p.date.toDate()),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        task1 && task2 && task3
                                            ? 'Условия конкурса - Выполнены!'
                                            : 'Условия конкурса - не выполнены',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w700,
                                            color: task1 && task2 && task3
                                                ? LightColors.kGreen
                                                : LightColors.kRed),
                                      ),
                                    ),
                                    _dashedText(),
                                    GestureDetector(
                                      onTap: () async {
                                        if (task1) {
                                          showAchievementView2(
                                              context,
                                              'Спасибо!',
                                              'Условие уже выполнено!');
                                        } else {
                                          sharing(
                                                  context,
                                                  p.task1Type,
                                                  p.task1CustomTypeLink,
                                                  p.task1InstaLink,
                                                  widget.userId,
                                                  widget.docRef,
                                                  widget.currentUser)
                                              .then((value) =>
                                                  [setShared(), awardPoints()]);
                                        }
                                      },
                                      child: TaskContainer(
                                        icon: task1
                                            ? FontAwesomeIcons.check
                                            : FontAwesomeIcons.times,
                                        iconColor: task1
                                            ? LightColors.kGreen
                                            : LightColors.kRed,
                                        title: 'Задание #1',
                                        subtitle: p.task1,
                                        boxColor: LightColors.kLightYellow2,
                                        shadowColor:
                                            LightColors.kLightYellow2Shadow,
                                        blurRadius: task1
                                            ? _animation2.value
                                            : _animation.value,
                                        spreadRadius: task1
                                            ? _animation2.value
                                            : _animation.value,
                                      ),
                                    ),
                                    _dashedText(),
                                    GestureDetector(
                                      onTap: () async {
                                        if (task2) {
                                          showAchievementView2(
                                              context,
                                              'Спасибо!',
                                              'Условие уже выполнено!');
                                        } else {
                                          sharing(
                                                  context,
                                                  p.task2Type,
                                                  p.task2CustomTypeLink,
                                                  p.task2InstaLink,
                                                  widget.userId,
                                                  widget.docRef,
                                                  widget.currentUser)
                                              .whenComplete(() => [
                                                    setShared2(),
                                                    awardPoints()
                                                  ]);
                                        }
                                      },
                                      child: TaskContainer(
                                        icon: task2
                                            ? FontAwesomeIcons.check
                                            : FontAwesomeIcons.times,
                                        iconColor: task2
                                            ? LightColors.kGreen
                                            : LightColors.kRed,
                                        title: 'Задание #2',
                                        subtitle: p.task2,
                                        boxColor: LightColors.kLightGreen,
                                        shadowColor:
                                            LightColors.kLightGreenShadow,
                                        blurRadius: task2
                                            ? _animation2.value
                                            : _animation.value,
                                        spreadRadius: task2
                                            ? _animation2.value
                                            : _animation.value,
                                      ),
                                    ),
                                    _dashedText(),
                                    GestureDetector(
                                      onTap: () async {
                                        if (task3) {
                                          showAchievementView2(
                                              context,
                                              'Спасибо!',
                                              'Условие уже выполнено!');
                                        } else {
                                          sharing(
                                                  context,
                                                  p.task3Type,
                                                  p.task3CustomTypeLink,
                                                  p.task3InstaLink,
                                                  widget.userId,
                                                  widget.docRef,
                                                  widget.currentUser)
                                              .whenComplete(() => [
                                                    setShared3(),
                                                    awardPoints()
                                                  ]);
                                        }
                                      },
                                      child: TaskContainer(
                                        icon: task3
                                            ? FontAwesomeIcons.check
                                            : FontAwesomeIcons.times,
                                        iconColor: task3
                                            ? LightColors.kGreen
                                            : LightColors.kRed,
                                        title: 'Задание #3',
                                        subtitle: p.task3,
                                        boxColor: LightColors.kPalePink,
                                        shadowColor:
                                            LightColors.kPalePinkShadow,
                                        blurRadius: task3
                                            ? _animation2.value
                                            : _animation.value,
                                        spreadRadius: task3
                                            ? _animation2.value
                                            : _animation.value,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
