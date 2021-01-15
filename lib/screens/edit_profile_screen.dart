import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
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
  String _q5 = '';
  String _q12 = '';
  List<String> _q1 = [];
  List<String> _q2 = [];
  List<String> _q3 = [];
  List<String> _q4 = [];
  List<String> _q6 = [];
  List<String> _q7 = [];
  List<String> _q8 = [];
  List<String> _q9 = [];
  List<String> _q10 = [];
  List<String> _q11 = [];
  List<String> _q13 = [];

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _insta = widget.user.insta;
    _phone = widget.user.phone;
    _location = widget.user.location;
  }

  _handleImageFromGallery() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _profileImage = imageFile;
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
        q5: _q5,
        q12: _q12,
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
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
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: CheckboxGroup(
                                orientation: GroupedButtonsOrientation.VERTICAL,
                                margin: const EdgeInsets.only(left: 12.0),
                                onSelected: (List selected) => setState(() {
                                  _q1 = selected;
                                }),
                                labels: <String>[
                                  "1 раз в 2-3 года",
                                  "1 раз в год",
                                  "2-3 раза в год",
                                  "более 3 раз в год",
                                  "Затрудняюсь ответить"
                                ],
                                checked: _q1,
                                itemBuilder: (Checkbox cb, Text txt, int i) {
                                  return Row(
                                    children: <Widget>[
                                      cb,
                                      txt,
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
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
                                  Text(
                                    "Какая средняя продолжительность вашего отдыха?",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: CheckboxGroup(
                                orientation: GroupedButtonsOrientation.VERTICAL,
                                margin: const EdgeInsets.only(left: 12.0),
                                onSelected: (List selected) => setState(() {
                                  _q2 = selected;
                                }),
                                labels: <String>[
                                  "менее 7 дней",
                                  "7 дней",
                                  "7-14 дней",
                                  "14-21 дней",
                                  "21-28",
                                  "больее 28 дней"
                                ],
                                checked: _q2,
                                itemBuilder: (Checkbox cb, Text txt, int i) {
                                  return Row(
                                    children: <Widget>[
                                      cb,
                                      txt,
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
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
                                  Text(
                                    "В какое время года вы препочитаете путешествовать?",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: CheckboxGroup(
                                orientation: GroupedButtonsOrientation.VERTICAL,
                                margin: const EdgeInsets.only(left: 12.0),
                                onSelected: (List selected) => setState(() {
                                  _q3 = selected;
                                }),
                                labels: <String>[
                                  "зима",
                                  "весна",
                                  "лето",
                                  "осень",
                                  "неважно"
                                ],
                                checked: _q3,
                                itemBuilder: (Checkbox cb, Text txt, int i) {
                                  return Row(
                                    children: <Widget>[
                                      cb,
                                      txt,
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
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
                                  Text(
                                    "Какие страны для отдыха вы предпочитаете?",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: CheckboxGroup(
                                orientation: GroupedButtonsOrientation.VERTICAL,
                                margin: const EdgeInsets.only(left: 12.0),
                                onSelected: (List selected) => setState(() {
                                  _q4 = selected;
                                }),
                                labels: <String>[
                                  "Турция",
                                  "Египет",
                                  "ОАЭ",
                                  "Тайланд",
                                  "Индия",
                                  "Китай",
                                  "Доминикана",
                                  "Европа",
                                  "Грузия"
                                ],
                                checked: _q4,
                                itemBuilder: (Checkbox cb, Text txt, int i) {
                                  return Row(
                                    children: <Widget>[
                                      cb,
                                      txt,
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
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
                                  Text(
                                    "Какой вид отдыха вы предпочитаете?",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: CheckboxGroup(
                                orientation: GroupedButtonsOrientation.VERTICAL,
                                margin: const EdgeInsets.only(left: 12.0),
                                onSelected: (List selected) => setState(() {
                                  _q6 = selected;
                                }),
                                labels: <String>[
                                  "Пляжный отдых",
                                  "Посещение исторических памятников",
                                  "Посещение храмов и т.д.",
                                  "Посещение заповедников",
                                  "Отдых на природе",
                                  "Экстрим отдых",
                                  "Посещение праздников"
                                ],
                                checked: _q6,
                                itemBuilder: (Checkbox cb, Text txt, int i) {
                                  return Row(
                                    children: <Widget>[
                                      cb,
                                      txt,
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
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
                                  Text(
                                    "Как вы предпочитаете организовать свой отдых?",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: CheckboxGroup(
                                orientation: GroupedButtonsOrientation.VERTICAL,
                                margin: const EdgeInsets.only(left: 12.0),
                                onSelected: (List selected) => setState(() {
                                  _q7 = selected;
                                }),
                                labels: <String>[
                                  "Самостоятельно",
                                  "через туроператоров и агенства"
                                ],
                                checked: _q7,
                                itemBuilder: (Checkbox cb, Text txt, int i) {
                                  return Row(
                                    children: <Widget>[
                                      cb,
                                      txt,
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
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
                                  Text(
                                    "Что вы ждете от отдыха?",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: CheckboxGroup(
                                orientation: GroupedButtonsOrientation.VERTICAL,
                                margin: const EdgeInsets.only(left: 12.0),
                                onSelected: (List selected) => setState(() {
                                  _q8 = selected;
                                }),
                                labels: <String>[
                                  "Получить новые знания, увидеть памятники истории, музеи",
                                  "Посетить святые места",
                                  "Отдохнуть на природе или на пляже вдали от города",
                                  "Экстремально отдохнуть",
                                  "Окунуться в особенную атмосферу места, где я планирую отдохнуть",
                                  "Просто провести время с семьей и друзьями"
                                ],
                                checked: _q8,
                                itemBuilder: (Checkbox cb, Text txt, int i) {
                                  return Row(
                                    children: <Widget>[
                                      cb,
                                      txt,
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
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
                                  Text(
                                    "Какие места проживания вы предпочитаете на время путешествий?",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: CheckboxGroup(
                                orientation: GroupedButtonsOrientation.VERTICAL,
                                margin: const EdgeInsets.only(left: 12.0),
                                onSelected: (List selected) => setState(() {
                                  _q9 = selected;
                                }),
                                labels: <String>[
                                  "хостелы",
                                  "гостиницы",
                                  "мотели",
                                  "пансионаты",
                                  "гостевые дома",
                                  "турбазы"
                                ],
                                checked: _q9,
                                itemBuilder: (Checkbox cb, Text txt, int i) {
                                  return Row(
                                    children: <Widget>[
                                      cb,
                                      txt,
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
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
                                  Text(
                                    "Ваш предполагаемый бюджет на путешествие?",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: CheckboxGroup(
                                orientation: GroupedButtonsOrientation.VERTICAL,
                                margin: const EdgeInsets.only(left: 12.0),
                                onSelected: (List selected) => setState(() {
                                  _q10 = selected;
                                }),
                                labels: <String>[
                                  "500-1000%",
                                  "1000-2000%",
                                  "2000-5000%",
                                  "больше 5000%"
                                ],
                                checked: _q10,
                                itemBuilder: (Checkbox cb, Text txt, int i) {
                                  return Row(
                                    children: <Widget>[
                                      cb,
                                      txt,
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: CheckboxGroup(
                                orientation: GroupedButtonsOrientation.VERTICAL,
                                margin: const EdgeInsets.only(left: 12.0),
                                onSelected: (List selected) => setState(() {
                                  _q11 = selected;
                                }),
                                labels: <String>[
                                  "3 звезды",
                                  "4 звезды",
                                  "5 звезд",
                                  "не был(а) в отеле"
                                ],
                                checked: _q11,
                                itemBuilder: (Checkbox cb, Text txt, int i) {
                                  return Row(
                                    children: <Widget>[
                                      cb,
                                      txt,
                                    ],
                                  );
                                },
                              ),
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
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: CheckboxGroup(
                                orientation: GroupedButtonsOrientation.VERTICAL,
                                margin: const EdgeInsets.only(left: 12.0),
                                onSelected: (List selected) => setState(() {
                                  _q13 = selected;
                                }),
                                labels: <String>[
                                  "Да",
                                  "Нет",
                                ],
                                checked: _q13,
                                itemBuilder: (Checkbox cb, Text txt, int i) {
                                  return Row(
                                    children: <Widget>[
                                      cb,
                                      txt,
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
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
    );
  }
}
