import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/models/post_model.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/services/database_service.dart';
import 'package:konkurs_app/utilities/back_button.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/task_type.dart';

class TaskProfileList extends StatefulWidget {
  final Timestamp dates;
  final String userId;
  final String task1type;
  final String task2type;
  final String task3type;
  final DocumentReference docRef;
  final User currentUser, user;

  const TaskProfileList(
      {Key key,
      this.dates,
      this.task1type,
      this.task2type,
      this.task3type,
      this.userId,
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

class _TaskProfileListState extends State<TaskProfileList> {
  String userName;
  String userPhoto;
  String userId;
  String task1Type;
  String task2Type;
  String task3Type;
  List<dynamic> shares;
  List<dynamic> shares2;
  List<dynamic> shares3;
  bool isClaimed = false;
  bool isClaimed2 = false;
  bool isClaimed3 = false;

  void awardPoints() async {
    var doc = db.collection('users').doc(widget.userId);
    doc.update({'points': FieldValue.increment(1)});
  }

  Future getShared(String id) async {
    DocumentSnapshot document = await db.collection('post').doc(id).get();
    shares = document['task1TypeShared'];
    shares2 = document['task2TypeShared'];
    shares3 = document['task3TypeShared'];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection('post')
                  .where('people', arrayContains: widget.userId)
                  .where('isFinished', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: LinearProgressIndicator(
                          backgroundColor: LightColors.kLightYellow2,
                          valueColor:
                              AlwaysStoppedAnimation(LightColors.kBlue)));
                }
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 15, bottom: 15),
                        child: MyBackButton(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              'Ваши действующие задания',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: ((context, index) =>
                              _buildList(snapshot.data.docs[index])),
                        ),
                      )
                    ]),
                  ),
                );
              }),
        ],
      ),
    );
  }

  FutureBuilder _buildList(DocumentSnapshot doc) {
    Post post = Post.fromDoc(doc);
    if (doc != null) {
      return FutureBuilder(
          future: getShared(doc.id),
          builder: (context, snapshot) {
            return Container(
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                color: LightColors.kDarkBlue,
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 10.0),
                        child: Text(
                          "Название конкурса - " + post.name,
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                      Divider(),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, bottom: 10),
                                child: Container(
                                  height: 75,
                                  width: 275,
                                  decoration: BoxDecoration(
                                    color: LightColors.kLightYellow2,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: ListTile(
                                      title: Text('Задание #1'),
                                      subtitle: Text(post.task1),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '   - - - - - - - - ',
                                style:
                                    TextStyle(color: LightColors.kLightYellow),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      shares.contains(widget.userId)
                                          ? FontAwesomeIcons.check
                                          : FontAwesomeIcons.times,
                                      color: shares.contains(widget.userId)
                                          ? LightColors.kGreen
                                          : LightColors.kRed,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, bottom: 10),
                                child: Container(
                                  height: 75,
                                  width: 275,
                                  decoration: BoxDecoration(
                                    color: LightColors.kLavender,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: ListTile(
                                      title: Text('Задание #2'),
                                      subtitle: Text(post.task2),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '   - - - - - - - - ',
                                style:
                                    TextStyle(color: LightColors.kLightYellow),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      shares2.contains(widget.userId)
                                          ? FontAwesomeIcons.check
                                          : FontAwesomeIcons.times,
                                      color: shares2.contains(widget.userId)
                                          ? LightColors.kGreen
                                          : LightColors.kRed,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, bottom: 10),
                                child: Container(
                                  height: 75,
                                  width: 275,
                                  decoration: BoxDecoration(
                                    color: LightColors.kLightGreen,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: ListTile(
                                      title: Text('Задание #3'),
                                      subtitle: Text(post.task3),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                '   - - - - - - - - ',
                                style:
                                    TextStyle(color: LightColors.kLightYellow),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      shares3.contains(widget.userId)
                                          ? FontAwesomeIcons.check
                                          : FontAwesomeIcons.times,
                                      color: shares3.contains(widget.userId)
                                          ? LightColors.kGreen
                                          : LightColors.kRed,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }
    return null;
  }
}
