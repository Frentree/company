import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Format{
  String weekFormat(DateTime date){
    String week;

    switch (date.weekday){
      case 1 :
        week = "월";
        break;

      case 2 :
        week = "화";
        break;

      case 3 :
        week = "수";
        break;

      case 4 :
        week = "목";
        break;

      case 5 :
        week = "금";
        break;

      case 6 :
        week = "토";
        break;

      case 0 :
        week = "일";
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

    dateText = twoDigitsFormat(_date.month) +
        "." +
        twoDigitsFormat(_date.day) +
        " " +
        weekFormat(_date);
    return dateText;
  }

  String dateFormat(DateTime date){
    String dateText;

    dateText = date.year.toString() + "년 " + twoDigitsFormat(date.month) + "월 " + twoDigitsFormat(date.day) + "일 " + weekFormat(date) + "요일";
    return dateText;
  }

  String dateToString(DateTime date){
    String dateText;

    dateText = date.year.toString() + "년 " + twoDigitsFormat(date.month) + "월 " + twoDigitsFormat(date.day) + "일 " + twoDigitsFormat(date.hour) + "시 " + twoDigitsFormat(date.minute) + "분";
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
    dateTime = DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(
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