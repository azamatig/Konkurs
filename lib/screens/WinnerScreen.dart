import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:konkurs_app/models/user_data.dart';
import 'package:konkurs_app/screens/DetailsScreen.dart';
import 'package:konkurs_app/services/database_service.dart';
import 'package:konkurs_app/utilities/utils.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class WinnerScreen extends StatefulWidget {
  @override
  _WinnerScreenState createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen> {
  String id;
  final db = FirebaseFirestore.instance;
  String name;
  String description;
  String imageUrl;

  @override
  void initState() {
    super.initState();
    DatabaseService.getData().then((value) => null);
  }

  Container buildItem(DocumentSnapshot doc) {
    return Container(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                // Верхняя часть карточки с именем победителя
                color: PaypalColors.Win,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        child: Image.network(
                          'https://image.flaticon.com/icons/png/128/1319/1319983.png',
                          height: 25,
                          width: 25,
                        ),
                        radius: 25.0,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          doc.data()['winner'] ?? 'Победитель еще определён',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Победитель',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  // Название розыгрыша
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 2.0),
                  child: Text(
                    '${doc.data()['name']}',
                    style: TextStyle(fontSize: 18, color: Colors.black45),
                  ),
                ),
              ),
              Divider(),
              Padding(
                // Описание в середине карточки
                padding: const EdgeInsets.all(10.0),
                child: ReadMoreText(
                  '${doc.data()['description']}',
                  style: TextStyle(fontSize: 16),
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Больше',
                  trimExpandedText: 'меньше',
                ),
              ),
              Divider(),
              Row(
                // Buttons here
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 95.0, 10.0),
                    child: FlatButton(
                      child: Icon(Icons.share),
                      onPressed: () async {
                        var response = await FlutterShareMe().shareToSystem(
                            msg: 'ссылка на приложение будет здесь');
                        if (response == 'success') {
                          print('navigate success');
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 10.0),
                    child: Container(
                      width: 180,
                      height: 43,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailsScreen(
                                  userId: Provider.of<UserData>(context)
                                      .currentUserId,
                                  isShared: doc.data()['shared'],
                                  isFinished: doc.data()['isFinished'],
                                  prize: doc.data()['prize'],
                                  task1: doc.data()['task1'],
                                  task2: doc.data()['task2'],
                                  task3: doc.data()['task3'],
                                  postImage: doc.data()['imagepost'],
                                  postName: doc.data()['name'],
                                  postDesc: doc.data()['description'],
                                  docId: doc.id),
                            )),
                        child: Text(
                          'Подробнее',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        color: PaypalColors.Violet,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Победители',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'CeraCompactPro',
              fontSize: 20.0,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('post').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children:
                      snapshot.data.docs.map((doc) => buildItem(doc)).toList(),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
