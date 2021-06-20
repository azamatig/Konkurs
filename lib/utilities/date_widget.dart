import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konkurs_app/widgets/hand_cursor.dart';

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
    return HandCursor(
        child: GestureDetector(
      onTap: () => {},
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
        decoration: BoxDecoration(
            color: const Color(0xffFCCD00),
            borderRadius: BorderRadius.all(Radius.circular(6)),
            border: Border.all(color: const Color(0xffFCCD00), width: 1)),
        child: Column(
          children: [
            Icon(
              Icons.circle,
              color: widget.eventDays
                      .contains(widget.date.toString().substring(0, 10))
                  ? Colors.red
                  : Color(0xffFCCD00),
              size: 2,
            ),
            _showDate1(widget.date),
            _showWeek1(widget.date),
          ],
        ),
      ),
    ));
  }

  Widget _showDate1(DateTime date) {
    return Container(
        //padding: EdgeInsets.all(2),
        child: Text(
      widget.arr[date.weekday - 1],
      style: GoogleFonts.roboto(color: Colors.black),
    ));
  }

  Widget _showWeek1(DateTime date) {
    return Container(
        //padding: EdgeInsets.all(2),
        child: Text(
      '${date.day}',
      style: GoogleFonts.roboto(color: Colors.black),
    ));
  }
}
