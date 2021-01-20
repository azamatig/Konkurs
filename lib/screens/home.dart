import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:konkurs_app/models/date_model.dart';
import 'package:konkurs_app/models/event.dart';
import 'package:konkurs_app/models/event_type.dart';
import 'package:konkurs_app/models/post_model.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/screens/dashboard.dart';
import 'package:konkurs_app/services/data.dart';
import 'package:konkurs_app/services/database_service.dart';
import 'package:konkurs_app/utilities/constants.dart';

class HomeScreen1 extends StatefulWidget {
  static final String id = 'feed_screen';
  @override
  _HomeScreen1State createState() => _HomeScreen1State();
}

String userPhoto, userName;

class _HomeScreen1State extends State<HomeScreen1> {
  List<DateModel> dates = List<DateModel>();
  List<EventTypeModel> eventsType = List();
  List<EventsModel> events = List<EventsModel>();
  DatabaseService service = DatabaseService();
  final db = FirebaseFirestore.instance;

  String todayDateIs = "12";

  @override
  void initState() {
    super.initState();
    dates = getDates();
    eventsType = getEventTypes();
    events = getEvents();
    service
        .getCurrentUser()
        .then((user) => service.fetchUserDetailsById(user.uid).then((user) => {
              setState(() {
                userPhoto = user.profileImageUrl;
                userName = user.name;
              })
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Color(0xff102733)),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 60, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/images/logo.png",
                          height: 28,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "GIVE",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              "APP",
                              style: TextStyle(
                                  color: Color(0xffFCCD00),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        ),
                        Spacer(),
                        Image.asset(
                          "assets/images/notify.png",
                          height: 22,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Image.asset(
                          "assets/images/menu.png",
                          height: 22,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Привет, $userName",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 21),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Вот последние данные по конкурсам.",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DashBoardPage()),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 3, color: Color(0xffFAE072)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: CachedNetworkImageProvider(
                                userPhoto,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    /// Dates
                    Container(
                      height: 60,
                      child: ListView.builder(
                          itemCount: dates.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return DateTile(
                              weekDay: dates[index].weekDay,
                              date: dates[index].date,
                              isSelected: todayDateIs == dates[index].date,
                            );
                          }),
                    ),

                    /// Events
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "All Giveaways",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 100,
                      child: ListView.builder(
                          itemCount: eventsType.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return EventTile(
                              imgAssetPath: eventsType[index].imgAssetPath,
                              eventType: eventsType[index].eventType,
                            );
                          }),
                    ),

                    /// Popular Events
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Popular Giveaways",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    StreamBuilder(
                        stream: db
                            .collection('post')
                            .where('isFinished', isEqualTo: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: snapshot.data.docs
                                  .map<Widget>((doc) => buildItems(doc))
                                  .toList(),
                            );
                          }
                          return SizedBox();
                        })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItems(DocumentSnapshot doc) {
    return PopularEventTile(
      desc: doc.data()['description'],
      imgeAssetPath: doc.data()['imagepost'],
      date: doc.data()['date'],
      address: doc.data()['name'],
    );
  }
}

class DateTile extends StatelessWidget {
  String weekDay;
  String date;
  bool isSelected;
  DateTile({this.weekDay, this.date, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: isSelected ? Color(0xffFCCD00) : Colors.transparent,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            date,
            style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            weekDay,
            style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  String imgAssetPath;
  String eventType;
  EventTile({this.imgAssetPath, this.eventType});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          color: Color(0xff29404E), borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imgAssetPath,
            height: 27,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            eventType,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

class PopularEventTile extends StatelessWidget {
  String desc;
  Timestamp date;
  String address;
  String imgeAssetPath;

  /// later can be changed with imgUrl
  PopularEventTile({this.address, this.date, this.imgeAssetPath, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    desc,
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
                        formatOnlyDate(date.toDate()),
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/location.png",
                        height: 12,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        address,
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
              child: Image.network(
                imgeAssetPath,
                height: 100,
                width: 120,
                fit: BoxFit.cover,
              )),
        ],
      ),
    );
  }
}
