//Firebase
import 'dart:math';

import 'package:MyCompany/models/alarmModel.dart';
import 'package:MyCompany/models/wifiListModel.dart';
import 'package:MyCompany/models/inquireModel.dart';
import 'package:MyCompany/models/workApprovalModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MyCompany/consts/universalString.dart';
import 'package:MyCompany/models/approvalModel.dart';
import 'package:MyCompany/models/attendanceModel.dart';
import 'package:MyCompany/models/commentListModel.dart';
import 'package:MyCompany/models/commentModel.dart';
import 'package:MyCompany/models/companyModel.dart';
import 'package:MyCompany/models/companyUserModel.dart';
import 'package:MyCompany/models/expenseModel.dart';
import 'package:MyCompany/models/meetingModel.dart';
import 'package:MyCompany/models/noticeModel.dart';
import 'package:MyCompany/models/workModel.dart';
import 'package:MyCompany/models/userModel.dart';
import 'package:MyCompany/utils/date/dateFormat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseMethods {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseStorage firestorage = FirebaseStorage.instance;
  Format _format = Format();

  // 경비 청구 항목 저장 메서드
  Future<DocumentReference> saveExpense(ExpenseModel expenseModel) async {
    var map = expenseModel.toMap();
    var _docRf = firestore
        .collection(COMPANY)
        .doc(expenseModel.companyCode)
        .collection(USER)
        .doc(expenseModel.mail)
        .collection(EXPENSE)
        .doc();
    map.update('docId', (existingValue) => _docRf.id);

    firestore
        .collection(COMPANY)
        .doc(expenseModel.companyCode)
        .collection(USER)
        .doc(expenseModel.mail)
        .collection(EXPENSE)
        .doc(_docRf.id)
        .set(map);
  }

  // 경비 청구 항목 수정 메서드
  Future<void> updateExpense(
      ExpenseModel expenseModel, String companyCode, String docId) async {
    var map = expenseModel.toMap();
    firestore
        .collection(COMPANY)
        .doc(expenseModel.companyCode)
        .collection(USER)
        .doc(expenseModel.mail)
        .collection(EXPENSE)
        .doc(docId)
        .update(map);
  }

  // 경비 결재 완료 후 프로세스
  Future<void> postProcessApprovedExpense(
      User user, WorkApproval model, int type) async {
    String _docId;
    int _index = model.docIds.length;
    bool _isApproved = false;
    String _status = "미";

    switch (type) {
    //1 : 결재요청 후, 2: 결재요청 취소 후, 3: 결재완료
      case 1: _status = "진";
        break;
      case 2: _status = "미";
        break;
      case 3: _isApproved = true; _status = "결";
        break;
    }

    for (int i = 0; i < _index; i++) {
      _docId = model.docIds[i];
      await firestore
          .collection(COMPANY)
          .doc(user.companyCode)
          .collection(USER)
          .doc(model.userMail)
          .collection(EXPENSE)
          .doc(_docId)
          .update({
        "isApproved": _isApproved,
        "status": _status,
      });
    }
  }

  // 결재자 경비 항목 조회 메서드
  Future<List<ExpenseModel>> getExpenses(
      WorkApproval model, String companyCode) async {
    List<ExpenseModel> _result = List<ExpenseModel>();
    ExpenseModel _eModel = ExpenseModel();
    String _docId;
    int _index = model.docIds.length;
    var _temp;

    for (int i = 0; i < _index; i++) {
      _docId = model.docIds[i];
      _eModel = ExpenseModel();
      _temp = await firestore
          .collection(COMPANY)
          .doc(companyCode)
          .collection(USER)
          .doc(model.userMail)
          .collection(EXPENSE)
          .doc(_docId)
          .get();

      _eModel.buyDate = _temp.data()["buyDate"];
      _eModel.contentType = _temp.data()["contentType"];
      _eModel.cost = _temp.data()["cost"];
      _eModel.imageUrl = _temp.data()["imageUrl"];
      _eModel.status = _temp.data()["status"];
      _eModel.companyCode = _temp.data()["companyCode"];
      _eModel.docId = _temp.data()["docId"];
      _result.add(_eModel);
    }
    return _result;
  }

  Timestamp dateTimeToTimeStamp(DateTime time) {
    Timestamp dateTime;
    dateTime = Timestamp.fromDate(time);

    return dateTime;
  }

  // 경비 청구 항목 불러오기 메서드
  Stream<QuerySnapshot> getExpense(
      String companyCode, String uid, DateTime thisMonth) {
    DateTime _thisMonth = DateTime(thisMonth.year, thisMonth.month);
    DateTime _nextMonth = DateTime(thisMonth.year, thisMonth.month + 1);

    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .doc(uid)
        .collection(EXPENSE)
        .where("buyDate",
            isGreaterThanOrEqualTo: dateTimeToTimeStamp(_thisMonth))
        .where("buyDate", isLessThan: dateTimeToTimeStamp(_nextMonth))
        .orderBy("buyDate", descending: true)
        .snapshots();
  }

  // 경비 저장 항목 삭제 메서드
  Future<void> deleteExpense(
      String companyCode, String documentID, String uid) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .doc(uid)
        .collection(EXPENSE)
        .doc(documentID)
        .delete();
  }

  //사용자 데이터 관련
  Future<void> saveUser({User userModel}) async {
    return await firestore
        .collection(USER)
        .doc(userModel.mail)
        .set(userModel.toJson());
  }

  Future<CompanyUser> getMyCompanyInfo({String companyCode, String myMail}) async {
    var doc = await firestore.collection(COMPANY).doc(companyCode).collection(USER).doc(myMail).get();
    return CompanyUser.fromMap(doc.data(), doc.id);
  }

  Future<void> deleteAttendance(
      {String companyCode, String documentId}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(ATTENDANCE)
        .doc(documentId).delete();
  }

  Stream<QuerySnapshot> getMyAttendance({String companyCode, String loginUserMail, DateTime thisMonth}){

    DateTime _thisMonth = DateTime(thisMonth.year, thisMonth.month);
    DateTime _nextMonth = DateTime(thisMonth.year, thisMonth.month+1);

    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(ATTENDANCE)
        .where("mail", isEqualTo: loginUserMail)
        .where("createDate", isGreaterThanOrEqualTo: dateTimeToTimeStamp(_thisMonth))
        .where("createDate", isLessThan: dateTimeToTimeStamp(_nextMonth))
        .orderBy("createDate", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllAttendance({String companyCode, DateTime thisMonth}){

    DateTime _thisMonth = DateTime(thisMonth.year, thisMonth.month);
    DateTime _nextMonth = DateTime(thisMonth.year, thisMonth.month+1);

    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(ATTENDANCE)
        .where("createDate", isGreaterThanOrEqualTo: dateTimeToTimeStamp(_thisMonth))
        .where("createDate", isLessThan: dateTimeToTimeStamp(_nextMonth))
        .orderBy("createDate", descending: true)
        .snapshots();
  }

  Future<User> getUser({String userMail}) async {
    var doc = await firestore.collection(USER).doc(userMail).get();
    return User.fromMap(doc.data(), doc.id);
  }

  Future<void> updateUser({User userModel}) async {
    Format _format = Format();
    userModel.lastModDate = _format.dateTimeToTimeStamp(DateTime.now());

    return await firestore
        .collection(USER)
        .doc(userModel.mail)
        .update(userModel.toJson());
  }

  //회사데이터 관련
  Future<void> saveCompany({Company companyModel}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyModel.companyCode)
        .set(companyModel.toJson());
  }

  Future<List<DocumentSnapshot>> getCompany() async {
    List<DocumentSnapshot> result = [];
    //List<String> findString = companyName.split("");
    QuerySnapshot querySnapshot = await firestore.collection(COMPANY).get();

    querySnapshot.docs.forEach((element) {
      result.add(element);
    });
    return result;
  }

  Future<List<DocumentSnapshot>> searchCompanyUser(
      {String companyUserName,
      String companyCode,
      String loginUserMail}) async {
    List<DocumentSnapshot> result = [];
    List<String> findString = companyUserName.split("");
    QuerySnapshot querySnapshot = await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .where("userSearch", arrayContains: findString[0])
        .get();

    querySnapshot.docs.forEach(
      (element) {
        if (element.id != loginUserMail &&
            !element.data()["level"].contains(9)) {
          if (findString.length == 1) {
            result.add(element);
          } else {
            int firstIndex =
                element.data()["userSearch"].indexOf(findString[0]);
            for (int i = 1; i < findString.length; i++) {
              if (element.data()["userSearch"][firstIndex + i] !=
                  findString[i]) {
                break;
              } else {
                if (i == (findString.length - 1)) {
                  result.add(element);
                }
              }
            }
          }
        }
      },
    );
    return result;
  }

  Future<void> saveCompanyUser({CompanyUser companyUserModel}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyUserModel.user.companyCode)
        .collection(USER)
        .doc(companyUserModel.user.mail)
        .set(companyUserModel.toJson());
  }

  Future<void> deleteCompanyUser(
      {String companyCode, CompanyUser companyUserModel}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .doc(companyUserModel.id)
        .delete();
  }

  Future<Map<DateTime, List<CompanyUser>>> getBirthday(
      {String companyCode}) async {
    Map<DateTime, List<CompanyUser>> birthday = {};

    QuerySnapshot querySnapshot = await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .orderBy("name")
        .get();
    querySnapshot.docs.forEach((element) {
      if (element.data()["birthday"] != null) {
        DateTime key = DateTime.parse(element.data()["birthday"]);

        if (birthday[DateTime(DateTime.now().year, key.month, key.day)] ==
            null) {
          birthday
              .addAll({DateTime(DateTime.now().year, key.month, key.day): []});
        }

        birthday[DateTime(DateTime.now().year, key.month, key.day)]
            .add(CompanyUser.fromMap(element.data(), element.id));
      }
    });

    print(birthday);
    return birthday;
  }

  //회사 직원 관련
  Future<Map<String, String>> getColleague(
      {String loginUserMail, String companyCode}) async {
    Map<String, String> colleague = {};
    QuerySnapshot querySnapshot = await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .orderBy("name")
        .get();
    querySnapshot.docs.forEach((element) {
      if (element.id != loginUserMail) {
        colleague[element.id] = element.data()["name"];
      }
    });

    return colleague;
  }

  Stream<QuerySnapshot> getColleagueInfo({String companyCode}) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .orderBy("name")
        .snapshots();
  }

  //알람 데이터 관련
  Future<void> saveAlarm(
      {Alarm alarmModel, String companyCode, String mail}) async {
    Map<String, String> colleague =
        await getColleague(companyCode: companyCode, loginUserMail: mail);

    colleague.keys.forEach((element) async {
      await firestore
          .collection(COMPANY)
          .doc(companyCode)
          .collection(USER)
          .doc(element)
          .collection(ALARM)
          .add(alarmModel.toJson());
    });
  }

  Future<void> saveOneUserAlarm(
      {Alarm alarmModel, String companyCode, String mail}) async {
    await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .doc(mail)
        .collection(ALARM)
        .add(alarmModel.toJson());
  }

  Future<void> deleteAlarm(
      {String companyCode, String mail, String documentID}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .doc(mail)
        .collection(ALARM)
        .doc(documentID)
        .delete();
  }

  Future<void> updateReadAlarm(
      {String companyCode, String mail, String alarmId}) async {
    var doc = await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .doc(mail)
        .collection(ALARM)
        .where("alarmId", isEqualTo: int.parse(alarmId))
        .get();
    String docId = doc.docs.first.id;
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .doc(mail)
        .collection(ALARM)
        .doc(docId)
        .update({
      "read": true,
    });
  }

  Stream<QuerySnapshot> getNoReadAlarm({String companyCode, String mail}) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .doc(mail)
        .collection(ALARM)
        .where("read", isEqualTo: false)
        .orderBy("alarmDate")
        .snapshots();
  }

  Stream<QuerySnapshot> getAllAlarm({String companyCode, String mail}) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .doc(mail)
        .collection(ALARM)
        .orderBy("alarmDate", descending: true)
        .snapshots();
  }

  //내외근 데이터 관련
  Future<void> saveWork({WorkModel workModel, String companyCode}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(WORK)
        .add(workModel.toJson());
  }

  Future<void> updateWork({WorkModel workModel, String companyCode}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(WORK)
        .doc(workModel.id)
        .update(workModel.toJson());
  }

  Future<void> deleteWork({String documentID, String companyCode}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(WORK)
        .doc(documentID)
        .delete();
  }

  //회의 데이터 관련 관련
  Future<void> saveMeeting(
      {MeetingModel meetingModel, String companyCode}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(WORK)
        .add(meetingModel.toJson());
  }

  Future<void> updateMeeting(
      {MeetingModel meetingModel, String companyCode}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(WORK)
        .doc(meetingModel.id)
        .update(meetingModel.toJson());
  }

  Future<void> deleteMeeting({String documentID, String companyCode}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(WORK)
        .doc(documentID)
        .delete();
  }

  //Work 데이터 전체 관련
  Stream<QuerySnapshot> getCompanyWork({String companyCode}) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(WORK)
        .snapshots();
  }

  Stream<QuerySnapshot> getSelectedDateCompanyWork(
      {String companyCode, Timestamp selectedDate}) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(WORK)
        .where("startDate", isEqualTo: selectedDate)
        .orderBy("startTime")
        .snapshots();
  }

  Stream<QuerySnapshot> getSelectedWeekCompanyWork(
      {String companyCode, List<Timestamp> selectedWeek}) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(WORK)
        .where("startDate", whereIn: selectedWeek)
        .orderBy("startTime")
        .snapshots();
  }

  //출퇴근 관련
  Future<DocumentReference> saveAttendance(
      {Attendance attendanceModel, String companyCode}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(ATTENDANCE)
        .add(attendanceModel.toJson());
  }

  Future<QuerySnapshot> getMyTodayAttendance(
      {String companyCode, String loginUserMail, Timestamp today}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(ATTENDANCE)
        .where("mail", isEqualTo: loginUserMail)
        .where("createDate", isEqualTo: today)
        .get();
  }

  Stream<QuerySnapshot> getColleagueNowAttendance(
      {String companyCode, String loginUserMail, Timestamp today}) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(ATTENDANCE)
        .where("mail", isNotEqualTo: loginUserMail)
        .where("createDate", isEqualTo: today)
        .snapshots();
  }

  Future<void> updateAttendance(
      {Attendance attendanceModel,
      String documentId,
      String companyCode}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(ATTENDANCE)
        .doc(documentId)
        .update(attendanceModel.toJson());
  }

  //알람 관련
  //사용자 승인
  Future<void> saveApproval(
      {String companyCode, Approval approvalModel}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(APPROVAL)
        .add(approvalModel.toJson());
  }

  Stream<QuerySnapshot> getApproval({String companyCode}) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(APPROVAL)
        .where("state", isEqualTo: 0)
        .snapshots();
  }

  Future<void> updateApproval(
      {Approval approvalModel, String companyCode}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(APPROVAL)
        .doc(approvalModel.id)
        .update(approvalModel.toJson());
  }

  Future<DocumentSnapshot> getCompanyInfo({String companyCode}) {
    return firestore.collection(COMPANY).document(companyCode).get();
  }

  Stream<DocumentSnapshot> getCompanyInfos(String companyCode) {
    return firestore.collection(COMPANY).document(companyCode).snapshots();
  }

  Future<DocumentSnapshot> photoProfile(String companyCode, String mail) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .document(mail)
        .get();
  }

  Future<void> updatePhotoProfile(
      String companyCode, String mail, String url) async {
    await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .document(mail)
        .update({
      "profilePhoto": url,
    });

    return firestore.collection(USER).document(mail).update({
      "profilePhoto": url,
    });
  }

  //WIFI 리스트 가져오기
  Future<List<DocumentSnapshot>> getWifiList({String companyCode}) async {
    List<DocumentSnapshot> wifiList = [];

    QuerySnapshot querySnapshot = await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection("wifi")
        .get();
    querySnapshot.docs.forEach((element) {
      wifiList.add(element);
    });

    return wifiList;
  }

  //WIFI 리스트 가져오기
  Future<List<String>> getWifiName({String companyCode}) async {
    List<String> wifiNameList = [];

    QuerySnapshot querySnapshot = await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection("wifi")
        .get();
    querySnapshot.docs.forEach((element) {
      wifiNameList.add(element.data()["wifiName"]);
    });

    return wifiNameList;
  }

  //WIFI 리스트 추가
  Future<void> addWifiList({List<String> wifiList, User loginUser}) async {
    Format _format = Format();

    wifiList.forEach((element) async {
      WifiList tempWifi = WifiList(
          wifiName: element,
          registrantMail: loginUser.mail,
          registrantName: loginUser.name,
          registrationDate: _format.dateTimeToTimeStamp(DateTime.now()));

      await firestore
          .collection(COMPANY)
          .doc(loginUser.companyCode)
          .collection(WIFI)
          .add(tempWifi.toJson());
    });
  }

  //WIFI 리스트 삭제
  Future<void> deleteWifiList(
      {String companyCode, List<String> documentID}) async {
    documentID.forEach((element) async {
      await firestore
          .collection(COMPANY)
          .doc(companyCode)
          .collection(WIFI)
          .doc(element)
          .delete();
    });
  }

  //FCM 토큰 업데이트
  Future<void> updateToken(
      {String companyCode, String mail, String token}) async {
    await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .doc(mail)
        .update({
      "token": token,
    });
  }

  //FCM 토큰 가져오기
  Future<List<String>> getTokens({String companyCode, String mail}) async {
    List<String> tokenList = [];
    QuerySnapshot querySnapshot = await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .where("mail", isNotEqualTo: mail)
        .get();

    querySnapshot.docs.forEach((element) {
      if (element.data()["token"] != null) {
        tokenList.add(element.data()["token"]);
      }
    });

    return tokenList;
  }

  Future<List<String>> getApprovalUserTokens(
      {String companyCode, String mail}) async {
    List<String> tokenList = [];
    QuerySnapshot querySnapshot = await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .where("mail", isEqualTo: mail)
        .get();

    querySnapshot.docs.forEach((element) {
      tokenList.add(element.data()["token"]);
    });

    return tokenList;
  }

  Future<void> updateCompany(
      String companyCode,
      String companyName,
      String companyNo,
      String companyAddr,
      String companyPhone,
      String companyWeb,
      String url) async {
    return await firestore.collection(COMPANY).document(companyCode).update({
      "companyName": companyName,
      "comapnyNo": companyNo,
      "companyAddr": companyAddr,
      "companyPhone": companyPhone,
      "companyWeb": companyWeb,
      "companyPhoto": url,
    });
  }

  Future<void> updatePhone(
      String companyCode, String mail, String phone) async {
    await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .document(mail)
        .update({
      "phone": phone,
    });

    return firestore.collection(USER).document(mail).update({
      "phone": phone,
    });
  }

  Future<DocumentSnapshot> userGrade(String companyCode, String mail) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .document(mail)
        .get();
  }

  Stream<QuerySnapshot> getGrade(String companyCode) {
    return Firestore.instance
        .collection("company")
        .document(companyCode)
        .collection("grade")
        .orderBy("gradeID", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getGradeUser(String companyCode, int level) {
    return Firestore.instance
        .collection("company")
        .document(companyCode)
        .collection(USER)
        .where("level", arrayContains: level)
        .snapshots();
  }

  Future<void> deleteUser(
      String documentID, String companyCode, int level) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .document(documentID)
        .updateData({
      "level": FieldValue.arrayRemove([level])
    });
  }

  Future<void> addGrade(
      String companyCode, String gradeName, int gradeID) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(GRADE)
        .add({"gradeID": gradeID, "gradeName": gradeName});
  }

  Future<void> updateGradeName(
      String documentID, String gradeName, String companyCode) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(GRADE)
        .doc(documentID)
        .update({"gradeName": gradeName});
  }

  Future<void> deleteGrade(String documentID, String companyCode) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(GRADE)
        .doc(documentID)
        .delete();
  }

  Future<void> deleteUserGrade(
      String documentID, String companyCode, int level) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .where("level", arrayContains: level)
        .get()
        .then((value) {
      value.documents.forEach((element) {
        element.reference.updateData({
          "level": FieldValue.arrayRemove([level])
        });
      });
    });
  }

  Stream<QuerySnapshot> getGreadeUserDetail(String companyCode, int level) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .where("level", arrayContains: level)
        .snapshots();
  }

  Stream<QuerySnapshot> getGreadeUserAdd(String companyCode) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .orderBy("name", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getGreadeUserDelete(String companyCode, int level) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .where("level", arrayContains: level)
        .snapshots();
  }

  Future<void> addGradeUser(
      String companyCode, List<Map<String, dynamic>> user) async {
    for (int i = 0; i < user.length; i++) {
      await firestore
          .collection(COMPANY)
          .doc(companyCode)
          .collection(USER)
          .doc(user[i]['mail'])
          .update({
        "level": FieldValue.arrayUnion([user[i]['level']])
      });
    }
    return null;
  }

  Future<void> deleteGradeUser(
      String companyCode, List<Map<String, dynamic>> user) async {
    for (int i = 0; i < user.length; i++) {
      await firestore
          .collection(COMPANY)
          .doc(companyCode)
          .collection(USER)
          .doc(user[i]['mail'])
          .update({
        "level": FieldValue.arrayRemove([user[i]['level']])
      });
    }
    return null;
  }

  Future<void> addNotice(String companyCode, NoticeModel notice) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(NOTICE)
        .add(notice.toJson());
  }

  Future<void> deleteNotice(String companyCode, String documentID) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(NOTICE)
        .doc(documentID)
        .delete();
  }

  Stream<QuerySnapshot> getNoticeList(String companyCode) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(NOTICE)
        .orderBy("noticeCreateDate", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getNoticeCommentList(
      String companyCode, String documentID) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(NOTICE)
        .doc(documentID)
        .collection(COMMENT)
        .orderBy("createDate", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getNoticeCommentsList(
      String companyCode, String noticeDocumentID, String commntDocumentID) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(NOTICE)
        .doc(noticeDocumentID)
        .collection(COMMENT)
        .doc(commntDocumentID)
        .collection(COMMENTS)
        .orderBy("createDate", descending: false)
        .snapshots();
  }

  Future<void> addNoticeComment(
      String companyCode, String noticeDocumentID, CommentModel comment) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(NOTICE)
        .doc(noticeDocumentID)
        .collection(COMMENT)
        .add(comment.toJson());
  }

  Future<void> updateNoticeComment(String companyCode, String noticeDocumentID,
      String commntDocumentID, String comment) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(NOTICE)
        .doc(noticeDocumentID)
        .collection(COMMENT)
        .doc(commntDocumentID)
        .update({
      "comment": comment,
      "updateDate": Timestamp.now(),
    });
  }

  Future<void> deleteNoticeComment(String companyCode, String noticeDocumentID,
      String commntDocumentID) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(NOTICE)
        .doc(noticeDocumentID)
        .collection(COMMENT)
        .doc(commntDocumentID)
        .delete();
  }

  Future<void> addNoticeComments(String companyCode, String noticeDocumentID,
      String commntDocumentID, CommentListModel comment) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(NOTICE)
        .doc(noticeDocumentID)
        .collection(COMMENT)
        .doc(commntDocumentID)
        .collection(COMMENTS)
        .add(comment.toJson());
  }

  Future<void> updateNoticeComments(String companyCode, String noticeDocumentID,
      String commntDocumentID, String commntsDocumentID, String comment) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(NOTICE)
        .doc(noticeDocumentID)
        .collection(COMMENT)
        .doc(commntDocumentID)
        .collection(COMMENTS)
        .doc(commntsDocumentID)
        .update({
      "comment": comment,
      "updateDate": Timestamp.now(),
    });
  }

  Future<void> deleteNoticeComments(String companyCode, String noticeDocumentID,
      String commntDocumentID, String commntsDocumentID) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(NOTICE)
        .doc(noticeDocumentID)
        .collection(COMMENT)
        .doc(commntDocumentID)
        .collection(COMMENTS)
        .doc(commntsDocumentID)
        .delete();
  }

  Stream<QuerySnapshot> getTeamList(String companyCode) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(TEAM)
        .orderBy("teamName", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserTeam(String companyCode, String teamName) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .where("team", isEqualTo: teamName)
        .snapshots();
  }

  Future<void> addOrganizationChart(String companyCode, String teamName) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(TEAM)
        .add({"teamName": teamName});
  }

  Future<void> modifyOrganizationChartName(
      String companyCode, String teamName, String documentID) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(TEAM)
        .doc(documentID)
        .update({"teamName": teamName});
  }

  Future<void> addOrganizationChartMembers(
      String companyCode,
      String noticeDocumentID,
      String commntDocumentID,
      String commntsDocumentID,
      String comment) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(NOTICE)
        .doc(noticeDocumentID)
        .collection(COMMENT)
        .doc(commntDocumentID)
        .collection(COMMENTS)
        .doc(commntsDocumentID)
        .update({
      "comment": comment,
      "updateDate": Timestamp.now(),
    });
  }

  Future<void> addTeamUser(
      String companyCode, List<Map<String, dynamic>> user) async {
    for (int i = 0; i < user.length; i++) {
      //print("추가 ====> " + user[i]['mail']);
      await firestore
          .collection(COMPANY)
          .doc(companyCode)
          .collection(USER)
          .doc(user[i]['mail'])
          .updateData({"team": user[i]['team']});
    }
    return null;
  }

  Future<void> deleteUserOrganizationChart(
      String documentID, String companyCode, String teamName) async {
    await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(TEAM)
        .doc(documentID)
        .delete();

    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .where("team", isEqualTo: teamName)
        .get()
        .then((value) {
      value.documents.forEach((element) {
        element.reference.update({"team": ""});
      });
    });
  }

  Stream<QuerySnapshot> getTeamUserDelete(String companyCode, String teamName) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .where("team", isEqualTo: teamName)
        .snapshots();
  }

  Stream<QuerySnapshot> getPositionList(String companyCode) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(POSITION)
        .orderBy("position", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserPosition(String companyCode, String position) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .where("position", isEqualTo: position)
        .snapshots();
  }

  Future<void> addPosition(String companyCode, String position) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(POSITION)
        .add({"position": position});
  }

  Future<void> modifyPositionName(
      String companyCode, String position, String documentID) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(POSITION)
        .doc(documentID)
        .update({"position": position});
  }

  Future<void> addPositionUser(
      String companyCode, List<Map<String, dynamic>> user) async {
    for (int i = 0; i < user.length; i++) {
      //print("추가 ====> " + user[i]['mail']);
      await firestore
          .collection(COMPANY)
          .doc(companyCode)
          .collection(USER)
          .doc(user[i]['mail'])
          .updateData({"position": user[i]['position']});
    }
    return null;
  }

  Future<void> deleteUserPosition(
      String documentID, String companyCode, String position) async {
    await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(POSITION)
        .doc(documentID)
        .delete();

    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .where("position", isEqualTo: position)
        .get()
        .then((value) {
      value.documents.forEach((element) {
        element.reference.update({"position": ""});
      });
    });
  }

  Stream<QuerySnapshot> getPositionUserDelete(
      String companyCode, String position) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .where("position", isEqualTo: position)
        .snapshots();
  }

  Future<void> deleteAccount(String companyCode, String mail) async {
    await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .doc(mail)
        .delete();

    return await firestore.collection(USER).doc(mail).delete();
  }

  Future<CompanyUser> getComapnyUser(String companyCode, String mail) async {
    var doc = await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .doc(mail)
        .get();
    return CompanyUser.fromMap(doc.data(), doc.id);
  }

  Stream<QuerySnapshot> getCopyMyShedule(
      String companyCode, String mail, int count) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(WORK)
        .where("createUid", isEqualTo: mail)
        .orderBy("createDate")
        .limit(count)
        .snapshots();
  }

  Future<void> createAnnualLeave(
      String companyCode, WorkApproval workApproval) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(WORKAPPROVAL)
        .add(workApproval.toJson());
  }

  Stream<QuerySnapshot> requestAnnualLeave(String companyCode, String whereUser,
      String mail, String orderByType, bool isOrderBy) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(WORKAPPROVAL)
        .where(whereUser, isEqualTo: mail)
        .orderBy(orderByType, descending: isOrderBy)
        .snapshots();
  }

  Stream<QuerySnapshot> selectAnnualLeave(String companyCode, String whereUser,
      String mail, String orderByType, bool isOrderBy, String date) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(WORK)
        .where("startTime",
            isGreaterThan:
                Timestamp.fromDate(DateTime.parse("${date}-01-01 00:00:00")),
            isLessThan:
                Timestamp.fromDate(DateTime.parse("${date}-12-31 23:59:59")))
        .where("createUid", isEqualTo: mail)
        .where("type", whereIn: ['연차', '반차'])
        //.orderBy(orderByType, descending: isOrderBy)
        .snapshots();
  }

  /*Future<String> firebaseStorege(String companyCode, String mail) async {
    String data = await firestorage.ref("profile/${mail}").getDownloadURL().catchError({

    });

    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .document(mail)
        .get();
  }*/

  Stream<QuerySnapshot> getRequestUser(String companyCode, String mail) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .where("mail", isNotEqualTo: mail)
        .snapshots();
  }

  Stream<QuerySnapshot> getQnA(String mail) {
    return firestore
        .collection(QNA)
        .orderBy("createDate")
        .where("mail", isEqualTo: mail)
        .snapshots();
  }

  Future<void> createQnA(InquireModel model) async {
    return await firestore.collection(QNA).add(model.toJson());
  }
}

class FirestoreApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String path;
  String secondPath;
  String thirdPath;
  String documentId;
  String secondDocumentId;
  CollectionReference ref;

  FirestoreApi.onePath(this.path) {
    ref = _db.collection(path);
  }

  FirestoreApi.twoPath(this.path, this.secondPath, this.documentId) {
    ref = _db.collection(path).document(documentId).collection(secondPath);
  }

  FirestoreApi.threePath(this.path, this.documentId, this.secondPath,
      this.secondDocumentId, this.thirdPath) {
    ref = _db
        .collection(path)
        .document(documentId)
        .collection(secondPath)
        .document(secondDocumentId)
        .collection(thirdPath);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }

  Future<void> removeDocument(String id) {
    return ref.document(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }

  Future<void> updateDocument(Map data, String id) {
    return ref.document(id).updateData(data);
  }

  Future<void> setDocument(Map data, String id) {
    return ref.document(id).setData(data);
  }
}
