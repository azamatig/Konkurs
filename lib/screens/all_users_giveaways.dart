import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:konkurs_app/models/post_model.dart';
import 'package:konkurs_app/utilities/constants.dart';

class AllGivesUsers extends StatefulWidget {
  final String userPhoto;
  final Post doc;

  const AllGivesUsers({Key key, this.userPhoto, this.doc}) : super(key: key);

  @override
  _AllGiveawaysState createState() => _AllGiveawaysState();
}

class _AllGiveawaysState extends State<AllGivesUsers> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ScrollController controller;
  List<dynamic> participants;
  List<Widget> participantWidgets = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool doneLoadingParticipants = false;

  getParticipants() async {
    DocumentSnapshot document =
        await firestore.collection('post').doc(widget.doc.id).get();
    participants = document['people'];

    for (int i = 0; i < participants.length; ++i) {
      DocumentSnapshot participant = await firestore
          .collection('users')
          .doc(participants[i].toString())
          .get();

      Widget participantWidget = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(participant['profileImageUrl']),
                      radius: 20,
                    ),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Text(formatOnlyDate(DateTime.now()),
                            style: TextStyle(
                                fontSize: 8, color: LightColors.kLightYellow)),
                      ),
                      Row(
                        children: <Widget>[
                          Text(participant['name'] + ' ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: LightColors.kLightYellow)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Text(participant['insta'],
                            style: TextStyle(
                                fontSize: 15, color: LightColors.kLavender)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      );

      setState(() {
        participantWidgets.add(participantWidget);
      });
      setState(() {
        doneLoadingParticipants = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.doc.people.length == 0)
      setState(() {
        doneLoadingParticipants = true;
      });
    getParticipants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff102733),
        title: Text("Участники"),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        elevation: 0,
      ),
      backgroundColor: Color(0xff102733),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Row(
          children: [ParticipantsList(participantWidgets)],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ParticipantsList extends StatelessWidget {
  final participants;

  ParticipantsList(this.participants);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: participants,
    );
  }
}
