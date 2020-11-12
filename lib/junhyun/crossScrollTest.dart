import 'package:companyplaylist/consts/colorCode.dart';
import 'package:companyplaylist/consts/font.dart';
import 'package:companyplaylist/repos/tableCalendar/table_calendar.dart';
import 'package:flutter/material.dart';


class CrossScrollTest extends StatefulWidget {
  @override
  _CrossScrollTestState createState() => _CrossScrollTestState();
}

class _CrossScrollTestState extends State<CrossScrollTest> {
  CalendarController _calendarController;

  @override
  void initState(){
    super.initState();
    _calendarController = CalendarController();
  }

  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body : TableCalendar(
          calendarController: _calendarController,
          initialCalendarFormat: CalendarFormat.week,
          availableCalendarFormats: {
            CalendarFormat.week: "Week",
            CalendarFormat.month: "Month"
          },
          locale: 'ko_KR',
          headerStyle: HeaderStyle(
            formatButtonDecoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(20),
            ),
            formatButtonTextStyle: customStyle(
                fontSize: 13,
                fontWeightName: "Bold",
                fontColor: whiteColor
            ),
          ),
          calendarStyle:  CalendarStyle(
              selectedColor: mainColor,
              selectedStyle: customStyle(
                  fontSize: 18,
                  fontWeightName: "Bold",
                  fontColor: whiteColor
              )
          ),
        )
    );
  }
}
