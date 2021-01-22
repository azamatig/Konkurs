import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/models/date_model.dart';
import 'package:konkurs_app/models/event.dart';
import 'package:konkurs_app/models/event_type.dart';
import 'package:konkurs_app/models/user_data.dart';
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
    with TickerProviderStateMixin {
  List<DateModel> dates = List<DateModel>();
  List<EventTypeModel> eventsType = List();
  List<EventsModel> events = List<EventsModel>();
  DatabaseService service = DatabaseService();
  final db = FirebaseFirestore.instance;
  AnimationController _animationController;
  CalendarController _calendarController;
  String todayDateIs = "12";
  bool isSelected;

  @override
  void initState() {
    super.initState();
    dates = getDates();
    eventsType = getEventTypes();
    events = getEvents();
    service.fetchUserDetailsById(widget.currentUserId).then((user) => {
          setState(() {
            userPhoto = user.profileImageUrl;
            userName = user.name;
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
      DateTime first, DateTime last, CalendarFormat format) {
    service
        .getCurrentUser()
        .then((user) => service.fetchUserDetailsById(user.uid).then((user) => {
              setState(() {
                userPhoto = user.profileImageUrl;
                userName = user.name;
                userId = user.id;
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
                        GestureDetector(
                          onTap: () => AuthService.logout(),
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
                        Image.asset(
                          "assets/images/notify.png",
                          height: 22,
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DashBoardPage(userId)));
                                  }
                                  break;
                                case 1:
                                  {
                                    var response = await FlutterShareMe()
                                        .shareToSystem(
                                            msg:
                                                'ссылка на приложение будет здесь');
                                    if (response == 'success') {
                                      print('navigate success');
                                    }
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
                            MaterialPageRoute(
                                builder: (_) => DashBoardPage(userId)),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 3, color: Color(0xffFAE072)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: userPhoto == null
                                  ? AssetImage('assets/images/ph.png')
                                  : NetworkImage(userPhoto),
                            ),
                          ),
                        )
                      ],
                    ),
      body: GestureDetector(
        onTap: (){
           SimpleAccountMenu.overlayEntry.remove();
           SimpleAccountMenu.isMenuOpen = !SimpleAccountMenu.isMenuOpen;
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
                            onTap: () => AuthService.logout(),
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
                          Image.asset(
                            "assets/images/notify.png",
                            height: 22,
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
                                       Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                             builder: (context) =>
                                                   DashBoardPage(userId)));
                                    }
                                    break;
                                  case 1:
                                    {
                                      var response = await FlutterShareMe()
                                          .shareToSystem(msg: 'ссылка на приложение будет здесь');
                                      if (response == 'success') {
                                        print('navigate success');
                                      }
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              )
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              SimpleAccountMenu.overlayEntry.remove();
                              SimpleAccountMenu.isMenuOpen = !SimpleAccountMenu.isMenuOpen;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DashBoardPage(userId)),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 3, color: Color(0xffFAE072)),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: userPhoto.isEmpty
                                    ? AssetImage('assets/images/ph.png')
                                    : CachedNetworkImageProvider(userPhoto),
                              ),
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
                        })
                  ],
                ),
              ),
            ),
          ],
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
      ),
    );
  }

  var arr = new List(7);

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
              child: Container(
                margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                decoration: BoxDecoration(
                    color: const Color(0xffFCCD00),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    border:
                        Border.all(color: const Color(0xffFCCD00), width: 1)),
                child: Column(
                  children: [
                    _showDate1(date),
                    SizedBox(
                      height: 5,
                    ),
                    _showWeek1(date),
                  ],
                ),
              ));
        },
        dowWeekdayBuilder: (context, weekday) {
          return Container();
        },
        dayBuilder: (context, date, events) {
          return Container(
            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
            child: Column(
              children: [
                _showDate(date),
                _showWeek(date),
              ],
            ),
          );
        },
      ),
      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events, holidays);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _showDate(DateTime date) {
    return Container(
        padding: EdgeInsets.all(2),
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
      doc: doc ?? " ",
      desc: doc.data()['description'] ?? " ",
      imgeAssetPath: doc.data()['imagepost'] ?? "",
      date: doc.data()['date'] ?? "",
      address: doc.data()['name'] ?? "",
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
              SimpleAccountMenu.overlayEntry.remove();
              SimpleAccountMenu.isMenuOpen = !SimpleAccountMenu.isMenuOpen;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllGiveaways()));
            }
            break;
          case "Мои конкурсы":
            {
              SimpleAccountMenu.overlayEntry.remove();
              SimpleAccountMenu.isMenuOpen = !SimpleAccountMenu.isMenuOpen;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyGiveaways(userId)));
            }
            break;
          case "Завершенные":
            {
              SimpleAccountMenu.overlayEntry.remove();
              SimpleAccountMenu.isMenuOpen = !SimpleAccountMenu.isMenuOpen;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ClosedGiveaways()));
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
      ),
    );
  }
}

class PopularEventTile extends StatelessWidget {
  String desc;
  Timestamp date;
  String address;
  String imgeAssetPath;
  DocumentSnapshot doc;

  /// later can be changed with imgUrl
  PopularEventTile(
      {this.address, this.date, this.imgeAssetPath, this.desc, this.doc});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SimpleAccountMenu.overlayEntry.remove();
        SimpleAccountMenu.isMenuOpen = !SimpleAccountMenu.isMenuOpen;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DetailsScreen(
                      docId: doc.id,
                      docRef: doc.reference,
                      date: doc.data()['date'],
                      userId: Provider.of<UserData>(context).currentUserId,
                      isShared: doc.data()['shared'],
                      prize: doc.data()['prize'],
                      task1: doc.data()['task1'],
                      task2: doc.data()['task2'],
                      task3: doc.data()['task3'],
                      postImage: doc.data()['imagepost'],
                      postName: doc.data()['name'],
                      postDesc: doc.data()['description'],
                      isFinished: doc.data()['isFinished'],
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
      ),
    );
  }
}
