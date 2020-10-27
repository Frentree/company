import 'package:cloud_firestore/cloud_firestore.dart';

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

  String dateFormat(DateTime date){
    String dateText;

    dateText = date.month.toString() + "월 " + date.day.toString() + "일 " + weekFormat(date) + "요일";
    return dateText;
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
}