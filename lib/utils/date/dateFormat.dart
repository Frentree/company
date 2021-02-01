import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/i18n/word.dart';
import 'package:intl/intl.dart';

final word = Words();

class Format{
  String weekFormat(DateTime date){
    String week;

    switch (date.weekday){
      case 1 :
        week = word.Mon();
        break;

      case 2 :
        week = word.Tue();
        break;

      case 3 :
        week = word.Wed();
        break;

      case 4 :
        week = word.Thu();
        break;

      case 5 :
        week = word.Fri();
        break;

      case 6 :
        week = word.Sat();
        break;

      case 7 :
        week = word.Sun();
        break;
    }

    return week;
  }

  String twoDigitsFormat(int date){
    String newDate = "";

    if(date < 10) {
      newDate = "0" + date.toString();
    }

    else{
      newDate = date.toString();
    }

    return newDate;
  }

  String dateFormatForExpenseCard(Timestamp date) {
    String dateText;
    DateTime _date = timeStampToDateTime(date);

    dateText = twoDigitsFormat(_date.month) +"." +twoDigitsFormat(_date.day) + " " +  weekFormat(_date);
    return dateText;
  }

  String dateFormat(DateTime date){
    String dateText;

    dateText = date.year.toString() + " / " + twoDigitsFormat(date.month) + " / " + twoDigitsFormat(date.day) + "  " + weekFormat(date) + "${word.week()}";
    return dateText;
  }

  String dateToString(DateTime date){
    String dateText;

    dateText = date.year.toString() + " / " + twoDigitsFormat(date.month) + " / " + twoDigitsFormat(date.day) + "  " + twoDigitsFormat(date.hour) + " : " + twoDigitsFormat(date.minute) + "";
    return dateText;
  }

  String timeToString(Timestamp time){
    DateTime dateTime = timeStampToDateTime(time);
    String dateText;
    dateText = twoDigitsFormat(dateTime.hour) + ":" + twoDigitsFormat(dateTime.minute);
    return dateText;
  }

  int timeSlot(DateTime time){
    int timeSlot;

    if(time.hour < 12){
      timeSlot = 1;
    }
    else {
      timeSlot = 2;
    }

    return timeSlot;
  }

  DateTime timeFormat(DateTime date){
    DateTime time;
    DateTime now = DateTime.now();

    time = DateTime(now.year, now.month, now.day, date.hour, date.minute);

    return time;
  }

  DateTime timeStampToDateTime(Timestamp time){
    DateTime dateTime;
    dateTime = DateTime.parse(time.toDate().toString());
    
    return dateTime;
  }

  Timestamp dateTimeToTimeStamp(DateTime time){
    Timestamp dateTime;
    dateTime = Timestamp.fromDate(time);

    return dateTime;
  }

  String timeStampToDateTimeString(Timestamp time){
    String dateTime;
    dateTime = DateFormat('yyyy/MM/dd HH:mm:ss').format(
        DateTime.parse(time.toDate().toString()));

    return dateTime;
  }

  String yearMonthDay(Timestamp time){
    String dateTime;
    dateTime = DateFormat('yyyy/MM/dd').format(
        DateTime.parse(time.toDate().toString()));

    return dateTime;
  }

  List<Timestamp> oneWeekDay(DateTime selectTime){
    DateTime monday = selectTime.subtract(Duration(days: selectTime.weekday -1));
    List<Timestamp> weekDay = [dateTimeToTimeStamp(monday)];
    for(int i = 1; i < 5; i++){
      weekDay.add(dateTimeToTimeStamp(monday.add(Duration(days: i))));
    }

    return weekDay;
  }
}