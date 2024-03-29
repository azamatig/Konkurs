import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  static final String id = 'notifications';
  final String userid;

  const Notifications({Key key, this.userid}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final _database = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff102733),
      appBar: AppBar(
        backgroundColor: Color(0xff102733),
        title: Text("Уведомления"),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: _database
            .collection("users/${widget.userid}/notifications")
            .orderBy('ts', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final notifications = snapshot.data.docs; //.reversed;
          List<Widget> notificationWidgets = [];
          for (var v in notifications) {
            var message = v.data()['message'];
            var type = v.data()['type'];
            var title = v.data()['title'];
            var isUnread = v.data()['is_Unread'];
            if (isUnread) {
              _database
                  .doc("users/${widget.userid}/notifications/${v.id}")
                  .update({'is_Unread': false});
            }
            var notificationWidget = Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              height: 100,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                  color: Color(0xff29404E),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  SizedBox(height: 7),
                  Text(message,
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            );
            notificationWidgets.add(notificationWidget);
          }
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: notificationWidgets,
          );
        },
      ),
    );
  }
}
