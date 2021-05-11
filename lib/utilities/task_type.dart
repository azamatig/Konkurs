import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:image_picker/image_picker.dart';
import 'package:konkurs_app/models/user_model.dart';
import 'package:konkurs_app/screens/auxillary/comments_screen.dart';
import 'package:konkurs_app/utilities/next_screen.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskType {
  File file;
  final _picker = ImagePicker();
  void setInsta() async {
    PickedFile pick = await _picker.getImage(source: ImageSource.gallery);
    file = File(pick.path);
    SocialShare.checkInstalledAppsForShare();
    SocialShare.shareInstagramStory(file.path).then((data) {});
  }

  void setTweet() async {
    SocialShare.shareTwitter("Приходи в GIVEAPP, тут много призов!",
            hashtags: ["giveapp", "prizes", "giveaway", "gifts"],
            url:
                "https://play.google.com/store/apps/details?id=konkurs.aza.com.konkurs_app",
            trailingText: "\nGIVEAPP")
        .then((data) {
      print(data);
    });
  }

  void setSystem() async {
    var response = await FlutterShareMe().shareToSystem(
        msg:
            'https://play.google.com/store/apps/details?id=konkurs.aza.com.konkurs_app');
    if (response == 'success') {}
  }

  void setFacebook() async {
    PickedFile pick = await _picker.getImage(source: ImageSource.gallery);
    file = File(pick.path);
    SocialShare.shareFacebookStory(file.path, "#ffffff", "#000000",
        "https://play.google.com/store/apps/details?id=konkurs.aza.com.konkurs_app",
        appId: "229775418626099");
  }

  void setUrl(String urlString) async {
    var url = urlString;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void setGiveComment(
      BuildContext context, String userId, DocumentReference ref, User user) {
    nextScreen(
        context,
        CommentsScreen(
          userId: userId,
          documentReference: ref,
          user: user,
        ));
  }
}
