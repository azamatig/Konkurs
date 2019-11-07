import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        color: Colors.black38,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(
                doc.data['imagepost'],
                fit: BoxFit.fill,
              ),
              Center(
                child: Text(
                  '${doc.data['name']}',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              Divider(),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      '${doc.data['description']}',
                      style: TextStyle(fontSize: 19, color: Colors.white70),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(6.0),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () => updateData(doc),
                      child: Text('Подробнее',
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                      color: Colors.lightBlueAccent,
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
