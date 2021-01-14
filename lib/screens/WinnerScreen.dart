import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:konkurs_app/utilities/utils.dart';
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
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //  List<DocumentSnapshot> _snap = new List<DocumentSnapshot>();
  // List<User> _user = [];

  @override
  void initState() {
    super.initState();
    /* _getData();*/
  }

// generates a new Random object
  //  final _random = new Random();

// generate a random index based on the list length
// and use it to retrieve the element

/*  Future<Null> _getData() async {
    QuerySnapshot data;
    data = await firestore
        .collection('users')
        .orderBy('name', descending: false)
        .get();
    if (data != null) {
      setState(() {
        _snap.addAll(data.docs);
        _user = _snap.map((e) => User.fromFirestore(e)).toList();
      });
    }
 }*/

  Container buildItem(DocumentSnapshot doc) {
    // var element = _user[_random.nextInt(_user.length)];
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
                            ' --- ',
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
                doc.data()['imagepost'],
                fit: BoxFit.fill,
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

  void updateData(DocumentSnapshot doc) async {
    await db.collection('post').doc(doc.id).update({'todo': 'please 🤫'});
  }
}
