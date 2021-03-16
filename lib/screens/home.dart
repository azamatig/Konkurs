import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/models/event.dart';
import 'package:konkurs_app/models/user_data.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/screens/DetailsScreen.dart';
import 'package:konkurs_app/screens/dashboard.dart';
import 'package:konkurs_app/services/auth_service.dart';
import 'package:konkurs_app/services/data.dart';
import 'package:konkurs_app/services/database_service.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'all_giveaways.dart';
import 'my_giveaways.dart';
import 'closed_giveaways.dart';
import 'package:konkurs_app/utilities/dropdown_menu.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:konkurs_app/screens/notifications.dart';
import 'package:konkurs_app/utilities/PushNotifications.dart';
import 'package:konkurs_app/utilities/date_widget.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class HomeScreen1 extends StatefulWidget {
  static final String id = 'feed_screen';
  final currentUserId;

  const HomeScreen1({Key key, this.currentUserId}) : super(key: key);

  @override
  _HomeScreen1State createState() => _HomeScreen1State();
}

String userName;
String userPhoto;
String userId;

class _HomeScreen1State extends State<HomeScreen1>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  GlobalKey<ScaffoldMessengerState> scaffoldState =
      GlobalKey<ScaffoldMessengerState>();
  // List<DateModel> dates = List<DateModel>();
  List<EventTypeModel> eventsType;
  // List<EventsModel> events = List<EventsModel>();
  DatabaseService service = DatabaseService();
  final db = FirebaseFirestore.instance;
  AnimationController _animationController;
  CalendarController _calendarController;
  bool isSelected;
  List eventDays = [];

  initPush() async {
    await PushNotifications().initialise();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    PushNotifications().userId = widget.currentUserId;
    initPush();
    eventsType = getEventTypes();
    service.fetchUserDetailsById(widget.currentUserId).then((user) => {
          setState(() {
            userPhoto = user.profileImageUrl;
            userName = user.name;
            userId = user.id;
            setState(() {
              eventDays = user.eventDays;
            });
          })
        });
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _retrieveDynamicLink();
    }
  }

  Future<void> _retrieveDynamicLink() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      Navigator.pushNamed(context, deepLink.path);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {});
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {}

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      body: GestureDetector(
        onTap: () {
          if (SimpleAccountMenu.isMenuOpen) {
            SimpleAccountMenu.overlayEntry.remove();
            SimpleAccountMenu.animationController.reverse();
            SimpleAccountMenu.isMenuOpen = !SimpleAccountMenu.isMenuOpen;
          }
        },
        child: Container(
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
                          GestureDetector(
                            onTap: () {
                              if (SimpleAccountMenu.isMenuOpen) {
                                SimpleAccountMenu.overlayEntry.remove();
                                SimpleAccountMenu.animationController.reverse();
                                SimpleAccountMenu.isMenuOpen =
                                    !SimpleAccountMenu.isMenuOpen;
                              }
                            },
                            child: Row(
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
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Notifications()));
                            },
                            child: userId != null
                                ? StreamBuilder(
                                    stream: db
                                        .collection(
                                            "users/$userId/notifications")
                                        .orderBy('ts', descending: true)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Image.asset(
                                          "assets/images/notify.png",
                                          height: 22,
                                        );
                                      }
                                      final notification =
                                          snapshot.data.docs[0];
                                      return notification.data()['is_Unread']
                                          ? Stack(
                                              children: <Widget>[
                                                Image.asset(
                                                  "assets/images/notify.png",
                                                  height: 22,
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  child: Container(
                                                    //padding: EdgeInsets.all(1),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    constraints: BoxConstraints(
                                                      minWidth: 12,
                                                      minHeight: 12,
                                                    ),
                                                    child: Text(
                                                      '',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 8,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Image.asset(
                                              "assets/images/notify.png",
                                              height: 22,
                                            );
                                    })
                                : Image.asset(
                                    "assets/images/notify.png",
                                    height: 22,
                                  ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Container(
                            child: SimpleAccountMenu(
                              icons: [
                                Icon(Icons.person),
                                Icon(Icons.share),
                                Icon(Icons.exit_to_app),
                              ],
                              iconColor: Colors.white,
                              onChange: (index) async {
                                switch (index) {
                                  case 0:
                                    {
                                      if (SimpleAccountMenu.isMenuOpen) {
                                        SimpleAccountMenu.overlayEntry.remove();
                                        SimpleAccountMenu.animationController
                                            .reverse();
                                        SimpleAccountMenu.isMenuOpen =
                                            !SimpleAccountMenu.isMenuOpen;
                                      }
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DashBoardPage(
                                                      userId, userPhoto)));
                                    }
                                    break;
                                  case 1:
                                    {
                                      var response = await FlutterShareMe()
                                          .shareToSystem(
                                              msg:
                                                  'ссылка на приложение будет здесь');
                                      if (response == 'success') {}
                                    }
                                    break;
                                  case 2:
                                    {
                                      AuthService.logout();
                                    }
                                    break;
                                }
                              },
                            ),
                          ),
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
                                "Привет, $userName" ?? "Привет",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 21),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Добро пожаловать к нам!",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              )
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              if (SimpleAccountMenu.isMenuOpen) {
                                SimpleAccountMenu.overlayEntry.remove();
                                SimpleAccountMenu.animationController.reverse();
                                SimpleAccountMenu.isMenuOpen =
                                    !SimpleAccountMenu.isMenuOpen;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        DashBoardPage(userId, userPhoto)),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 3, color: Color(0xffFAE072)),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: StreamBuilder(
                                  stream: db
                                      .collection('users')
                                      .doc(userId)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return CircularProgressIndicator(
                                        backgroundColor:
                                            LightColors.kLightYellow,
                                        valueColor: AlwaysStoppedAnimation(
                                            LightColors.kBlue),
                                      );
                                    }
                                    User u = User.fromDoc(snapshot.data);
                                    return CircleAvatar(
                                      radius: 30,
                                      backgroundImage: userPhoto == null
                                          ? AssetImage('assets/images/ph.png')
                                          : CachedNetworkImageProvider(
                                              u.profileImageUrl),
                                    );
                                  }),
                            ),
                          )
                        ],
                      ),
                      _buildTableCalendarWithBuilders(),

                      /// Events
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Конкурсы",
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
                        "Популярные конкурсы",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 16,
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
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var arr = List(7);

  Widget _buildTableCalendarWithBuilders() {
    arr[0] = "Пн";
    arr[1] = "Вт";
    arr[2] = "Ср";
    arr[3] = "Чт";
    arr[4] = "Пт";
    arr[5] = "Сб";
    arr[6] = "Вс";
    return TableCalendar(
      locale: 'ru_RU',
      calendarController: _calendarController,
      initialCalendarFormat: CalendarFormat.week,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.horizontalSwipe,
      availableCalendarFormats: const {
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekdayStyle: TextStyle().copyWith(color: Colors.white),
        weekendStyle: TextStyle().copyWith(color: Colors.deepOrange[300]),
        holidayStyle: TextStyle().copyWith(color: Colors.deepOrange[300]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(
          color: Colors.deepOrange[300],
        ),
        weekdayStyle: TextStyle().copyWith(color: Colors.white),
      ),
      headerStyle: HeaderStyle(
        titleTextStyle: TextStyle(color: Colors.white),
        rightChevronIcon: Icon(
          FontAwesomeIcons.chevronRight,
          color: Colors.white,
          size: 15,
        ),
        leftChevronIcon: Icon(
          FontAwesomeIcons.chevronLeft,
          color: Colors.white,
          size: 15,
        ),
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
              opacity:
                  Tween(begin: 0.0, end: 1.0).animate(_animationController),
              child: DateWidget(arr, date, eventDays));
        },
        dowWeekdayBuilder: (context, weekday) {
          return Container();
        },
        dayBuilder: (context, date, events) {
          return Container(
            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
            child: Column(
              children: [
                Icon(Icons.circle, color: eventDays.contains(date.toString().substring(0, 10)) ?
          Colors.red : Color(0xff102733), size: 8,),
                SizedBox(height: 2.5,),
                Column(
                  children: [
                    _showDate(date),
                    _showWeek(date),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events, holidays);
        _animationController.forward(from: 0.0);
        if(eventDays.contains(date.toString().substring(0, 10)))
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyGiveaways(userId, userPhoto)));
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _showDate(DateTime date) {
    return Container(
        //padding: EdgeInsets.all(2),
        child: Text(
          arr[date.weekday - 1],
          style: TextStyle(color: Colors.white),
        ));
  }

  Widget _showWeek(DateTime date) {
    return Container(
        padding: EdgeInsets.all(2),
        child: Text(
          '${date.day}',
          style: TextStyle(color: Colors.white),
        ));
  }

  Widget _showDate1(DateTime date) {
    return Container(
        padding: EdgeInsets.all(2),
        child: Text(
          arr[date.weekday - 1],
          style: TextStyle(color: Colors.black),
        ));
  }

  Widget _showWeek1(DateTime date) {
    return Container(
        padding: EdgeInsets.all(2),
        child: Text(
          '${date.day}',
          style: TextStyle(color: Colors.black),
        ));
  }

  Widget buildItems(DocumentSnapshot doc) {
    return PopularEventTile(
      userId: Provider.of<UserData>(context).currentUserId,
      doc: doc,
      desc: doc.data()['description'],
      imgeAssetPath: doc.data()['imagepost'],
      date: doc.data()['date'],
      name: doc.data()['name'],
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
    return GestureDetector(
      onTap: () {
        switch (eventType) {
          case "Все конкурсы":
            {
              if (SimpleAccountMenu.isMenuOpen) {
                SimpleAccountMenu.overlayEntry.remove();
                SimpleAccountMenu.animationController.reverse();
                SimpleAccountMenu.isMenuOpen = !SimpleAccountMenu.isMenuOpen;
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllGiveaways(
                            userPhoto: userPhoto,
                          )));
            }
            break;
          case "Мои участия":
            {
              if (SimpleAccountMenu.isMenuOpen) {
                SimpleAccountMenu.overlayEntry.remove();
                SimpleAccountMenu.animationController.reverse();
                SimpleAccountMenu.isMenuOpen = !SimpleAccountMenu.isMenuOpen;
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyGiveaways(userId, userPhoto)));
            }
            break;
          case "Завершенные":
            {
              if (SimpleAccountMenu.isMenuOpen) {
                SimpleAccountMenu.overlayEntry.remove();
                SimpleAccountMenu.animationController.reverse();
                SimpleAccountMenu.isMenuOpen = !SimpleAccountMenu.isMenuOpen;
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ClosedGiveaways(
                            userPhoto: userPhoto,
                          )));
            }
            break;
        }
      },
      child: Container(
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
              height: 30,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              eventType,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PopularEventTile extends StatelessWidget {
  String desc;
  Timestamp date;
  String userId;
  String name;
  String imgeAssetPath;
  DocumentSnapshot doc;
  final db = FirebaseFirestore.instance;

  /// later can be changed with imgUrl
  PopularEventTile(
      {this.name,
      this.date,
      this.imgeAssetPath,
      this.desc,
      this.doc,
      this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (SimpleAccountMenu.isMenuOpen) {
          SimpleAccountMenu.overlayEntry.remove();
          SimpleAccountMenu.animationController.reverse();
          SimpleAccountMenu.isMenuOpen = !SimpleAccountMenu.isMenuOpen;
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DetailsScreen(
                      docId: doc.id,
                      docRef: doc.reference,
                      date: doc.data()['date'],
                      userId: userId,
                      userPhoto: userPhoto,
                      instaLink1: doc.data()['task1InstaLink'],
                      instaLink2: doc.data()['task2InstaLink'],
                      instaLink3: doc.data()['task3InstaLink'],
                      endDate: doc.data()['endDate'],
                      likesCount: doc.data()['likesCount'],
                      giveawayCost: doc.data()['giveawayCost'],
                      eventDays: doc.data()['eventDays'],
                    )));
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
                      name,
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
                          '${desc.substring(0, 20)} ...',
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
                  imageUrl: imgeAssetPath,
                  height: 100,
                  width: 120,
                  fit: BoxFit.cover,
                )),
          ],
        ),
      ),
    );
  }
}
