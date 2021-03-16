import 'package:flutter/material.dart';

class DateWidget extends StatefulWidget {
  final List arr;
  final DateTime date;
  final List eventDays;

  DateWidget(this.arr, this.date, this.eventDays);

  @override
  _DateWidgetState createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: (){
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
            decoration: BoxDecoration(
                color: const Color(0xffFCCD00),
                borderRadius: BorderRadius.all(Radius.circular(6)),
                border:
                Border.all(color: const Color(0xffFCCD00), width: 1)),
            child: Column(
              children: [
                Icon(Icons.circle, color: widget.eventDays.contains(widget.date.toString().substring(0, 10)) ?
                Colors.red : Color(0xffFCCD00), size: 8,),
                SizedBox(height: 2.5,),
                _showDate1(widget.date),
                _showWeek1(widget.date),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _showDate1(DateTime date) {
    return Container(
        //padding: EdgeInsets.all(2),
        child: Text(
          widget.arr[date.weekday - 1],
          style: TextStyle(color: Colors.black),
        ));
  }

  Widget _showWeek1(DateTime date) {
    return Container(
        //padding: EdgeInsets.all(2),
        child: Text(
          '${date.day}',
          style: TextStyle(color: Colors.black),
        ));
  }
}
