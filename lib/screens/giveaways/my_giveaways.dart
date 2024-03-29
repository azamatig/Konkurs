import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:konkurs_app/models/post_model.dart';
import 'package:konkurs_app/models/user_data.dart';
import 'package:konkurs_app/screens/tasks/details_screen.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/next_screen.dart';
import 'package:provider/provider.dart';

class MyGiveaways extends StatefulWidget {
  final String userId;
  final String userPhoto;
  MyGiveaways(this.userId, this.userPhoto);

  @override
  _MyGiveawaysState createState() => _MyGiveawaysState();
}

class _MyGiveawaysState extends State<MyGiveaways> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ScrollController controller;

  DocumentSnapshot _lastVisible;

  bool _isLoading;

  List<DocumentSnapshot> _snap = List<DocumentSnapshot>();

  List<Post> _data = [];

  final FirebaseAuth auth = FirebaseAuth.instance;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String collectionName = 'post';

  Future<Null> _getData() async {
    QuerySnapshot data;
    if (_lastVisible == null)
      data = await firestore
          .collection(collectionName)
          .where('people', arrayContains: widget.userId)
          .where('isFinished', isEqualTo: false)
          //.orderBy('date', descending: false)
          .limit(10)
          .get();
    else
      data = await firestore
          .collection(collectionName)
          .where('people', arrayContains: widget.userId)
          .where('isFinished', isEqualTo: false)
          //.orderBy('date', descending: false)
          .startAfter([_lastVisible['date']])
          .limit(10)
          .get();

    if (data != null && data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _snap.addAll(data.docs);
          _data = _snap.map((e) => Post.fromDoc(e)).toList();
        });
      }
    } else {
      setState(() => _isLoading = false);
      //openToast(context, 'No more content available');
    }
    return null;
  }

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff102733),
        title: Text("Мои участия"),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        elevation: 0,
      ),
      backgroundColor: Color(0xff102733),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: RefreshIndicator(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 30, bottom: 20),
            controller: controller,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: _data.length + 1,
            itemBuilder: (_, int index) {
              if (index < _data.length) {
                return dataList(_data[index]);
              }
              return Center(
                child: new Opacity(
                  opacity: _isLoading ? 1.0 : 0.0,
                  child: new SizedBox(
                      width: 32.0,
                      height: 32.0,
                      child: new CircularProgressIndicator()),
                ),
              );
            },
          ),
          onRefresh: () async {
            reloadData();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Widget dataList(Post d) {
    return GestureDetector(
      onTap: () async {
        DocumentSnapshot document =
            await firestore.collection("post").doc(d.id).get();
        nextScreenCloseOthers(
            context,
            DetailsScreen(
              docId: d.id,
              docRef: document.reference,
              date: d.date,
              userPhoto: widget.userPhoto,
              userId: Provider.of<UserData>(context).currentUserId,
              instaLink1: document.data()['task1InstaLink'],
              instaLink2: document.data()['task2InstaLink'],
              instaLink3: document.data()['task3InstaLink'],
              endDate: d.endDate,
              likesCount: d.likesCount,
              giveawayCost: d.giveawayCost,
            ));
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: Color(0xff29404E), borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16),
                width: MediaQuery.of(context).size.width - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      d.name,
                      maxLines: 2,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/images/calender.png",
                          height: 12,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          formatOnlyDate(d.date.toDate()),
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/images/location.png",
                          height: 15,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${d.description.substring(0, 10)} ...',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: d.imagepost,
                  height: 100,
                  width: 120,
                  fit: BoxFit.cover,
                )),
          ],
        ),
      ),
    );
  }

  reloadData() {
    setState(() {
      _snap.clear();
      _data.clear();
      _lastVisible = null;
    });
    _getData();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }
}
