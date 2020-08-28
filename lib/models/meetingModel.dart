/*

회의 관련 데이터 모델


 */

import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingModel {
  String createUid; // initial writer
  Timestamp createDate; // initial date
  String meetingAgenda;
  String meetingNumber;
  String meetingTitle;
  String minutes;
  Timestamp lastModDate;
  String lastUid;
  String level;
  String modPermission;
  String progress;
}