import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/models/post_model.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/services/database_service.dart';
import 'package:konkurs_app/utilities/back_button.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/task_container.dart';
import 'package:konkurs_app/utilities/task_type.dart';

class TaskProfileList extends StatefulWidget {
  final Timestamp dates;
  final String userId;
  final String docId;
  final String task1;
  final String task2;
  final String task3;
  final String task1type;
  final String task2type;
  final String task3type;
  final List shares;
  final List shares2;
  final List shares3;
  final DocumentReference docRef;
  final User currentUser, user;

  const TaskProfileList(
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
      this.user})
      : super(key: key);

  @override
  _TaskProfileListState createState() => _TaskProfileListState();
}

final db = FirebaseFirestore.instance;
TaskType tasks = TaskType();
File file;
DatabaseService ds = DatabaseService();

void sharing(String type) async {
  switch (type) {
    case ('instagram'):
      return tasks.setInsta();
    case ('tweeter'):
      return tasks.setTweet();
    case ('system'):
      return tasks.setSystem();
    case ('facebook'):
      return tasks.setFacebook();
  }
}

class _TaskProfileListState extends State<TaskProfileList> {
  String userName;
  String userPhoto;
  String userId;

  void setShared() async {
    var list = [widget.userId];
    db
        .collection('post')
        .doc(widget.docId)
        .update({'task1TypeShared': FieldValue.arrayUnion(list)});
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

  void getCurrentUserInfo() {
    ds.fetchUserDetailsById(widget.userId).then((user) => {
          setState(() {
            userPhoto = user.profileImageUrl;
            userName = user.name;
            userId = user.id;
          })
        });
  }

  @override
  void initState() {
    super.initState();
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
      backgroundColor: LightColors.kLightYellow,
      body: StreamBuilder(
          stream: db
              .collection('post')
              .where('people', arrayContains: widget.userId)
              .where('isFinished', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            Column(
              children:
                  snapshot.data.docs.map((doc) => buildList(doc)).toList(),
            );
            return SizedBox();
          }),
    );
  }

  Widget buildList(DocumentSnapshot doc) {
    var time = doc.data()['date'].toDate();
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
                'Дата ' + formatOnlyDate(time),
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
                              onTap: () {},
                              child: TaskContainer(
                                icon: FontAwesomeIcons.times,
                                iconColor: LightColors.kGreen,
                                title: 'Задание #1',
                                subtitle: doc.data()['task1'],
                                boxColor: LightColors.kLightYellow2,
                              ),
                            ),
                            _dashedText(),
                            GestureDetector(
                              onTap: () {},
                              child: TaskContainer(
                                icon: FontAwesomeIcons.times,
                                iconColor: LightColors.kRed,
                                title: 'Задание #2',
                                subtitle: doc.data()['task1'],
                                boxColor: LightColors.kLavender,
                              ),
                            ),
                            _dashedText(),
                            GestureDetector(
                              onTap: () {},
                              child: TaskContainer(
                                icon: FontAwesomeIcons.times,
                                iconColor: LightColors.kRed,
                                title: 'Задание #3',
                                subtitle: doc.data()['task1'],
                                boxColor: LightColors.kPalePink,
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
  }
}
