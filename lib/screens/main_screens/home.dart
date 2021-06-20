import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konkurs_app/blocs/parent_bloc.dart';
import 'package:konkurs_app/models/event.dart';
import 'package:konkurs_app/screens/auxillary/notifications.dart';
import 'package:konkurs_app/screens/giveaways/my_giveaways.dart';
import 'package:konkurs_app/screens/main_screens/profile_screen.dart';
import 'package:konkurs_app/services/data.dart';
import 'package:konkurs_app/utilities/date_widget.dart';
import 'package:konkurs_app/utilities/event_tile.dart';
import 'package:konkurs_app/utilities/next_screen.dart';
import 'package:konkurs_app/utilities/popular_events_tile.dart';
import 'package:konkurs_app/utilities/push_notifications.dart';
import 'package:konkurs_app/widgets/hand_cursor.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';
  final currentUserId;

  const HomeScreen({Key key, this.currentUserId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  GlobalKey<ScaffoldMessengerState> scaffoldState =
      GlobalKey<ScaffoldMessengerState>();
  List<EventTypeModel> eventsType;

  final db = FirebaseFirestore.instance;
  AnimationController _animationController;
  CalendarController _calendarController;
  bool isSelected;
  List eventDays = [];

  EdgeInsets get paddingOfMainContainer {
    final width = MediaQuery.of(context).size.width;
    if (width > 900) {
      return EdgeInsets.symmetric(vertical: 60, horizontal: 300);
    }
    return EdgeInsets.symmetric(vertical: 60, horizontal: 30);
  }

  initPush() async {
    await PushNotifications().initialise();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<ParentBloc>().getPartnerSetup(widget.currentUserId);
    PushNotifications().userId = widget.currentUserId;
    initPush();
    eventsType = getEventTypes();
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
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
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

  @override
  Widget build(BuildContext context) {
    final u = context.watch<ParentBloc>();
    return Scaffold(
      key: scaffoldState,
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Color(0xff102733)),
            ),
            SingleChildScrollView(
              child: Container(
                padding: paddingOfMainContainer,
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
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              "APP",
                              style: GoogleFonts.roboto(
                                  color: Color(0xffFCCD00),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            nextScreen(
                                context,
                                Notifications(
                                  userid: u.uid,
                                ));
                          },
                          child: u.uid != null
                              ? notificationsWidget()
                              : Image.asset(
                                  "assets/images/notify.png",
                                  height: 22,
                                ),
                        ),
                        SizedBox(
                          width: 5,
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
                              u.name != null ? "Привет, " + u.name : "Привет",
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 21),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Добро пожаловать к нам!",
                              style: GoogleFonts.roboto(
                                  color: Colors.white, fontSize: 15),
                            )
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            nextScreen(
                                context, ProfileScreen(u.uid, u.imageUrl));
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 3, color: Color(0xffFAE072)),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: u.imageUrl == null
                                    ? AssetImage('assets/images/ph.png')
                                    : CachedNetworkImageProvider(u.imageUrl),
                              )),
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
                      style:
                          GoogleFonts.roboto(color: Colors.white, fontSize: 20),
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
                              userPhoto: u.imageUrl,
                              userId: u.imageUrl,
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
    );
  }

  var arr = List.filled(7, "");

  Widget _buildTableCalendarWithBuilders() {
    final width =
        MediaQuery.of(context).size.width > 400 ? 320 : double.maxFinite;
    final u = context.watch<ParentBloc>();
    arr[0] = "Пн";
    arr[1] = "Вт";
    arr[2] = "Ср";
    arr[3] = "Чт";
    arr[4] = "Пт";
    arr[5] = "Сб";
    arr[6] = "Вс";
    return Container(
        width: width,
        child: TableCalendar(
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
            titleTextStyle: GoogleFonts.roboto(color: Colors.white),
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
              return HandCursor(
                  child: FadeTransition(
                      opacity: Tween(begin: 0.0, end: 1.0)
                          .animate(_animationController),
                      child: DateWidget(arr, date, eventDays)));
            },
            dowWeekdayBuilder: (context, weekday) {
              return Container();
            },
            dayBuilder: (context, date, events) {
              return HandCursor(
                  child: Container(
                margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: Column(
                  children: [
                    Icon(Icons.circle,
                        color:
                            eventDays.contains(date.toString().substring(0, 10))
                                ? Colors.red
                                : Color(0xff102733),
                        size: 1),
                    Column(
                      children: [
                        _showDate(date),
                        _showWeek(date),
                      ],
                    ),
                  ],
                ),
              ));
            },
          ),
          onDaySelected: (date, events, holidays) {
            _onDaySelected(date, events, holidays);
            _animationController.forward(from: 0.0);
            if (eventDays.contains(date.toString().substring(0, 10)))
              nextScreen(context, MyGiveaways(u.uid, u.imageUrl));
          },
          onVisibleDaysChanged: _onVisibleDaysChanged,
          onCalendarCreated: _onCalendarCreated,
        ));
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {});
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {}

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {}

  Widget _showDate(DateTime date) {
    return Container(
        //padding: EdgeInsets.all(2),
        child: Text(
      arr[date.weekday - 1],
      style: GoogleFonts.roboto(color: Colors.white),
    ));
  }

  Widget _showWeek(DateTime date) {
    return Container(
        padding: EdgeInsets.all(2),
        child: Text(
          '${date.day}',
          style: GoogleFonts.roboto(color: Colors.white),
        ));
  }

  Widget buildItems(DocumentSnapshot doc) {
    final u = context.watch<ParentBloc>();
    return PopularEventTile(
      userId: u.uid,
      doc: doc,
      desc: doc.data()['description'],
      userPhoto: u.imageUrl,
      imgeAssetPath: doc.data()['imagepost'],
      date: doc.data()['date'],
      name: doc.data()['name'],
    );
  }

  Widget notificationsWidget() {
    final u = context.watch<ParentBloc>();
    return StreamBuilder(
        stream: db
            .collection("users")
            .doc(u.uid)
            .collection('notifications')
            .orderBy('ts', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Image.asset(
              "assets/images/notify.png",
              height: 22,
            );
          }
          final notification = snapshot.data.docs[0];
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
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                )
              : Image.asset(
                  "assets/images/notify.png",
                  height: 22,
                );
        });
  }
}
