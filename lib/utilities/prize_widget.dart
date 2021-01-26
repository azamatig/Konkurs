import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:konkurs_app/utilities/constants.dart';

class PrizeWidget extends StatelessWidget {
  final String postImage;

  const PrizeWidget({Key key, this.postImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: _postImage(context));
  }

  SingleChildScrollView _postImage(context) {
    return SingleChildScrollView(
        child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: LightColors.kLightYellow2,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(postImage),
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: Container(
              height: 165,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Container(
                        color: LightColors.kLightYellow,
                        height: 40,
                        width: 40,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              FontAwesomeIcons.chevronLeft,
                              size: 25,
                              color: LightColors.kDarkBlue,
                            ),
                          ),
                        )),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
