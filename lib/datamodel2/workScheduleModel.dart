//내근 및 외근 스케줄 데이터 모델입니다.

/*
컬렉션 이름 : work_schedule
데이터 내용
  업무타입 <type>
  제목 <title>
  작성자 <writer>
  작성일 <writeDate>
  시작 날짜 <startDate>
  시작 시간 <startTime>
  종료 날짜 <endDate>
  종료 시간 <endTime>
  프로젝트 타입 <project>
  진행상태 <progress>
  상세 내용 <detail>
  */

  class WorkSchedule {
  String id; //Document ID
  String type;
  String title;
  String writer;
  String writeDate;
  String startDate;
  String startTime;
  String endDate;
  String endTime;
  String project;
  String progress;
  String detail;

  WorkSchedule({
    this.id,
    this.type,
    this.title,
    this.writer,
    this.writeDate,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.project,
    this.progress,
    this.detail
  });

  WorkSchedule.fromMap(Map snapshot, String id)
      :
        id = id ?? '',
        type = snapshot['type'] ?? '',
        title = snapshot['title'] ?? '',
        writer = snapshot['writer'] ?? '',
        writeDate = snapshot['writeDate'] ?? '',
        startDate = snapshot['startDate'] ?? '',
        startTime = snapshot['startTime'] ?? '',
        endDate = snapshot['endDate'] ?? '',
        endTime = snapshot['endTime'] ?? '',
        project = snapshot['project'] ?? '',
        progress = snapshot['progress'] ?? '',
        detail = snapshot['detail'] ?? '';

  toJson() {
    return {
      "type": type,
      "title": title,
      "writer": writer,
      "writerDate": writeDate,
      "startDate": startDate,
      "startTime": startTime,
      "endDate": endDate,
      "endTime": endTime,
      "project": project,
      "progress": progress,
      "detail": detail,
    };
  }
}
