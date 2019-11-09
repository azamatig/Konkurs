import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:konkurs_app/utilities/utils.dart';

class WinnerScreen extends StatefulWidget {
  @override
  _WinnerScreenState createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen> {
  String id;
  final db = Firestore.instance;
  String name;
  String description;
  String imageUrl;

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
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Имя Фамилия',
                            style: TextStyle(color: Colors.white),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 3.0, 13.0, 0.0),
                            child: Text(
                              'Победитель',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Image.network(
                doc.data['imagepost'],
                fit: BoxFit.fill,
              ),
              Center(
                child: Padding(
                  // Название розыгрыша
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 2.0),
                  child: Text(
                    '${doc.data['name']}',
                    style: TextStyle(fontSize: 24, color: Colors.black45),
                  ),
                ),
              ),
              Divider(),
              Padding(
                // Описание в середине карточки
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '${doc.data['description']}',
                  style: TextStyle(fontSize: 16),
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
                        onPressed: () => updateData(doc),
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
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context, true),
        ),
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
                  children: snapshot.data.documents
                      .map((doc) => buildItem(doc))
                      .toList(),
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

  void updateData(DocumentSnapshot doc) async {
    await db
        .collection('post')
        .document(doc.documentID)
        .updateData({'todo': 'please 🤫'});
  }
}
