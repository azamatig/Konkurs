import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:konkurs_app/screens/alert_dialog_screen.dart';
import 'package:readmore/readmore.dart';

class DetailsScreen extends StatefulWidget {
  final String userId;
  final String postImage;
  final String postName;
  final String postDesc;
  final String task1;
  final String task2;
  final String task3;
  final String prize;
  final bool isShared;

  DetailsScreen(
      {this.userId,
      this.postImage,
      this.postName,
      this.postDesc,
      this.task1,
      this.task2,
      this.task3,
      this.prize,
      this.isShared});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String id;
  final db = FirebaseFirestore.instance;
  String name;
  String description;
  String imageUrl;
  Dialogs dialogs = new Dialogs();

  Widget _details() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 500,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Информация о конкурсе',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Colors.blueGrey[300],
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.blueGrey[300],
                            ),
                            SizedBox(width: 3),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Казахстан',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.blueGrey[300],
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.postName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Описание",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: ReadMoreText(
                            widget.postDesc,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                            trimMode: TrimMode.Line,
                            trimLines: 2,
                            trimCollapsedText: 'Больше',
                            trimExpandedText: 'меньше',
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Призы",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 200,
                          width: 200,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.prize),
                          )),
                        ),
                        SizedBox(height: 30),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Задания',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          // Вторая часть листа
                          children: <Widget>[
                            Icon(
                              Icons.circle,
                              size: 21,
                              color: Colors.deepOrangeAccent,
                            ),
                            SizedBox(width: 15),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.task1,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          // Вторая часть листа
                          children: <Widget>[
                            Icon(
                              Icons.circle,
                              size: 21,
                              color: widget.isShared == true
                                  ? Colors.green[500]
                                  : Colors.yellowAccent[700],
                            ),
                            SizedBox(width: 15),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.task2,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          // Вторая часть листа
                          children: <Widget>[
                            Icon(
                              Icons.circle,
                              size: 21,
                              color: Colors.deepOrangeAccent,
                            ),
                            SizedBox(width: 15),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.task3,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        FlatButton(
                          height: 50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          onPressed: () => dialogs.information(context,
                              'Спасибо', 'Спасибо за участие в конкурсе!'),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          child: Text(
                            'Участвовать',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //
            //
            //
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Детали задания',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.postImage),
              )),
            ),
            Row(
              children: [
                Container(
                  width: 203,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Image.asset(
                      'assets/images/highlightColor.jpg',
                      alignment: Alignment.topLeft,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  width: 220,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Image.asset(
                      'assets/images/highlightColor.jpg',
                      alignment: Alignment.topRight,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: _details(),
            )
          ],
        ),
      ),
    );
  }
}
