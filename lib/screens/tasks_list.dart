import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/screens/AchievementView.dart';
import 'package:konkurs_app/screens/comments_screen.dart';
import 'package:konkurs_app/utilities/back_button.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/task_container.dart';
import 'package:konkurs_app/utilities/task_type.dart';

class TaskList extends StatefulWidget {
  final Timestamp dates;
  final String userId;
  final String docId;
  final String task1;
  final String task2;
  final String task3;
  final String task1type;
  final String task2type;
  final String task3type;
  final String instaLink1;
  final String instaLink2;
  final String instaLink3;
  final String customLink1;
  final String customLink2;
  final String customLink3;
  final List shares;
  final List shares2;
  final List shares3;
  final DocumentReference docRef;
  final User currentUser, user;
  final bool postIsLiked;

  const TaskList(
      {Key key,
      this.dates,
      this.task1,
      this.task2,
      this.task3,
      this.task1type,
      this.task2type,
      this.task3type,
      this.userId,
      this.docId,
      this.shares,
      this.shares2,
      this.shares3,
      this.docRef,
      this.currentUser,
      this.postIsLiked,
      this.customLink1,
      this.customLink2,
      this.customLink3,
      this.instaLink1,
      this.instaLink2,
      this.instaLink3,
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
bool _adEvent = false;

void sharing(BuildContext context, String type, String url, String instaUrl,
    String userId, DocumentReference ref, User user) async {
  switch (type) {
    case ('сторис в instagram'):
      return tasks.setInsta();
    case (' репост в twitter'):
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
  static const String testDevice = 'YOUR_DEVICE_ID';
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );

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
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-7479544369020585~3651727363');
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          _coins += rewardAmount;
          awardAdPoints(_coins);
        });
      } else {}
      if (event == RewardedVideoAdEvent.failedToLoad) {
        setState(() {
          _adEvent = true;
        });
      }
    };
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 2.0).animate(_animationController)
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
      body: SafeArea(
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
              Center(
                child: Text(
                  'Статус задания обновляется не сразу, перезайдите в раздел заданий чтобы увидеть изменения! ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: LightColors.kRed),
                ),
              ),
              SizedBox(height: 10.0),
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
                              fontSize: 30.0, fontWeight: FontWeight.w700),
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
                  'Дата ' + formatOnlyDate(widget.dates.toDate()),
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
                              _dashedText(),
                              GestureDetector(
                                onTap: () async {
                                  if (widget.shares.contains(widget.userId)) {
                                    showAchievementView2(context, 'Спасибо!',
                                        'Условие уже выполнено!');
                                  } else {
                                    if (widget.task1type == 'rewardAd') {
                                      RewardedVideoAd.instance
                                          .load(
                                              adUnitId:
                                                  'ca-app-pub-7479544369020585/1910543933',
                                              targetingInfo: targetingInfo)
                                          .whenComplete(() => RewardedVideoAd
                                              .instance
                                              .show()
                                              .whenComplete(() => {
                                                    if (_adEvent == true)
                                                      {
                                                        showError(
                                                            context,
                                                            'Ошибка',
                                                            'Не удалось загрузить!')
                                                      }
                                                    else
                                                      {setShared()}
                                                  }));
                                    } else {
                                      awardPoints();
                                      sharing(
                                          context,
                                          widget.task1type,
                                          widget.customLink1,
                                          widget.instaLink1,
                                          widget.userId,
                                          widget.docRef,
                                          widget.currentUser);
                                      setShared();
                                    }
                                  }
                                },
                                child: TaskContainer(
                                  icon: widget.shares.contains(widget.userId)
                                      ? FontAwesomeIcons.check
                                      : FontAwesomeIcons.times,
                                  iconColor:
                                      widget.shares.contains(widget.userId)
                                          ? LightColors.kGreen
                                          : LightColors.kRed,
                                  title: 'Задание #1',
                                  subtitle: widget.task1,
                                  boxColor: LightColors.kLightYellow2,
                                  shadowColor: LightColors.kLightYellow2Shadow,
                                  blurRadius:
                                      widget.shares.contains(widget.userId)
                                          ? _animation2.value
                                          : _animation.value,
                                  spreadRadius:
                                      widget.shares.contains(widget.userId)
                                          ? _animation2.value
                                          : _animation.value,
                                ),
                              ),
                              _dashedText(),
                              GestureDetector(
                                onTap: () async {
                                  if (widget.shares2.contains(widget.userId)) {
                                    showAchievementView2(context, 'Спасибо!',
                                        'Условие уже выполнено!');
                                  } else {
                                    if (widget.task2type == 'rewardAd') {
                                      RewardedVideoAd.instance
                                          .load(
                                              adUnitId:
                                                  'ca-app-pub-7479544369020585/1910543933',
                                              targetingInfo: targetingInfo)
                                          .whenComplete(() => RewardedVideoAd
                                              .instance
                                              .show()
                                              .whenComplete(() => {
                                                    if (_adEvent == true)
                                                      {
                                                        showError(
                                                            context,
                                                            'Ошибка',
                                                            'Не удалось загрузить!')
                                                      }
                                                    else
                                                      {setShared2()}
                                                  }));
                                    } else {
                                      sharing(
                                          context,
                                          widget.task2type,
                                          widget.customLink2,
                                          widget.instaLink2,
                                          widget.userId,
                                          widget.docRef,
                                          widget.currentUser);
                                      awardPoints();
                                      setShared2();
                                    }
                                  }
                                },
                                child: TaskContainer(
                                  icon: widget.shares2.contains(widget.userId)
                                      ? FontAwesomeIcons.check
                                      : FontAwesomeIcons.times,
                                  iconColor:
                                      widget.shares2.contains(widget.userId)
                                          ? LightColors.kGreen
                                          : LightColors.kRed,
                                  title: 'Задание #2',
                                  subtitle: widget.task2,
                                  boxColor: LightColors.kLightGreen,
                                  shadowColor: LightColors.kLightGreenShadow,
                                  blurRadius:
                                      widget.shares2.contains(widget.userId)
                                          ? _animation2.value
                                          : _animation.value,
                                  spreadRadius:
                                      widget.shares2.contains(widget.userId)
                                          ? _animation2.value
                                          : _animation.value,
                                ),
                              ),
                              _dashedText(),
                              GestureDetector(
                                onTap: () async {
                                  if (widget.shares3.contains(widget.userId)) {
                                    showAchievementView2(context, 'Спасибо!',
                                        'Условие уже выполнено!');
                                  } else {
                                    if (widget.task3type == 'rewardAd') {
                                      RewardedVideoAd.instance
                                          .load(
                                              adUnitId:
                                                  'ca-app-pub-7479544369020585/1910543933',
                                              targetingInfo: targetingInfo)
                                          .whenComplete(() => RewardedVideoAd
                                              .instance
                                              .show()
                                              .whenComplete(() => {
                                                    if (_adEvent == true)
                                                      {
                                                        showError(
                                                            context,
                                                            'Ошибка',
                                                            'Не удалось загрузить!')
                                                      }
                                                    else
                                                      {setShared3()}
                                                  }));
                                    } else {
                                      awardPoints();
                                      setShared3();
                                      sharing(
                                          context,
                                          widget.task3type,
                                          widget.customLink3,
                                          widget.instaLink3,
                                          widget.userId,
                                          widget.docRef,
                                          widget.currentUser);
                                    }
                                  }
                                },
                                child: TaskContainer(
                                  icon: widget.shares3.contains(widget.userId)
                                      ? FontAwesomeIcons.check
                                      : FontAwesomeIcons.times,
                                  iconColor:
                                      widget.shares3.contains(widget.userId)
                                          ? LightColors.kGreen
                                          : LightColors.kRed,
                                  title: 'Задание #3',
                                  subtitle: widget.task3,
                                  boxColor: LightColors.kPalePink,
                                  shadowColor: LightColors.kPalePinkShadow,
                                  blurRadius:
                                      widget.shares3.contains(widget.userId)
                                          ? _animation2.value
                                          : _animation.value,
                                  spreadRadius:
                                      widget.shares3.contains(widget.userId)
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
      ),
    );
  }
}
