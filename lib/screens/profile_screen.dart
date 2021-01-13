import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/screens/edit_profile_screen.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/utils.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  ProfileScreen({this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget _profileDetails() {
    return FutureBuilder(
        future: usersRef.doc(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          User user = User.fromDoc(snapshot.data);
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          height: MediaQuery.of(context).size.height,
                          child: ListView(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            primary: false,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      // Текст имя
                                      user.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                    ),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditProfileScreen(
                                          user: user,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.blueGrey[300],
                                  ),
                                  SizedBox(width: 3),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      // Местополодение
                                      user.location,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.blueGrey[300],
                                      ),
                                      maxLines: 1,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 3),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  // Возраст
                                  user.age,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.blueGrey[300]),
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(height: 40),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Обо мне",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  //Текст обо мне
                                  user.bio,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: usersRef.doc(widget.userId).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            User user = User.fromDoc(snapshot.data);

            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    user.profileImageUrl.isEmpty == null
                        ? 'https://www.seekpng.com/png/detail/115-1150053_avatar-png-transparent-png-royalty-free-default-user.png'
                        : (user.profileImageUrl),
                  ),
                ),
              ),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 170.0, 20.0),
                      child: Text(
                        'Ваш профиль',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: AvailableFonts.primaryFont,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Material(
                      elevation: 14.0,
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0)),
                      shadowColor: Colors.grey,
                      child: _profileDetails(),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
