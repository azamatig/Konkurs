import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:konkurs_app/screens/feed_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          FeedScreen(),
          //   SearchScreen(),
          //     CreatePostScreen(),
          //      ActivityScreen(),
          //       ProfileScreen(userId: Provider.of<UserData>(context).currentUserId),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentTab = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentTab,
        onTap: (int index) {
          setState(() {
            _currentTab = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
        activeColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 20.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.filter_list,
              size: 20.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.attach_money,
              size: 20.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
