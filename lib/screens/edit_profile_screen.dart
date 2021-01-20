import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/services/database_service.dart';
import 'package:konkurs_app/services/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File _profileImage;
  String _name = '';
  String _insta = '';
  String _phone = '';
  String _location = '';
  bool _isLoading = false;
  bool _isChecked = false;
  String _q1 = '';
  String _q2 = '';
  String _q3 = '';
  String _q4 = '';
  String _q6 = '';
  String _q7 = '';
  String _q8 = '';
  String _q9 = '';
  String _q10 = '';
  String _q11 = '';
  String _q13 = '';
  String _q5 = '';
  String _q12 = '';
  List<String> q1 = [
    "1 раз в 2-3 года",
    "1 раз в год",
    "2-3 раза в год",
    "более 3 раз в год",
    "Затрудняюсь ответить"
  ];
  List<String> q2 = [
    "менее 7 дней",
    "7 дней",
    "7-14 дней",
    "14-21 дней",
    "21-28",
    "больее 28 дней"
  ];
  List<String> q3 = ["зима", "весна", "лето", "осень", "неважно"];
  List<String> q4 = [
    "Турция",
    "Египет",
    "ОАЭ",
    "Тайланд",
    "Индия",
    "Китай",
    "Доминикана",
    "Европа",
    "Грузия"
  ];
  List<String> q6 = [
    "Пляжный отдых",
    "Посещение исторических памятников",
    "Посещение храмов и т.д.",
    "Посещение заповедников",
    "Отдых на природе",
    "Экстрим отдых",
    "Посещение праздников"
  ];
  List<String> q7 = ["Самостоятельно", "через туроператоров и агенства"];
  List<String> q8 = [
    "Получить новые знания, увидеть памятники истории, музеи",
    "Посетить святые места",
    "Отдохнуть на природе или на пляже вдали от города",
    "Экстремально отдохнуть",
    "Окунуться в особенную атмосферу места, где я планирую отдохнуть",
    "Просто провести время с семьей и друзьями"
  ];
  List<String> q9 = [
    "хостелы",
    "гостиницы",
    "мотели",
    "пансионаты",
    "гостевые дома",
    "турбазы"
  ];
  List<String> q10 = ["500-1000%", "1000-2000%", "2000-5000%", "больше 5000%"];
  List<String> q11 = ["3 звезды", "4 звезды", "5 звезд", "не был(а) в отеле"];
  List<String> q13 = [
    "Да",
    "Нет",
  ];

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _insta = widget.user.insta;
    _phone = widget.user.phone;
    _location = widget.user.location;
  }

  _handleImageFromGallery() async {
    PickedFile imageFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    File selected = File(imageFile.path);
    if (imageFile != null) {
      setState(() {
        _profileImage = selected;
      });
    }
  }

  _displayProfileImage() {
    // No new profile image
    if (_profileImage == null) {
      // No existing profile image
      if (widget.user.profileImageUrl.isEmpty) {
        // Display placeholder
        return AssetImage('assets/images/ph.png');
      } else {
        // User profile image exists
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
      }
    } else {
      // New profile image
      return FileImage(_profileImage);
    }
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });

      // Update user in database
      String _profileImageUrl = '';

      if (_profileImage == null) {
        _profileImageUrl = widget.user.profileImageUrl;
      } else {
        _profileImageUrl = await StorageService.uploadUserProfileImage(
          widget.user.profileImageUrl,
          _profileImage,
        );
      }

      User user = User(
        id: widget.user.id,
        name: _name,
        profileImageUrl: _profileImageUrl,
        insta: _insta,
        phone: _phone,
        location: _location,
      );

      // Database update
      DatabaseService.updateUser(user);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Редактировать профиль',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: <Widget>[
              _isLoading
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.blue[200],
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                    )
                  : SizedBox.shrink(),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Colors.grey,
                        backgroundImage: _displayProfileImage(),
                      ),
                      FlatButton(
                        onPressed: _handleImageFromGallery,
                        child: Text(
                          'Загрузить фото профиля',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 16.0),
                        ),
                      ),
                      TextFormField(
                        initialValue: _name,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            size: 30.0,
                          ),
                          labelText: 'ФИО',
                        ),
                        validator: (input) => input.trim().length < 1
                            ? 'Пожалуйста введите действительное ФИО'
                            : null,
                        onSaved: (input) => _name = input,
                      ),
                      TextFormField(
                        initialValue: _insta,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.book,
                            size: 30.0,
                          ),
                          labelText: 'Ваш логин в instagram',
                        ),
                        validator: (input) => input.trim().length > 150
                            ? 'Не больше 150 символов'
                            : null,
                        onSaved: (input) => _insta = input,
                      ),
                      TextFormField(
                        initialValue: _phone,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.account_circle,
                            size: 30.0,
                          ),
                          labelText: 'Телефон',
                        ),
                        validator: (input) =>
                            input.trim().length < 1 ? 'Введите возраст' : null,
                        onSaved: (input) => _phone = input,
                      ),
                      TextFormField(
                        initialValue: _location,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.pin_drop,
                            size: 30.0,
                          ),
                          labelText: 'Город',
                        ),
                        validator: (input) => input.trim().length < 1
                            ? 'Пожалуйста введите действительно местоположение'
                            : null,
                        onSaved: (input) => _location = input,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 10),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.solidQuestionCircle,
                                      color: Colors.black38,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Как часто вы путешествуете?",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                )),
                            Container(
                              height: 280,
                              child: Column(
                                children: q1
                                    .map((e) => CheckboxListTile(
                                          title: Text(e),
                                          value: _isChecked,
                                          onChanged: (val) {
                                            setState(() {
                                              _isChecked = val;
                                              if (val == true) {
                                                _q1 = e;
                                              }
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 10),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.solidQuestionCircle,
                                      color: Colors.black38,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 75,
                                      width: 300,
                                      child: Text(
                                        "Какая средняя продолжительность вашего отдыха?",
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              height: 336,
                              child: Column(
                                children: q2
                                    .map((e) => CheckboxListTile(
                                          title: Text(e),
                                          value: _isChecked,
                                          onChanged: (val) {
                                            setState(() {
                                              _isChecked = val;
                                              if (val == true) {
                                                _q2 = e;
                                              }
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 10),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.solidQuestionCircle,
                                      color: Colors.black38,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 60,
                                      width: 325,
                                      child: Text(
                                        "В какое время года вы препочитаете путешествовать?",
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              height: 280,
                              child: Column(
                                children: q3
                                    .map((e) => CheckboxListTile(
                                          title: Text(e),
                                          value: _isChecked,
                                          onChanged: (val) {
                                            setState(() {
                                              _isChecked = val;
                                              if (val == true) {
                                                _q3 = e;
                                              }
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 10),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.solidQuestionCircle,
                                      color: Colors.black38,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 250,
                                      child: Text(
                                        "Какие страны для отдыха вы предпочитаете?",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              height: 505,
                              child: Column(
                                children: q4
                                    .map((e) => CheckboxListTile(
                                          title: Text(e),
                                          value: _isChecked,
                                          onChanged: (val) {
                                            setState(() {
                                              _isChecked = val;
                                              if (val == true) {
                                                _q4 = e;
                                              }
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        initialValue: _q5,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.pin_drop,
                            size: 30.0,
                          ),
                          labelText: 'Другие страны (через запятую)',
                        ),
                        onSaved: (input) => _q5 = input,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 10),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.solidQuestionCircle,
                                      color: Colors.black38,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 250,
                                      child: Text(
                                        "Какой вид отдыха вы предпочитаете?",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              height: 392,
                              child: Column(
                                children: q6
                                    .map((e) => CheckboxListTile(
                                          title: Text(e),
                                          value: _isChecked,
                                          onChanged: (val) {
                                            setState(() {
                                              _isChecked = val;
                                              if (val == true) {
                                                _q6 = e;
                                              }
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 10),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.solidQuestionCircle,
                                      color: Colors.black38,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 250,
                                      child: Text(
                                        "Как вы предпочитаете организовать свой отдых?",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              height: 112,
                              child: Column(
                                children: q7
                                    .map((e) => CheckboxListTile(
                                          title: Text(e),
                                          value: _isChecked,
                                          onChanged: (val) {
                                            setState(() {
                                              _isChecked = val;
                                              if (val == true) {
                                                _q7 = e;
                                              }
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 10),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.solidQuestionCircle,
                                      color: Colors.black38,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 250,
                                      child: Text(
                                        "Что вы ждете от отдыха?",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              height: 336,
                              child: Column(
                                children: q8
                                    .map((e) => CheckboxListTile(
                                          title: Text(e),
                                          value: _isChecked,
                                          onChanged: (val) {
                                            setState(() {
                                              _isChecked = val;
                                              if (val == true) {
                                                _q8 = e;
                                              }
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 10),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.solidQuestionCircle,
                                      color: Colors.black38,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 280,
                                      child: Text(
                                        "Какие места проживания вы предпочитаете на время путешествий?",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              height: 336,
                              child: Column(
                                children: q9
                                    .map((e) => CheckboxListTile(
                                          title: Text(e),
                                          value: _isChecked,
                                          onChanged: (val) {
                                            setState(() {
                                              _isChecked = val;
                                              if (val == true) {
                                                _q9 = e;
                                              }
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 10),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.solidQuestionCircle,
                                      color: Colors.black38,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 282,
                                      child: Text(
                                        "Ваш предполагаемый бюджет на путешествие?",
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              height: 224,
                              child: Column(
                                children: q10
                                    .map((e) => CheckboxListTile(
                                          title: Text(e),
                                          value: _isChecked,
                                          onChanged: (val) {
                                            setState(() {
                                              _isChecked = val;
                                              if (val == true) {
                                                _q10 = e;
                                              }
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 10),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.solidQuestionCircle,
                                      color: Colors.black38,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 250,
                                      child: Text(
                                        "В какой категории отеля вы чаще всего останавливались?",
                                        style: TextStyle(fontSize: 18),
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              height: 224,
                              child: Column(
                                children: q11
                                    .map((e) => CheckboxListTile(
                                          title: Text(e),
                                          value: _isChecked,
                                          onChanged: (val) {
                                            setState(() {
                                              _isChecked = val;
                                              if (val == true) {
                                                _q11 = e;
                                              }
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        initialValue: _q12,
                        style: TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.pin_drop,
                            size: 30.0,
                          ),
                          labelText:
                              'Сколько человек обычно путешествует вместе с вами?',
                        ),
                        validator: (input) => input.trim().length < 1
                            ? 'Пожалуйста введите число'
                            : null,
                        onSaved: (input) => _q12 = input,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, top: 10),
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.solidQuestionCircle,
                                      color: Colors.black38,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Путешествуете ли вы с детьми?",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                )),
                            Container(
                              height: 112,
                              child: Column(
                                children: q13
                                    .map((e) => CheckboxListTile(
                                          title: Text(e),
                                          value: _isChecked,
                                          onChanged: (val) {
                                            setState(() {
                                              _isChecked = val;
                                              if (val == true) {
                                                _q13 = e;
                                              }
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(40.0),
                        height: 40.0,
                        width: 250.0,
                        child: FlatButton(
                          onPressed: _submit,
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Text(
                            'Сохранить',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
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
}
