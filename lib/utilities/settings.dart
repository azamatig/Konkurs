import 'package:flutter/material.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/utilities/achievements_view.dart';
import 'package:konkurs_app/utilities/next_screen.dart';

import '../screens/main_screens/edit_profile_screen.dart';

class Settings extends StatefulWidget {
  final User user;
  Settings(this.user);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSwitched = pushIsOn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff102733),
      appBar: AppBar(
        backgroundColor: Color(0xff102733),
        title: Text("Настройки"),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                nextScreen(
                    context,
                    EditProfileScreen(
                      user: widget.user,
                    ));
              },
              child: Text(
                'Настройки профиля',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Уведомления',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                    pushIsOn = isSwitched;
                  },
                  activeTrackColor: Colors.yellow,
                  activeColor: Color(0xffFCCD00),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
