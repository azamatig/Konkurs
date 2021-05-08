import 'package:flutter/material.dart';
import 'package:konkurs_app/screens/giveaways/all_giveaways.dart';
import 'package:konkurs_app/screens/giveaways/closed_giveaways.dart';
import 'package:konkurs_app/screens/giveaways/my_giveaways.dart';
import 'package:konkurs_app/utilities/dropdown_menu.dart';
import 'package:konkurs_app/utilities/next_screen.dart';

// ignore: must_be_immutable
class EventTile extends StatelessWidget {
  String imgAssetPath;
  String eventType;

  String userPhoto;
  String userId;

  EventTile({this.imgAssetPath, this.eventType, this.userPhoto, this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (eventType) {
          case "Все конкурсы":
            {
              if (SimpleAccountMenu.isMenuOpen) {
                SimpleAccountMenu.overlayEntry.remove();
                SimpleAccountMenu.animationController.reverse();
                SimpleAccountMenu.isMenuOpen = !SimpleAccountMenu.isMenuOpen;
              }
              nextScreenCloseOthers(
                  context,
                  AllGiveaways(
                    userPhoto: userPhoto,
                  ));
            }
            break;
          case "Мои участия":
            {
              if (SimpleAccountMenu.isMenuOpen) {
                SimpleAccountMenu.overlayEntry.remove();
                SimpleAccountMenu.animationController.reverse();
                SimpleAccountMenu.isMenuOpen = !SimpleAccountMenu.isMenuOpen;
              }
              nextScreen(context, MyGiveaways(userId, userPhoto));
            }
            break;
          case "Завершенные":
            {
              if (SimpleAccountMenu.isMenuOpen) {
                SimpleAccountMenu.overlayEntry.remove();
                SimpleAccountMenu.animationController.reverse();
                SimpleAccountMenu.isMenuOpen = !SimpleAccountMenu.isMenuOpen;
              }
              nextScreenCloseOthers(
                  context,
                  ClosedGiveaways(
                    userPhoto: userPhoto,
                  ));
            }
            break;
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 30),
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
            color: Color(0xff29404E), borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imgAssetPath,
              height: 30,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              eventType,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
