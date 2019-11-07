import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'feed_screen';

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String id;
  final db = Firestore.instance;
  String name;
  String description;
  String imageUrl;

  Container buildItem(DocumentSnapshot doc) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image.network(
                  doc.data['imagepost'],
                ),
              ),
              Text(
                '${doc.data['name']}',
                style: TextStyle(fontSize: 24, color: Colors.black45),
              ),
              Divider(),
              Text(
                '${doc.data['description']}',
                style: TextStyle(fontSize: 19),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: () => updateData(doc),
                    child: Text('Подробнее',
                        style: TextStyle(color: Colors.white)),
                    color: Colors.lightBlueAccent,
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
    return Container(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("****"),
                accountEmail: Text("***@**.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://static.joybuy.com/ept_m/res/en/launcher-144.png'),
                ),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "https://cdn.pixabay.com/photo/2015/09/21/06/59/mountains-949425_960_720.jpg"))),
              ),
              ListTile(
                title: Text('Оплата'),
                trailing: Icon(Icons.payment),
              ),
              ListTile(
                title: Text('Пригласить друга'),
                trailing: Icon(Icons.person),
              ),
              ListTile(
                title: Text('Обратная связь'),
                trailing: Icon(Icons.info_outline),
              ),
              ListTile(
                title: Text('Профиль'),
                trailing: Icon(Icons.input),
              ),
              Divider(),
              Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: Text('Выйти'),
                  trailing: Icon(Icons.exit_to_app),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              'Konkurs',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'CeraCompactPro',
                fontSize: 25.0,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white10,
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
