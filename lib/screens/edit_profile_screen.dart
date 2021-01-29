import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/services/database_service.dart';
import 'package:konkurs_app/services/storage_service.dart';
import 'package:konkurs_app/utilities/constants.dart';

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
      backgroundColor: Color(0xff102733),
      appBar: AppBar(
        backgroundColor: Color(0xff102733),
        title: Text(
          'Редактировать профиль',
          style: TextStyle(color: LightColors.kLightYellow),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: LightColors.kLightYellow, //change your color here
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: <Widget>[
              _isLoading
                  ? LinearProgressIndicator(
                      backgroundColor: LightColors.kLightYellow2,
                      valueColor: AlwaysStoppedAnimation(LightColors.kBlue),
                    )
                  : SizedBox.shrink(),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
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
                            color: LightColors.kLightYellow, fontSize: 16.0),
                      ),
                    ),
                    TextFormField(
                      initialValue: _name,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            size: 30.0,
                            color: LightColors.kLightYellow,
                          ),
                          labelText: 'ФИО',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                      validator: (input) => input.trim().length < 1
                          ? 'Пожалуйста введите действительное ФИО'
                          : null,
                      onSaved: (input) => _name = input,
                    ),
                    TextFormField(
                      initialValue: _insta,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.book,
                            size: 30.0,
                            color: LightColors.kLightYellow,
                          ),
                          labelText: 'Ваш профиль в instagram',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                      validator: (input) => input.trim().length > 150
                          ? 'Не больше 150 символов'
                          : null,
                      onSaved: (input) => _insta = input,
                    ),
                    TextFormField(
                      initialValue: _phone,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.account_circle,
                            size: 30.0,
                            color: LightColors.kLightYellow,
                          ),
                          labelText: 'Телефон',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                      validator: (input) =>
                          input.trim().length < 1 ? 'Введите возраст' : null,
                      onSaved: (input) => _phone = input,
                    ),
                    TextFormField(
                      initialValue: _location,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.pin_drop,
                            size: 30.0,
                            color: LightColors.kLightYellow,
                          ),
                          labelText: 'Город',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                      validator: (input) => input.trim().length < 1
                          ? 'Пожалуйста введите действительно местоположение'
                          : null,
                      onSaved: (input) => _location = input,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, top: 10),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(40.0),
                            height: 55.0,
                            width: 250.0,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              onPressed: _submit,
                              color: Color(0xffFCCD00),
                              textColor: LightColors.kDarkBlue,
                              child: Text(
                                'Сохранить',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
