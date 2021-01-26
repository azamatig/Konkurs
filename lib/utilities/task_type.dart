import 'dart:io';

import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_share/social_share.dart';

class TaskType {
  File file;
  final _picker = ImagePicker();
  void setInsta() async {
    PickedFile pick = await _picker.getImage(source: ImageSource.gallery);
    file = File(pick.path);
    SocialShare.shareInstagramStory(
            file.path, "#ffffff", "#000000", "https://this-is-a-test")
        .then((data) {
      print(data);
    });
  }

  void setTweet() async {
    SocialShare.shareTwitter("Приходи в GIVEAPP, тут много призов!",
            hashtags: ["giveapp", "prizes", "giveaway", "gifts"],
            url: "https://google.com/#/hello",
            trailingText: "\nGIVEAPP")
        .then((data) {
      print(data);
    });
  }

  void setSystem() async {
    var response = await FlutterShareMe()
        .shareToSystem(msg: 'ссылка на приложение будет здесь');
    if (response == 'success') {
      print('navigate success');
    }
  }

  void setFacebook() async {
    PickedFile pick = await _picker.getImage(source: ImageSource.gallery);
    file = File(pick.path);
    SocialShare.shareFacebookStory(
        file.path, "#ffffff", "#000000", "https://this-is-a-test",
        appId: "229775418626099");
  }
}
