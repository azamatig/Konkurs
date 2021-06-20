import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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
        child: _carouselSlider(context));
  }

  CarouselSlider _carouselSlider(BuildContext context) {
    List<String> imgList = [
      postImage,
      postImage,
      postImage,
      'https://wallpaperaccess.com/full/1180458.jpg'
    ];
    final double height = MediaQuery.of(context).size.height;
    return CarouselSlider(
        items: imgList
            .map((item) => Container(
                  decoration: BoxDecoration(
                    color: LightColors.kLightYellow,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: CachedNetworkImageProvider(item),
                    ),
                  ),
                ))
            .toList(),
        options: CarouselOptions(
          height: height,
          autoPlay: true,
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.height,
        ));
  }
}
