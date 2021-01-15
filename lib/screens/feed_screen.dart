import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:konkurs_app/models/post_model.dart';
import 'package:konkurs_app/models/user_data.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/screens/DetailsScreen.dart';
import 'package:konkurs_app/screens/profile_screen.dart';
import 'package:konkurs_app/services/auth_service.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/utils.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'feed_screen';
  final String userId;
  final String postImage;
  final String postName;
  final String postDesc;

  FeedScreen({this.userId, this.postImage, this.postDesc, this.postName});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String id;
  final db = FirebaseFirestore.instance;
  String name;
  String description;
  String imageUrl;
  Post posts;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        child: Scaffold(
          drawer: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85, //20.0,
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.all(0.0),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: FutureBuilder(
                      future: usersRef.doc(widget.userId).get(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        User user = User.fromDoc(snapshot.data);
                        return Column(
                          children: <Widget>[
                            UserAccountsDrawerHeader(
                              accountEmail: Text(
                                user.email,
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                              accountName: Text(
                                user.name,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              currentAccountPicture: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CircleAvatar(
                                  backgroundImage: user.profileImageUrl.isEmpty
                                      ? AssetImage('assets/images/ph.png')
                                      : CachedNetworkImageProvider(
                                          user.profileImageUrl),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          AssetImage("assets/images/two.png"))),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Image.asset(
                      'assets/images/highlightColor.jpg',
                      alignment: Alignment.topLeft,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ListTile(
                      title: Text('Пригласить друга'),
                      trailing: Icon(Icons.person),
                      onTap: () async {
                        var response = await FlutterShareMe().shareToSystem(
                            msg: 'ссылка на приложение будет здесь');
                        if (response == 'success') {
                          print('navigate success');
                        }
                      }),
                  ListTile(
                    title: Text('Обратная связь'),
                    trailing: Icon(Icons.info_outline),
                  ),
                  ListTile(
                      title: Text('Профиль'),
                      trailing: Icon(Icons.input),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                  userId: Provider.of<UserData>(context)
                                      .currentUserId)),
                        );
                      }),
                  Divider(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ListTile(
                      title: Text('Выйти'),
                      onTap: () => AuthService.logout(),
                      trailing: Icon(Icons.exit_to_app),
                    ),
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.white,
            bottom: TabBar(
              labelColor: Colors.black45,
              tabs: <Widget>[
                Tab(
                  text: ('Новые'),
                ), // First tab ListView with Primary Posts
                Tab(
                  text: ('В обработке'),
                ),
                Tab(
                  text: ('Завершенные'),
                )
              ],
            ),
            title: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 57.0, 0.0),
                child: Text(
                  'Konkurs',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'CerapCompactPro',
                    fontSize: 25.0,
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white10,
          body: TabBarView(
            children: <Widget>[
              ListView(
                padding: EdgeInsets.all(8),
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                    stream: db
                        .collection('post')
                        .where('isFinished', isEqualTo: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data.docs
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
              ListView(
                padding: EdgeInsets.all(8),
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                    stream: db
                        .collection('post')
                        .where('people', arrayContains: widget.userId)
                        .where('isFinished', isEqualTo: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data.docs
                              .map((doc) => buildPending(doc))
                              .toList(),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ],
              ),
              ListView(
                padding: EdgeInsets.all(8),
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                    stream: db
                        .collection('post')
                        .where('people', arrayContains: widget.userId)
                        .where('isFinished', isEqualTo: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data.docs
                              .map((doc) => buildFinished(doc))
                              .toList(),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildItem(DocumentSnapshot doc) {
    return Container(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(
                doc.data()['imagepost'],
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                child: Text(
                  '${doc.data()['name']}',
                  style: TextStyle(fontSize: 18, color: Colors.black45),
                ),
              ),
              Divider(),
              Padding(
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
                                  prize: doc.data()['prize'],
                                  task1: doc.data()['task1'],
                                  task2: doc.data()['task2'],
                                  task3: doc.data()['task3'],
                                  postImage: doc.data()['imagepost'],
                                  postName: doc.data()['name'],
                                  postDesc: doc.data()['description'],
                                  isFinished: doc.data()['isFinished'],
                                  docId: doc.id),
                            )),
                        child: Text(
                          'Подробнее',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'CeraCompactPro'),
                          textAlign: TextAlign.center,
                        ),
                        color: PaypalColors.Turquois,
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

  Container buildPending(DocumentSnapshot doc) {
    Post post = Post.fromDoc(doc);
    if (doc.exists == true) {
      return Container(
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(
                  post.imagepost,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                  child: Text(
                    post.name,
                    style: TextStyle(fontSize: 18, color: Colors.black45),
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ReadMoreText(
                    post.description,
                    style: TextStyle(fontSize: 16),
                    trimLines: 3,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Больше',
                    trimExpandedText: 'меньше',
                  ),
                ),
                Divider(),
                Row(
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
                                    prize: doc.data()['prize'],
                                    task1: doc.data()['task1'],
                                    task2: doc.data()['task2'],
                                    task3: doc.data()['task3'],
                                    postImage: doc.data()['imagepost'],
                                    postName: doc.data()['name'],
                                    postDesc: doc.data()['description'],
                                    isFinished: doc.data()['isFinished'],
                                    docId: doc.id),
                              )),
                          child: Text(
                            'Подробнее',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'CeraCompactPro'),
                            textAlign: TextAlign.center,
                          ),
                          color: PaypalColors.Turquois,
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
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Text(
          'На данный момент список пуст',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: PaypalColors.DarkBlue,
            fontFamily: AvailableFonts.primaryFont,
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  Container buildFinished(DocumentSnapshot doc) {
    Post post = Post.fromDoc(doc);
    return Container(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(
                post.imagepost,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                child: Text(
                  post.name,
                  style: TextStyle(fontSize: 18, color: Colors.black45),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ReadMoreText(
                  post.description,
                  style: TextStyle(fontSize: 16),
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Больше',
                  trimExpandedText: 'меньше',
                ),
              ),
              Divider(),
              Row(
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
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'CeraCompactPro'),
                          textAlign: TextAlign.center,
                        ),
                        color: PaypalColors.Turquois,
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
}
