//Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companyplaylist/consts/universalString.dart';
import 'package:companyplaylist/models/approvalModel.dart';
import 'package:companyplaylist/models/attendanceModel.dart';
import 'package:companyplaylist/models/commentListModel.dart';
import 'package:companyplaylist/models/commentModel.dart';
import 'package:companyplaylist/models/companyModel.dart';
import 'package:companyplaylist/models/companyUserModel.dart';
import 'package:companyplaylist/models/expenseModel.dart';
import 'package:companyplaylist/models/meetingModel.dart';
import 'package:companyplaylist/models/noticeModel.dart';
import 'package:companyplaylist/models/workModel.dart';
import 'package:companyplaylist/models/userModel.dart';
import 'package:companyplaylist/utils/date/dateFormat.dart';
import 'package:flutter/material.dart';

class FirebaseMethods {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // 경비 청구 항목 저장 메서드
  Future<DocumentReference> saveExpense(ExpenseModel expenseModel) async {
    var map = expenseModel.toMap();

    Future<DocumentReference> doc = firestore
        .collection(COMPANY)
        .document(expenseModel.companyCode)
        .collection(USER)
        .document(expenseModel.mail)
        .collection(EXPENSE)
        .add(map);

    return doc;
  }

  // 경비 청구 항목 불러오기 메서드
  Stream<QuerySnapshot> getExpense(String companyCode, String uid) {
    return firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .document(uid)
        .collection(EXPENSE)
        .orderBy("buyDate", descending: true)
        .snapshots();
  }

  //사용자 데이터 관련
  Future<void> saveUser({User userModel}) async {
    return await firestore
        .collection(USER)
        .doc(userModel.mail)
        .set(userModel.toJson());
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

  Future<List<DocumentSnapshot>> getCompany({String companyName}) async {
    List<DocumentSnapshot> result = [];
    List<String> findString = companyName.split("");
    QuerySnapshot querySnapshot = await firestore
        .collection(COMPANY)
        .where("companySearch", arrayContains: findString[0])
        .get();

    querySnapshot.docs.forEach((element) {
      if(findString.length == 1){
        result.add(element);
      }
      else{
        int firstIndex = element.data()["companySearch"].indexOf(findString[0]);
        for (int i = 1; i < findString.length; i++) {
          if (element.data()["companySearch"][firstIndex + i] != findString[i]) {
            break;
          } else {
            if (i == (findString.length - 1)) {
              result.add(element);
            }
          }
        }
      }
    });
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

  Future<String> geAppManagerMail({String companyCode}) async {
    QuerySnapshot querySnapshot = await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .where("level", arrayContains: 8)
        .get();

    String appManagerMail = querySnapshot.docs.first.id;

    return appManagerMail;
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

  //내외근 데이터 관련 관련
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
        .document(meetingModel.id)
        .updateData(meetingModel.toJson());
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
      {String companyCode,
      String appManagerMail,
      Approval approvalModel}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .doc(appManagerMail)
        .collection(APPROVAL)
        .add(approvalModel.toJson());
  }

  Stream<QuerySnapshot> getApproval({String companyCode, String managerMail}) {
    return firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .doc(managerMail)
        .collection(APPROVAL)
        .where("state", isEqualTo: 0)
        .snapshots();
  }

  Future<void> updateApproval(
      {Approval approvalModel, String companyCode, String managerMail}) async {
    return await firestore
        .collection(COMPANY)
        .doc(companyCode)
        .collection(USER)
        .doc(managerMail)
        .collection(APPROVAL)
        .doc(approvalModel.id)
        .update(approvalModel.toJson());
  }

  Future<DocumentSnapshot> getCompanyInfo({String companyCode}) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .get();
  }

  Stream<DocumentSnapshot> getCompanyInfos(String companyCode) {
    return firestore
        .collection(COMPANY)
        .document(companyCode)
        .snapshots();
  }

  Future<DocumentSnapshot> photoProfile(String companyCode, String mail) async {
    return await firestore
        .collection("company")
        .document(companyCode)
        .collection("user")
        .document(mail)
        .get();
  }

  Future<void> updatePhotoProfile(String companyCode, String mail, String url) async {
    await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .document(mail)
        .update({
          "profilePhoto" : url,
        });

    return await firestore
        .collection(USER)
        .document(mail)
        .update({
          "profilePhoto" : url,
        });
  }

  Future<void> updateCompany(String companyCode, String companyName, String companyNo, String companyAddr, String companyPhone, String companyWeb, String url) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .update({
      "companyName" : companyName,
      "comapnyNo" : companyNo,
      "companyAddr" : companyAddr,
      "companyPhone" : companyPhone,
      "companyWeb" : companyWeb,
      "companyPhoto" : url,
    });
  }

  Future<void> updatePhone(String companyCode, String mail, String phone) async {
    await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .document(mail)
        .update({
      "phone" : phone,
    });

    return firestore
        .collection(USER)
        .document(mail)
        .update({
      "phone" : phone,
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

  Future<void> deleteUser(String documentID, String companyCode, int level) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .document(documentID)
        .updateData({
      "level" : FieldValue.arrayRemove([level])
    });
  }

  Future<void> addGrade(String companyCode, String gradeName, int gradeID) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(GRADE)
        .add({
      "gradeID" : gradeID,
      "gradeName" : gradeName
    });
  }

  Future<void> updateGradeName(String documentID, String gradeName, String companyCode) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(GRADE)
        .document(documentID)
        .updateData({
      "gradeName" : gradeName
    });
  }

  Future<void> deleteGrade(String documentID, String companyCode) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(GRADE)
        .document(documentID)
        .delete();
  }

  Future<void> deleteUserGrade(String documentID, String companyCode, int level) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .where("level", arrayContains: level)
        .getDocuments().then((value) {
        value.documents.forEach((element) {
        element.reference.updateData({
          "level" : FieldValue.arrayRemove([level])
        });
      });
    });
  }

  Stream<QuerySnapshot> getGreadeUserDetail(String companyCode, int level) {
    return firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .where("level", arrayContains: level)
        .snapshots();
  }

  Stream<QuerySnapshot> getGreadeUserAdd(String companyCode) {
    return firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .orderBy("name", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getGreadeUserDelete(String companyCode, int level) {
    return firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(USER)
        .where("level", arrayContains: level)
        .snapshots();
  }

  Future<void> addGradeUser(String companyCode, List<Map<String,dynamic>> user) async {
    for(int i = 0; i < user.length; i++) {
      print("추가 ====> " + user[i]['mail']);
      await firestore
          .collection(COMPANY)
          .document(companyCode)
          .collection(USER)
          .document(user[i]['mail'])
          .updateData({
        "level": FieldValue.arrayUnion([user[i]['level']])
      });
    }
    return null;
  }

  Future<void> deleteGradeUser(String companyCode, List<Map<String,dynamic>> user) async {
    for(int i = 0; i < user.length; i++) {
      print("삭제 ====> " + user[i]['mail']);
      await firestore
          .collection(COMPANY)
          .document(companyCode)
          .collection(USER)
          .document(user[i]['mail'])
          .updateData({
        "level": FieldValue.arrayRemove([user[i]['level']])
      });
    }
    return null;
  }

  Future<void> addNotice(String companyCode, NoticeModel notice) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(NOTICE)
        .add(notice.toJson());
  }

  Future<void> deleteNotice(String companyCode, String documentID) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(NOTICE)
        .document(documentID)
        .delete();
  }

  Stream<QuerySnapshot> getNoticeList(String companyCode) {
    return firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(NOTICE)
        .orderBy("noticeCreateDate", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getNoticeCommentList(String companyCode, String documentID) {
    return firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(NOTICE)
        .document(documentID)
        .collection(COMMENT)
        .orderBy("createDate", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getNoticeCommentsList(String companyCode, String noticeDocumentID, String commntDocumentID) {
    return firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(NOTICE)
        .document(noticeDocumentID)
        .collection(COMMENT)
        .document(commntDocumentID)
        .collection(COMMENTS)
        .orderBy("createDate", descending: false)
        .snapshots();
  }

  Future<void> addNoticeComment(String companyCode, String noticeDocumentID, CommentModel comment) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(NOTICE)
        .document(noticeDocumentID)
        .collection(COMMENT)
        .add(comment.toJson());
  }

  Future<void> updateNoticeComment(String companyCode, String noticeDocumentID, String commntDocumentID, String comment) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(NOTICE)
        .document(noticeDocumentID)
        .collection(COMMENT)
        .document(commntDocumentID)
        .update({
          "comment" : comment,
          "updateDate" : Timestamp.now(),
        });
  }

  Future<void> deleteNoticeComment(String companyCode, String noticeDocumentID, String commntDocumentID) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(NOTICE)
        .document(noticeDocumentID)
        .collection(COMMENT)
        .document(commntDocumentID)
        .delete();
  }

  Future<void> addNoticeComments(String companyCode, String noticeDocumentID, String commntDocumentID, CommentListModel comment) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(NOTICE)
        .document(noticeDocumentID)
        .collection(COMMENT)
        .document(commntDocumentID)
        .collection(COMMENTS)
        .add(comment.toJson());
  }

  Future<void> updateNoticeComments(String companyCode, String noticeDocumentID, String commntDocumentID, String commntsDocumentID, String comment) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(NOTICE)
        .document(noticeDocumentID)
        .collection(COMMENT)
        .document(commntDocumentID)
        .collection(COMMENTS)
        .document(commntsDocumentID)
        .update({
          "comment" : comment,
          "updateDate" : Timestamp.now(),
        });
  }

  Future<void> deleteNoticeComments(String companyCode, String noticeDocumentID, String commntDocumentID, String commntsDocumentID) async {
    return await firestore
        .collection(COMPANY)
        .document(companyCode)
        .collection(NOTICE)
        .document(noticeDocumentID)
        .collection(COMMENT)
        .document(commntDocumentID)
        .collection(COMMENTS)
        .document(commntsDocumentID)
        .delete();
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
