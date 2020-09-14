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
}