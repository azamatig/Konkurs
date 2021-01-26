import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/utilities/constants.dart';

class MyBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'backButton',
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                FontAwesomeIcons.chevronLeft,
                size: 25,
                color: LightColors.kDarkBlue,
              ),
            ),
            Text(
              'Назад',
              style: TextStyle(fontSize: 16, color: LightColors.kDarkBlue),
            )
          ],
        ),
      ),
    );
  }
}
