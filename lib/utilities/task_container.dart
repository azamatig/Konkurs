import 'package:flutter/material.dart';

class TaskContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color boxColor;
  final IconData icon;
  final Color iconColor;
  final double blurRadius;
  final double spreadRadius;
  final Color shadowColor;

  TaskContainer({
    this.title,
    this.subtitle,
    this.boxColor,
    this.icon,
    this.iconColor,
    this.blurRadius,
    this.spreadRadius,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(
                icon,
                color: iconColor,
                size: 25,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
                color: shadowColor,
                blurRadius: blurRadius,
                spreadRadius: spreadRadius)
          ]),
    );
  }
}
