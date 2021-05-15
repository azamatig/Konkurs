import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konkurs_app/screens/tasks/details_screen.dart';
import 'package:konkurs_app/utilities/constants.dart';
import 'package:konkurs_app/utilities/dropdown_menu.dart';
import 'package:konkurs_app/utilities/next_screen.dart';
import 'package:konkurs_app/widgets/hand_cursor.dart';

// ignore: must_be_immutable
class PopularEventTile extends StatelessWidget {
  String desc;
  Timestamp date;
  String userId;
  String userPhoto;
  String name;
  String imgeAssetPath;
  DocumentSnapshot doc;
  final db = FirebaseFirestore.instance;

  /// later can be changed with imgUrl
  PopularEventTile(
      {this.name,
      this.date,
      this.imgeAssetPath,
      this.desc,
      this.doc,
      this.userId,
      this.userPhoto});

  @override
  Widget build(BuildContext context) {
    return HandCursor(
        child: GestureDetector(
      onTap: () async {
        if (SimpleAccountMenu.isMenuOpen) {
          SimpleAccountMenu.overlayEntry.remove();
          SimpleAccountMenu.animationController.reverse();
          SimpleAccountMenu.isMenuOpen = !SimpleAccountMenu.isMenuOpen;
        }
        nextScreen(
            context,
            DetailsScreen(
              docId: doc.id,
              docRef: doc.reference,
              date: doc.data()['date'],
              userId: userId,
              userPhoto: userPhoto,
              instaLink1: doc.data()['task1InstaLink'],
              instaLink2: doc.data()['task2InstaLink'],
              instaLink3: doc.data()['task3InstaLink'],
              endDate: doc.data()['endDate'],
              likesCount: doc.data()['likesCount'],
              giveawayCost: doc.data()['giveawayCost'],
              eventDays: doc.data()['eventDays'],
            ));
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: Color(0xff29404E), borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 16),
                width: MediaQuery.of(context).size.width - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      maxLines: 2,
                      style:
                          GoogleFonts.roboto(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/images/calender.png",
                          height: 12,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          formatOnlyDate(date.toDate()),
                          style: GoogleFonts.roboto(
                              color: Colors.white, fontSize: 10),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/images/location.png",
                          height: 15,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${desc.substring(0, 20)} ...',
                          style: GoogleFonts.roboto(
                              color: Colors.white, fontSize: 10),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: imgeAssetPath,
                  height: 100,
                  width: 120,
                  fit: BoxFit.cover,
                )),
          ],
        ),
      ),
    ));
  }
}
