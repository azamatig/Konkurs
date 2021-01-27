import 'package:flutter/material.dart';
import 'package:achievement_view/achievement_view.dart';

bool pushIsOn = true;

void showAchievementView1(BuildContext context) {
  if(pushIsOn)
  AchievementView(context,
      title: "Ура!", subTitle: "Вы теперь участник конкурса!",
      //onTab: _onTabAchievement,
      //icon: Icon(Icons.insert_emoticon, color: Colors.white,),
      //typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
      //borderRadius: 5.0,
      //color: Colors.blueGrey,
      //textStyleTitle: TextStyle(),
      //textStyleSubTitle: TextStyle(),
      //alignment: Alignment.topCenter,
      //duration: Duration(seconds: 3),
      //isCircle: false,
      listener: (status) {
    //AchievementState.opening
    //AchievementState.open
    //AchievementState.closing
    //AchievementState.closed
  })
    ..show();
}

void showAchievementView2(BuildContext context, var title, var subTitle) {
  if(pushIsOn)
    AchievementView(context,
        title: title, subTitle: subTitle,
        listener: (status) {
        })
      ..show();
}